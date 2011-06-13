/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements. See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership. The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License. You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

#import "THTTPClient.h"
#import "TTransportException.h"

@implementation THTTPClient


- (void) setupRequest
{
  if (mRequest != nil) {
    [mRequest release];
  }

  // set up our request object that we'll use for each request
  mRequest = [[NSMutableURLRequest alloc] initWithURL: mURL];
  [mRequest setHTTPMethod: @"POST"];
  [mRequest setValue: @"application/x-thrift" forHTTPHeaderField: @"Content-Type"];
  [mRequest setValue: @"application/x-thrift" forHTTPHeaderField: @"Accept"];

  NSString * userAgent = mUserAgent;
  if (!userAgent) {
    userAgent = @"Cocoa/THTTPClient";
  }
  [mRequest setValue: userAgent forHTTPHeaderField: @"User-Agent"];

  [mRequest setCachePolicy: NSURLRequestReloadIgnoringCacheData];
  if (mTimeout) {
    [mRequest setTimeoutInterval: mTimeout];
  }
	
	
	/*
	NSString *userName = @"fe8ebe0aaa3658f4a261f99b6d7e7457";  
	NSString *password = @"1564452860de5620";  
	
	
	
	// create a plaintext string in the format username:password  
	NSMutableString *loginString = (NSMutableString*)[@"" stringByAppendingFormat:@"%@:%@", userName, password];  
	
	// employ the Base64 encoding above to encode the authentication tokens  
	NSString *encodedLoginData = [THTTPClient encode:[loginString dataUsingEncoding:NSUTF8StringEncoding]];  
	
	// create the contents of the header   
	NSString *authHeader = [@"Basic " stringByAppendingFormat:@"%@", encodedLoginData];  
	
		
	// add the header to the request.  Here's the $$$!!!  
	[mRequest addValue:authHeader forHTTPHeaderField:@"Authorization"];  
	 */
}


- (id) initWithURL: (NSURL *) aURL
{
  return [self initWithURL: aURL
                 userAgent: nil
                   timeout: 0];
}


- (id) initWithURL: (NSURL *) aURL
         userAgent: (NSString *) userAgent
           timeout: (int) timeout
{
  self = [super init];
  if (!self) {
    return nil;
  }

  mTimeout = timeout;
  if (userAgent) {
    mUserAgent = [userAgent retain];
  }
  mURL = [aURL retain];

  [self setupRequest];

  // create our request data buffer
  mRequestData = [[NSMutableData alloc] initWithCapacity: 1024];

  return self;
}


- (void) setURL: (NSURL *) aURL
{
  [aURL retain];
  [mURL release];
  mURL = aURL;

  [self setupRequest];
}


- (void) dealloc
{
  [mURL release];
  [mUserAgent release];
  [mRequest release];
  [mRequestData release];
  [mResponseData release];
  [super dealloc];
}


- (int) readAll: (uint8_t *) buf offset: (int) off length: (int) len
{
  NSRange r;
  r.location = mResponseDataOffset;
  r.length = len;

  [mResponseData getBytes: buf+off range: r];
  mResponseDataOffset += len;

  return len;
}


- (void) write: (const uint8_t *) data offset: (unsigned int) offset length: (unsigned int) length
{
  [mRequestData appendBytes: data+offset length: length];
}


- (void) flush
{
  [mRequest setHTTPBody: mRequestData]; // not sure if it copies the data

  // make the HTTP request
  NSURLResponse * response;
  NSError * error;
  NSData * responseData =
    [NSURLConnection sendSynchronousRequest: mRequest returningResponse: &response error: &error];

  [mRequestData setLength: 0];

  if (responseData == nil) {
    @throw [TTransportException exceptionWithName: @"TTransportException"
                                reason: @"Could not make HTTP request"
                                error: error];
  }
  if (![response isKindOfClass: [NSHTTPURLResponse class]]) {
    @throw [TTransportException exceptionWithName: @"TTransportException"
                                           reason: [NSString stringWithFormat: @"Unexpected NSURLResponse type: %@",
                                                    NSStringFromClass([response class])]];
  }

  NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *) response;
  if ([httpResponse statusCode] != 200) {
    @throw [TTransportException exceptionWithName: @"TTransportException"
                                           reason: [NSString stringWithFormat: @"Bad response from HTTP server: %d",
                                                    [httpResponse statusCode]]];
  }

  // phew!
  [mResponseData release];
  mResponseData = [responseData retain];
  mResponseDataOffset = 0;
}

static char *alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";  
  
+(NSString *)encode:(NSData *)plainText {  
    int encodedLength = (((([plainText length] % 3) + [plainText length]) / 3) * 4) + 1;  
    unsigned char *outputBuffer = malloc(encodedLength);  
    unsigned char *inputBuffer = (unsigned char *)[plainText bytes];  
	
    NSInteger i;  
    NSInteger j = 0;  
    int remain;  
	
    for(i = 0; i < [plainText length]; i += 3) {  
        remain = [plainText length] - i;  
		
        outputBuffer[j++] = alphabet[(inputBuffer[i] & 0xFC) >> 2];  
        outputBuffer[j++] = alphabet[((inputBuffer[i] & 0x03) << 4) |   
                                     ((remain > 1) ? ((inputBuffer[i + 1] & 0xF0) >> 4): 0)];  
		
        if(remain > 1)  
            outputBuffer[j++] = alphabet[((inputBuffer[i + 1] & 0x0F) << 2)  
                                         | ((remain > 2) ? ((inputBuffer[i + 2] & 0xC0) >> 6) : 0)];  
        else   
            outputBuffer[j++] = '=';  
		
        if(remain > 2)  
            outputBuffer[j++] = alphabet[inputBuffer[i + 2] & 0x3F];  
        else  
            outputBuffer[j++] = '=';              
    }  
	
    outputBuffer[j] = 0;  
	
    NSString *result = [NSString stringWithCString:outputBuffer length:strlen(outputBuffer)];  
    free(outputBuffer);  
	
    return result;  
}  


@end

#!/usr/bin/env python

#  CopyFramework.py
#  ThriftCocoaLibrary

#
#  Created by Paul Mans on 5/18/11.
#  Copyright 2011 TripAdvisor. All rights reserved.


import os

info = os.environ['INFOPLIST_FILE']
target = os.environ['TARGET_NAME']
srcroot = os.environ['SRCROOT']
buildProductsDir = os.environ['BUILT_PRODUCTS_DIR']
productName = os.environ['PRODUCT_NAME']

os.system('cp -R ' + buildProductsDir + '/ThriftCocoaLibrary.framework ' + '~/Library/Frameworks/ThriftCocoaLibrary.framework')

#!/bin/sh

thrift -v -strict --gen java:android_legacy,server -out ../../../../ ../../../../../../../Thrift/JWall/jwall.thrift
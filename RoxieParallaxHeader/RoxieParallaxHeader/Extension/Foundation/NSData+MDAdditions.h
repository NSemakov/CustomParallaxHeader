// ----------------------------------------------------------------------------
//
//  NSData+MDAdditions.h
//
//  @author     Alexander Bragin <alexander.bragin@gmail.com>
//  @copyright  Copyright (c) 2013, MediariuM Ltd. All rights reserved.
//
// ----------------------------------------------------------------------------

#import <Foundation/Foundation.h>

// ----------------------------------------------------------------------------

@interface NSData (MDAdditions)

// -- functions

+ (BOOL)isNullOrEmpty:(NSData *)aData;
- (BOOL)isEmpty;

- (NSString *)base64Decoding;

// returns a Foundation object
- (id)JSONObjectWithOptions:(NSJSONReadingOptions)opt error:(NSError **)error;

// --

@end

// ----------------------------------------------------------------------------

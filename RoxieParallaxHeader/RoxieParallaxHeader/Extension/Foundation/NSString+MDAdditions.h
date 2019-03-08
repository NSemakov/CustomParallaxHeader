// ----------------------------------------------------------------------------
//
//  NSString+MDAdditions.h
//
//  @author     Alexander Bragin <alexander.bragin@gmail.com>
//  @copyright  Copyright (c) 2013, MediariuM Ltd. All rights reserved.
//
// ----------------------------------------------------------------------------

#import <Foundation/Foundation.h>

// ----------------------------------------------------------------------------

@interface NSString (MDAdditions)

// -- functions

+ (BOOL)isNullOrEmpty:(NSString *)string;
- (BOOL)isEmpty;

- (BOOL)hasPrefixCaseInsensitive:(NSString *)string;

- (BOOL)isPhoneNumber;

- (NSString *)base64Decoding;

+ (NSString *)compressWhitespaces:(NSString *)target removeNewline:(BOOL)removeNL;
- (NSString *)compressWhitespaces;

- (NSString *)filterWithCharacterSet:(NSCharacterSet *)characterSet;

- (NSString *)trim;

// returns a Foundation object
- (id)JSONObjectWithOptions:(NSJSONReadingOptions)opt error:(NSError **)error;

// --

@end

// ----------------------------------------------------------------------------

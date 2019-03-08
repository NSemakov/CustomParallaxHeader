// ----------------------------------------------------------------------------
//
//  NSArray+MDAdditions.h
//
//  @author     Alexander Bragin <alexander.bragin@gmail.com>
//  @copyright  Copyright (c) 2013, MediariuM Ltd. All rights reserved.
//
// ----------------------------------------------------------------------------

#import <Foundation/Foundation.h>

// ----------------------------------------------------------------------------

@interface NSArray (MDAdditions)

// -- functions

+ (BOOL)isNullOrEmpty:(NSArray *)anArray;
- (BOOL)isEmpty;

// returns JSON string from a Foundation object
- (NSString *)JSONStringWithOptions:(NSJSONWritingOptions)opt error:(NSError **)error;

// --

@end

// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
//
//  NSDictionary+MDAdditions.h
//
//  @author     Alexander Bragin <alexander.bragin@gmail.com>
//  @copyright  Copyright (c) 2013, MediariuM Ltd. All rights reserved.
//
// ----------------------------------------------------------------------------

#import <Foundation/Foundation.h>

// ----------------------------------------------------------------------------

@interface NSDictionary (kMD_Additions)

// -- functions

+ (BOOL)isNullOrEmpty:(NSDictionary *)aDict;
- (BOOL)isEmpty;

- (id)objectForKey:(id)aKey defaultValue:(id)aValue;

// returns JSON string from a Foundation object
- (NSString *)JSONStringWithOptions:(NSJSONWritingOptions)opt error:(NSError **)error;

// --

@end

// ----------------------------------------------------------------------------

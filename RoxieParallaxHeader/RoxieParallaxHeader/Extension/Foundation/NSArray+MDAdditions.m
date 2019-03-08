// ----------------------------------------------------------------------------
//
//  NSArray+MDAdditions.m
//
//  @author     Alexander Bragin <alexander.bragin@gmail.com>
//  @copyright  Copyright (c) 2013, MediariuM Ltd. All rights reserved.
//
// ----------------------------------------------------------------------------

#import "NSArray+MDAdditions.h"

// ----------------------------------------------------------------------------

@implementation NSArray (MDAdditions)

// ----------------------------------------------------------------------------

+ (BOOL)isNullOrEmpty:(NSArray *)anArray
{
	return ( ! anArray || [anArray isKindOfClass:NSNull.class] || [anArray isEmpty]);
}

// ----------------------------------------------------------------------------

- (BOOL)isEmpty
{
	return (self.count < 1);
}

// ----------------------------------------------------------------------------

- (NSString *)JSONStringWithOptions:(NSJSONWritingOptions)opt error:(NSError **)error
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:opt error:error];
    return (data ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : nil);
}

// ----------------------------------------------------------------------------

@end

// ----------------------------------------------------------------------------

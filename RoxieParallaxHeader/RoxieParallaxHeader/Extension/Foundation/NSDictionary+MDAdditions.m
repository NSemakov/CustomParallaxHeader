// ----------------------------------------------------------------------------
//
//  NSDictionary+MDAdditions.m
//
//  @author     Alexander Bragin <alexander.bragin@gmail.com>
//  @copyright  Copyright (c) 2013, MediariuM Ltd. All rights reserved.
//
// ----------------------------------------------------------------------------

#import "NSDictionary+MDAdditions.h"

// ----------------------------------------------------------------------------

@implementation NSDictionary (kMD_Additions)

// ----------------------------------------------------------------------------

+ (BOOL)isNullOrEmpty:(NSDictionary *)aDict
{
	return ( ! aDict || [aDict isKindOfClass:NSNull.class] || [aDict isEmpty]);
}

// ----------------------------------------------------------------------------

- (BOOL)isEmpty
{
	return (self.count < 1);
}

// ----------------------------------------------------------------------------

- (id)objectForKey:(id)aKey defaultValue:(id)aValue
{
	id object = [self objectForKey:aKey];
	return (object != nil) ? object : aValue;
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

// ----------------------------------------------------------------------------
//
//  NSData+MDAdditions.m
//
//  @author     Alexander Bragin <alexander.bragin@gmail.com>
//  @copyright  Copyright (c) 2013, MediariuM Ltd. All rights reserved.
//
// ----------------------------------------------------------------------------

#import <CommonCrypto/CommonDigest.h>

#import "NSData+MDAdditions.h"

// ----------------------------------------------------------------------------

@implementation NSData (MDAdditions)

// ----------------------------------------------------------------------------

+ (BOOL)isNullOrEmpty:(NSData *)aData
{
	return ( ! aData || [aData isKindOfClass:NSNull.class] || [aData isEmpty]);
}

// ----------------------------------------------------------------------------

- (BOOL)isEmpty
{
	return (self.length < 1);
}

// ----------------------------------------------------------------------------

- (NSString *)base64Decoding
{
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

// ----------------------------------------------------------------------------

- (id)JSONObjectWithOptions:(NSJSONReadingOptions)opt error:(NSError **)error
{
    return [NSJSONSerialization JSONObjectWithData:self options:opt error:error];
}

// ----------------------------------------------------------------------------

@end

// ----------------------------------------------------------------------------

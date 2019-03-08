// ----------------------------------------------------------------------------
//
//  NSString+MDAdditions.m
//
//  @author     Alexander Bragin <alexander.bragin@gmail.com>
//  @copyright  Copyright (c) 2013, MediariuM Ltd. All rights reserved.
//
// ----------------------------------------------------------------------------

#import <CommonCrypto/CommonDigest.h>

#import "NSString+MDAdditions.h"

// ----------------------------------------------------------------------------

#define kSMA_RegExp_PhoneNumber  @"" \
		@"^(7|8)[0-9]{10}$"

// ----------------------------------------------------------------------------

@implementation NSString (MDAdditions)

// ----------------------------------------------------------------------------

+ (BOOL)isNullOrEmpty:(NSString *)aString
{
	return ( ! aString || [aString isKindOfClass:NSNull.class] || [aString isEmpty]);
}

// ----------------------------------------------------------------------------

- (BOOL)isEmpty
{
	return [self isEqualToString:@""];
}

// ----------------------------------------------------------------------------

- (BOOL)hasPrefixCaseInsensitive:(NSString *)string
{
    return (([string length] <= [self length]) &&
            ([self compare:string options:(NSCaseInsensitiveSearch | NSAnchoredSearch) range:NSMakeRange(0, [string length])] == NSOrderedSame));
}

// ----------------------------------------------------------------------------

- (BOOL)isPhoneNumber
{
	static NSPredicate *predicate = nil;

	if (predicate == nil) {
		predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kSMA_RegExp_PhoneNumber];
	}

	return [predicate evaluateWithObject:[self lowercaseString]];
}

// ----------------------------------------------------------------------------

- (NSString *)base64Decoding
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    return (data ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : nil);
}

// ----------------------------------------------------------------------------

+ (NSString *)compressWhitespaces:(NSString *)sourceString removeNewline:(BOOL)removeNL
{
	if ([NSString isNullOrEmpty:sourceString]) { return @""; }

	// ...
	sourceString = [[[sourceString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
				stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"]
				stringByReplacingOccurrencesOfString:@"\r"   withString:@"\n"];

	// ...
	NSCharacterSet *characterSet = (removeNL ? [NSCharacterSet whitespaceAndNewlineCharacterSet]
											 : [NSCharacterSet whitespaceCharacterSet]);

	NSArray *components = [sourceString componentsSeparatedByCharactersInSet:characterSet];
	NSMutableArray *chunks = [NSMutableArray arrayWithCapacity:components.count];

	for (id component in components)
	{
		NSString *string = [component stringByTrimmingCharactersInSet:characterSet];

		if (string.isEmpty)
			continue;

		[chunks addObject:string];
	}

	// Done
	return [chunks componentsJoinedByString:@" "];
}

// ----------------------------------------------------------------------------

- (NSString *)compressWhitespaces {
    return [NSString compressWhitespaces:self removeNewline:YES];
}

// ----------------------------------------------------------------------------

- (NSString *)filterWithCharacterSet:(NSCharacterSet *)allowedChars
{
	NSString *source = [self copy]; // the original text
	NSMutableString *result = [NSMutableString stringWithCapacity:source.length];

	// filter string
	NSScanner *scanner = [NSScanner scannerWithString:source];
	while ([scanner isAtEnd] == NO)
	{
		NSString *buffer = nil;
		if ([scanner scanCharactersFromSet:allowedChars intoString:&buffer])
		{
			[result  appendString:buffer];
		}
		else {
			[scanner setScanLocation:([scanner scanLocation] + 1)];
		}
	}
	
	// Done
	return result;
}

// ----------------------------------------------------------------------------

- (NSString *)trim {
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

// ----------------------------------------------------------------------------

- (id)JSONObjectWithOptions:(NSJSONReadingOptions)opt error:(NSError **)error
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return (data ? [NSJSONSerialization JSONObjectWithData:data options:opt error:error] : nil);
}

// ----------------------------------------------------------------------------

@end

// ----------------------------------------------------------------------------

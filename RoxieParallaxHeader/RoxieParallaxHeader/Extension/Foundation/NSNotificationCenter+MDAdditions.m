// ----------------------------------------------------------------------------
//
//  NSNotificationCenter+MDAdditions.m
//
//  @author     Alexander Bragin <alexander.bragin@gmail.com>
//  @copyright  Copyright (c) 2014, MediariuM Ltd. All rights reserved.
//  @link       http://www.mediarium.com/
//
// ----------------------------------------------------------------------------

#import "NSNotificationCenter+MDAdditions.h"

// ----------------------------------------------------------------------------

@implementation NSNotificationCenter (MDAdditions)

// ----------------------------------------------------------------------------
#pragma mark - @functions
// ----------------------------------------------------------------------------

- (void)postNotificationName:(NSString *)aName
{
    return [self postNotificationName:aName object:nil userInfo:nil];
}

// ----------------------------------------------------------------------------

@end

// ----------------------------------------------------------------------------

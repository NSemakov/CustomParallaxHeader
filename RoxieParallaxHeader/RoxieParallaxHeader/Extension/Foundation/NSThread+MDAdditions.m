// ----------------------------------------------------------------------------
//
//  NSThread+MDAdditions.m
//
//  @author     Alexander Bragin <alexander.bragin@gmail.com>
//  @copyright  Copyright (c) 2014, MediariuM Ltd. All rights reserved.
//  @link       http://www.mediarium.com/
//
// ----------------------------------------------------------------------------

#import "NSThread+MDAdditions.h"

// ----------------------------------------------------------------------------

#ifdef __BLOCKS__
void
dispatch_main_sync_safe(dispatch_block_t block)
{
    if ( ! block)
        return;

    if ([NSThread isMainThread]) {
        block();
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}
#endif

// ----------------------------------------------------------------------------

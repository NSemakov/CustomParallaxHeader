// ----------------------------------------------------------------------------
//
//  NSError+MDAdditions.h
//
//  @author     Alexander Bragin <alexander.bragin@gmail.com>
//  @copyright  Copyright (c) 2014, MediariuM Ltd. All rights reserved.
//  @link       http://www.mediarium.com/
//
// ----------------------------------------------------------------------------

#import <Foundation/Foundation.h>

// ----------------------------------------------------------------------------

@interface NSError (MDAdditions)

// -- properties

// ...

// -- functions

// ...

// --

@end

// ----------------------------------------------------------------------------
#ifndef NSERROR_INIT_SAFE
// --

#define NSERROR_INIT_SAFE(ptr, error) \
        if (ptr != nil) {*ptr = error;}

// --
#endif
// ----------------------------------------------------------------------------

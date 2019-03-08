// ----------------------------------------------------------------------------
//
//  UIImage+MDAdditions.h
//
//  @author     Alexander Bragin <alexander.bragin@gmail.com>
//  @copyright  Copyright (c) 2014, MediariuM Ltd. All rights reserved.
//  @link       http://www.mediarium.com/
//
// ----------------------------------------------------------------------------

#import <UIKit/UIKit.h>

// ----------------------------------------------------------------------------

@interface UIImage (MDAdditions)

// -- properties

// ...

// -- functions

+ (UIImage *)stretchableImageNamed:(NSString *)name leftCapWidth:(NSInteger)leftCapWidth
        topCapHeight:(NSInteger)topCapHeight;

- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha;

// --

@end

// ----------------------------------------------------------------------------

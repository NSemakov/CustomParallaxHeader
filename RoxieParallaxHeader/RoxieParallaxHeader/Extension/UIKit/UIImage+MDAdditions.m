// ----------------------------------------------------------------------------
//
//  UIImage+MDAdditions.m
//
//  @author     Alexander Bragin <alexander.bragin@gmail.com>
//  @copyright  Copyright (c) 2014, MediariuM Ltd. All rights reserved.
//  @link       http://www.mediarium.com/
//
// ----------------------------------------------------------------------------

#import "UIImage+MDAdditions.h"

// ----------------------------------------------------------------------------

@implementation UIImage (MDAdditions)

// ----------------------------------------------------------------------------
#pragma mark - @properties
// ----------------------------------------------------------------------------

// ...

// ----------------------------------------------------------------------------
#pragma mark - @protected functions
// ----------------------------------------------------------------------------

// ...

// ----------------------------------------------------------------------------
#pragma mark - @functions
// ----------------------------------------------------------------------------

+ (UIImage *)stretchableImageNamed:(NSString *)name leftCapWidth:(NSInteger)leftCapWidth
        topCapHeight:(NSInteger)topCapHeight
{
    UIImage *image = nil;

    // load stretchable image
    image = [UIImage imageNamed:name];
    image = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];

    // Done
    return image;
}

// ----------------------------------------------------------------------------

- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha
{
    // How to set the opacity/alpha of a UIImage?
    // @link http://stackoverflow.com/a/10819117

    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);

    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, self.CGImage);

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}

// ----------------------------------------------------------------------------

@end

// ----------------------------------------------------------------------------

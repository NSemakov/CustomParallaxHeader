// ----------------------------------------------------------------------------
//
//  UIView+MDAdditions.m
//
//  @author     Alexander Bragin <alexander.bragin@gmail.com>
//  @copyright  Copyright (c) 2014, MediariuM Ltd. All rights reserved.
//
// ----------------------------------------------------------------------------

#import "UIView+MDAdditions.h"

// ----------------------------------------------------------------------------

@implementation UIView (MDAdditions)

// ----------------------------------------------------------------------------
#pragma mark - @properties
// ----------------------------------------------------------------------------

- (CGFloat)left {
    return self.frame.origin.x;
}

// ----------------------------------------------------------------------------

- (void)setLeft:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

// ----------------------------------------------------------------------------

- (CGFloat)top {
    return self.frame.origin.y;
}

// ----------------------------------------------------------------------------

- (void)setTop:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

// ----------------------------------------------------------------------------

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

// ----------------------------------------------------------------------------

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

// ----------------------------------------------------------------------------

- (CGFloat)width {
    return self.frame.size.width;
}

// ----------------------------------------------------------------------------

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

// ----------------------------------------------------------------------------

- (CGFloat)height {
    return self.frame.size.height;
}

// ----------------------------------------------------------------------------

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

// ----------------------------------------------------------------------------

- (CGFloat)screenX
{
    CGFloat x = 0;
    for (UIView *view = self; view; view = view.superview) {
        x += view.left;
    }

    return x;
}

// ----------------------------------------------------------------------------

- (CGFloat)screenY
{
    CGFloat y = 0;
    for (UIView *view = self; view; view = view.superview) {
        y += view.top;
    }

    return y;
}

// ----------------------------------------------------------------------------

- (CGFloat)screenViewX
{
    CGFloat x = 0;
    for (UIView *view = self; view; view = view.superview) {
        x += view.left;

        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *) view;
            x -= scrollView.contentOffset.x;
        }
    }

    return x;
}

// ----------------------------------------------------------------------------

- (CGFloat)screenViewY
{
    CGFloat y = 0;
    for (UIView *view = self; view; view = view.superview) {
        y += view.top;

        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *) view;
            y -= scrollView.contentOffset.y;
        }
    }

    return y;
}

// ----------------------------------------------------------------------------

- (CGPoint)origin {
    return self.frame.origin;
}

// ----------------------------------------------------------------------------

- (void)setOrigin:(CGPoint)point
{
    CGRect frame = self.frame;
    frame.origin.x = point.x;
    frame.origin.y = point.y;
    self.frame = frame;
}

// ----------------------------------------------------------------------------

- (CGSize)size {
    return self.frame.size;
}

// ----------------------------------------------------------------------------

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size.width = size.width;
    frame.size.height = size.height;
    self.frame = frame;
}

// ----------------------------------------------------------------------------
#pragma mark - @functions
// ----------------------------------------------------------------------------

- (UIView *)findChildWithDescendant:(UIView *)descendant
{
    for (UIView *view = descendant; view && view != self; view = view.superview)
    {
        if (view.superview == self)
            return view;
    }

    return nil;
}

// ----------------------------------------------------------------------------

- (CGPoint)offsetFromView:(UIView *)otherView
{
    CGFloat x = 0, y = 0;
    for (UIView *view = self; view && view != otherView; view = view.superview)
    {
        x += view.left;
        y += view.top;
    }

    return CGPointMake(x, y);
}

// ----------------------------------------------------------------------------

- (void)removeSubviews
{
    while (self.subviews.count)
    {
        UIView *child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

// ----------------------------------------------------------------------------

@end

// ----------------------------------------------------------------------------

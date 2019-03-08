// ----------------------------------------------------------------------------
//
//  UIView+MDAdditions.h
//
//  @author     Alexander Bragin <alexander.bragin@gmail.com>
//  @copyright  Copyright (c) 2014, MediariuM Ltd. All rights reserved.
//
// ----------------------------------------------------------------------------

#import <UIKit/UIKit.h>

// ----------------------------------------------------------------------------

@interface UIView (MDAdditions)

// -- properties

@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat top;
@property(nonatomic,readonly) CGFloat right;
@property(nonatomic,readonly) CGFloat bottom;

@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;

@property(nonatomic,readonly) CGFloat screenX;
@property(nonatomic,readonly) CGFloat screenY;

@property(nonatomic,readonly) CGFloat screenViewX;
@property(nonatomic,readonly) CGFloat screenViewY;

@property(nonatomic) CGPoint origin;
@property(nonatomic) CGSize size;

// -- functions

- (UIView *)findChildWithDescendant:(UIView *)descendant;

- (CGPoint)offsetFromView:(UIView *)otherView;

- (void)removeSubviews;

// --

@end

// ----------------------------------------------------------------------------

//
//  UIView+ZCCate.h
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/24.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZCCate)

/**
 Shortcut to set the view.layer's shadow
 
 @param color  Shadow Color
 @param offset Shadow offset
 @param radius Shadow radius
 */
- (void)setLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius;

/**
 Remove all subviews.
 
 @warning Never call this method inside your view's drawRect: method.
 */
- (void)removeAllSubviews;

/**
 Returns the view's view controller (may be nil).
 */
@property (nonatomic, readonly) UIViewController *viewController;

@property (nonatomic) CGFloat left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint origin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  size;        ///< Shortcut for frame.size.
/// 获取当前 view 在 superview 内垂直居中时的 top
@property(nonatomic, assign, readonly) CGFloat zc_topWhenCenterInSuperview;

@end

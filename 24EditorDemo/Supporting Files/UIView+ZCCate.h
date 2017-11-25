//
//  UIView+ZCCate.h
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/24.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZCCate)

/// 获取当前 view 在 superview 内垂直居中时的 top
@property(nonatomic, assign, readonly) CGFloat zc_topWhenCenterInSuperview;

@end

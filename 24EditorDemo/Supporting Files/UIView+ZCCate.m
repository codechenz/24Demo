//
//  UIView+ZCCate.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/24.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "UIView+ZCCate.h"

@implementation UIView (ZCCate)

- (CGFloat)zc_topWhenCenterInSuperview {
    return CGFloatGetCenter(CGRectGetHeight(self.superview.bounds), CGRectGetHeight(self.frame));
}

@end

//
//  CALayer+ZCCate.h
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/23.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface CALayer (ZCCate)

/**
 * 移除 CALayer（包括 CAShapeLayer 和 CAGradientLayer）所有支持动画的属性的默认动画，方便需要一个不带动画的 layer 时使用。
 */
- (void)zc_removeDefaultAnimations;

@end

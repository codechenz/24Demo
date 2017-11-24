//
//  UIControl+ZCCate.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/23.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "UIControl+ZCCate.h"
#import <objc/runtime.h>

static char kAssociatedObjectKey_outsideEdge;
@implementation UIControl (ZCCate)

- (void)setZc_outsideEdge:(UIEdgeInsets)zc_outsideEdge {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_outsideEdge, [NSValue valueWithUIEdgeInsets:zc_outsideEdge], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)zc_outsideEdge {
    return [objc_getAssociatedObject(self, &kAssociatedObjectKey_outsideEdge) UIEdgeInsetsValue];
}

@end

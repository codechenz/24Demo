//
//  UILabel+ZCCate.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/23.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "UILabel+ZCCate.h"
#import "NSObject+ZCCate.h"

@implementation UILabel (ZCCate)

- (void)zc_setTheSameAppearanceAsLabel:(UILabel *)label {
    self.font = label.font;
    self.textColor = label.textColor;
    self.backgroundColor = label.backgroundColor;
    self.lineBreakMode = label.lineBreakMode;
    self.textAlignment = label.textAlignment;
    if ([self respondsToSelector:@selector(setContentEdgeInsets:)] && [label respondsToSelector:@selector(contentEdgeInsets)]) {
        UIEdgeInsets contentEdgeInsets;
        [label zc_performSelector:@selector(contentEdgeInsets) withReturnValue:&contentEdgeInsets];
        [self zc_performSelector:@selector(setContentEdgeInsets:) withArguments:&contentEdgeInsets, nil];
    }
}

@end

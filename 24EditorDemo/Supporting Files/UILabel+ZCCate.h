//
//  UILabel+ZCCate.h
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/23.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ZCCate)

/**
 * 将目标UILabel的样式属性设置到当前UILabel上
 *
 * 将会复制的样式属性包括：font、textColor、backgroundColor
 * @param label 要从哪个目标UILabel上复制样式
 */
- (void)zc_setTheSameAppearanceAsLabel:(UILabel *)label;

@end

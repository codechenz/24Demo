//
//  UIImage+ZCCate.h
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/22.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZCCate)

+ (UIImage *)imageWithIcon:(NSString *)iconCode size:(NSUInteger)size color:(UIColor *)color;
+ (UIImage *)imageWithIcon:(NSString *)iconCode withSize:(CGSize)size withColor:(UIColor *)color;
@end

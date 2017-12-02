//
//  UIImage+ZCCate.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/22.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "UIImage+ZCCate.h"

@implementation UIImage (ZCCate)

+ (UIImage *)imageWithIcon:(NSString *)iconCode size:(NSUInteger)size color:(UIColor *)color {
    CGSize imageSize = CGSizeMake(size, size);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [[UIScreen mainScreen] scale]);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size, size)];
    label.font = [UIFont fontWithName:kIFIcon24App size:size];
    label.text = iconCode;
    if (color) {
        label.textColor = color;
    }
    [label.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    return retImage;
}

+ (UIImage *)imageWithIcon:(NSString *)iconCode withSize:(CGSize)size withColor:(UIColor *)color {
    CGSize imageSize = size;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [[UIScreen mainScreen] scale]);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    CGFloat fontSize = size.width > size.height ? size.width : size.height;
    label.font = [UIFont fontWithName:kIFIcon24App size:24];
    label.text = iconCode;
    if (color) {
        label.textColor = color;
    }
    [label.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    return retImage;
}

@end

//
//  UIColor+ZCCate.h
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/28.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ZCCate)

/**
 Creates and returns a color object from hex string.
 
 @discussion:
 Valid format: #RGB #RGBA #RRGGBB #RRGGBBAA 0xRGB ...
 The `#` or "0x" sign is not required.
 The alpha will be set to 1.0 if there is no alpha component.
 It will return nil when an error occurs in parsing.
 
 Example: @"0xF0F", @"66ccff", @"#66CCFF88"
 
 @param hexStr  The hex string value for the new color.
 
 @return        An UIColor object from string, or nil if an error occurs.
 */
+ (UIColor *)colorWithHexString:(NSString *)hexStr;

/**
 Creates and returns a color object by add new color.
 
 @param add        the color added
 
 @param blendMode  add color blend mode
 */
- (UIColor *)colorByAddColor:(UIColor *)add blendMode:(CGBlendMode)blendMode;

@end

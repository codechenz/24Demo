//
//  ZCHelper.h
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/24.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ZCHelperDelegate <NSObject>

@required
- (void)ZCHelperPrintLog:(nonnull NSString *)log;

@end

@interface ZCHelper : NSObject

+ (instancetype _Nonnull)sharedInstance;

@property(nullable, nonatomic, weak) id<ZCHelperDelegate> helperDelegate;

@end

@interface ZCHelper (UIGraphic)

/// 获取一像素的大小
+ (CGFloat)pixelOne;

@end

@interface ZCHelper (Device)

+ (BOOL)isIPad;
+ (BOOL)isIPadPro;
+ (BOOL)isIPod;
+ (BOOL)isIPhone;
+ (BOOL)isSimulator;

+ (BOOL)is58InchScreen;
+ (BOOL)is55InchScreen;
+ (BOOL)is47InchScreen;
+ (BOOL)is40InchScreen;
+ (BOOL)is35InchScreen;

+ (CGSize)screenSizeFor58Inch;
+ (CGSize)screenSizeFor55Inch;
+ (CGSize)screenSizeFor47Inch;
+ (CGSize)screenSizeFor40Inch;
+ (CGSize)screenSizeFor35Inch;

/// 判断当前设备是否高性能设备，只会判断一次，以后都直接读取结果，所以没有性能问题
+ (BOOL)isHighPerformanceDevice;
@end

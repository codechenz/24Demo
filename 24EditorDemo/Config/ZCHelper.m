//
//  ZCHelper.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/24.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCHelper.h"
#import <QuartzCore/QuartzCore.h>

@implementation ZCHelper

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static ZCHelper *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
        // 此处没有用到Keyboard
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (void)dealloc {
    // QMUIHelper 若干个分类里有用到消息监听，所以在 dealloc 的时候注销一下
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

@implementation ZCHelper (UIGraphic)

static CGFloat pixelOne = -1.0f;
+ (CGFloat)pixelOne {
    if (pixelOne < 0) {
        pixelOne = 1 / [[UIScreen mainScreen] scale];
    }
    return pixelOne;
}

@end

@implementation ZCHelper (Device)

static NSInteger isIPad = -1;
+ (BOOL)isIPad {
    if (isIPad < 0) {
        // [[[UIDevice currentDevice] model] isEqualToString:@"iPad"] 无法判断模拟器，改为以下方式
        isIPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 1 : 0;
    }
    return isIPad > 0;
}

static NSInteger isIPadPro = -1;
+ (BOOL)isIPadPro {
    if (isIPadPro < 0) {
        isIPadPro = [ZCHelper isIPad] ? (kDeviceWidth == 1024 && kDeviceHeight == 1366 ? 1 : 0) : 0;
    }
    return isIPadPro > 0;
}

static NSInteger isIPod = -1;
+ (BOOL)isIPod {
    if (isIPod < 0) {
        NSString *string = [[UIDevice currentDevice] model];
        isIPod = [string rangeOfString:@"iPod touch"].location != NSNotFound ? 1 : 0;
    }
    return isIPod > 0;
}

static NSInteger isIPhone = -1;
+ (BOOL)isIPhone {
    if (isIPhone < 0) {
        NSString *string = [[UIDevice currentDevice] model];
        isIPhone = [string rangeOfString:@"iPhone"].location != NSNotFound ? 1 : 0;
    }
    return isIPhone > 0;
}

static NSInteger isSimulator = -1;
+ (BOOL)isSimulator {
    if (isSimulator < 0) {
#if TARGET_OS_SIMULATOR
        isSimulator = 1;
#else
        isSimulator = 0;
#endif
    }
    return isSimulator > 0;
}

static NSInteger is58InchScreen = -1;
+ (BOOL)is58InchScreen {
    if (is58InchScreen < 0) {
        is58InchScreen = (kDeviceWidth == self.screenSizeFor58Inch.width && kDeviceHeight == self.screenSizeFor58Inch.height) ? 1 : 0;
    }
    return is58InchScreen > 0;
}

static NSInteger is55InchScreen = -1;
+ (BOOL)is55InchScreen {
    if (is55InchScreen < 0) {
        is55InchScreen = (kDeviceWidth == self.screenSizeFor55Inch.width && kDeviceHeight == self.screenSizeFor55Inch.height) ? 1 : 0;
    }
    return is55InchScreen > 0;
}

static NSInteger is47InchScreen = -1;
+ (BOOL)is47InchScreen {
    if (is47InchScreen < 0) {
        is47InchScreen = (kDeviceWidth == self.screenSizeFor47Inch.width && kDeviceHeight == self.screenSizeFor47Inch.height) ? 1 : 0;
    }
    return is47InchScreen > 0;
}

static NSInteger is40InchScreen = -1;
+ (BOOL)is40InchScreen {
    if (is40InchScreen < 0) {
        is40InchScreen = (kDeviceWidth == self.screenSizeFor40Inch.width && kDeviceHeight == self.screenSizeFor40Inch.height) ? 1 : 0;
    }
    return is40InchScreen > 0;
}

static NSInteger is35InchScreen = -1;
+ (BOOL)is35InchScreen {
    if (is35InchScreen < 0) {
        is35InchScreen = (kDeviceWidth == self.screenSizeFor35Inch.width && kDeviceHeight == self.screenSizeFor35Inch.height) ? 1 : 0;
    }
    return is35InchScreen > 0;
}

+ (CGSize)screenSizeFor58Inch {
    return CGSizeMake(375, 812);
}

+ (CGSize)screenSizeFor55Inch {
    return CGSizeMake(414, 736);
}

+ (CGSize)screenSizeFor47Inch {
    return CGSizeMake(375, 667);
}

+ (CGSize)screenSizeFor40Inch {
    return CGSizeMake(320, 568);
}

+ (CGSize)screenSizeFor35Inch {
    return CGSizeMake(320, 480);
}

static NSInteger isHighPerformanceDevice = -1;
+ (BOOL)isHighPerformanceDevice {
    if (isHighPerformanceDevice < 0) {
        isHighPerformanceDevice = PreferredVarForUniversalDevices(1, 1, 1, 0, 0);
    }
    return isHighPerformanceDevice > 0;
}
@end



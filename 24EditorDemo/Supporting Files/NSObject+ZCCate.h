//
//  NSObject+ZCCate.h
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/23.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ZCCate)

/**
 *  系统的 performSelector 不支持参数或返回值为非对象的 selector 的调用，所以在 QMUI 增加了对应的方法，支持对象和非对象的 selector。
 *  @param selector 要被调用的方法名
 *  @param firstArgument 调用 selector 时要传的第一个参数的指针地址
 */
- (void)zc_performSelector:(SEL)selector withArguments:(void *)firstArgument, ...;

/**
 *  系统的 performSelector 不支持参数或返回值为非对象的 selector 的调用，所以在 QMUI 增加了对应的方法，支持对象和非对象的 selector。
 *  @param selector 要被调用的方法名
 *  @param returnValue selector 的返回值的指针地址
 */
- (void)zc_performSelector:(SEL)selector withReturnValue:(void *)returnValue;

/**
 *  系统的 performSelector 不支持参数或返回值为非对象的 selector 的调用，所以在 QMUI 增加了对应的方法，支持对象和非对象的 selector。
 *
 *  使用示例：
 *  CGFloat result;
 *  CGFloat arg1, arg2;
 *  [self zc_performSelector:xxx withReturnValue:&result arguments:&arg1, &arg2, nil];
 *  // 到这里 result 已经被赋值为 selector 的 return 值
 *
 *  @param selector 要被调用的方法名
 *  @param returnValue selector 的返回值的指针地址
 *  @param firstArgument 调用 selector 时要传的第一个参数的指针地址
 */
- (void)zc_performSelector:(SEL)selector withReturnValue:(void *)returnValue arguments:(void *)firstArgument, ...;

/**
 遍历某个 protocol 里的所有方法
 
 @param protocol 要遍历的 protocol，例如 \@protocol(xxx)
 @param block 遍历过程中调用的 block
 */
+ (void)zc_enumerateProtocolMethods:(Protocol *)protocol usingBlock:(void (^)(SEL selector))block;

@end

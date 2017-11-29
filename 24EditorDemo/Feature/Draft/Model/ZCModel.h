//
//  ZCModel.h
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/29.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *time;

@end

//
//  ZCModel.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/29.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCModel.h"

@implementation ZCModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _title = dictionary[@"title"];
        _content = dictionary[@"content"];
        _time = dictionary[@"time"];
    }
    return self;
}

@end

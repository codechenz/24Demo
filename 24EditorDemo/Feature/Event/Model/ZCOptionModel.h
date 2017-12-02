//
//  ZCOptionModel.h
//  24EditorDemo
//
//  Created by zhuchen on 2017/12/2.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCBaseModel.h"

@interface ZCOptionModel : ZCBaseModel

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSString * pid;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

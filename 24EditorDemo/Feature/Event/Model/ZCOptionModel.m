//
//  ZCOptionModel.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/12/2.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCOptionModel.h"

NSString *const kZCOptionCount = @"count";
NSString *const kZCOptionDesc = @"desc";
NSString *const kZCOptionPid = @"pid";

@interface ZCOptionModel ()
@end
@implementation ZCOptionModel


/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kZCOptionCount] isKindOfClass:[NSNull class]]){
        self.count = [dictionary[kZCOptionCount] integerValue];
    }
    
    if(![dictionary[kZCOptionDesc] isKindOfClass:[NSNull class]]){
        self.desc = dictionary[kZCOptionDesc];
    }
    if(![dictionary[kZCOptionPid] isKindOfClass:[NSNull class]]){
        self.pid = dictionary[kZCOptionPid];
    }
    return self;
}
@end

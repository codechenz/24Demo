//
//  ZCNewsModel.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/30.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCNewsModel.h"

NSString *const kZCNewsModelAlert = @"alert";
NSString *const kZCNewsModelAvatar = @"avatar";
NSString *const kZCNewsModelContents = @"contents";
NSString *const kZCNewsModelDate = @"date";
NSString *const kZCNewsModelEditorname = @"editorname";
NSString *const kZCNewsModelEid = @"eid";
NSString *const kZCNewsModelIdField = @"id";
NSString *const kZCNewsModelLikes = @"likes";
NSString *const kZCNewsModelShare = @"share";
NSString *const kZCNewsModelTitle = @"title";
NSString *const kZCNewsModelType = @"type";
NSString *const kZCNewsModelUpdated = @"updated";
NSString *const kZCNewsModelUsername = @"username";

@interface ZCNewsModel ()
@end
@implementation ZCNewsModel

/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kZCNewsModelAlert] isKindOfClass:[NSNull class]]){
        self.alert = [dictionary[kZCNewsModelAlert] boolValue];
    }
    
    if(![dictionary[kZCNewsModelAvatar] isKindOfClass:[NSNull class]]){
        self.avatar = dictionary[kZCNewsModelAvatar];
    }
    if(![dictionary[kZCNewsModelContents] isKindOfClass:[NSNull class]]){
        self.contents = dictionary[kZCNewsModelContents];
    }
    if(![dictionary[kZCNewsModelDate] isKindOfClass:[NSNull class]]){
        self.date = [dictionary[kZCNewsModelDate] integerValue];
    }
    
    if(![dictionary[kZCNewsModelEditorname] isKindOfClass:[NSNull class]]){
        self.editorname = [dictionary[kZCNewsModelEditorname] boolValue];
    }
    
    if(![dictionary[kZCNewsModelEid] isKindOfClass:[NSNull class]]){
        self.eid = dictionary[kZCNewsModelEid];
    }
    if(![dictionary[kZCNewsModelIdField] isKindOfClass:[NSNull class]]){
        self.idField = dictionary[kZCNewsModelIdField];
    }
    if(![dictionary[kZCNewsModelLikes] isKindOfClass:[NSNull class]]){
        self.likes = [dictionary[kZCNewsModelLikes] integerValue];
    }
    
    if(![dictionary[kZCNewsModelShare] isKindOfClass:[NSNull class]]){
        self.share = dictionary[kZCNewsModelShare];
    }
    if(![dictionary[kZCNewsModelTitle] isKindOfClass:[NSNull class]]){
        self.title = dictionary[kZCNewsModelTitle];
    }
    if(![dictionary[kZCNewsModelType] isKindOfClass:[NSNull class]]){
        self.type = [dictionary[kZCNewsModelType] integerValue];
    }
    
    if(![dictionary[kZCNewsModelUpdated] isKindOfClass:[NSNull class]]){
        self.updated = [dictionary[kZCNewsModelUpdated] integerValue];
    }
    
    if(![dictionary[kZCNewsModelUsername] isKindOfClass:[NSNull class]]){
        self.username = dictionary[kZCNewsModelUsername];
    }
    return self;
}

@end

//
//  ZCAudioModel.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/12/1.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCAudioModel.h"

NSString *const kZCAudioModelAlert = @"alert";
NSString *const kZCAudioModelAvatar = @"avatar";
NSString *const kZCAudioModelContents = @"contents";
NSString *const kZCAudioModelDate = @"date";
NSString *const kZCAudioModelEditorname = @"editorname";
NSString *const kZCAudioModelEid = @"eid";
NSString *const kZCAudioModelIdField = @"id";
NSString *const kZCAudioModelLikes = @"likes";
NSString *const kZCAudioModelShare = @"share";
NSString *const kZCAudioModelTitle = @"title";
NSString *const kZCAudioModelType = @"type";
NSString *const kZCAudioModelUpdated = @"updated";
NSString *const kZCAudioModelUsername = @"username";

@interface ZCAudioModel ()
@end
@implementation ZCAudioModel

/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if(![dictionary[kZCAudioModelContents] isKindOfClass:[NSNull class]]){
        self.audioFileURL = [NSURL URLWithString: dictionary[kZCAudioModelContents]];
    }
    
    if(![dictionary[kZCAudioModelAlert] isKindOfClass:[NSNull class]]){
        self.alert = [dictionary[kZCAudioModelAlert] boolValue];
    }
    
    if(![dictionary[kZCAudioModelAvatar] isKindOfClass:[NSNull class]]){
        self.avatar = dictionary[kZCAudioModelAvatar];
    }
    if(![dictionary[kZCAudioModelContents] isKindOfClass:[NSNull class]]){
        self.contents = dictionary[kZCAudioModelContents];
    }
    if(![dictionary[kZCAudioModelDate] isKindOfClass:[NSNull class]]){
        self.date = [dictionary[kZCAudioModelDate] integerValue];
    }
    
    if(![dictionary[kZCAudioModelEditorname] isKindOfClass:[NSNull class]]){
        self.editorname = [dictionary[kZCAudioModelEditorname] boolValue];
    }
    
    if(![dictionary[kZCAudioModelEid] isKindOfClass:[NSNull class]]){
        self.eid = dictionary[kZCAudioModelEid];
    }
    if(![dictionary[kZCAudioModelIdField] isKindOfClass:[NSNull class]]){
        self.idField = dictionary[kZCAudioModelIdField];
    }
    if(![dictionary[kZCAudioModelLikes] isKindOfClass:[NSNull class]]){
        self.likes = [dictionary[kZCAudioModelLikes] integerValue];
    }
    
    if(![dictionary[kZCAudioModelShare] isKindOfClass:[NSNull class]]){
        self.share = dictionary[kZCAudioModelShare];
    }
    if(![dictionary[kZCAudioModelTitle] isKindOfClass:[NSNull class]]){
        self.title = dictionary[kZCAudioModelTitle];
    }
    if(![dictionary[kZCAudioModelType] isKindOfClass:[NSNull class]]){
        self.type = [dictionary[kZCAudioModelType] integerValue];
    }
    
    if(![dictionary[kZCAudioModelUpdated] isKindOfClass:[NSNull class]]){
        self.updated = [dictionary[kZCAudioModelUpdated] integerValue];
    }
    
    if(![dictionary[kZCAudioModelUsername] isKindOfClass:[NSNull class]]){
        self.username = dictionary[kZCAudioModelUsername];
    }
    
    //附加字段
    self.audioStreamerStatus = DOUAudioStreamerPaused; //DOUAudioStreamerPaused
    return self;
}

@end

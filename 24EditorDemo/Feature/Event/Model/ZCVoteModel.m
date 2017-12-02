//
//  ZCVoteModel.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/12/2.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCVoteModel.h"

NSString *const kZCVoteModelAlert = @"alert";
NSString *const kZCVoteModelAvatar = @"avatar";
NSString *const kZCVoteModelCreated = @"created";
NSString *const kZCVoteModelDuration = @"duration";
NSString *const kZCVoteModelEditorname = @"editorname";
NSString *const kZCVoteModelOptions = @"options";
NSString *const kZCVoteModelSubject = @"subject";
NSString *const kZCVoteModelTotalCount = @"totalCount";
NSString *const kZCVoteModelUid = @"uid";
NSString *const kZCVoteModelUname = @"uname";
NSString *const kZCVoteModelVid = @"vid";
NSString *const kZCVoteModelVisible = @"visible";

@interface ZCVoteModel ()
@end
@implementation ZCVoteModel

/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kZCVoteModelAlert] isKindOfClass:[NSNull class]]){
        self.alert = [dictionary[kZCVoteModelAlert] boolValue];
    }
    
    if(![dictionary[kZCVoteModelAvatar] isKindOfClass:[NSNull class]]){
        self.avatar = dictionary[kZCVoteModelAvatar];
    }
    if(![dictionary[kZCVoteModelCreated] isKindOfClass:[NSNull class]]){
        self.created = [dictionary[kZCVoteModelCreated] integerValue];
    }
    
    if(![dictionary[kZCVoteModelDuration] isKindOfClass:[NSNull class]]){
        self.duration = [dictionary[kZCVoteModelDuration] integerValue];
    }
    
    if(![dictionary[kZCVoteModelEditorname] isKindOfClass:[NSNull class]]){
        self.editorname = [dictionary[kZCVoteModelEditorname] boolValue];
    }
    
    if(dictionary[kZCVoteModelOptions] != nil && [dictionary[kZCVoteModelOptions] isKindOfClass:[NSArray class]]){
        NSArray * optionsDictionaries = dictionary[kZCVoteModelOptions];
        NSMutableArray * optionsItems = [NSMutableArray array];
        for(NSDictionary * optionsDictionary in optionsDictionaries){
            ZCOptionModel * optionsItem = [[ZCOptionModel alloc] initWithDictionary:optionsDictionary];
            [optionsItems addObject:optionsItem];
        }
        self.options = optionsItems;
    }
    if(![dictionary[kZCVoteModelSubject] isKindOfClass:[NSNull class]]){
        self.subject = dictionary[kZCVoteModelSubject];
    }
    if(![dictionary[kZCVoteModelTotalCount] isKindOfClass:[NSNull class]]){
        self.totalCount = [dictionary[kZCVoteModelTotalCount] integerValue];
    }
    
    if(![dictionary[kZCVoteModelUid] isKindOfClass:[NSNull class]]){
        self.uid = dictionary[kZCVoteModelUid];
    }
    if(![dictionary[kZCVoteModelUname] isKindOfClass:[NSNull class]]){
        self.uname = dictionary[kZCVoteModelUname];
    }
    if(![dictionary[kZCVoteModelVid] isKindOfClass:[NSNull class]]){
        self.vid = dictionary[kZCVoteModelVid];
    }
    if(![dictionary[kZCVoteModelVisible] isKindOfClass:[NSNull class]]){
        self.visible = [dictionary[kZCVoteModelVisible] boolValue];
    }
    
    return self;
}
@end

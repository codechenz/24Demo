//
//  ZCAudioModel.h
//  24EditorDemo
//
//  Created by zhuchen on 2017/12/1.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCBaseModel.h"
#import "DOUAudioFile.h"
#import "DOUAudioStreamer.h"

@interface ZCAudioModel : ZCBaseModel <DOUAudioFile>

@property (nonatomic, assign) BOOL alert;
@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSString * contents;
@property (nonatomic, assign) NSInteger date;
@property (nonatomic, assign) BOOL editorname;
@property (nonatomic, strong) NSString * eid;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, assign) NSInteger likes;
@property (nonatomic, strong) NSString * share;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger updated;
@property (nonatomic, strong) NSString * username;


@property (nonatomic, strong) NSURL *audioFileURL;

//附加音频本地字段
@property (nonatomic, assign) DOUAudioStreamerStatus audioStreamerStatus;
@property (nonatomic, assign) float audioDuration;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

//
//  ZCVoteModel.h
//  24EditorDemo
//
//  Created by zhuchen on 2017/12/2.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCBaseModel.h"
#import "ZCOptionModel.h"

@interface ZCVoteModel : ZCBaseModel

@property (nonatomic, assign) BOOL alert;
@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, assign) NSInteger created;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) BOOL editorname;
@property (nonatomic, strong) NSArray * options;
@property (nonatomic, strong) NSString * subject;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) NSString * uid;
@property (nonatomic, strong) NSString * uname;
@property (nonatomic, strong) NSString * vid;
@property (nonatomic, assign) BOOL visible;


//占时补充字段
@property (nonatomic, assign) NSInteger type;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

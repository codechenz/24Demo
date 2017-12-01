//
//  ZCNewsModel.h
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/30.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCBaseModel.h"

@interface ZCNewsModel : ZCBaseModel

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

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

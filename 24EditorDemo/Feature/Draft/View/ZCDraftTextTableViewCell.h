//
//  ZCDraftTextTableViewCell.h
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/27.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCModel.h"

@interface ZCDraftTextTableViewCell : UITableViewCell

@property (nonatomic, strong) ZCModel *model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end

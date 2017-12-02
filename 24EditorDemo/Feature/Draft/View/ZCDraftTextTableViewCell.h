//
//  ZCDraftTextTableViewCell.h
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/27.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCNewsModel.h"

@class ZCDraftTextTableViewCell;
@protocol ZCDraftTextTableViewCellDelegate <NSObject>

@optional

- (void)draftTextHandleClapButtonClick:(ZCDraftTextTableViewCell *)cell;

- (void)draftTextCell:(ZCDraftTextTableViewCell *)cell handleArtboardButtonClick:(UIButton *)sender;

@end

@interface ZCDraftTextTableViewCell : UITableViewCell
@property (nonatomic, weak) id<ZCDraftTextTableViewCellDelegate> delegate;

@property (nonatomic, strong) ZCNewsModel *newsModel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)updateLikesWithAnimation;

@end

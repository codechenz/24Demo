//
//  ZCNewsAudioTableViewCell.h
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/29.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCAudioModel.h"
#import <YLProgressBar.h>
#import "DOUAudioStreamer.h"

@class ZCNewsAudioTableViewCell;
@protocol ZCNewsAudioTableViewCellDelegate <NSObject>

@optional
- (void)handleAudioPlayButtonClick:(UIButton *)sender cell:(ZCNewsAudioTableViewCell *)cell withAudioURL:(NSURL *)URL;

- (void)handleClapButtonClick:(ZCNewsAudioTableViewCell *)cell;

- (void)audioCell:(ZCNewsAudioTableViewCell *)cell handleArtBoardButtonClick:(UIButton *)sender;

@end

@interface ZCNewsAudioTableViewCell : UITableViewCell
@property (nonatomic, weak) id<ZCNewsAudioTableViewCellDelegate> delegate;

@property (nonatomic, strong) ZCAudioModel *audioModel;
@property (nonatomic, strong) YLProgressBar *audioYLProgressBar;
@property (nonatomic, strong) UILabel *audioTime;
@property (nonatomic, strong) UIActivityIndicatorView *audioIndicator;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)updateLikesWithAnimation;
- (void)updateAudioButtonStatus;

@end

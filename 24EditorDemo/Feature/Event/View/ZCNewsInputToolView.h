//
//  ZCNewsInputToolView.h
//  24EditorDemo
//
//  Created by zhuchen on 2017/12/2.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCInputTypeCollectionViewCell.h"

typedef void(^AddTypeButtonClickBlock)(UIButton *sender);
typedef void(^EditNewsTextButtonClickBlock)(UIButton *sender);
typedef void(^VoiceRecordButtonClickBlock)(UIButton *sender);

@protocol ZCNewsInputToolViewDelegate <NSObject>

@optional
- (void)collectionCellDidSelected:(ZCInputTypeCollectionViewCell *)cell;


@end

@interface ZCNewsInputToolView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, copy) AddTypeButtonClickBlock addTypeButtonClickBlock;
@property (nonatomic, copy) EditNewsTextButtonClickBlock editNewsTextButtonClickBlock;
@property (nonatomic, copy) VoiceRecordButtonClickBlock voiceRecordButtonClickBlock;
@property (nonatomic, weak) id<ZCNewsInputToolViewDelegate> delegate;
@property (nonatomic, strong) UIButton *voiceButton;


- (instancetype)initWithFrame:(CGRect)frame;
- (void)addTypeButtonClick:(AddTypeButtonClickBlock)block;
- (void)editNewsTextButtonClick:(EditNewsTextButtonClickBlock)block;
- (void)voiceRecordButtonClick:(VoiceRecordButtonClickBlock)block;
@end

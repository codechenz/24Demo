//
//  ZCInputToolView.h
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/22.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCBaseView.h"
#import "YYText.h"

typedef void(^SelectPhotoBlock) (UIButton *sender);
typedef void(^InputButtonBlock) (UIButton *sender);

@interface ZCInputToolView : ZCBaseView
@property (nonatomic, copy) SelectPhotoBlock selectPhotoBlock;
@property (nonatomic, copy) InputButtonBlock inputButtonBlock;

- (instancetype)initWithFrame:(CGRect)frame HostView:(YYTextView *)hostView isShowTool:(BOOL)isShowTool buttonTitle:(NSString *)buttonTitle;
- (void)selectPhotoButtonClick:(SelectPhotoBlock)block;
- (void)inputButtonOnClick:(InputButtonBlock)block;

@end

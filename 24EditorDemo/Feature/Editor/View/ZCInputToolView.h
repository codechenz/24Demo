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

@interface ZCInputToolView : ZCBaseView
@property (nonatomic, copy) SelectPhotoBlock selectPhotoBlock;

- (instancetype)initWithFrame:(CGRect)frame HostView:(YYTextView *)hostView;
- (void)selectPhotoButtonOnTouch:(SelectPhotoBlock)block;
@end

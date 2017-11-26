//
//  ZCInputToolView.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/22.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCInputToolView.h"
#import "UIView+YYAdd.h"
#import "UIImage+ZCCate.h"

@interface ZCInputToolView ()
@property (nonatomic, strong) UIView *toolView;
@property (nonatomic, strong) YYTextView *hostView;
@end

@implementation ZCInputToolView

- (instancetype)initWithFrame:(CGRect)frame HostView:(YYTextView *)hostView isShowTool:(BOOL)isShowTool buttonTitle:(NSString *)buttonTitle{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.hostView = hostView;
        
        self.backgroundColor = UIColorHex(#ffffff);
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        topView.backgroundColor = UIColorHex(#dfe6ee);
        [self addSubview:topView];
        
        UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, self.width / 5 * 2, self.height - 1)];
        [self addSubview:toolView];
        self.toolView = toolView;
        
        [self addButtonWithIcon:kIFIArrowDown size:12 tag:1001 hidden:NO];
        [self addButtonWithIcon:kIFIImage size:20 tag:1002 hidden:!isShowTool];
        [self addButtonWithIcon:kIFIUser size:20 tag:1003 hidden:!isShowTool];
        
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sendButton.size = CGSizeMake(66, 29);
        sendButton.right = kScreenWidth - 15;
        sendButton.centerY = self.centerY;
        sendButton.backgroundColor = UIColorHex(#0088cc);
        [sendButton setTitle:buttonTitle forState:UIControlStateNormal];
        sendButton.titleLabel.font = [UIFont fontWithName:kFNRalewayRegular size:15];
        sendButton.layer.cornerRadius = 4;
        sendButton.layer.masksToBounds = true;
        [sendButton addTarget:self action:@selector(handleSendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendButton];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    int count = self.toolView.subviews.count;
    
    CGFloat buttonW = self.toolView.width / count;
    CGFloat buttonH = self.height;
    for (int i = 0; i < count; i++) {
        UIButton *button = self.toolView.subviews[i];
        button.top = 0;
        button.width = buttonW;
        button.height = buttonH;
        button.left = i * buttonW;
    }
    
}

- (void)addButtonWithIcon:(NSString *)icon size:(NSInteger)size tag:(NSInteger)tag hidden:(BOOL)hidden {
    UIButton *button = [[UIButton alloc] init];
    button.tag = tag;
    button.hidden = hidden;
    [button addTarget:self action:@selector(buttonOnTouch:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [UIImage imageWithIcon:icon size:size color:UIColorHex(#667587)];
    [button setImage:image forState:UIControlStateNormal];
    
    [self.toolView addSubview:button];
}

#pragma mark - Event Handle

- (void)buttonOnTouch:(UIButton *)sender {
    switch (sender.tag) {
        case 1001:
            [_hostView resignFirstResponder];
            break;
        case 1002:
            self.selectPhotoBlock(sender);
            break;
            
        default:
            break;
    }
    NSLog(@"touch");
}

- (void)handleSendButtonClick:(UIButton *)sender {
    self.inputButtonBlock(sender);
}

#pragma mark - Block

- (void)selectPhotoButtonClick:(SelectPhotoBlock)block {
    self.selectPhotoBlock = block;
}

- (void)inputButtonOnClick:(InputButtonBlock)block {
    self.inputButtonBlock = block;
}



@end

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
@property (nonatomic, assign) UIView *toolView;
@end

@implementation ZCInputToolView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorHex(#ffffff);
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        topView.backgroundColor = UIColorHex(#dfe6ee);
        [self addSubview:topView];
        
        UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, self.width / 5 * 2, self.height - 1)];
        [self addSubview:toolView];
        self.toolView = toolView;
        
        [self addButtonWithIcon:kFIArrowDown size:12];
        [self addButtonWithIcon:kFIImage size:20];
        [self addButtonWithIcon:kFIUser size:20];
        
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sendButton.size = CGSizeMake(66, 29);
        sendButton.right = kScreenWidth - 15;
        sendButton.centerY = self.centerY;
        sendButton.backgroundColor = UIColorHex(#0088cc);
        [sendButton setTitle:@"Send" forState:UIControlStateNormal];
        sendButton.titleLabel.font = [UIFont fontWithName:@"Raleway-Medium" size:15];
        sendButton.layer.cornerRadius = 4;
        sendButton.layer.masksToBounds = true;
        [self addSubview:sendButton];
    }
    return self;
}

- (void)addButtonWithIcon:(NSString *)icon size:(NSInteger)size {
    UIButton *button = [[UIButton alloc] init];
    [button addTarget:self action:@selector(buttonOnTouch:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [UIImage imageWithIcon:icon size:size color:UIColorHex(#667587)];
    [button setImage:image forState:UIControlStateNormal];
    
    [self.toolView addSubview:button];
}

- (void)buttonOnTouch:(UIButton *)sender {
    NSLog(@"touch");
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

@end

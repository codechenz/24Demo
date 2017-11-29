//
//  ZCEventCountView.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/29.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCEventCountView.h"

@interface ZCEventCountView ()
@property (nonatomic, strong) UILabel *newsCountLabel;
@property (nonatomic, strong) UILabel *newsLabel;
@property (nonatomic, strong) UILabel *onlineCountLabel;
@property (nonatomic, strong) UILabel *onlineLabel;
@property (nonatomic, strong) UILabel *viewCountLabel;
@property (nonatomic, strong) UILabel *viewLabel;

@end

@implementation ZCEventCountView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.frame = self.bounds;
        
        [self.layer addSublayer:layer];
        
        layer.startPoint = CGPointMake(0, 1);
        layer.endPoint = CGPointMake(0, 0);
        
        layer.colors = @[(__bridge id)UIColorHex(#0088cc).CGColor, (__bridge id)UIColorHex(#19aacc).CGColor];
        layer.locations = @[@(0.5f), @(1.0f)];
        [self loadSubView];
    }
    return self;
}

- (void)loadSubView {
    UIView *insideView = [[UIView alloc] init];
    [self addSubview:insideView];
    [insideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).multipliedBy(0.84);
        make.top.and.bottom.and.centerX.equalTo(self);
    }];
    
    self.newsCountLabel = [[UILabel alloc] init];
    self.newsCountLabel.textColor = [UIColor whiteColor];
    self.newsCountLabel.font = [UIFont fontWithName:kFNPoppinsRegular size:14.5];
    self.newsCountLabel.text = @"235";
    self.newsCountLabel.textAlignment = NSTextAlignmentCenter;
    [insideView addSubview:self.newsCountLabel];
    [self.newsCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(insideView).multipliedBy(0.33);
        make.left.equalTo(insideView);
        make.bottom.equalTo(insideView.mas_centerY);
        make.height.equalTo(insideView).multipliedBy(0.35);
    }];
    
    self.newsLabel = [[UILabel alloc] init];
    self.newsLabel.textColor = [UIColor whiteColor];
    self.newsLabel.font = [UIFont fontWithName:kFNPoppinsRegular size:10.5];
    self.newsLabel.text = @"News";
    self.newsLabel.textAlignment = NSTextAlignmentCenter;
    [insideView addSubview:self.newsLabel];
    [self.newsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(insideView).multipliedBy(0.33);
        make.left.equalTo(insideView);
        make.top.equalTo(insideView.mas_centerY);
        make.height.equalTo(insideView).multipliedBy(0.35);
    }];
    
    UIView *separaViewA = [[UIView alloc] init];
    separaViewA.backgroundColor = [UIColor whiteColor];
    [insideView addSubview:separaViewA];
    
    [separaViewA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.newsCountLabel.mas_right);
        make.centerY.equalTo(self);
        make.height.equalTo(self).multipliedBy(0.3);
        make.width.equalTo(PixelOne);
    }];
    
    self.onlineCountLabel = [[UILabel alloc] init];
    self.onlineCountLabel.textColor = [UIColor whiteColor];
    self.onlineCountLabel.font = [UIFont fontWithName:kFNPoppinsRegular size:14.5];
    self.onlineCountLabel.text = @"3243";
    self.onlineCountLabel.textAlignment = NSTextAlignmentCenter;
    [insideView addSubview:self.onlineCountLabel];
    [self.onlineCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(insideView).multipliedBy(0.33);
        make.left.equalTo(self.newsCountLabel.mas_right);
        make.bottom.equalTo(insideView.mas_centerY);
        make.height.equalTo(insideView).multipliedBy(0.35);
    }];
    
    self.onlineLabel = [[UILabel alloc] init];
    self.onlineLabel.textColor = [UIColor whiteColor];
    self.onlineLabel.font = [UIFont fontWithName:kFNPoppinsRegular size:10.5];
    self.onlineLabel.text = @"Online";
    self.onlineLabel.textAlignment = NSTextAlignmentCenter;
    [insideView addSubview:self.onlineLabel];
    [self.onlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(insideView).multipliedBy(0.33);
        make.left.equalTo(self.newsCountLabel.mas_right);
        make.top.equalTo(insideView.mas_centerY);
        make.height.equalTo(insideView).multipliedBy(0.35);
    }];
    
    UIView *separaViewB = [[UIView alloc] init];
    separaViewB.backgroundColor = [UIColor whiteColor];
    [insideView addSubview:separaViewB];
    
    [separaViewB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.onlineCountLabel.mas_right);
        make.centerY.equalTo(self);
        make.height.equalTo(self).multipliedBy(0.3);
        make.width.equalTo(PixelOne);
    }];
    
    self.viewCountLabel = [[UILabel alloc] init];
    self.viewCountLabel.textColor = [UIColor whiteColor];
    self.viewCountLabel.font = [UIFont fontWithName:kFNPoppinsRegular size:14.5];
    self.viewCountLabel.text = @"22,320";
    self.viewCountLabel.textAlignment = NSTextAlignmentCenter;
    [insideView addSubview:self.viewCountLabel];
    [self.viewCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(insideView).multipliedBy(0.33);
        make.left.equalTo(self.onlineCountLabel.mas_right);
        make.bottom.equalTo(insideView.mas_centerY);
        make.height.equalTo(insideView).multipliedBy(0.35);
    }];
    
    self.viewLabel = [[UILabel alloc] init];
    self.viewLabel.textColor = [UIColor whiteColor];
    self.viewLabel.font = [UIFont fontWithName:kFNPoppinsRegular size:10.5];
    self.viewLabel.text = @"Page Views";
    self.viewLabel.textAlignment = NSTextAlignmentCenter;
    [insideView addSubview:self.viewLabel];
    [self.viewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(insideView).multipliedBy(0.33);
        make.left.equalTo(self.onlineCountLabel.mas_right);
        make.top.equalTo(insideView.mas_centerY);
        make.height.equalTo(insideView).multipliedBy(0.35);
    }];
}

@end

//
//  ZCScoreView.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/29.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCScoreView.h"

@interface ZCScoreView ()
@property (nonatomic, strong) UILabel *homeTeamLabel;
@property (nonatomic, strong) UILabel *homeTeamScoreLabel;
@property (nonatomic, strong) UILabel *visitingTeamLabel;
@property (nonatomic, strong) UILabel *visitingScoreTeamLabel;
@end

@implementation ZCScoreView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self loadSubView];
    }
    return self;
}

- (void)loadSubView {
    UIView *scoreView = [UIView new];
    scoreView.backgroundColor = UIColorHex(#48d2a0);
    scoreView.layer.cornerRadius = 2;
    scoreView.layer.masksToBounds = YES;
    [self addSubview:scoreView];
    
    [scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.equalTo(CGSizeMake(67, 25));
    }];
    
    UILabel *placeLabel = [UILabel new];
    placeLabel.text = @":";
    placeLabel.textColor = UIColorHex(#ffffff);
    placeLabel.font = [UIFont fontWithName:kFNMuliRegular size:13];
    [placeLabel sizeToFit];
    [scoreView addSubview:placeLabel];
    
    [placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(scoreView);
    }];
    
    self.homeTeamScoreLabel = [UILabel new];
    self.homeTeamScoreLabel.text = @"1";
    self.homeTeamScoreLabel.textAlignment = NSTextAlignmentCenter;
    self.homeTeamScoreLabel.textColor = UIColorHex(#ffffff);
    self.homeTeamScoreLabel.font = [UIFont fontWithName:kFNMuliRegular size:13];
    
    [scoreView addSubview:self.homeTeamScoreLabel];
    
    [self.homeTeamScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(placeLabel.mas_left);
        make.left.and.height.and.top.equalTo(scoreView);
    }];
    
    self.visitingScoreTeamLabel = [UILabel new];
    self.visitingScoreTeamLabel.text = @"0";
    self.visitingScoreTeamLabel.textAlignment = NSTextAlignmentCenter;
    self.visitingScoreTeamLabel.textColor = UIColorHex(#ffffff);
    self.visitingScoreTeamLabel.font = [UIFont fontWithName:kFNMuliRegular size:13];
    
    [scoreView addSubview:self.visitingScoreTeamLabel];
    
    [self.visitingScoreTeamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(placeLabel.mas_right);
        make.right.and.height.and.top.equalTo(scoreView);
    }];
    
    self.homeTeamLabel = [UILabel new];
    self.homeTeamLabel.textColor = UIColorHex(#3f4a56);
    self.homeTeamLabel.font = [UIFont fontWithName:kFNMuliSemiBold size:13];
    self.homeTeamLabel.textAlignment = NSTextAlignmentCenter;
    self.homeTeamLabel.text = @"Joseph Simmons";
    [self addSubview:self.homeTeamLabel];
    
    [self.homeTeamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-10);
        make.right.equalTo(scoreView.mas_left).offset(-10);
    }];
    
    self.visitingTeamLabel = [UILabel new];
    self.visitingTeamLabel.textColor = UIColorHex(#3f4a56);
    self.visitingTeamLabel.font = [UIFont fontWithName:kFNMuliSemiBold size:13];
    self.visitingTeamLabel.textAlignment = NSTextAlignmentCenter;
    self.visitingTeamLabel.text = @"Joseph Simmons";
    [self addSubview:self.visitingTeamLabel];
    
    [self.visitingTeamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.bottom.and.right.equalTo(self).offset(-10);
        make.left.equalTo(scoreView.mas_right).offset(10);
    }];
}


@end

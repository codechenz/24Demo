//
//  ZCPerVoteTableViewCell.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/12/2.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCPerVoteTableViewCell.h"
#import <YLProgressBar.h>

@interface ZCPerVoteTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) YLProgressBar *progressBar;
@property (nonatomic, strong) UILabel *percentageLabel;
@end

@implementation ZCPerVoteTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.bounds = [UIScreen mainScreen].bounds;
        
        [self loadSubView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (CGSize)sizeThatFits:(CGSize)size {
    [super sizeThatFits:size];
    CGFloat totalHeight = 0;
    totalHeight += [self.titleLabel sizeThatFits:size].height;
    totalHeight += [self.progressBar sizeThatFits:size].height;
    totalHeight += 20;
    return CGSizeMake(size.width, totalHeight);
}

- (void)loadSubView {
    self.titleLabel = [UILabel new];
    self.titleLabel.textColor = UIColorHex(#667587);
    self.titleLabel.font = [UIFont fontWithName:kFNMuliRegular size:13];
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.top.equalTo(self).offset(5);
        make.height.equalTo(16.5);
    }];
    
    self.progressBar = [[YLProgressBar alloc] init];
    self.progressBar.progressTintColor = UIColorHex(#48d2a0);
    self.progressBar.trackTintColor = UIColorHex(#e5e9f2);
    self.progressBar.hideStripes = YES;
    self.progressBar.hideGloss = YES;
    self.progressBar.uniformTintColor = YES;
    [self.contentView addSubview:self.progressBar];
    
    [self.progressBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.width.equalTo(self.mas_width).multipliedBy(0.9);
        make.height.equalTo(5);
        make.bottom.equalTo(self).offset(-5);
    }];
    
    self.percentageLabel = [UILabel new];
    self.percentageLabel.textColor = UIColorHex(#475669);
    self.percentageLabel.textAlignment = NSTextAlignmentRight;
    self.percentageLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.percentageLabel];
    
    [self.percentageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.progressBar);
        make.left.equalTo(self.progressBar.mas_right);
        make.right.equalTo(self);
        make.height.equalTo(14);
    }];
}

- (void)setTotalCount:(NSInteger)totalCount {
    _totalCount = totalCount;
}

- (void)setOptionModel:(ZCOptionModel *)optionModel {
    _optionModel = optionModel;
    self.titleLabel.text = optionModel.desc;
    float percent = 1 * 100 / 3;
    self.percentageLabel.text = [NSString stringWithFormat:@"%i%%", (int)percent];
    self.progressBar.progress = percent / 100;
}

@end

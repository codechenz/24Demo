//
//  ZCNewsAudioTableViewCell.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/29.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCNewsAudioTableViewCell.h"
#import "UIImage+ZCCate.h"
#import "UIView+ZCCate.h"

@interface ZCNewsAudioTableViewCell ()
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)UILabel *author;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UIImageView *artboardImageView;
@property (nonatomic, strong)UIImageView *authorImage;
@property (nonatomic, strong)UILabel *clapCountLabel;
@property (nonatomic, strong)UIImageView *clapImageView;
@end
@implementation ZCNewsAudioTableViewCell

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

    // Configure the view for the selected state
}

- (CGSize)sizeThatFits:(CGSize)size {
    [super sizeThatFits:size];
    CGFloat totalHeight = 0;
    totalHeight += [self.contentLabel sizeThatFits:size].height;
    totalHeight += [self.author sizeThatFits:size].height;
    totalHeight += [self.authorImage sizeThatFits:size].height;
    totalHeight += 50; //40;
    return CGSizeMake(size.width, totalHeight);
}

- (void)loadSubView {
    self.author = [[UILabel alloc] init];
    self.author.font = [UIFont fontWithName:kFNMuliSemiBold size:13];
    self.author.textColor = UIColorHex(#3f4a56);
    
    [self.author sizeToFit];
    [self.contentView addSubview:self.author];
    [self.author mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(self).offset(10);
        make.height.equalTo(16.5);
    }];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont fontWithName:kFNMuliRegular size:12];
    self.timeLabel.textColor = UIColorHex(#667587);
    
    [self.timeLabel sizeToFit];
    [self.contentView addSubview:self.timeLabel];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.author.mas_right).offset(10);
        make.bottom.equalTo(self.author);
    }];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.font = [UIFont fontWithName:kFNMuliRegular size:13];
    self.contentLabel.textColor = UIColorHex(#667587);
    self.contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    
    [self.contentView addSubview:self.contentLabel];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self.author.mas_bottom).offset(10);
    }];
    
    self.artboardImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithIcon:kIFIArtboard size:15 color:UIColorHex(#667587)]];
    [self.contentView addSubview:self.artboardImageView];
    [self.artboardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self.author);
        make.size.equalTo(CGSizeMake(15, 15));
    }];
    
    self.authorImage = [[UIImageView alloc] initWithImage:[UIImage imageWithIcon:kIFIUser size:14 color:UIColorHex(#667587)]];
    
    [self.contentView addSubview:self.authorImage];
    [self.authorImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self).offset(-10);
        make.size.equalTo(CGSizeMake(15, 15));
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont fontWithName:kFNMuliRegular size:12];
    self.nameLabel.textColor = UIColorHex(#667587);
    
    [self.nameLabel sizeToFit];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.authorImage);
        make.left.equalTo(self.authorImage.mas_right).offset(10);
        make.width.equalTo(self).multipliedBy(0.2);
    }];
    
    self.clapImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithIcon:kIFIClap size:14 color:UIColorHex(#667587)]];
    
    [self.contentView addSubview:self.clapImageView];
    [self.clapImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(10);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self).offset(-10);
        make.size.equalTo(CGSizeMake(15, 15));
    }];
    
    self.clapCountLabel = [[UILabel alloc] init];
    self.clapCountLabel.font = [UIFont fontWithName:kFNMuliRegular size:12];
    self.clapCountLabel.textColor = UIColorHex(#667587);
    
    [self.clapCountLabel sizeToFit];
    [self.contentView addSubview:self.clapCountLabel];
    [self.clapCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.clapImageView);
        make.left.equalTo(self.clapImageView.mas_right).offset(10);
    }];
}

- (void)setModel:(ZCModel *)model {
    _model = model;
    self.author.text = model.title;
    self.timeLabel.text = model.time;
    self.nameLabel.text = @"Name";
    self.clapCountLabel.text = @"32";
}

@end

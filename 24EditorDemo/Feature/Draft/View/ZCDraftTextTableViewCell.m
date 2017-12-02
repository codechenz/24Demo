//
//  ZCDraftTextTableViewCell.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/27.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCDraftTextTableViewCell.h"
#import "UIImage+ZCCate.h"
#import "UIView+ZCCate.h"
#import "NSAttributedString+Ashton.h"
#import <YYText.h>
#import <DateTools.h>

@interface ZCDraftTextTableViewCell ()
@property (nonatomic, strong)YYLabel *contentLabel;
@property (nonatomic, strong)UILabel *author;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UIButton *artboardButton;
@property (nonatomic, strong)UIImageView *authorImage;
@property (nonatomic, strong)UIButton *clapButton;
@end

@implementation ZCDraftTextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.bounds = [UIScreen mainScreen].bounds;
        
        [self loadSubView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
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
    totalHeight += PixelOne; //分割线;
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
    
    self.artboardButton = [UIButton new];
    [self.artboardButton setImage:[UIImage imageWithIcon:kIFIArtboard size:15 color:UIColorHex(#667587)] forState:UIControlStateNormal];
    [self.artboardButton addTarget:self action:@selector(handleArtboardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.artboardButton];
    [self.artboardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self.author);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    self.artboardButton.backgroundColor = [UIColor whiteColor];
    self.artboardButton.imageView.backgroundColor = [UIColor whiteColor];
    [self.artboardButton setImageEdgeInsets:UIEdgeInsetsMake(0, self.artboardButton.width - self.artboardButton.imageView.width, 0, 0)];

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
    
    self.clapButton = [UIButton new];
    [self.clapButton setImage:[UIImage imageWithIcon:kIFIClap size:14 color:UIColorHex(#667587)] forState:UIControlStateNormal];
    self.clapButton.titleLabel.font = [UIFont fontWithName:kFNMuliRegular size:12];
    
    [self.clapButton setTitleColor:UIColorHex(#667587) forState:UIControlStateNormal];
    
    [self.clapButton setImage:[UIImage imageWithIcon:kIFIClap size:14 color:UIColorHex(#0088cc)] forState:UIControlStateSelected];
    [self.clapButton setTitleColor:UIColorHex(#667587) forState:UIControlStateSelected];
    self.clapButton.backgroundColor = [UIColor whiteColor];
    [self.clapButton setTitle:@"0" forState:UIControlStateNormal];
    
    [self.clapButton addTarget:self action:@selector(handleClapButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.clapButton];
    
    [self.clapButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(10);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self).offset(-10);
        make.size.equalTo(CGSizeMake(80, 15));
    }];
    self.clapButton.imageView.backgroundColor = [UIColor whiteColor];
    self.clapButton.titleLabel.backgroundColor = [UIColor whiteColor];
    
    [self.clapButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, self.clapButton.width - self.clapButton.imageView.width)];
    [self.clapButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, self.clapButton.width - self.clapButton.imageView.width - self.clapButton.titleLabel.width - 10)];
    
    UIView *separaView = [UIView new];
    separaView.backgroundColor = UIColorHex(#dfe6ee);
    [self.contentView addSubview:separaView];
    [separaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.and.width.equalTo(self);
        make.height.equalTo(PixelOne);
    }];
}

- (void)setNewsModel:(ZCNewsModel *)newsModel {
    _newsModel = newsModel;
    self.author.text = [newsModel.title isEqualToString:@""] ? @"Untitled" : newsModel.title;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:newsModel.date];
    self.timeLabel.text = [NSString stringWithFormat:@"· %@", date.timeAgoSinceNow];
    NSAttributedString *content = [[NSAttributedString alloc] mn_initWithHTMLString:newsModel.contents];
    
    self.contentLabel.attributedText = content;
    self.nameLabel.text = newsModel.username;
    self.clapButton.selected = newsModel.alert;
    
    
}

- (void)updateLikesWithAnimation {
    self.clapButton.selected = self.newsModel.alert;
    [self.clapButton setTitle:[NSString stringWithFormat:@"%d", self.newsModel.likes] forState:UIControlStateSelected];
}

#pragma mark - Event Handle

- (void)handleClapButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(draftTextHandleClapButtonClick:)]) {
        [self.delegate draftTextHandleClapButtonClick:self];
    }
}

- (void)handleArtboardButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(draftTextCell:handleArtboardButtonClick:)]) {
        [self.delegate draftTextCell:self handleArtboardButtonClick:sender];
    }
}


@end

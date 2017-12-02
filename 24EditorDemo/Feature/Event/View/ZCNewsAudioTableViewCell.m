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
#import <DateTools.h>


@interface ZCNewsAudioTableViewCell ()
@property (nonatomic, strong)UILabel *author;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UIButton *artboardButton;
@property (nonatomic, strong)UIImageView *authorImage;
@property (nonatomic, strong)UIView *shadowView;
@property (nonatomic, strong)UIButton *clapButton;
@property (nonatomic, strong)UIButton *audioButton;

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
    totalHeight += [self.shadowView sizeThatFits:size].height;
    totalHeight += [self.author sizeThatFits:size].height;
    totalHeight += [self.authorImage sizeThatFits:size].height;
    totalHeight += 40; //40;
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
    
    [self audioView];
    
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
        make.top.equalTo(self.shadowView.mas_bottom).offset(10);
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
        make.top.equalTo(self.shadowView.mas_bottom).offset(10);
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

- (void)audioView {
    
#warning 阴影
    self.shadowView = [UIView new];
    self.shadowView.backgroundColor = [UIColor clearColor];
    self.shadowView.layer.shadowColor = UIColorHex(#0000001a).CGColor;
    self.shadowView.layer.shadowOffset = CGSizeMake(10, 10);
    self.shadowView.layer.shadowRadius = 10;
    self.shadowView.layer.shadowOpacity = 1;
    [self.contentView addSubview:self.shadowView];
    
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.equalTo(self).offset(10);
        make.top.equalTo(self.author.mas_bottom).offset(10);
        make.size.equalTo(CGSizeMake(kScreenWidth - 20, 46));
    }];
#warning 手动高度
    self.shadowView.height = 46;
    
    UIView *audio = [UIView new];
    audio.layer.borderColor = UIColorHex(#dfe6ee).CGColor;
    audio.layer.borderWidth = PixelOne;
    audio.layer.cornerRadius = 10;
    audio.layer.masksToBounds = YES;
    
    [self.shadowView addSubview:audio];
    [audio mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.shadowView);
    }];
    
    self.audioButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.audioButton setImage:[UIImage imageWithIcon:kIFIPlayVoice size:26 color:UIColorHex(#0088cc)] forState:UIControlStateNormal];
    
    [self.audioButton addTarget:self action:@selector(handleAudioButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [audio addSubview:self.audioButton];
    [self.audioButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(audio);
        make.left.equalTo(audio).offset(15);
        make.size.equalTo(CGSizeMake(26, 26));
    }];
    
    self.audioIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.audioIndicator.layer.cornerRadius = 22 / 2;
    self.audioIndicator.layer.masksToBounds = YES;
    self.audioIndicator.backgroundColor = [UIColor whiteColor];
    [self.audioButton addSubview:self.audioIndicator];
    
    [self.audioIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.audioButton).offset(UIEdgeInsetsMake(2, 2, 2, 2));
    }];
    
    self.audioTime = [UILabel new];
    self.audioTime.text = @"--:--";
    self.audioTime.textAlignment = NSTextAlignmentCenter;
    self.audioTime.font = [UIFont fontWithName:kFNMuliRegular size:13];
    self.audioTime.textColor = UIColorHex(#667587);
    [self.audioTime sizeToFit];
    [audio addSubview:self.audioTime];
    
    [self.audioTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.audioButton.mas_right).offset(10);
        make.centerY.equalTo(audio);
        make.width.equalTo(35);
    }];
    
    self.audioYLProgressBar = [[YLProgressBar alloc] init];
    [audio addSubview:self.audioYLProgressBar];
    [self.audioYLProgressBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.audioTime.mas_right).offset(10);
        make.right.equalTo(audio).offset(-15);
        make.centerY.equalTo(audio);
        make.height.equalTo(6);
    }];
    
    self.audioYLProgressBar.trackTintColor = UIColorHex(#e8f1f9);
    self.audioYLProgressBar.progressTintColor = UIColorHex(#0088cc);
    self.audioYLProgressBar.hideStripes = YES;
    self.audioYLProgressBar.hideGloss = YES;
    self.audioYLProgressBar.progress = 0;
    self.audioYLProgressBar.uniformTintColor = YES;
    
    
    //创建滑动条对象
    UISlider *slider = [[UISlider alloc]init];
    slider.maximumValue = 100;
    slider.minimumValue = 0;
    slider.value=0;
    slider.minimumTrackTintColor = [UIColor clearColor];
    slider.maximumTrackTintColor = [UIColor clearColor];
    slider.thumbTintColor = [UIColor clearColor];
    [slider addTarget:self action:@selector(handleSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.audioYLProgressBar addSubview:slider];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.audioYLProgressBar);
    }];
}

- (void)setAudioModel:(ZCAudioModel *)audioModel {
    _audioModel = audioModel;
    self.author.text = [audioModel.title isEqualToString:@""] ? @"Untitled" : audioModel.title;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:audioModel.date];
    self.timeLabel.text = [NSString stringWithFormat:@"· %@", date.timeAgoSinceNow];
    self.nameLabel.text = audioModel.username;
    self.clapButton.selected = audioModel.alert;
    [self updateAudioButtonStatus];
}

- (void)updateLikesWithAnimation {
    self.clapButton.selected = self.audioModel.alert;
    [self.clapButton setTitle:[NSString stringWithFormat:@"%d", self.audioModel.likes] forState:UIControlStateSelected];
}

- (void)updateAudioButtonStatus {
    switch (self.audioModel.audioStreamerStatus) {
        case DOUAudioStreamerPlaying:
            [self.audioButton setImage:[UIImage imageWithIcon:kIFIPauseVoice size:26 color:UIColorHex(#0088cc)] forState:UIControlStateNormal];
            [self.audioIndicator stopAnimating];
            break;
            
        case DOUAudioStreamerPaused:
            [self.audioButton setImage:[UIImage imageWithIcon:kIFIPlayVoice size:26 color:UIColorHex(#0088cc)] forState:UIControlStateNormal];
            [self.audioIndicator stopAnimating];
            break;
            
        case DOUAudioStreamerIdle:
            [self.audioButton setImage:[UIImage imageWithIcon:kIFIPlayVoice size:26 color:UIColorHex(#0088cc)] forState:UIControlStateNormal];
            [self.audioIndicator stopAnimating];
            break;
            
        case DOUAudioStreamerFinished:
            [self.audioButton setImage:[UIImage imageWithIcon:kIFIPlayVoice size:26 color:UIColorHex(#0088cc)] forState:UIControlStateNormal];
            [self.audioIndicator stopAnimating];
            break;
            
        case DOUAudioStreamerBuffering:
            [self.audioButton setImage:[UIImage imageWithIcon:kIFIPauseVoice size:26 color:UIColorHex(#0088cc)] forState:UIControlStateNormal];
            [self.audioIndicator startAnimating];
            break;
            
        case DOUAudioStreamerError:
            [self.audioButton setImage:[UIImage imageWithIcon:kIFIPlayVoice size:26 color:UIColorHex(#0088cc)] forState:UIControlStateNormal];
            [self.audioIndicator stopAnimating];
            break;
    }
}

#pragma mark - Event Handle
- (void)handleAudioButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(handleAudioPlayButtonClick:cell:withAudioURL:)]) {
        [self.delegate handleAudioPlayButtonClick:sender cell:self withAudioURL:[NSURL URLWithString:self.audioModel.contents]];
    }
}

- (void)handleSliderValueChanged:(UISlider *)sender {
    float progress = (sender.value-sender.minimumValue) / (sender.maximumValue - sender.minimumValue);
    [self.audioYLProgressBar setProgress:progress animated:NO];
    
}

- (void)handleClapButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(handleClapButtonClick:)]) {
        [self.delegate handleClapButtonClick:self];
    }
}

- (void)handleArtboardButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(audioCell:handleArtBoardButtonClick:)]) {
        [self.delegate audioCell:self handleArtBoardButtonClick:sender];
    }
}


@end

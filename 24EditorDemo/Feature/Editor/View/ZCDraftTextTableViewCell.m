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

@implementation ZCDraftTextTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *author = [[UILabel alloc] init];
        author.font = [UIFont fontWithName:kFNMuliSemiBold size:13];
        author.textColor = UIColorHex(#3f4a56);
        author.text = @"Joseph Simmons";
        [author sizeToFit];
        [self addSubview:author];
        self.author = author;
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = [UIFont fontWithName:kFNMuliRegular size:12];
        timeLabel.textColor = UIColorHex(#667587);
        timeLabel.text = @"· 3 hours ago";
        [timeLabel sizeToFit];
        [self addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.font = [UIFont fontWithName:kFNMuliRegular size:13];
        self.contentLabel.textColor = UIColorHex(#667587);
        self.contentLabel.text = @"Etiam blandit nisi feugiat eros mollis, sed vehicula massatempus. Donec suscipit a lectus et egestas. ";
        [self addSubview:self.contentLabel];
        
        UIImageView *artboardImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithIcon:kIFIArtboard size:15 color:UIColorHex(#667587)]];
        [self addSubview:artboardImageView];
        self.artboardImageView = artboardImageView;
        
        UIImageView *authorImage = [[UIImageView alloc] initWithImage:[UIImage imageWithIcon:kIFIUser size:14 color:UIColorHex(#667587)]];
        
        [self addSubview:authorImage];
        self.authorImage = authorImage;
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont fontWithName:kFNMuliRegular size:12];
        nameLabel.textColor = UIColorHex(#667587);
        nameLabel.text = @"Name";
        [nameLabel sizeToFit];
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        self.author.left = self.left + 10;
        self.author.top = self.top + 10;
        
        self.timeLabel.left = self.author.right + 10;
        self.timeLabel.bottom = self.author.bottom;
        
        self.contentLabel.size = CGSizeMake(kScreenWidth - 20, 33);
        self.contentLabel.left = self.left + 10;
        self.contentLabel.top = self.author.bottom + 10;
        
        self.artboardImageView.size = CGSizeMake(15, 15);
        self.artboardImageView.centerY = self.author.centerY;
        self.artboardImageView.right = self.right - 10;
        
        self.authorImage.size = CGSizeMake(15, 15);
        self.authorImage.left = self.left + 10;
        self.authorImage.bottom = self.bottom - 10;
        
        self.nameLabel.left = self.authorImage.right + 10;
        self.nameLabel.bottom = self.bottom - 10;
        
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

@end

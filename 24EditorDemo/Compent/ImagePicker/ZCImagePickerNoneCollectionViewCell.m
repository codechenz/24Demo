//
//  ZCImagePickerNoneCollectionViewCell.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/25.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCImagePickerNoneCollectionViewCell.h"
#import "UIImage+ZCCate.h"
#import "UIView+ZCCate.h"

@implementation ZCImagePickerNoneCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *photoImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithIcon:kIFIImage size:30 color:UIColorHex(#667587)]];
        [self addSubview:photoImageView];
        
        [photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(20);
            make.size.equalTo(CGSizeMake(30, 30));
        }];
        
        UILabel *label = [[UILabel alloc] init];
        
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:kFNRalewayMedium size:12];
        label.textColor = UIColorHex(#667587);
        label.text = @"Photo";
        [self addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(photoImageView.mas_bottom).offset(10);
            make.left.and.width.equalTo(self);
            make.height.equalTo(20);
        }];
    }
    return self;
}

@end

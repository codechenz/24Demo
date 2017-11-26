//
//  ZCImagePickerNoneCollectionViewCell.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/25.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCImagePickerNoneCollectionViewCell.h"
#import "UIImage+ZCCate.h"

@implementation ZCImagePickerNoneCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *photoImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithIcon:kIFIImage size:30 color:UIColorHex(#667587)]];
        photoImageView.centerX = self.centerX;
        photoImageView.top = 20;
        photoImageView.size = CGSizeMake(30, 30);
        [self addSubview:photoImageView];
        
        UILabel *label = [[UILabel alloc] init];
        label.top = photoImageView.bottom + 10;
        label.left = self.left;
        label.size = CGSizeMake(self.width, 20);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:kFNRalewayMedium size:12];
        label.textColor = UIColorHex(#667587);
        label.text = @"Photo";
        [self addSubview:label];
    }
    return self;
}

@end

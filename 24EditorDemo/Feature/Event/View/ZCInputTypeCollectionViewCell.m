//
//  ZCInputTypeCollectionViewCell.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/12/2.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCInputTypeCollectionViewCell.h"
#import "UIImage+ZCCate.h"

@interface ZCInputTypeCollectionViewCell ()
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *typeLabel;

@end

@implementation ZCInputTypeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSubView];
    }
    return self;
}

- (void)loadSubView {
    
    UIView *imagebackView = [UIView new];
    imagebackView.backgroundColor = [UIColor whiteColor];
    imagebackView.layer.cornerRadius = 9;
    imagebackView.layer.masksToBounds = YES;
    imagebackView.layer.borderColor = UIColorHex(#dfe6ee).CGColor;
    imagebackView.layer.borderWidth = PixelOne;
    [self.contentView addSubview:imagebackView];
    [imagebackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.centerX.equalTo(self);
        make.size.equalTo(CGSizeMake(54, 54));
    }];
    
    self.typeImageView = [[UIImageView alloc] init];
    [imagebackView addSubview:self.typeImageView];
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(imagebackView);
        make.size.equalTo(CGSizeMake(25, 25));
    }];
    self.typeLabel = [UILabel new];
    self.typeLabel.textColor = UIColorHex(#8091a5);
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    self.typeLabel.font = [UIFont fontWithName:kFNMuliRegular size:12];
    
    [self.contentView addSubview:self.typeLabel];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeImageView.mas_bottom).offset(5);
        make.left.and.width.equalTo(self);
        make.bottom.equalTo(self).offset(5);
    }];
}

- (void)setDataSource:(NSDictionary *)dataSource {
    _dataSource = dataSource;
    self.typeImageView.image = [UIImage imageWithIcon:dataSource[@"image"] size:25 color:UIColorHex(#8091a5)];
    self.typeLabel.text = dataSource[@"title"];
}



@end

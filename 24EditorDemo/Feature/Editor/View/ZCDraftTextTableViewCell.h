//
//  ZCDraftTextTableViewCell.h
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/27.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCDraftTextTableViewCell : UITableViewCell
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)UILabel *author;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UIImageView *artboardImageView;
@property (nonatomic, strong)UIImageView *authorImage;
@property (nonatomic, strong)UILabel *nameLabel;

@end

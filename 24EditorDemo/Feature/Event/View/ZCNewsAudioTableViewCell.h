//
//  ZCNewsAudioTableViewCell.h
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/29.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCModel.h"

@interface ZCNewsAudioTableViewCell : UITableViewCell

@property (nonatomic, strong) ZCModel *model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end

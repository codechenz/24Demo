//
//  ZCPerVoteTableViewCell.h
//  24EditorDemo
//
//  Created by zhuchen on 2017/12/2.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCOptionModel.h"

@interface ZCPerVoteTableViewCell : UITableViewCell
@property (nonatomic, strong) ZCOptionModel *optionModel;
@property (nonatomic, assign) NSInteger totalCount;
@end

//
//  ZCNewsVoteTableViewCell.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/12/2.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCNewsVoteTableViewCell.h"
#import "UIImage+ZCCate.h"
#import "ZCPerVoteTableViewCell.h"
#import <UITableView+FDTemplateLayoutCell.h>

@interface ZCNewsVoteTableViewCell () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ZCNewsVoteTableViewCell

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
    
}

- (CGSize)sizeThatFits:(CGSize)size {
    [super sizeThatFits:size];
    CGFloat totalHeight = 0;
    totalHeight += [self.titleLabel sizeThatFits:size].height;
    totalHeight += (41.5 * self.voteModel.options.count); //tableview 高度
    totalHeight += 30;
    return CGSizeMake(size.width, totalHeight);
}

- (void)loadSubView {
    UIImageView *voteImage = [[UIImageView alloc] initWithImage:[UIImage imageWithIcon:kIFIVote size:14.5 color:UIColorHex(#48d2a0)]];
    [self.contentView addSubview:voteImage];
    
    [voteImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(12.5);
        make.size.equalTo(CGSizeMake(15, 15));
    }];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.textColor = UIColorHex(#3f4a56);
    self.titleLabel.font = [UIFont fontWithName:kFNMuliRegular size:13];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(voteImage.mas_right).offset(10);
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(voteImage);
        make.height.equalTo(16.5);
    }];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    [self.tableView registerClass:[ZCPerVoteTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ZCPerVoteTableViewCell class])];
    
    [self.contentView addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(voteImage.mas_bottom).offset(10);
        make.bottom.equalTo(self).offset(-10);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-15);
    }];
    
    UIView *separaView = [UIView new];
    separaView.backgroundColor = UIColorHex(#dfe6ee);
    [self.contentView addSubview:separaView];
    [separaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.and.width.equalTo(self);
        make.height.equalTo(PixelOne);
    }];
}

- (void)setVoteModel:(ZCVoteModel *)voteModel {
    _voteModel = voteModel;
    self.titleLabel.text = voteModel.subject;
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.voteModel.options.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  [tableView fd_heightForCellWithIdentifier:NSStringFromClass([ZCPerVoteTableViewCell class]) cacheByIndexPath:indexPath configuration:^(id cell) {
        [self configureTextCell:cell atIndexPath:indexPath];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCPerVoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZCPerVoteTableViewCell class]) forIndexPath:indexPath];
    if (!cell) {
        cell = [[ZCPerVoteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ZCPerVoteTableViewCell class])];
        
    }
    [self configureTextCell:cell atIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)configureTextCell:(ZCPerVoteTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.totalCount = self.voteModel.totalCount;
    cell.optionModel = self.voteModel.options[indexPath.row];
}

@end

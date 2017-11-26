//
//  ZCAlbumView.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/26.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCAlbumView.h"
#import "UIView+ZCCate.h"


// 相册预览图的大小默认值
const CGFloat ZCAlbumViewDefaultAlbumTableViewCellHeight = 57;
// 相册名称的 insets 默认值
const UIEdgeInsets ZCAlbumViewTableViewCellDefaultAlbumNameInsets = {0, 8, 0, 4};


#pragma mark - ZCAlbumViewTableViewCell

@implementation ZCAlbumViewTableViewCell {
    CALayer *_bottomLineLayer;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.albumNameInsets = ZCAlbumViewTableViewCellDefaultAlbumNameInsets;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        self.textLabel.textColor = UIColorHex(#667587);
        self.textLabel.font = [UIFont fontWithName:kFNRalewayRegular size:15];
        
        _bottomLineLayer = [[CALayer alloc] init];
        _bottomLineLayer.backgroundColor =  UIColorHex(#dfe6ee).CGColor;
        // 让分隔线垫在背后
        [self.layer insertSublayer:_bottomLineLayer atIndex:0];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 避免iOS7下seletedBackgroundView会往上下露出1px（以盖住系统分隔线，但我们的分隔线是自定义的）
    self.selectedBackgroundView.frame = self.bounds;
    
    CGFloat contentViewPaddingRight = 10;
    self.imageView.frame = CGRectMake(0, 0, CGRectGetHeight(self.contentView.bounds), CGRectGetHeight(self.contentView.bounds));
    self.textLabel.frame = CGRectSetXY(self.textLabel.frame, CGRectGetMaxX(self.imageView.frame) + self.albumNameInsets.left, flat([self.textLabel zc_topWhenCenterInSuperview]));
    CGFloat textLabelMaxWidth = CGRectGetWidth(self.contentView.bounds) - contentViewPaddingRight - CGRectGetWidth(self.detailTextLabel.frame) - self.albumNameInsets.right - CGRectGetMinX(self.textLabel.frame);
    if (CGRectGetWidth(self.textLabel.frame) > textLabelMaxWidth) {
        self.textLabel.frame = CGRectSetWidth(self.textLabel.frame, textLabelMaxWidth);
    }
    
    self.detailTextLabel.frame = CGRectSetXY(self.detailTextLabel.frame, CGRectGetMaxX(self.textLabel.frame) + self.albumNameInsets.right, flat([self.detailTextLabel zc_topWhenCenterInSuperview]));
    _bottomLineLayer.frame = CGRectMake(0, CGRectGetHeight(self.contentView.bounds) - PixelOne, CGRectGetWidth(self.bounds), PixelOne);
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    _bottomLineLayer.hidden = highlighted;
}

@end


@implementation ZCAlbumView {
    BOOL _usePhotoKit;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _usePhotoKit = YES;
        _shouldShowDefaultLoadingView = YES;
        _albumTableViewCellHeight = ZCAlbumViewDefaultAlbumTableViewCellHeight;
        self.backgroundColor = UIColorMakeWithRGBA(0, 0, 0, 0.4);
        [self initTableView];
    }
    return self;
}

- (void)initTableView {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleViewTap)];
    tap.delegate = self;
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[ZCAlbumViewTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ZCAlbumViewTableViewCell class])];
    self.tableView.backgroundColor = UIColorMakeWithRGBA(0, 0, 0, 0.4);
    [self addSubview:self.tableView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)handleViewTap {
    if ([self.albumViewDelegate respondsToSelector:@selector(cancelChooseAlbum)]) {
        [self.albumViewDelegate cancelChooseAlbum];
    }
}

#pragma mark - <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_albumsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.albumTableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCAlbumViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([ZCAlbumViewTableViewCell class])];
    
    ZCAssetsGroup *assetsGroup = [_albumsArray objectAtIndex:indexPath.row];
    // 显示相册缩略图
    cell.imageView.image = [assetsGroup posterImageWithSize:CGSizeMake(self.albumTableViewCellHeight, self.albumTableViewCellHeight)];
    // 显示相册名称
    cell.textLabel.text = [NSString stringWithFormat:@"%@   (%@)",[assetsGroup name], @(assetsGroup.numberOfAssets)];
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.albumViewDelegate respondsToSelector:@selector(albumDidChange:)]) {
        [self.albumViewDelegate albumDidChange:self.albumsArray[indexPath.row]];
    }
}

@end

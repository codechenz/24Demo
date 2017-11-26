//
//  ZCAlbumViewController.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/24.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCAlbumViewController.h"
#import "UIView+ZCCate.h"
#import "ZCAssetsManager.h"
#import "ZCImagePickerViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PHPhotoLibrary.h>
#import <Photos/PHAsset.h>
#import <Photos/PHFetchOptions.h>
#import <Photos/PHCollection.h>
#import <Photos/PHFetchResult.h>

// 相册预览图的大小默认值
const CGFloat ZCAlbumViewControllerDefaultAlbumTableViewCellHeight = 57;
// 相册名称的字号默认值
const CGFloat ZCAlbumTableViewCellDefaultAlbumNameFontSize = 16;
// 相册资源数量的字号默认值
const CGFloat ZCAlbumTableViewCellDefaultAlbumAssetsNumberFontSize = 16;
// 相册名称的 insets 默认值
const UIEdgeInsets ZCAlbumTableViewCellDefaultAlbumNameInsets = {0, 8, 0, 4};


#pragma mark - ZCAlbumTableViewCell

@implementation ZCAlbumTableViewCell {
    CALayer *_bottomLineLayer;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.albumNameFontSize = ZCAlbumTableViewCellDefaultAlbumNameFontSize;
        self.albumAssetsNumberFontSize = ZCAlbumTableViewCellDefaultAlbumAssetsNumberFontSize;
        self.albumNameInsets = ZCAlbumTableViewCellDefaultAlbumNameInsets;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        self.detailTextLabel.textColor = [UIColor darkGrayColor];
        
        _bottomLineLayer = [[CALayer alloc] init];
        _bottomLineLayer.backgroundColor = [UIColor grayColor].CGColor;
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

#pragma mark - ZCAlbumViewController

@implementation ZCAlbumViewController {
    ZCImagePickerViewController *_imagePickerViewController;
    
    BOOL _usePhotoKit;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    _usePhotoKit = YES;
    _shouldShowDefaultLoadingView = YES;
    _albumTableViewCellHeight = ZCAlbumViewControllerDefaultAlbumTableViewCellHeight;
    
    self.title = @"照片";
    [self initTableView];
    
}

- (void)initTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    NSLog(@"%d", self.navigationController.navigationBar.isHidden);
//    if (self.tableView.top == 0) {
//        self.tableView.top = 64;
//    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[ZCAlbumTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ZCAlbumTableViewCell class])];
    [self.view addSubview:self.tableView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_albumsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.albumTableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZCAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([ZCAlbumTableViewCell class])];
    if (!cell) {
        //        cell = [ZCAlbumTableViewCell alloc]
        //        cell = [[ZCAlbumTableViewCell alloc] initForTableView:self.tableView withStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifer];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    ZCAssetsGroup *assetsGroup = [_albumsArray objectAtIndex:indexPath.row];
    // 显示相册缩略图
    cell.imageView.image = [assetsGroup posterImageWithSize:CGSizeMake(self.albumTableViewCellHeight, self.albumTableViewCellHeight)];
    // 显示相册名称
    cell.textLabel.text = [assetsGroup name];
    // 显示相册中所包含的资源数量
    cell.detailTextLabel.text = [NSString stringWithFormat:@"(%@)", @(assetsGroup.numberOfAssets)];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (!_imagePickerViewController) {
//        _imagePickerViewController = [self.albumViewControllerDelegate imagePickerViewControllerForAlbumViewController:self];
//    }
    //    NSAssert(_imagePickerViewController, @"self.%@ 必须实现 %@ 并返回一个 %@ 对象", NSStringFromSelector(@selector(albumViewControllerDelegate)), NSStringFromSelector(@selector(imagePickerViewControllerForAlbumViewController:)), NSStringFromClass([ZCImagePickerViewController class]));
    [_albumViewControllerDelegate albumViewControllerDidChangeAlbum:[_albumsArray objectAtIndex:indexPath.row]];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleCancelSelectAlbum:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^(void) {
        if (self.albumViewControllerDelegate && [self.albumViewControllerDelegate respondsToSelector:@selector(albumViewControllerDidCancel:)]) {
            [self.albumViewControllerDelegate albumViewControllerDidCancel:self];
        }
    }];
}

@end

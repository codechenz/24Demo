//
//  ZCImagePickerViewController.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/23.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCImagePickerViewController.h"
#import "ZCImagePickerCollectionViewCell.h"
#import "UIView+YYAdd.h"
#import "ZCAssetsManager.h"

// CollectionView
#define CollectionViewInsetHorizontal PreferredVarForDevices((PixelOne * 2), 1, 2, 2)
#define CollectionViewInset UIEdgeInsetsMake(CollectionViewInsetHorizontal, CollectionViewInsetHorizontal, CollectionViewInsetHorizontal, CollectionViewInsetHorizontal)
#define CollectionViewCellMargin CollectionViewInsetHorizontal

@interface ZCImagePickerViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, strong) UICollectionViewFlowLayout *collectionViewLayout;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UIView *operationToolBarView;

@property(nonatomic, strong, readwrite) NSMutableArray<ZCAsset *> *imagesAssetArray;
@end

@implementation ZCImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initSubViews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initSubViews {
    self.collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionViewLayout.minimumLineSpacing = 1;
    self.collectionViewLayout.minimumInteritemSpacing = 1;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_collectionViewLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.delaysContentTouches = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alwaysBounceHorizontal = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[ZCImagePickerCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([ZCImagePickerCollectionViewCell class])];
    
    [self.view addSubview:self.collectionView];
}

- (CGSize)referenceImageSize {
    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.bounds);
    CGFloat collectionViewContentSpacing = collectionViewWidth - (self.collectionView.contentInset.left + self.collectionView.contentInset.right);
    NSInteger columnCount = floor(collectionViewContentSpacing / self.minimumImageWidth);
    CGFloat referenceImageWidth = self.minimumImageWidth;
    BOOL isSpacingEnoughWhenDisplayInMinImageSize = UIEdgeInsetsGetHorizontalValue(self.collectionViewLayout.sectionInset) + (self.minimumImageWidth + self.collectionViewLayout.minimumInteritemSpacing) * columnCount - self.collectionViewLayout.minimumInteritemSpacing <= collectionViewContentSpacing;
    if (!isSpacingEnoughWhenDisplayInMinImageSize) {
        // 算上图片之间的间隙后发现其实还是放不下啦，所以得把列数减少，然后放大图片以撑满剩余空间
        columnCount -= 1;
    }
    referenceImageWidth = (collectionViewContentSpacing - UIEdgeInsetsGetHorizontalValue(self.collectionViewLayout.sectionInset) - self.collectionViewLayout.minimumInteritemSpacing * (columnCount - 1)) / columnCount;
    return CGSizeMake(referenceImageWidth, referenceImageWidth);
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.imagesAssetArray count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self referenceImageSize];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = kImageOrUnknownCellIdentifier;
    // 获取需要显示的资源
    QMUIAsset *imageAsset = [self.imagesAssetArray objectAtIndex:indexPath.item];
    if (imageAsset.assetType == QMUIAssetTypeVideo) {
        identifier = kVideoCellIdentifier;
    }
    QMUIImagePickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    // 异步请求资源对应的缩略图（因系统接口限制，iOS 8.0 以下为实际上同步请求）
    [imageAsset requestThumbnailImageWithSize:[self referenceImageSize] completion:^(UIImage *result, NSDictionary *info) {
        if (!info || [[info objectForKey:PHImageResultIsDegradedKey] boolValue]) {
            // 模糊，此时为同步调用
            cell.contentImageView.image = result;
        } else if ([collectionView qmui_itemVisibleAtIndexPath:indexPath]) {
            // 清晰，此时为异步调用
            QMUIImagePickerCollectionViewCell *anotherCell = (QMUIImagePickerCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            anotherCell.contentImageView.image = result;
        }
    }];
    
    if (imageAsset.assetType == QMUIAssetTypeVideo) {
        cell.videoDurationLabel.text = [NSString qmui_timeStringWithMinsAndSecsFromSecs:imageAsset.duration];
    }
    
    [cell.checkboxButton addTarget:self action:@selector(handleCheckBoxButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.progressView addTarget:self action:@selector(handleProgressViewClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.downloadRetryButton addTarget:self action:@selector(handleDownloadRetryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.editing = self.allowsMultipleSelection;
    if (cell.editing) {
        // 如果该图片的 QMUIAsset 被包含在已选择图片的数组中，则控制该图片被选中
        cell.checked = [QMUIImagePickerHelper imageAssetArray:_selectedImageAssetArray containsImageAsset:imageAsset];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    QMUIAsset *imageAsset = [self.imagesAssetArray objectAtIndex:indexPath.item];
    if (self.imagePickerViewControllerDelegate && [self.imagePickerViewControllerDelegate respondsToSelector:@selector(imagePickerViewController:didSelectImageWithImagesAsset:afterImagePickerPreviewViewControllerUpdate:)]) {
        [self.imagePickerViewControllerDelegate imagePickerViewController:self didSelectImageWithImagesAsset:imageAsset afterImagePickerPreviewViewControllerUpdate:self.imagePickerPreviewViewController];
    }
    
    if ([self.imagePickerViewControllerDelegate respondsToSelector:@selector(imagePickerPreviewViewControllerForImagePickerViewController:)]) {
        [self initPreviewViewControllerIfNeeded];
        if (!self.allowsMultipleSelection) {
            // 单选的情况下
            [self.imagePickerPreviewViewController updateImagePickerPreviewViewWithImagesAssetArray:@[imageAsset]
                                                                            selectedImageAssetArray:nil
                                                                                  currentImageIndex:0
                                                                                    singleCheckMode:YES];
        } else {
            // cell 处于编辑状态，即图片允许多选
            [self.imagePickerPreviewViewController updateImagePickerPreviewViewWithImagesAssetArray:self.imagesAssetArray
                                                                            selectedImageAssetArray:_selectedImageAssetArray
                                                                                  currentImageIndex:indexPath.item
                                                                                    singleCheckMode:NO];
        }
        [self.navigationController pushViewController:self.imagePickerPreviewViewController animated:YES];
    }
}

@end

//
//  ZCImagePickerViewController.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/23.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCImagePickerViewController.h"
#import "ZCImagePickerCollectionViewCell.h"
#import "ZCImagePickerNoneCollectionViewCell.h"
#import "UIView+YYAdd.h"
#import "UICollectionView+ZCCate.h"
#import "NSString+YYAdd.h"
#import "ZCAssetsManager.h"
#import "ZCImagePickerHelper.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PHAsset.h>
#import "UIImage+ZCCate.h"



#define OperationToolBarViewHeight 44
#define OperationToolBarViewPaddingHorizontal 12
#define ImageCountLabelSize CGSizeMake(18, 18)

#define CollectionViewInsetHorizontal PreferredVarForDevices((PixelOne * 2), 1, 2, 2)
#define CollectionViewInset UIEdgeInsetsMake(CollectionViewInsetHorizontal, CollectionViewInsetHorizontal, CollectionViewInsetHorizontal, CollectionViewInsetHorizontal)
#define CollectionViewCellMargin CollectionViewInsetHorizontal

static NSString * const kVideoCellIdentifier = @"video";
static NSString * const kImageOrUnknownCellIdentifier = @"imageorunknown";

@interface ZCImagePickerViewController ()

@property(nonatomic, strong, readwrite) UICollectionViewFlowLayout *collectionViewLayout;
@property(nonatomic, strong, readwrite) UICollectionView *collectionView;
@property(nonatomic, strong, readwrite) UIView *operationToolBarView;
@property(nonatomic, strong, readwrite) UIButton *previewButton;
@property(nonatomic, strong, readwrite) UIButton *sendButton;
@property(nonatomic, strong, readwrite) UILabel *imageCountLabel;

@property(nonatomic, strong, readwrite) NSMutableArray<ZCAsset *> *imagesAssetArray;
@property(nonatomic, strong, readwrite) ZCAssetsGroup *assetsGroup;

@property(nonatomic, strong) ZCImagePickerPreviewViewController *imagePickerPreviewViewController;
@property(nonatomic, assign) BOOL hasScrollToInitialPosition;
@property(nonatomic, assign) BOOL canScrollToInitialPosition;// 要等数据加载完才允许滚动
@property(nonatomic, strong) ZCAlbumView *albumView;
@end

@implementation ZCImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _allowsMultipleSelection = YES;
    _maximumSelectImageCount = INT_MAX;
    _minimumSelectImageCount = 0;
    _shouldShowDefaultLoadingView = YES;
    _minimumImageWidth = 75;
//    [self setNavigationBar];
    [self initSubViews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.collectionView.dataSource = nil;
    self.collectionView.delegate = nil;
}

//- (void)setNavigationBar {
//    
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    [btn setTitle:@"Cancel" forState:UIControlStateNormal];
//    btn.titleLabel.font = [UIFont fontWithName:kf size:<#(CGFloat)#>]
//    [btn addTarget:self action:@selector(handleBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
//}

//- (void)handleBackButtonClick:(UIBarButtonItem *)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)initSubViews {
    
    self.naviTitleButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.naviTitleButton setTitle:self.title forState:(UIControlStateNormal)];
    [self.naviTitleButton addTarget:self action:@selector(handleTitleButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.naviTitleButton sizeToFit];
    self.naviTitleButton.titleLabel.font = [UIFont fontWithName:@"Muli-SemiBold" size:16];
    [self.naviTitleButton setTitleColor:UIColorHex(#3F4A56) forState:UIControlStateNormal];
    [self.naviTitleButton setImage:[UIImage imageWithIcon:kIFIArrowDown size:12 color:UIColorHex(#3F4A56)] forState:UIControlStateNormal];
    [self.naviTitleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.naviTitleButton.imageView.image.size.width, 0, self.naviTitleButton.imageView.image.size.width)];
#warning button 中图片位置适配
    [self.naviTitleButton setImageEdgeInsets:UIEdgeInsetsMake(0, self.naviTitleButton.titleLabel.bounds.size.width + 20, 0, -self.naviTitleButton.titleLabel.bounds.size.width)];
    self.navigationItem.titleView = self.naviTitleButton;
    
    self.collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionViewLayout.sectionInset = CollectionViewInset;
    self.collectionViewLayout.minimumLineSpacing = CollectionViewCellMargin;
    self.collectionViewLayout.minimumInteritemSpacing = CollectionViewCellMargin;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kiOS7Later ? 64 : 0, self.view.width, self.view.height) collectionViewLayout:_collectionViewLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.delaysContentTouches = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alwaysBounceHorizontal = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[ZCImagePickerCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([ZCImagePickerCollectionViewCell class])];
    [self.collectionView registerClass:[ZCImagePickerNoneCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([ZCImagePickerNoneCollectionViewCell class])];
    
    [self.view addSubview:self.collectionView];
    
    if (self.allowsMultipleSelection) {
        self.operationToolBarView = [[UIView alloc] init];
        self.operationToolBarView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.operationToolBarView];
        
        self.sendButton = [[UIButton alloc] init];
        self.sendButton.titleLabel.font = [UIFont systemFontOfSize:16];
        self.sendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.sendButton setTitleColor:UIColorHex(#0088cc) forState:UIControlStateNormal];
        [self.sendButton setTitleColor:UIColorHex(#667587) forState:UIControlStateDisabled];
        self.sendButton.titleLabel.font = [UIFont fontWithName:kFNRalewayMedium size:15];
        [self.sendButton setTitle:@"Send" forState:UIControlStateNormal];
        [self.sendButton sizeToFit];
        self.sendButton.enabled = NO;
        [self.sendButton addTarget:self action:@selector(handleSendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.operationToolBarView addSubview:self.sendButton];
        
        self.previewButton = [[UIButton alloc] init];
        self.previewButton.titleLabel.font = self.sendButton.titleLabel.font;
        [self.previewButton setTitleColor:[self.sendButton titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
        [self.previewButton setTitleColor:[self.sendButton titleColorForState:UIControlStateDisabled] forState:UIControlStateDisabled];
        [self.previewButton setTitle:@"Preview" forState:UIControlStateNormal];
        [self.previewButton sizeToFit];
        self.previewButton.enabled = NO;
        [self.previewButton addTarget:self action:@selector(handlePreviewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.operationToolBarView addSubview:self.previewButton];
        
        self.imageCountLabel = [[UILabel alloc] init];
        self.imageCountLabel.backgroundColor = UIColorHex(#0088cc);
        self.imageCountLabel.textColor = [UIColor whiteColor];
        self.imageCountLabel.font = [UIFont fontWithName:kFNMuliSemiBold size:12];;
        self.imageCountLabel.textAlignment = NSTextAlignmentCenter;
        self.imageCountLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.imageCountLabel.layer.masksToBounds = YES;
        self.imageCountLabel.layer.cornerRadius = CGSizeMake(18, 18).width / 2;
        self.imageCountLabel.hidden = YES;
        [self.operationToolBarView addSubview:self.imageCountLabel];
    }
    
    self.albumView = [[ZCAlbumView alloc] initWithFrame:CGRectMake(0, -(kScreenHeight - 2 * 64), kScreenWidth, kScreenHeight - 64)];
    self.albumView.bottom = 0;
    self.albumView.albumViewDelegate = self;
    self.albumView.albumsArray = self.albumsArray;
    
    [self.view addSubview:self.albumView];

    
    _selectedImageAssetArray = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 由于被选中的图片 selectedImageAssetArray 是 property，所以可以由外部改变，
    // 因此 viewWillAppear 时检查一下图片被选中的情况，并刷新 collectionView
    if (self.allowsMultipleSelection) {
        // 只有允许多选，即底部工具栏显示时，需要重新设置底部工具栏的元素
        NSInteger selectedImageCount = [_selectedImageAssetArray count];
        if (selectedImageCount > 0) {
            // 如果有图片被选择，则预览按钮和发送按钮可点击，并刷新当前被选中的图片数量
            self.previewButton.enabled = YES;
            self.sendButton.enabled = YES;
            self.imageCountLabel.text = [NSString stringWithFormat:@"%@", @(selectedImageCount)];
//            self.imageCountLabel.hidden = NO;
        } else {
            // 如果没有任何图片被选择，则预览和发送按钮不可点击，并且隐藏显示图片数量的 Label
            self.previewButton.enabled = NO;
            self.sendButton.enabled = NO;
            self.imageCountLabel.hidden = YES;
        }
    }
    [self.collectionView reloadData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!CGSizeEqualToSize(self.collectionView.frame.size, self.view.bounds.size)) {
        self.collectionView.frame = self.view.bounds;
    }
    
    CGFloat operationToolBarViewHeight = 0;
    if (self.allowsMultipleSelection) {
        self.operationToolBarView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - OperationToolBarViewHeight, CGRectGetWidth(self.view.bounds), OperationToolBarViewHeight);
        self.previewButton.frame = CGRectSetXY(self.previewButton.frame, OperationToolBarViewPaddingHorizontal, CGFloatGetCenter(CGRectGetHeight(self.operationToolBarView.frame), CGRectGetHeight(self.previewButton.frame)));
        self.sendButton.frame = CGRectMake(CGRectGetWidth(self.operationToolBarView.frame) - OperationToolBarViewPaddingHorizontal - CGRectGetWidth(self.sendButton.frame), CGFloatGetCenter(CGRectGetHeight(self.operationToolBarView.frame), CGRectGetHeight(self.sendButton.frame)), CGRectGetWidth(self.sendButton.frame), CGRectGetHeight(self.sendButton.frame));
        self.imageCountLabel.frame = CGRectMake(CGRectGetMinX(self.sendButton.frame) - ImageCountLabelSize.width - 5, CGRectGetMinY(self.sendButton.frame) + CGFloatGetCenter(CGRectGetHeight(self.sendButton.frame), ImageCountLabelSize.height), ImageCountLabelSize.width, ImageCountLabelSize.height);
        operationToolBarViewHeight = CGRectGetHeight(self.operationToolBarView.frame);
    }
    
    if (self.collectionView.contentInset.bottom != operationToolBarViewHeight) {
        self.collectionView.contentInset = UIEdgeInsetsSetBottom(self.collectionView.contentInset, operationToolBarViewHeight);
        self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
        // 放在这里是因为有时候会先走完 refreshWithAssetsGroup 里的 completion 再走到这里，此时前者不会导致 scollToInitialPosition 的滚动，所以在这里再调用一次保证一定会滚
        [self scrollToInitialPositionIfNeeded];
    }
}

- (void)refreshWithImagesArray:(NSMutableArray<ZCAsset *> *)imagesArray {
    self.imagesAssetArray = imagesArray;
    [self.collectionView reloadData];
}

- (void)refreshWithAssetsGroup:(ZCAssetsGroup *)assetsGroup {
    self.assetsGroup = assetsGroup;
    if (!self.imagesAssetArray) {
        self.imagesAssetArray = [[NSMutableArray alloc] init];
    } else {
        [self.imagesAssetArray removeAllObjects];
    }
    // 通过 ZCAssetsGroup 获取该相册所有的图片 ZCAsset，并且储存到数组中
    ZCAlbumSortType albumSortType = ZCAlbumSortTypeReverse;
    // 从 delegate 中获取相册内容的排序方式，如果没有实现这个 delegate，则使用 ZCAlbumSortType 的默认值，即最新的内容排在最后面
    if (self.imagePickerViewControllerDelegate && [self.imagePickerViewControllerDelegate respondsToSelector:@selector(albumSortTypeForImagePickerViewController:)]) {
        albumSortType = [self.imagePickerViewControllerDelegate albumSortTypeForImagePickerViewController:self];
    }
    
    // 遍历相册内的资源较为耗时，交给子线程去处理，因此这里需要显示 Loading
    if ([self.imagePickerViewControllerDelegate respondsToSelector:@selector(imagePickerViewControllerWillStartLoad:)]) {
        [self.imagePickerViewControllerDelegate imagePickerViewControllerWillStartLoad:self];
    }
//    if (self.shouldShowDefaultLoadingView) {
//        [self showEmptyViewWithLoading];
//    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [assetsGroup enumerateAssetsWithOptions:albumSortType usingBlock:^(ZCAsset *resultAsset) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 这里需要对 UI 进行操作，因此放回主线程处理
                if (resultAsset) {
                    [self.imagesAssetArray addObject:resultAsset];
                } else { // result 为 nil，即遍历相片或视频完毕
#warning 相机相册时添加照相选择
                    if (true) {
                        NSNull *null = [[NSNull alloc] init];
                        [self.imagesAssetArray insertObject:null atIndex:0];
                    }
                    [self.collectionView reloadData];
                    [self.collectionView performBatchUpdates:NULL
                                                  completion:^(BOOL finished) {
                                                      
                                                      // 有时候如果这里很早就执行（比 viewWillAppear: 以及 self.view 被添加到 superview 上还早），那它实际上是不会滚动的，会等到 viewDidLayoutSubviews 里改完 contentInsets 后才滚
                                                      [self scrollToInitialPositionIfNeeded];
                                                      
                                                      if ([self.imagePickerViewControllerDelegate respondsToSelector:@selector(imagePickerViewControllerWillFinishLoad:)]) {
                                                          [self.imagePickerViewControllerDelegate imagePickerViewControllerWillFinishLoad:self];
                                                      }
                                                      if (self.shouldShowDefaultLoadingView) {
//                                                          [self hideEmptyView];
                                                      }
                                                  }];
                }
            });
        }];
    });
}

- (void)initPreviewViewControllerIfNeeded {
    if (!self.imagePickerPreviewViewController) {
        self.imagePickerPreviewViewController = [[ZCImagePickerPreviewViewController alloc] init];
        self.imagePickerPreviewViewController.delegate = self;
        self.imagePickerPreviewViewController.maximumSelectImageCount = self.maximumSelectImageCount;
        self.imagePickerPreviewViewController.minimumSelectImageCount = self.minimumSelectImageCount;
    }
}

- (CGSize)referenceImageSize {
    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.bounds);
    CGFloat collectionViewContentSpacing = collectionViewWidth - (self.collectionView.contentInset.left + self.collectionView.contentInset.right);
    NSInteger columnCount = floor(collectionViewContentSpacing / self.minimumImageWidth);
    CGFloat referenceImageWidth = self.minimumImageWidth;
    BOOL isSpacingEnoughWhenDisplayInMinImageSize = (self.collectionViewLayout.sectionInset.top + self.collectionViewLayout.sectionInset.bottom) + (self.minimumImageWidth + self.collectionViewLayout.minimumInteritemSpacing) * columnCount - self.collectionViewLayout.minimumInteritemSpacing <= collectionViewContentSpacing;
    if (!isSpacingEnoughWhenDisplayInMinImageSize) {
        // 算上图片之间的间隙后发现其实还是放不下啦，所以得把列数减少，然后放大图片以撑满剩余空间
        columnCount -= 1;
    }
    referenceImageWidth = (collectionViewContentSpacing - (self.collectionViewLayout.sectionInset.left + self.collectionViewLayout.sectionInset.right) - self.collectionViewLayout.minimumInteritemSpacing * (columnCount - 1)) / columnCount;
    return CGSizeMake(referenceImageWidth, referenceImageWidth);
}

- (void)setMinimumImageWidth:(CGFloat)minimumImageWidth {
    _minimumImageWidth = minimumImageWidth;
    [self referenceImageSize];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)scrollToInitialPositionIfNeeded {
    BOOL hasDataLoaded = [self.collectionView numberOfItemsInSection:0] > 0;
    if (self.collectionView.window && hasDataLoaded && !self.hasScrollToInitialPosition) {
        if ([self.imagePickerViewControllerDelegate respondsToSelector:@selector(albumSortTypeForImagePickerViewController:)] && [self.imagePickerViewControllerDelegate albumSortTypeForImagePickerViewController:self] == ZCAlbumSortTypeReverse) {
//            [self.collectionView zc_scrollToTop];
        } else {
//            [self.collectionView zc_scrollToBottom];
        }
        
        self.hasScrollToInitialPosition = YES;
    }
}

- (void)willPopInNavigationControllerWithAnimated:(BOOL)animated {
    self.hasScrollToInitialPosition = NO;
}

- (void)naviButtonAnimation:(UIButton *)sender {
    [UIView beginAnimations:@"rotate"context:nil];
    [UIView setAnimationDuration:.25f];
    if(CGAffineTransformEqualToTransform(sender.imageView.transform,CGAffineTransformIdentity)){
        sender.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        [UIView animateWithDuration:.25 animations:^{
            self.albumView.top = 0;
        }];
    }else {
        sender.imageView.transform =CGAffineTransformIdentity;
        [UIView animateWithDuration:.25 animations:^{
            self.albumView.bottom = 0;
        }];
    }
    [UIView commitAnimations];
}


#pragma mark - <ZCImagePickerPreviewViewControllerDelegate>

- (void)imagePickerPreviewViewController:(ZCImagePickerPreviewViewController *)imagePickerViewController didFinishPickingImageWithImagesAssetArray:(NSMutableArray<ZCAsset *> *)imagesAssetArray {
    if (self.imagePickerViewControllerDelegate && [self.imagePickerViewControllerDelegate respondsToSelector:@selector(imagePickerViewController:didFinishPickingImageWithImagesAssetArray:)]) {
        [self.imagePickerViewControllerDelegate imagePickerViewController:self didFinishPickingImageWithImagesAssetArray:imagesAssetArray];
    }
    [self.navigationController popViewControllerAnimated:YES];

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
    
    if ([self.imagesAssetArray[indexPath.row] isKindOfClass:[NSNull class]]) {
        ZCImagePickerNoneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZCImagePickerNoneCollectionViewCell class]) forIndexPath:indexPath];
        
        return cell;
        
    }else {
        NSString *identifier = NSStringFromClass([ZCImagePickerCollectionViewCell class]);
        // 获取需要显示的资源
        ZCAsset *imageAsset = [self.imagesAssetArray objectAtIndex:indexPath.item];
        
        ZCImagePickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        [imageAsset requestThumbnailImageWithSize:[self referenceImageSize] completion:^(UIImage *result, NSDictionary *info) {
            if (!info || [[info objectForKey:PHImageResultIsDegradedKey] boolValue]) {
                cell.contentImageView.image = result;
            } else if ([collectionView zc_itemVisibleAtIndexPath:indexPath]) {
//                ZCImagePickerCollectionViewCell *anotherCell = (ZCImagePickerCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//                anotherCell.contentImageView.image = result;
            }
        }];
        
        if (imageAsset.assetType == ZCAssetTypeVideo) {
            cell.videoDurationLabel.text = [NSString zc_timeStringWithMinsAndSecsFromSecs:imageAsset.duration];
        }
        
        [cell.checkboxButton addTarget:self action:@selector(handleCheckBoxButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        //    [cell.progressView addTarget:self action:@selector(handleProgressViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.downloadRetryButton addTarget:self action:@selector(handleDownloadRetryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.editing = self.allowsMultipleSelection;
        if (cell.editing) {
            // 如果该图片的 ZCAsset 被包含在已选择图片的数组中，则控制该图片被选中
            cell.checked = [ZCImagePickerHelper imageAssetArray:_selectedImageAssetArray containsImageAsset:imageAsset];
        }
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.imagesAssetArray[indexPath.row] isKindOfClass:[NSNull class]]) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.mediaTypes = @[(NSString *)kUTTypeImage];
            picker.allowsEditing = NO;
            picker.videoQuality = UIImagePickerControllerQualityTypeHigh;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
        }
        else
        {
            // 相机类型不可用
        }
    }else {
        ZCAsset *imageAsset = [self.imagesAssetArray objectAtIndex:indexPath.item];
        [self initPreviewViewControllerIfNeeded];
        if (!self.allowsMultipleSelection) {
            // 单选的情况下
            [self.imagePickerPreviewViewController updateImagePickerPreviewViewWithImagesAssetArray:@[imageAsset]
                                                                            selectedImageAssetArray:nil
                                                                                  currentImageIndex:0
                                                                                    singleCheckMode:YES];
        } else {
            NSMutableArray *tempImageAssetArray = self.imagesAssetArray.mutableCopy;
            if ([_imagesAssetArray[0] isKindOfClass:[NSNull class]]) {
                [tempImageAssetArray removeObjectAtIndex:0];
            }
            // cell 处于编辑状态，即图片允许多选
            [self.imagePickerPreviewViewController updateImagePickerPreviewViewWithImagesAssetArray:tempImageAssetArray
                                                                            selectedImageAssetArray:_selectedImageAssetArray
                                                                                  currentImageIndex:indexPath.item - 1
                                                                                    singleCheckMode:NO];
        }
        [self.navigationController pushViewController:self.imagePickerPreviewViewController animated:YES];
    }
}

#pragma mart - <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

// 操作完成
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    
    ZCAssetsGroup *assetsGroup = [[ZCAssetsGroup alloc] initWithPHCollection:result[0]];
    [[ZCAssetsManager sharedInstance] saveImageWithImageRef:image.CGImage albumAssetsGroup:assetsGroup orientation:image.imageOrientation completionBlock:^(ZCAsset *asset, NSError *error) {
        [self initPreviewViewControllerIfNeeded];
        NSMutableArray *assetArray = [NSMutableArray arrayWithObject:asset];
        // 单选的情况下
        [self.imagePickerPreviewViewController updateImagePickerPreviewViewWithImagesAssetArray:assetArray
                                                                        selectedImageAssetArray:assetArray
                                                                              currentImageIndex:0
                                                                                singleCheckMode:YES];
        [self.navigationController pushViewController:self.imagePickerPreviewViewController animated:YES];
    }];
    
    
    
}

// 操作取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    // 回收图像选取控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark - <ZCAlbumViewControllerDelegate>


- (void)albumDidChange:(ZCAssetsGroup *)assetsGroup {
    [self refreshWithAssetsGroup:assetsGroup];
    [self.naviTitleButton setTitle:assetsGroup.name forState:UIControlStateNormal];
    [self.naviTitleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.naviTitleButton.imageView.image.size.width, 0, self.naviTitleButton.imageView.image.size.width)];
#warning button 中图片位置适配
    [self.naviTitleButton setImageEdgeInsets:UIEdgeInsetsMake(0, self.naviTitleButton.titleLabel.bounds.size.width + 20, 0, -self.naviTitleButton.titleLabel.bounds.size.width)];
    [self naviButtonAnimation:self.naviTitleButton];
}

- (void)cancelChooseAlbum {
    [self naviButtonAnimation:self.naviTitleButton];
    
}

#pragma mark - 按钮点击回调

- (void)handleTitleButtonClick:(UIButton *)sender {
    
    [self naviButtonAnimation:sender];
}

- (void)handleSendButtonClick:(id)sender {
    if (self.imagePickerViewControllerDelegate && [self.imagePickerViewControllerDelegate respondsToSelector:@selector(imagePickerViewController:didFinishPickingImageWithImagesAssetArray:)]) {
        [self.imagePickerViewControllerDelegate imagePickerViewController:self didFinishPickingImageWithImagesAssetArray:_selectedImageAssetArray];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handlePreviewButtonClick:(id)sender {
    [self initPreviewViewControllerIfNeeded];
    // 手工更新图片预览界面
    [self.imagePickerPreviewViewController updateImagePickerPreviewViewWithImagesAssetArray:[_selectedImageAssetArray copy]
                                                                    selectedImageAssetArray:_selectedImageAssetArray
                                                                          currentImageIndex:0
                                                                            singleCheckMode:NO];
    [self.navigationController pushViewController:self.imagePickerPreviewViewController animated:YES];
}

- (void)handleCancelPickerImage:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^() {
        if (self.imagePickerViewControllerDelegate && [self.imagePickerViewControllerDelegate respondsToSelector:@selector(imagePickerViewControllerDidCancel:)]) {
            [self.imagePickerViewControllerDelegate imagePickerViewControllerDidCancel:self];
        }
    }];
}

- (void)handleCheckBoxButtonClick:(id)sender {
    UIButton *checkBoxButton = sender;
    NSIndexPath *indexPath = [self.collectionView zc_indexPathForItemAtView:checkBoxButton];
    
    ZCImagePickerCollectionViewCell *cell = (ZCImagePickerCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    ZCAsset *imageAsset = [self.imagesAssetArray objectAtIndex:indexPath.item];
    if (cell.checked) {
        // 移除选中状态
        if ([self.imagePickerViewControllerDelegate respondsToSelector:@selector(imagePickerViewController:willUncheckImageAtIndex:)]) {
            [self.imagePickerViewControllerDelegate imagePickerViewController:self willUncheckImageAtIndex:indexPath.item];
        }
        
        cell.checked = NO;
        [ZCImagePickerHelper imageAssetArray:_selectedImageAssetArray removeImageAsset:imageAsset];
        
        if ([self.imagePickerViewControllerDelegate respondsToSelector:@selector(imagePickerViewController:didUncheckImageAtIndex:)]) {
            [self.imagePickerViewControllerDelegate imagePickerViewController:self didUncheckImageAtIndex:indexPath.item];
        }
        
        // 根据选择图片数控制预览和发送按钮的 enable，以及修改已选中的图片数
        [self updateImageCountAndCheckLimited];
    } else {
        // 选中该资源
        // 发出请求获取大图，如果图片在 iCloud，则会发出网络请求下载图片。这里同时保存请求 id，供取消请求使用
        [self requestImageWithIndexPath:indexPath];
    }
}

- (void)handleProgressViewClick:(id)sender {
    UIControl *progressView = sender;
    NSIndexPath *indexPath = [self.collectionView zc_indexPathForItemAtView:progressView];
    ZCAsset *imageAsset = [self.imagesAssetArray objectAtIndex:indexPath.item];
    if (imageAsset.downloadStatus == ZCAssetDownloadStatusDownloading) {
        // 下载过程中点击，取消下载，理论上能点击 progressView 就肯定是下载中，这里只是做个保护
        ZCImagePickerCollectionViewCell *cell = (ZCImagePickerCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        [[ZCAssetsManager sharedInstance].phCachingImageManager cancelImageRequest:(int32_t)imageAsset.requestID];
        NSLog(@"Cancel download asset image with request ID %@", [NSNumber numberWithInteger:imageAsset.requestID]);
        cell.downloadStatus = ZCAssetDownloadStatusCanceled;
        [imageAsset updateDownloadStatusWithDownloadResult:NO];
    }
}

- (void)handleDownloadRetryButtonClick:(id)sender {
    UIButton *downloadRetryButton = sender;
    NSIndexPath *indexPath = [self.collectionView zc_indexPathForItemAtView:downloadRetryButton];
    [self requestImageWithIndexPath:indexPath];
}

- (void)updateImageCountAndCheckLimited {
    NSInteger selectedImageCount = [_selectedImageAssetArray count];
    if (selectedImageCount > 0 && selectedImageCount >= _minimumSelectImageCount) {
        self.previewButton.enabled = YES;
        self.sendButton.enabled = YES;
        self.imageCountLabel.text = [NSString stringWithFormat:@"%@", @(selectedImageCount)];
        self.imageCountLabel.hidden = NO;
        [ZCImagePickerHelper springAnimationOfImageSelectedCountChangeWithCountLabel:self.imageCountLabel];
    } else {
        self.previewButton.enabled = NO;
        self.sendButton.enabled = NO;
        self.imageCountLabel.hidden = YES;
    }
}

#pragma mark - Request Image

- (void)requestImageWithIndexPath:(NSIndexPath *)indexPath {
    // 发出请求获取大图，如果图片在 iCloud，则会发出网络请求下载图片。这里同时保存请求 id，供取消请求使用
    ZCAsset *imageAsset = [self.imagesAssetArray objectAtIndex:indexPath.item];
    ZCImagePickerCollectionViewCell *cell = (ZCImagePickerCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    imageAsset.requestID = [imageAsset requestPreviewImageWithCompletion:^(UIImage *result, NSDictionary *info) {
        
        BOOL downloadSucceed = (result && !info) || (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        
        if (downloadSucceed) {
            // 资源资源已经在本地或下载成功
            [imageAsset updateDownloadStatusWithDownloadResult:YES];
            cell.downloadStatus = ZCAssetDownloadStatusSucceed;
            
            if ([_selectedImageAssetArray count] >= _maximumSelectImageCount) {
                if (!_alertTitleWhenExceedMaxSelectImageCount) {
                    _alertTitleWhenExceedMaxSelectImageCount = [NSString stringWithFormat:@"你最多只能选择%@张图片", @(_maximumSelectImageCount)];
                }
                if (!_alertButtonTitleWhenExceedMaxSelectImageCount) {
                    _alertButtonTitleWhenExceedMaxSelectImageCount = [NSString stringWithFormat:@"我知道了"];
                }
                
//               UIAlertController *alertController = [UIAlertController alertControllerWithTitle:_alertTitleWhenExceedMaxSelectImageCount message:nil preferredStyle:UIAlertControllerStyleAlert];
//                [alertController addAction:[UIAlertAction actionWithTitle:_alertButtonTitleWhenExceedMaxSelectImageCount style:UIAlertActionStyleCancel handler:nil]];
//                
//                [alertController showWithAnimated:YES];
                return;
            }
            
            if ([self.imagePickerViewControllerDelegate respondsToSelector:@selector(imagePickerViewController:willCheckImageAtIndex:)]) {
                [self.imagePickerViewControllerDelegate imagePickerViewController:self willCheckImageAtIndex:indexPath.item];
            }
            
            cell.checked = YES;
            [_selectedImageAssetArray addObject:imageAsset];
            
            if ([self.imagePickerViewControllerDelegate respondsToSelector:@selector(imagePickerViewController:didCheckImageAtIndex:)]) {
                [self.imagePickerViewControllerDelegate imagePickerViewController:self didCheckImageAtIndex:indexPath.item];
            }
            
            // 根据选择图片数控制预览和发送按钮的 enable，以及修改已选中的图片数
            [self updateImageCountAndCheckLimited];
        } else if ([info objectForKey:PHImageErrorKey] ) {
            // 下载错误
            [imageAsset updateDownloadStatusWithDownloadResult:NO];
            cell.downloadStatus = ZCAssetDownloadStatusFailed;
        }
        
    } withProgressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        imageAsset.downloadProgress = progress;
        
        if ([self.collectionView zc_itemVisibleAtIndexPath:indexPath]) {
            /**
             *  withProgressHandler 不在主线程执行，若用户在该 block 中操作 UI 时会产生一些问题，
             *  为了避免这种情况，这里该 block 主动放到主线程执行。
             */
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Download iCloud image, current progress is : %f", progress);
                
                if (cell.downloadStatus != ZCAssetDownloadStatusDownloading) {
                    cell.downloadStatus = ZCAssetDownloadStatusDownloading;
                    // 重置 progressView 的显示的进度为 0
//                    [cell.progressView setProgress:0 animated:NO];
                    // 预先设置预览界面的下载状态
                    self.imagePickerPreviewViewController.downloadStatus = ZCAssetDownloadStatusDownloading;
                }
                // 拉取资源的初期，会有一段时间没有进度，猜测是发出网络请求以及与 iCloud 建立连接的耗时，这时预先给个 0.02 的进度值，看上去好看些
                float targetProgress = MAX(0.02, progress);
//                if ( targetProgress < cell.progressView.progress ) {
//                    [cell.progressView setProgress:targetProgress animated:NO];
//                } else {
//                    cell.progressView.progress = MAX(0.02, progress);
//                }
                if (error) {
                    NSLog(@"Download iCloud image Failed, current progress is: %f", progress);
                    cell.downloadStatus = ZCAssetDownloadStatusFailed;
                }
            });
        }
    }];
}


@end

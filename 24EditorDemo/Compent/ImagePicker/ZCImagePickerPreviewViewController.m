//
//  ZCImagePickerPreviewViewController.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/23.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCImagePickerPreviewViewController.h"
#import "UIControl+ZCCate.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZCImagePickerViewController.h"
#import "ZCImagePickerHelper.h"
#import "ZCAssetsManager.h"
#import "ZCZoomImageView.h"
#import "ZCAsset.h"
#import "UIImage+ZCCate.h"

#define TopToolBarViewHeight 64

#define OperationToolBarViewHeight 44
#define OperationToolBarViewPaddingHorizontal 12
#define ImageCountLabelSize CGSizeMake(18, 18)

@interface ZCImagePickerPreviewViewController ()
@property(nonatomic, strong, readwrite) UIView *operationToolBarView;
@property(nonatomic, strong, readwrite) UIButton *sendButton;
@property(nonatomic, strong, readwrite) UIButton *editButton;
@property(nonatomic, strong, readwrite) UILabel *imageCountLabel;
@end

@implementation ZCImagePickerPreviewViewController {
    BOOL _singleCheckMode;
    BOOL _usePhotoKit;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
    self.toolBarBackgroundColor = UIColorMakeWithRGBA(27, 27, 27, .9f);
    self.toolBarTintColor = [UIColor whiteColor];
    self.maximumSelectImageCount = INT_MAX;
    self.minimumSelectImageCount = 0;
    _usePhotoKit = !EnforceUseAssetsLibraryForDebug;
}

- (void)initSubviews {
    
    self.imagePreviewView.delegate = self;
    
    _topToolBarView = [[UIView alloc] init];
    self.topToolBarView.backgroundColor = self.toolBarBackgroundColor;
    self.topToolBarView.tintColor = self.toolBarTintColor;
    [self.view addSubview:self.topToolBarView];
    
    _backButton = [[UIButton alloc] init];

    [self.backButton setImage:[UIImage imageWithIcon:kIFIArrowLeft size:18 color:UIColorHex(#ffffff)] forState:UIControlStateNormal];
    self.backButton.tintColor = self.topToolBarView.tintColor;
    [self.backButton sizeToFit];
    [self.backButton addTarget:self action:@selector(handleCancelPreviewImage:) forControlEvents:UIControlEventTouchUpInside];
    self.backButton.zc_outsideEdge = UIEdgeInsetsMake(-30, -20, -50, -80);
    [self.topToolBarView addSubview:self.backButton];
    
    _checkboxButton = [[UIButton alloc] init];
    

    [self.checkboxButton setImage:[UIImage imageNamed:@"PreviewImageCheckbox"] forState:UIControlStateNormal];
   
    [self.checkboxButton setImage:[UIImage imageNamed:@"PreviewImageCheckboxChecked"] forState:UIControlStateSelected];
    [self.checkboxButton setImage:[UIImage imageNamed:@"PreviewImageCheckboxChecked"] forState:UIControlStateSelected|UIControlStateHighlighted];
    self.checkboxButton.tintColor = self.topToolBarView.tintColor;
    [self.checkboxButton sizeToFit];
    [self.checkboxButton addTarget:self action:@selector(handleCheckButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.checkboxButton.zc_outsideEdge = UIEdgeInsetsMake(-6, -6, -6, -6);
    [self.topToolBarView addSubview:self.checkboxButton];
    
    _downloadRetryButton = [[UIButton alloc] init];
    [self.downloadRetryButton setImage:[UIImage imageNamed:@"IcloudDownloadFault"] forState:UIControlStateNormal];
    [self.downloadRetryButton sizeToFit];
    [self.downloadRetryButton addTarget:self action:@selector(handleDownloadRetryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.downloadRetryButton.zc_outsideEdge = UIEdgeInsetsMake(-6, -6, -6, -6);
    self.downloadRetryButton.hidden = YES;
    [self.topToolBarView addSubview:self.downloadRetryButton];
    
    
    self.operationToolBarView = [[UIView alloc] init];
    self.operationToolBarView.backgroundColor = UIColorMakeWithRGBA(27, 27, 27, .9f);
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
    
    self.editButton = [[UIButton alloc] init];
    self.editButton.titleLabel.font = self.sendButton.titleLabel.font;
    [self.editButton setTitleColor:[self.sendButton titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
    [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
    [self.editButton sizeToFit];
    self.editButton.enabled = YES;
    [self.editButton addTarget:self action:@selector(handleEditButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.operationToolBarView addSubview:self.editButton];
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if (!_singleCheckMode) {
        ZCAsset *imageAsset = [self.imagesAssetArray objectAtIndex:self.imagePreviewView.currentImageIndex];
        self.checkboxButton.selected = [self.selectedImageAssetArray containsObject:imageAsset];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.operationToolBarView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - OperationToolBarViewHeight, CGRectGetWidth(self.view.bounds), OperationToolBarViewHeight);
    
     self.sendButton.frame = CGRectMake(CGRectGetWidth(self.operationToolBarView.frame) - OperationToolBarViewPaddingHorizontal - CGRectGetWidth(self.sendButton.frame), CGFloatGetCenter(CGRectGetHeight(self.operationToolBarView.frame), CGRectGetHeight(self.sendButton.frame)), CGRectGetWidth(self.sendButton.frame), CGRectGetHeight(self.sendButton.frame));
    self.editButton.frame = CGRectSetXY(self.editButton.frame, OperationToolBarViewPaddingHorizontal, CGFloatGetCenter(CGRectGetHeight(self.operationToolBarView.frame), CGRectGetHeight(self.editButton.frame)));
    self.imageCountLabel.frame = CGRectMake(CGRectGetMinX(self.sendButton.frame) - ImageCountLabelSize.width - 5, CGRectGetMinY(self.sendButton.frame) + CGFloatGetCenter(CGRectGetHeight(self.sendButton.frame), ImageCountLabelSize.height), ImageCountLabelSize.width, ImageCountLabelSize.height);
    
    self.topToolBarView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), TopToolBarViewHeight);
    
    CGFloat topToolbarPaddingTop = [[UIApplication sharedApplication] isStatusBarHidden] ? 0 : StatusBarHeight;
    CGFloat topToolbarContentHeight = CGRectGetHeight(self.topToolBarView.bounds) - topToolbarPaddingTop;
    self.backButton.frame = CGRectSetXY(self.backButton.frame, 15, topToolbarPaddingTop + CGFloatGetCenter(topToolbarContentHeight, CGRectGetHeight(self.backButton.frame)));
    if (!self.checkboxButton.hidden) {
        self.checkboxButton.frame = CGRectSetXY(self.checkboxButton.frame, CGRectGetWidth(self.topToolBarView.frame) - 10 - CGRectGetWidth(self.checkboxButton.frame), topToolbarPaddingTop + CGFloatGetCenter(topToolbarContentHeight, CGRectGetHeight(self.checkboxButton.frame)));
    }
    UIImage *downloadRetryImage = [self.downloadRetryButton imageForState:UIControlStateNormal];
    self.downloadRetryButton.frame = CGRectSetXY(self.downloadRetryButton.frame, CGRectGetWidth(self.topToolBarView.frame) - 10 - downloadRetryImage.size.width, topToolbarPaddingTop + CGFloatGetCenter(topToolbarContentHeight, CGRectGetHeight(self.downloadRetryButton.frame)));
    /* 理论上 progressView 作为进度按钮，应该需要跟错误重试按钮 downloadRetryButton 的 frame 保持一致，但这里并没有直接使用
     * self.progressView.frame = self.downloadRetryButton.frame，这是因为 self.downloadRetryButton 具有 1pt 的 top
     * contentEdgeInsets，因此最终的 frame 是椭圆型，如果按上面的操作，progressView 内部绘制出的饼状图形就会变成椭圆型，
     * 因此，这里 progressView 直接拿 downloadRetryButton 的 image 图片尺寸作为 frame size
     */
//    self.progressView.frame = CGRectFlatMake(CGRectGetMinX(self.downloadRetryButton.frame), CGRectGetMinY(self.downloadRetryButton.frame) + self.downloadRetryButton.contentEdgeInsets.top, downloadRetryImage.size.width, downloadRetryImage.size.height);
}

- (void)setToolBarBackgroundColor:(UIColor *)toolBarBackgroundColor {
    _toolBarBackgroundColor = toolBarBackgroundColor;
    self.topToolBarView.backgroundColor = self.toolBarBackgroundColor;
}

- (void)setToolBarTintColor:(UIColor *)toolBarTintColor {
    _toolBarTintColor = toolBarTintColor;
    self.topToolBarView.tintColor = toolBarTintColor;
    self.backButton.tintColor = toolBarTintColor;
    self.checkboxButton.tintColor = toolBarTintColor;
}

- (void)updateImageCountAndCheckLimited {
    NSInteger selectedImageCount = [_selectedImageAssetArray count];
    if (selectedImageCount > 0 && selectedImageCount >= _minimumSelectImageCount) {
        
        self.sendButton.enabled = YES;
        self.imageCountLabel.text = [NSString stringWithFormat:@"%@", @(selectedImageCount)];
        self.imageCountLabel.hidden = NO;
        [ZCImagePickerHelper springAnimationOfImageSelectedCountChangeWithCountLabel:self.imageCountLabel];
    } else {
        self.sendButton.enabled = NO;
        self.imageCountLabel.hidden = YES;
    }
}

- (void)setDownloadStatus:(ZCAssetDownloadStatus)downloadStatus {
    _downloadStatus = downloadStatus;
    switch (downloadStatus) {
        case ZCAssetDownloadStatusSucceed:
            if (!_singleCheckMode) {
                self.checkboxButton.hidden = NO;
            }
            self.downloadRetryButton.hidden = YES;
            break;
            
        case ZCAssetDownloadStatusDownloading:
            self.checkboxButton.hidden = YES;
            self.downloadRetryButton.hidden = YES;
            break;
            
        case ZCAssetDownloadStatusCanceled:
            self.checkboxButton.hidden = NO;
            self.downloadRetryButton.hidden = YES;
            break;
            
        case ZCAssetDownloadStatusFailed:
            self.checkboxButton.hidden = YES;
            self.downloadRetryButton.hidden = NO;
            break;
            
        default:
            break;
    }
}

- (void)updateImagePickerPreviewViewWithImagesAssetArray:(NSMutableArray<ZCAsset *> *)imageAssetArray
                                 selectedImageAssetArray:(NSMutableArray<ZCAsset *> *)selectedImageAssetArray
                                       currentImageIndex:(NSInteger)currentImageIndex
                                         singleCheckMode:(BOOL)singleCheckMode {
    self.imagesAssetArray = imageAssetArray;
    self.selectedImageAssetArray = selectedImageAssetArray;
    self.imagePreviewView.currentImageIndex = currentImageIndex;
    _singleCheckMode = singleCheckMode;
    if (singleCheckMode) {
        self.checkboxButton.hidden = YES;
        self.sendButton.enabled = YES;
    }else {
        [self updateImageCountAndCheckLimited];
    }
}
    

#pragma mark - <ZCImagePreviewViewDelegate>

- (NSUInteger)numberOfImagesInImagePreviewView:(ZCImagePreviewView *)imagePreviewView {
    return [self.imagesAssetArray count];
}

- (ZCImagePreviewMediaType)imagePreviewView:(ZCImagePreviewView *)imagePreviewView assetTypeAtIndex:(NSUInteger)index {
    ZCAsset *imageAsset = [self.imagesAssetArray objectAtIndex:index];
        if (imageAsset.assetType == ZCAssetTypeImage) {
            return ZCImagePreviewMediaTypeImage;
        } else if (imageAsset.assetType == ZCAssetTypeLivePhoto) {
            return ZCImagePreviewMediaTypeLivePhoto;
        } else if (imageAsset.assetType == ZCAssetTypeVideo) {
            return ZCImagePreviewMediaTypeVideo;
        } else {
            return ZCImagePreviewMediaTypeOthers;
        }
}

- (void)imagePreviewView:(ZCImagePreviewView *)imagePreviewView renderZoomImageView:(ZCZoomImageView *)zoomImageView atIndex:(NSUInteger)index {
    [self requestImageForZoomImageView:zoomImageView withIndex:index];
}

- (void)imagePreviewView:(ZCImagePreviewView *)imagePreviewView willScrollHalfToIndex:(NSUInteger)index {
    if (!_singleCheckMode) {
        ZCAsset *imageAsset = [self.imagesAssetArray objectAtIndex:index];
        self.checkboxButton.selected = [self.selectedImageAssetArray containsObject:imageAsset];
    }
}

#pragma mark - <ZCZoomImageViewDelegate>

- (void)singleTouchInZoomingImageView:(ZCZoomImageView *)zoomImageView location:(CGPoint)location {
    self.topToolBarView.hidden = !self.topToolBarView.hidden;
    self.operationToolBarView.hidden = !self.operationToolBarView.hidden;
}


- (void)zoomImageView:(ZCZoomImageView *)imageView didHideVideoToolbar:(BOOL)didHide {
    self.topToolBarView.hidden = didHide;
    self.operationToolBarView.hidden = didHide;
}

#pragma mark - <CLImageEditorDelegate>

- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image {
    
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    
    ZCAssetsGroup *assetsGroup = [[ZCAssetsGroup alloc] initWithPHCollection:result[0]];
    [[ZCAssetsManager sharedInstance] saveImageWithImageRef:image.CGImage albumAssetsGroup:assetsGroup orientation:image.imageOrientation completionBlock:^(ZCAsset *asset, NSError *error) {
        [self.imagesAssetArray replaceObjectAtIndex:self.imagePreviewView.currentImageIndex withObject:asset];
        [self updateImagePickerPreviewViewWithImagesAssetArray:self.imagesAssetArray selectedImageAssetArray:self.selectedImageAssetArray currentImageIndex:self.imagePreviewView.currentImageIndex singleCheckMode:_singleCheckMode];
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imageEditorDidCancel:(CLImageEditor *)editor {
    
}

#pragma mark - 按钮点击回调

- (void)handleCancelPreviewImage:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerPreviewViewControllerDidCancel:)]) {
        [self.delegate imagePickerPreviewViewControllerDidCancel:self];
    }

}

- (void)handleEditButtonClick:(UIButton *)sender {
        ZCAsset *imageAsset = [self.imagesAssetArray objectAtIndex:self.imagePreviewView.currentImageIndex];
        CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:imageAsset.originImage];
        editor.delegate = self;
        [self.navigationController pushViewController:editor animated:YES];
}

- (void)handleSendButtonClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerPreviewViewController:didFinishPickingImageWithImagesAssetArray:)]) {
            [self.delegate imagePickerPreviewViewController:self didFinishPickingImageWithImagesAssetArray:self.selectedImageAssetArray];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleCheckButtonClick:(UIButton *)button {
    [ZCImagePickerHelper removeSpringAnimationOfImageCheckedWithCheckboxButton:button];
    
    if (button.selected) {
        if ([self.delegate respondsToSelector:@selector(imagePickerPreviewViewController:willUncheckImageAtIndex:)]) {
            [self.delegate imagePickerPreviewViewController:self willUncheckImageAtIndex:self.imagePreviewView.currentImageIndex];
        }
        button.selected = NO;
        ZCAsset *imageAsset = [self.imagesAssetArray objectAtIndex:self.imagePreviewView.currentImageIndex];
        [ZCImagePickerHelper imageAssetArray:self.selectedImageAssetArray removeImageAsset:imageAsset];
        
        if ([self.delegate respondsToSelector:@selector(imagePickerPreviewViewController:didUncheckImageAtIndex:)]) {
            [self.delegate imagePickerPreviewViewController:self didUncheckImageAtIndex:self.imagePreviewView.currentImageIndex];
        }
    } else {
        if ([self.selectedImageAssetArray count] >= self.maximumSelectImageCount) {
#warning 超出限制提醒
            if (!self.alertTitleWhenExceedMaxSelectImageCount) {
                self.alertTitleWhenExceedMaxSelectImageCount = [NSString stringWithFormat:@"你最多只能选择%@张图片", @(self.maximumSelectImageCount)];
            }
            if (!self.alertButtonTitleWhenExceedMaxSelectImageCount) {
                self.alertButtonTitleWhenExceedMaxSelectImageCount = [NSString stringWithFormat:@"我知道了"];
            }

            return;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerPreviewViewController:willCheckImageAtIndex:)]) {
            [self.delegate imagePickerPreviewViewController:self willCheckImageAtIndex:self.imagePreviewView.currentImageIndex];
        }
        button.selected = YES;
        [ZCImagePickerHelper springAnimationOfImageCheckedWithCheckboxButton:button];
        ZCAsset *imageAsset = [self.imagesAssetArray objectAtIndex:self.imagePreviewView.currentImageIndex];
        [self.selectedImageAssetArray addObject:imageAsset];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerPreviewViewController:didCheckImageAtIndex:)]) {
            [self.delegate imagePickerPreviewViewController:self didCheckImageAtIndex:self.imagePreviewView.currentImageIndex];
        }
    }
    [self updateImageCountAndCheckLimited];
}

- (void)handleDownloadRetryButtonClick:(id)sender {
    [self requestImageForZoomImageView:nil withIndex:self.imagePreviewView.currentImageIndex];
}

#pragma mark - Request Image

- (void)requestImageForZoomImageView:(ZCZoomImageView *)zoomImageView withIndex:(NSInteger)index {
    ZCZoomImageView *imageView = zoomImageView ? : [self.imagePreviewView zoomImageViewAtIndex:index];
    // 如果是走 PhotoKit 的逻辑，那么这个 block 会被多次调用，并且第一次调用时返回的图片是一张小图，
    // 拉取图片的过程中可能会多次返回结果，且图片尺寸越来越大，因此这里调整 contentMode 以防止图片大小跳动
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    ZCAsset *imageAsset = [self.imagesAssetArray objectAtIndex:index];
    
    // 获取资源图片的预览图，这是一张适合当前设备屏幕大小的图片，最终展示时把图片交给组件控制最终展示出来的大小。
    // 系统相册本质上也是这么处理的，因此无论是系统相册，还是这个系列组件，由始至终都没有显示照片原图，
    // 这也是系统相册能加载这么快的原因。
    // 另外这里采用异步请求获取图片，避免获取图片时 UI 卡顿
    PHAssetImageProgressHandler phProgressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        imageAsset.downloadProgress = progress;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (index == self.imagePreviewView.currentImageIndex) {
                // 只有当前显示的预览图才会展示下载进度
                NSLog(@"Download iCloud image in preview, current progress is: %f", progress);
                
                if (self.downloadStatus != ZCAssetDownloadStatusDownloading) {
                    self.downloadStatus = ZCAssetDownloadStatusDownloading;
                    // 重置 progressView 的显示的进度为 0
//                    [self.progressView setProgress:0 animated:NO];
                }
                // 拉取资源的初期，会有一段时间没有进度，猜测是发出网络请求以及与 iCloud 建立连接的耗时，这时预先给个 0.02 的进度值，看上去好看些
                float targetProgress = fmax(0.02, progress);
//                if ( targetProgress < self.progressView.progress ) {
//                    [self.progressView setProgress:targetProgress animated:NO];
//                } else {
//                    self.progressView.progress = fmax(0.02, progress);
//                }
                if (error) {
                    NSLog(@"Download iCloud image Failed, current progress is: %f", progress);
                    self.downloadStatus = ZCAssetDownloadStatusFailed;
                }
            }
        });
    };
    
    if (imageAsset.assetType == ZCAssetTypeLivePhoto) {
        imageView.tag = -1;
        imageAsset.requestID = [imageAsset requestLivePhotoWithCompletion:^void(PHLivePhoto *livePhoto, NSDictionary *info) {
            // 这里可能因为 imageView 复用，导致前面的请求得到的结果显示到别的 imageView 上，
            // 因此判断如果是新请求（无复用问题）或者是当前的请求才把获得的图片结果展示出来
            BOOL isNewRequest = (imageView.tag == -1 && imageAsset.requestID == 0);
            BOOL isCurrentRequest = imageView.tag == imageAsset.requestID;
            BOOL loadICloudImageFault = !livePhoto || info[PHImageErrorKey];
            if (!loadICloudImageFault && (isNewRequest || isCurrentRequest)) {
                // 如果是走 PhotoKit 的逻辑，那么这个 block 会被多次调用，并且第一次调用时返回的图片是一张小图，
                // 这时需要把图片放大到跟屏幕一样大，避免后面加载大图后图片的显示会有跳动
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.livePhoto = livePhoto;
                });
            }
            
            BOOL downloadSucceed = (livePhoto && !info) || (![[info objectForKey:PHLivePhotoInfoCancelledKey] boolValue] && ![info objectForKey:PHLivePhotoInfoErrorKey] && ![[info objectForKey:PHLivePhotoInfoIsDegradedKey] boolValue]);
            
            if (downloadSucceed) {
                // 资源资源已经在本地或下载成功
                [imageAsset updateDownloadStatusWithDownloadResult:YES];
                self.downloadStatus = ZCAssetDownloadStatusSucceed;
                
            } else if ([info objectForKey:PHLivePhotoInfoErrorKey] ) {
                // 下载错误
                [imageAsset updateDownloadStatusWithDownloadResult:NO];
                self.downloadStatus = ZCAssetDownloadStatusFailed;
            }
            
        } withProgressHandler:phProgressHandler];
        imageView.tag = imageAsset.requestID;
    } else if (imageAsset.assetType == ZCAssetTypeVideo) {
        imageView.tag = -1;
        imageAsset.requestID = [imageAsset requestPlayerItemWithCompletion:^(AVPlayerItem *playerItem, NSDictionary *info) {
            // 这里可能因为 imageView 复用，导致前面的请求得到的结果显示到别的 imageView 上，
            // 因此判断如果是新请求（无复用问题）或者是当前的请求才把获得的图片结果展示出来
            BOOL isNewRequest = (imageView.tag == -1 && imageAsset.requestID == 0);
            BOOL isCurrentRequest = imageView.tag == imageAsset.requestID;
            BOOL loadICloudImageFault = !playerItem || info[PHImageErrorKey];
            if (!loadICloudImageFault && (isNewRequest || isCurrentRequest)) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.videoPlayerItem = playerItem;
                });
            }
        } withProgressHandler:phProgressHandler];
        imageView.tag = imageAsset.requestID;
    } else {
        imageView.tag = -1;
        imageAsset.requestID = [imageAsset requestPreviewImageWithCompletion:^void(UIImage *result, NSDictionary *info) {
            // 这里可能因为 imageView 复用，导致前面的请求得到的结果显示到别的 imageView 上，
            // 因此判断如果是新请求（无复用问题）或者是当前的请求才把获得的图片结果展示出来
            BOOL isNewRequest = (imageView.tag == -1 && imageAsset.requestID == 0);
            BOOL isCurrentRequest = imageView.tag == imageAsset.requestID;
            BOOL loadICloudImageFault = !result || info[PHImageErrorKey];
            if (!loadICloudImageFault && (isNewRequest || isCurrentRequest)) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.image = result;
                });
            }
            
            BOOL downloadSucceed = (result && !info) || (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
            
            if (downloadSucceed) {
                // 资源资源已经在本地或下载成功
                [imageAsset updateDownloadStatusWithDownloadResult:YES];
                self.downloadStatus = ZCAssetDownloadStatusSucceed;
                
            } else if ([info objectForKey:PHImageErrorKey] ) {
                // 下载错误
                [imageAsset updateDownloadStatusWithDownloadResult:NO];
                self.downloadStatus = ZCAssetDownloadStatusFailed;
            }
            
        } withProgressHandler:phProgressHandler];
        imageView.tag = imageAsset.requestID;
    }
}

@end

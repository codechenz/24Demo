//
//  ZCImagePickerCollectionViewCell.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/23.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCImagePickerCollectionViewCell.h"
#import "UIControl+ZCCate.h"
#import "CALayer+ZCCate.h"
#import "ZCImagePickerHelper.h"

// checkbox 的 margin 默认值
const UIEdgeInsets QMUIImagePickerCollectionViewCellDefaultCheckboxButtonMargins = {2, 0, 0, 2};
const UIEdgeInsets QMUIImagePickerCollectionViewCellDefaultVideoMarkImageViewMargins = {0, 8, 8, 0};


@interface ZCImagePickerCollectionViewCell ()

@property(nonatomic, strong, readwrite) UIButton *checkboxButton;

@end


@implementation ZCImagePickerCollectionViewCell

@synthesize videoMarkImageView = _videoMarkImageView;
@synthesize videoDurationLabel = _videoDurationLabel;
@synthesize videoBottomShadowLayer = _videoBottomShadowLayer;

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [ZCImagePickerCollectionViewCell appearance].checkboxImage = [UIImage imageNamed:@"QMUI_pickerImage_checkbox"];
        [ZCImagePickerCollectionViewCell appearance].checkboxCheckedImage =
        [UIImage imageNamed:@"QMUI_pickerImage_checkbox_checked"];
        [ZCImagePickerCollectionViewCell appearance].checkboxButtonMargins = QMUIImagePickerCollectionViewCellDefaultCheckboxButtonMargins;
        
        [ZCImagePickerCollectionViewCell appearance].downloadRetryImage = [UIImage imageNamed:@"QMUI_icloud_download_fault_small"];
        [ZCImagePickerCollectionViewCell appearance].videoMarkImage = [UIImage imageNamed:@"QMUI_pickerImage_video_mark"];
        [ZCImagePickerCollectionViewCell appearance].videoMarkImageViewMargins = QMUIImagePickerCollectionViewCellDefaultVideoMarkImageViewMargins;
        [ZCImagePickerCollectionViewCell appearance].videoDurationLabelFont = [UIFont systemFontOfSize:12];
        [ZCImagePickerCollectionViewCell appearance].videoDurationLabelTextColor = [UIColor whiteColor];
        [ZCImagePickerCollectionViewCell appearance].videoDurationLabelMargins = UIEdgeInsetsMake(0, 0, 6, 6);
    });
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initImagePickerCollectionViewCellUI];
        self.checkboxImage = [ZCImagePickerCollectionViewCell appearance].checkboxImage;
        self.checkboxCheckedImage = [ZCImagePickerCollectionViewCell appearance].checkboxCheckedImage;
        self.checkboxButtonMargins = [ZCImagePickerCollectionViewCell appearance].checkboxButtonMargins;
        self.progressViewTintColor = [ZCImagePickerCollectionViewCell appearance].progressViewTintColor;
        self.downloadRetryImage = [ZCImagePickerCollectionViewCell appearance].downloadRetryImage;
        self.videoMarkImage = [ZCImagePickerCollectionViewCell appearance].videoMarkImage;
        self.videoMarkImageViewMargins = [ZCImagePickerCollectionViewCell appearance].videoMarkImageViewMargins;
        self.videoDurationLabelFont = [ZCImagePickerCollectionViewCell appearance].videoDurationLabelFont;
        self.videoDurationLabelTextColor = [ZCImagePickerCollectionViewCell appearance].videoDurationLabelTextColor;
        self.videoDurationLabelMargins = [ZCImagePickerCollectionViewCell appearance].videoDurationLabelMargins;
    }
    return self;
}

- (void)initImagePickerCollectionViewCellUI {
    _contentImageView = [[UIImageView alloc] init];
    self.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.contentImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.contentImageView];
    
    self.checkboxButton = [[UIButton alloc] init];
    self.checkboxButton.zc_outsideEdge = UIEdgeInsetsMake(-6, -6, -6, -6);
    self.checkboxButton.hidden = YES;
    [self.contentView addSubview:self.checkboxButton];
    
    
    _downloadRetryButton = [[UIButton alloc] init];
    self.downloadRetryButton.zc_outsideEdge = UIEdgeInsetsMake(-6, -6, -6, -6);
    self.downloadRetryButton.hidden = YES;
    [self.contentView addSubview:self.downloadRetryButton];
}

- (void)initVideoBottomShadowLayerIfNeeded {
    if (!_videoBottomShadowLayer) {
        _videoBottomShadowLayer = [CAGradientLayer layer];
        [_videoBottomShadowLayer zc_removeDefaultAnimations];
        _videoBottomShadowLayer.colors = @[(id)[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0/1.0].CGColor, (id)[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:.6/1.0].CGColor];
        [self.contentView.layer addSublayer:_videoBottomShadowLayer];
        
        [self setNeedsLayout];
    }
}

- (void)initVideoMarkImageViewIfNeed {
    if (_videoMarkImageView) {
        return;
    }
    _videoMarkImageView = [[UIImageView alloc] init];
    [_videoMarkImageView setImage:self.videoMarkImage];
    [_videoMarkImageView sizeToFit];
    [self.contentView addSubview:_videoMarkImageView];
    
    [self setNeedsLayout];
}

- (void)initVideoDurationLabelIfNeed {
    if (_videoDurationLabel) {
        return;
    }
    _videoDurationLabel = [[UILabel alloc] init];
    _videoDurationLabel.font = self.videoDurationLabelFont;
    _videoDurationLabel.textColor = self.videoDurationLabelTextColor;
    [self.contentView addSubview:_videoDurationLabel];
    
    [self setNeedsLayout];
}

- (void)initVideoRelatedViewsIfNeeded {
    [self initVideoBottomShadowLayerIfNeeded];
    [self initVideoMarkImageViewIfNeed];
    [self initVideoDurationLabelIfNeed];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentImageView.frame = self.contentView.bounds;
    if (_editing) {
        self.checkboxButton.frame = CGRectFlatted(CGRectSetXY(self.checkboxButton.frame, CGRectGetWidth(self.contentView.bounds) - self.checkboxButtonMargins.right - CGRectGetWidth(self.checkboxButton.frame), self.checkboxButtonMargins.top));
    }
    
    /* 理论上 downloadRetryButton 应该在 setImage 后 sizeToFit 计算大小，
     * 但因为当图片小于某个高度时， UIButton sizeToFit 时会自动改写 height 值，
     * 因此，这里 downloadRetryButton 直接拿 downloadRetryButton 的 image 图片尺寸作为 frame size
     */
    self.downloadRetryButton.frame = CGRectFlatted(CGRectMake(CGRectGetWidth(self.contentView.bounds) - self.checkboxButtonMargins.right - _downloadRetryImage.size.width, self.checkboxButtonMargins.top, _downloadRetryImage.size.width, _downloadRetryImage.size.height));
    
    if (_videoBottomShadowLayer && _videoMarkImageView && _videoDurationLabel) {
        _videoMarkImageView.frame = CGRectFlatted(CGRectSetXY(_videoMarkImageView.frame, self.videoMarkImageViewMargins.left, CGRectGetHeight(self.contentView.bounds) - CGRectGetHeight(_videoMarkImageView.frame) - self.videoMarkImageViewMargins.bottom));
        
        [_videoDurationLabel sizeToFit];
        _videoDurationLabel.frame = ({
            CGFloat minX = CGRectGetWidth(self.contentView.bounds) - self.videoDurationLabelMargins.right - CGRectGetWidth(_videoDurationLabel.frame);
            CGFloat minY = CGRectGetHeight(self.contentView.bounds) - self.videoDurationLabelMargins.bottom - CGRectGetHeight(_videoDurationLabel.frame);
            CGRectFlatted(CGRectSetXY(_videoDurationLabel.frame, minX, minY));
        });
        
        CGFloat videoBottomShadowLayerHeight = CGRectGetHeight(self.contentView.bounds) - CGRectGetMinY(_videoMarkImageView.frame) + self.videoMarkImageViewMargins.bottom;// 背景阴影遮罩的高度取决于（视频 icon 的高度 + 上下 margin）
        _videoBottomShadowLayer.frame = CGRectMake(0, CGRectGetHeight(self.contentView.bounds) - videoBottomShadowLayerHeight, CGRectGetWidth(self.contentView.bounds), videoBottomShadowLayerHeight);
    }
}

- (void)setCheckboxImage:(UIImage *)checkboxImage {
    if (![self.checkboxImage isEqual:checkboxImage]) {
        [self.checkboxButton setImage:checkboxImage forState:UIControlStateNormal];
        [self.checkboxButton sizeToFit];
    }
    _checkboxImage = checkboxImage;
}

- (void)setCheckboxCheckedImage:(UIImage *)checkboxCheckedImage {
    if (![self.checkboxCheckedImage isEqual:checkboxCheckedImage]) {
        [self.checkboxButton setImage:checkboxCheckedImage forState:UIControlStateSelected];
        [self.checkboxButton setImage:checkboxCheckedImage forState:UIControlStateSelected|UIControlStateHighlighted];
        [self.checkboxButton sizeToFit];
    }
    _checkboxCheckedImage = checkboxCheckedImage;
}

- (void)setDownloadRetryImage:(UIImage *)downloadRetryImage {
    if (![self.downloadRetryImage isEqual:downloadRetryImage]) {
        [self.downloadRetryButton setImage:downloadRetryImage forState:UIControlStateNormal];
    }
    _downloadRetryImage = downloadRetryImage;
}



- (void)setVideoMarkImage:(UIImage *)videoMarkImage {
    if (![self.videoMarkImage isEqual:videoMarkImage]) {
        [_videoMarkImageView setImage:videoMarkImage];
        [_videoMarkImageView sizeToFit];
    }
    _videoMarkImage = videoMarkImage;
}

- (void)setVideoDurationLabelFont:(UIFont *)videoDurationLabelFont {
    if (![self.videoDurationLabelFont isEqual:videoDurationLabelFont]) {
        _videoDurationLabel.font = videoDurationLabelFont;
//        [_videoDurationLabel qmui_calculateHeightAfterSetAppearance];
    }
    _videoDurationLabelFont = videoDurationLabelFont;
}

- (void)setVideoDurationLabelTextColor:(UIColor *)videoDurationLabelTextColor {
    if (![self.videoDurationLabelTextColor isEqual:videoDurationLabelTextColor]) {
        _videoDurationLabel.textColor = videoDurationLabelTextColor;
    }
    _videoDurationLabelTextColor = videoDurationLabelTextColor;
}

- (void)setChecked:(BOOL)checked {
    _checked = checked;
    if (_editing) {
        self.checkboxButton.selected = checked;
        [ZCImagePickerHelper removeSpringAnimationOfImageCheckedWithCheckboxButton:self.checkboxButton];
        if (checked) {
            [ZCImagePickerHelper springAnimationOfImageCheckedWithCheckboxButton:self.checkboxButton];
        }
    }
}

- (void)setEditing:(BOOL)editing {
    _editing = editing;
    if (self.downloadStatus == ZCAssetDownloadStatusSucceed) {
        self.checkboxButton.hidden = !_editing;
    }
}

- (void)setDownloadStatus:(ZCAssetDownloadStatus)downloadStatus {
    _downloadStatus = downloadStatus;
    switch (downloadStatus) {
        case ZCAssetDownloadStatusSucceed:
            if (_editing) {
                self.checkboxButton.hidden = !_editing;
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

- (UILabel *)videoDurationLabel {
    [self initVideoRelatedViewsIfNeeded];
    return _videoDurationLabel;
}

- (UIImageView *)videoMarkImageView {
    [self initVideoRelatedViewsIfNeeded];
    return _videoMarkImageView;
}

- (CAGradientLayer *)videoBottomShadowLayer {
    [self initVideoRelatedViewsIfNeeded];
    return _videoBottomShadowLayer;
}

@end

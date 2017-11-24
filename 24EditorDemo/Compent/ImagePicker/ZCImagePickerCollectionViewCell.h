//
//  ZCImagePickerCollectionViewCell.h
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/23.
//  Copyright © 2017年 personal. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZCAsset.h"

#define UI_APPEARANCE_SELECTOR __attribute__((annotate("ui_appearance_selector")))

extern const UIEdgeInsets QMUIImagePickerCollectionViewCellDefaultCheckboxButtonMargins;

/**
 *  图片选择空间里的九宫格 cell，支持显示 checkbox、饼状进度条及重试按钮（iCloud 图片需要）
 */
@interface ZCImagePickerCollectionViewCell : UICollectionViewCell

/// checkbox 未被选中时显示的图片
@property(nonatomic, strong) UIImage *checkboxImage UI_APPEARANCE_SELECTOR;

/// checkbox 被选中时显示的图片
@property(nonatomic, strong) UIImage *checkboxCheckedImage UI_APPEARANCE_SELECTOR;

/// checkbox 的 margin，定位从每个 cell（即每张图片）的最右边开始计算
@property(nonatomic, assign) UIEdgeInsets checkboxButtonMargins UI_APPEARANCE_SELECTOR;

/// progressView tintColor
@property(nonatomic, strong) UIColor *progressViewTintColor UI_APPEARANCE_SELECTOR;

/// downloadRetryButton 的 icon
@property(nonatomic, strong) UIImage *downloadRetryImage UI_APPEARANCE_SELECTOR;

/// videoMarkImageView 的 icon
@property(nonatomic, strong) UIImage *videoMarkImage UI_APPEARANCE_SELECTOR;

/// videoMarkImageView 的 margin，定位从每个 cell（即每张图片）的左下角开始计算
@property(nonatomic, assign) UIEdgeInsets videoMarkImageViewMargins UI_APPEARANCE_SELECTOR;

/// videoDurationLabel 的字号
@property(nonatomic, strong) UIFont *videoDurationLabelFont UI_APPEARANCE_SELECTOR;

/// videoDurationLabel 的字体颜色
@property(nonatomic, strong) UIColor *videoDurationLabelTextColor UI_APPEARANCE_SELECTOR;

/// videoDurationLabel 布局是对齐右下角再做 margins 偏移
@property(nonatomic, assign) UIEdgeInsets videoDurationLabelMargins UI_APPEARANCE_SELECTOR;

@property(nonatomic, strong, readonly) UIImageView *contentImageView;
@property(nonatomic, strong, readonly) UIButton *checkboxButton;

@property(nonatomic, strong, readonly) UIButton *downloadRetryButton;
@property(nonatomic, strong, readonly) UIImageView *videoMarkImageView;
@property(nonatomic, strong, readonly) UILabel *videoDurationLabel;
@property(nonatomic, strong, readonly) CAGradientLayer *videoBottomShadowLayer;

@property(nonatomic, assign, getter=isEditing) BOOL editing;
@property(nonatomic, assign, getter=isChecked) BOOL checked;

@property(nonatomic, assign) ZCAssetDownloadStatus downloadStatus; // Cell 中对应资源的下载状态，这个值的变动会相应地调整 UI 表现


@end

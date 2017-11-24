//
//  ZCImagePickerHelper.h
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/23.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZCAsset.h"
#import "ZCAssetsGroup.h"

/**
 *  配合 ZCImagePickerViewController 使用的工具类
 */
@interface ZCImagePickerHelper : NSObject

/**
 *  判断一个由 ZCAsset 对象组成的数组中是否包含特定的 ZCAsset 对象
 *
 *  @param imageAssetArray  一个由 ZCAsset 对象组成的数组
 *  @param targetImageAsset 需要被判断的 ZCAsset 对象
 *
 */
+ (BOOL)imageAssetArray:(NSMutableArray *)imageAssetArray containsImageAsset:(ZCAsset *)targetImageAsset;

/**
 *  从一个由 ZCAsset 对象组成的数组中移除特定的 ZCAsset 对象（如果这个 ZCAsset 对象不在该数组中，则不作处理）
 *
 *  @param imageAssetArray  一个由 ZCAsset 对象组成的数组
 *  @param targetImageAsset 需要被移除的 ZCAsset 对象
 */
+ (void)imageAssetArray:(NSMutableArray *)imageAssetArray removeImageAsset:(ZCAsset *)targetImageAsset;

/**
 *  选中图片数量改变时，展示图片数量的 Label 的动画，动画过程如下：
 *  Label 背景色改为透明，同时产生一个与背景颜色和形状、大小都相同的图形置于 Label 底下，做先缩小再放大的 spring 动画
 *  动画结束后移除该图形，并恢复 Label 的背景色
 *
 *  @warning iOS6 下降级处理不调用动画效果
 *
 *  @param label 需要做动画的 UILabel
 */
+ (void)springAnimationOfImageSelectedCountChangeWithCountLabel:(UILabel *)label;

/**
 *  图片 checkBox 被选中时的动画
 *  @warning iOS6 下降级处理不调用动画效果
 *
 *  @param button 需要做动画的 checkbox 按钮
 */
+ (void)springAnimationOfImageCheckedWithCheckboxButton:(UIButton *)button;

/**
 * 搭配<i>springAnimationOfImageCheckedWithCheckboxButton:</i>一起使用，添加animation之前建议先remove
 */
+ (void)removeSpringAnimationOfImageCheckedWithCheckboxButton:(UIButton *)button;


/**
 *  获取最近一次调用 updateLastAlbumWithAssetsGroup 方法调用时储存的 ZCAssetsGroup 对象
 *
 *  @param userIdentify 用户标识，由于每个用户可能需要分开储存一个最近调用过的 ZCAssetsGroup，因此增加一个标识区分用户。
 *  一个常见的应用场景是选择图片时保存图片所在相册的对应的 ZCAssetsGroup，并使用用户的 user id 作为区分不同用户的标识，
 *  当用户再次选择图片时可以根据已经保存的 ZCAssetsGroup 直接进入上次使用过的相册。
 */
+ (ZCAssetsGroup *)assetsGroupOfLastestPickerAlbumWithUserIdentify:(NSString *)userIdentify;

/**
 *  储存一个 ZCAssetsGroup，从而储存一个对应的相册，与 assetsGroupOfLatestPickerAlbumWithUserIdentify 方法对应使用
 *
 *  @param assetsGroup   要被储存的 ZCAssetsGroup
 *  @param albumContentType 相册的内容类型
 *  @param userIdentify 用户标识，由于每个用户可能需要分开储存一个最近调用过的 ZCAssetsGroup，因此增加一个标识区分用户
 */
+ (void)updateLastestAlbumWithAssetsGroup:(ZCAssetsGroup *)assetsGroup ablumContentType:(ZCAlbumContentType)albumContentType userIdentify:(NSString *)userIdentify;

@end

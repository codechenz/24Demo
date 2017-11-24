//
//  ZCImagePickerHelper.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/23.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCImagePickerHelper.h"
#import "ZCAssetsManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PHCollection.h>
#import <Photos/PHFetchResult.h>


static NSString * const kLastAlbumKeyPrefix = @"ZCLastAlbumKeyWith";
static NSString * const kContentTypeOfLastAlbumKeyPrefix = @"ZCContentTypeOfLastAlbumKeyWith";

@implementation ZCImagePickerHelper

+ (BOOL)imageAssetArray:(NSMutableArray *)imageAssetArray containsImageAsset:(ZCAsset *)targetImageAsset {
    NSString *targetAssetIdentify = [targetImageAsset assetIdentity];
    for (NSUInteger i = 0; i < [imageAssetArray count]; i++) {
        ZCAsset *imageAsset = [imageAssetArray objectAtIndex:i];
        if ([[imageAsset assetIdentity] isEqual:targetAssetIdentify]) {
            return YES;
        }
    }
    return NO;
}

+ (void)imageAssetArray:(NSMutableArray *)imageAssetArray removeImageAsset:(ZCAsset *)targetImageAsset {
    NSString *targetAssetIdentify = [targetImageAsset assetIdentity];
    for (NSUInteger i = 0; i < [imageAssetArray count]; i++) {
        ZCAsset *imageAsset = [imageAssetArray objectAtIndex:i];
        if ([[imageAsset assetIdentity] isEqual:targetAssetIdentify]) {
            [imageAssetArray removeObject:imageAsset];
            break;
        }
    }
}
NSString *const ZCSpringAnimationKey = @"QMUISpringAnimationKey";

+ (void)springAnimationOfImageSelectedCountChangeWithCountLabel:(UILabel *)label {
    NSTimeInterval duration = 0.6;
    CAKeyframeAnimation *springAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    springAnimation.values = @[@.85, @1.15, @.9, @1.0,];
    springAnimation.keyTimes = @[@(0.0 / duration), @(0.15 / duration) , @(0.3 / duration), @(0.45 / duration),];
    springAnimation.duration = duration;
    [label.layer addAnimation:springAnimation forKey:ZCSpringAnimationKey];
}

+ (void)springAnimationOfImageCheckedWithCheckboxButton:(UIButton *)button {
    NSTimeInterval duration = 0.6;
    CAKeyframeAnimation *springAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    springAnimation.values = @[@.85, @1.15, @.9, @1.0,];
    springAnimation.keyTimes = @[@(0.0 / duration), @(0.15 / duration) , @(0.3 / duration), @(0.45 / duration),];
    springAnimation.duration = duration;
    [button.layer addAnimation:springAnimation forKey:ZCSpringAnimationKey];
}

+ (void)removeSpringAnimationOfImageCheckedWithCheckboxButton:(UIButton *)button {
    [button.layer removeAnimationForKey:ZCSpringAnimationKey];
}


+ (ZCAssetsGroup *)assetsGroupOfLastestPickerAlbumWithUserIdentify:(NSString *)userIdentify {
    // 获取 NSUserDefaults，里面储存了所有 updateLastestAlbumWithAssetsGroup 的结果
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 使用特定的前缀和可以标记不同用户的字符串拼接成 key，用于获取当前用户最近调用 updateLastestAlbumWithAssetsGroup 储存的相册以及对于的 ZCAlbumContentType 值
    NSString *lastAlbumKey = [NSString stringWithFormat:@"%@%@", kLastAlbumKeyPrefix, userIdentify];
    NSString *contentTypeOflastAlbumKey = [NSString stringWithFormat:@"%@%@", kContentTypeOfLastAlbumKeyPrefix, userIdentify];
    
    __block ZCAssetsGroup *assetsGroup;
    BOOL usePhotoKit = YES;
    
    ZCAlbumContentType albumContentType = (ZCAlbumContentType)[userDefaults integerForKey:contentTypeOflastAlbumKey];
    
    if (usePhotoKit) {
        NSString *groupIdentifier = [userDefaults valueForKey:lastAlbumKey];
        /**
         *  如果获取到的 PHAssetCollection localIdentifier 不为空，则获取该 URL 对应的相册。
         *  用户升级设备的系统后，这里会从原来的 AssetsLibrary 改为用 PhotoKit，
         *  因此原来储存的 groupIdentifier 实际上会是一个 NSURL 而不是我们需要的 NSString。
         *  所以这里还需要判断一下实际拿到的数据的类型是否为 NSString，如果是才继续进行。
         */
        if (groupIdentifier && [groupIdentifier isKindOfClass:[NSString class]]) {
            PHFetchResult *phFetchResult = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[groupIdentifier] options:nil];
            if (phFetchResult.count > 0) {
                // 创建一个 PHFetchOptions，用于对内容类型进行控制
                PHFetchOptions *phFetchOptions;
                // 旧版本中没有存储 albumContentType，因此为了防止 crash，这里做一下判断
                if (albumContentType) {
                    phFetchOptions = [PHPhotoLibrary createFetchOptionsWithAlbumContentType:albumContentType];
                }
                PHAssetCollection *phAssetCollection = [phFetchResult firstObject];
                assetsGroup = [[ZCAssetsGroup alloc] initWithPHCollection:phAssetCollection fetchAssetsOptions:phFetchOptions];
            }
        } else {
            NSLog(@"Group For localIdentifier is not found!");
        }
    } else {
        NSURL *groupUrl = [userDefaults URLForKey:lastAlbumKey];
        // 如果获取到的 ALAssetsGroup URL 不为空，则获取该 URL 对应的相册
        if (groupUrl) {
            [[[ZCAssetsManager sharedInstance] alAssetsLibrary] groupForURL:groupUrl resultBlock:^(ALAssetsGroup *group) {
                if (group) {
                    assetsGroup = [[ZCAssetsGroup alloc] initWithALAssetsGroup:group];
                    // 对内容类型进行控制
                    switch (albumContentType) {
                        case ZCAlbumContentTypeOnlyPhoto:
                            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                            break;
                            
                        case ZCAlbumContentTypeOnlyVideo:
                            [group setAssetsFilter:[ALAssetsFilter allVideos]];
                            break;
                            
                        default:
                            break;
                    }
                }
            } failureBlock:^(NSError *error) {
                NSLog(@"Group For URL is Error!");
            }];
        }
    }
    return assetsGroup;
}

+ (void)updateLastestAlbumWithAssetsGroup:(ZCAssetsGroup *)assetsGroup ablumContentType:(ZCAlbumContentType)albumContentType userIdentify:(NSString *)userIdentify {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 使用特定的前缀和可以标记不同用户的字符串拼接成 key，用于为当前用户储存相册对应的 ZCAssetsGroup 与 ZCAlbumContentType
    NSString *lastAlbumKey = [NSString stringWithFormat:@"%@%@", kLastAlbumKeyPrefix, userIdentify];
    NSString *contentTypeOflastAlbumKey = [NSString stringWithFormat:@"%@%@", kContentTypeOfLastAlbumKeyPrefix, userIdentify];
    if (assetsGroup.alAssetsGroup) {
        [userDefaults setURL:[assetsGroup.alAssetsGroup valueForProperty:ALAssetsGroupPropertyURL] forKey:lastAlbumKey];
    } else {
        // 使用 PhotoKit
        [userDefaults setValue:assetsGroup.phAssetCollection.localIdentifier forKey:lastAlbumKey];
    }
    
    [userDefaults setInteger:albumContentType forKey:contentTypeOflastAlbumKey];
    
    [userDefaults synchronize];
}

@end

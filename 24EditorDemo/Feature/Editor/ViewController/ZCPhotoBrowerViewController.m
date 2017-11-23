//
//  ZCPhotoBrowerViewController.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/23.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCPhotoBrowerViewController.h"
#import <Photos/Photos.h>

@interface ZCPhotoBrowerViewController ()

@end

@implementation ZCPhotoBrowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadPhotos];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadPhotos {
    // 所有智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    for (NSInteger i=0; i<smartAlbums.count; i++) {
        // 获取一个相册PHAssetCollection
        PHCollection *collection = smartAlbums[i];
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            // 从一个相册中获取的PHFetchResult中包含的才是PHAsset
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
            PHAsset *asset = nil;
            if (fetchResult.count != 0) {
                asset = fetchResult[i];
            }
            
            // 使用PHImageManager从PHAsset中请求图片
            PHImageManager *imageManager = [[PHImageManager alloc] init];
            [imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                if (result) {
                    NSLog(@"%@,%@", result,info);
                }
            }];
        } else {
            NSAssert1(NO, @"Fetch collection not PHCollection: %@", collection);
        }
    }
}


@end

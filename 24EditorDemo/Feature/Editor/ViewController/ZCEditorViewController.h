//
//  ZCEditorViewController.h
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/22.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCBaseViewController.h"
#import "ZCAssetsManager.h"
#import "ZCAssetsGroup.h"
#import "ZCImagePickerViewController.h"

@interface ZCEditorViewController : ZCBaseViewController <ZCImagePickerViewControllerDelegate>

@property(nonatomic, assign) ZCAlbumContentType contentType;

@end

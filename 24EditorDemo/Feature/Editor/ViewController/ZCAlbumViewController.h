//
//  ZCAlbumsViewController.h
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/25.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCBaseViewController.h"
#import "ZCAssetsGroup.h"

// 相册预览图的大小默认值
extern const CGFloat ZCAlbumViewControllerDefaultAlbumTableViewCellHeight;
// 相册名称的字号默认值
extern const CGFloat ZCAlbumTableViewCellDefaultAlbumNameFontSize;
// 相册资源数量的字号默认值
extern const CGFloat ZCAlbumTableViewCellDefaultAlbumAssetsNumberFontSize;
// 相册名称的 insets 默认值
extern const UIEdgeInsets ZCAlbumTableViewCellDefaultAlbumNameInsets;


@class ZCImagePickerViewController;
@class ZCAlbumViewController;

@protocol ZCAlbumViewControllerDelegate <NSObject>

@required
/// 点击相簿里某一行时，需要给一个 ZCImagePickerViewController 对象用于展示九宫格图片列表
- (ZCImagePickerViewController *)imagePickerViewControllerForAlbumViewController:(ZCAlbumViewController *)albumViewController;

@optional
/**
 *  取消查看相册列表后被调用
 */
- (void)albumViewControllerDidCancel:(ZCAlbumViewController *)albumViewController;

/**
 *  即将需要显示 Loading 时调用
 *
 *  @see shouldShowDefaultLoadingView
 */
- (void)albumViewControllerWillStartLoad:(ZCAlbumViewController *)albumViewController;

/**
 *  即将需要隐藏 Loading 时调用
 *
 *  @see shouldShowDefaultLoadingView
 */
- (void)albumViewControllerWillFinishLoad:(ZCAlbumViewController *)albumViewController;

- (void)albumViewControllerDidChangeAlbum:(ZCAssetsGroup *)assetsGroup;

@end


@interface ZCAlbumTableViewCell : UITableViewCell

@property(nonatomic, assign) CGFloat albumNameFontSize UI_APPEARANCE_SELECTOR; // 相册名称的字号
@property(nonatomic, assign) CGFloat albumAssetsNumberFontSize UI_APPEARANCE_SELECTOR; // 相册资源数量的字号
@property(nonatomic, assign) UIEdgeInsets albumNameInsets UI_APPEARANCE_SELECTOR; // 相册名称的 insets

@end

/**
 *  当前设备照片里的相簿列表，使用方式：
 *  1. 使用 init 初始化。
 *  2. 指定一个 albumViewControllerDelegate，并实现 @required 方法。
 *
 *  @warning 注意，iOS 访问相册需要得到授权，建议先询问用户授权，通过了再进行 ZCAlbumViewController 的初始化工作。关于授权的代码，可参考 ZC Demo 项目里的 [QDImagePickerExampleViewController authorizationPresentAlbumViewControllerWithTitle] 方法。
 *  @see [ZCAssetsManager requestAuthorization:]
 */
@interface ZCAlbumViewController : ZCBaseViewController <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, assign) CGFloat albumTableViewCellHeight UI_APPEARANCE_SELECTOR; // 相册列表 cell 的高度，同时也是相册预览图的宽高

@property(nonatomic, weak) id<ZCAlbumViewControllerDelegate> albumViewControllerDelegate;

@property(nonatomic, assign) ZCAlbumContentType contentType; // 相册展示内容的类型，可以控制只展示照片、视频或音频（仅 iOS 8.0 及以上版本支持）的其中一种，也可以同时展示所有类型的资源，默认展示所有类型的资源。

@property(nonatomic, copy) NSString *tipTextWhenNoPhotosAuthorization;
@property(nonatomic, copy) NSString *tipTextWhenPhotosEmpty;
/**
 *  加载相册列表时会出现 loading，若需要自定义 loading 的形式，可将该属性置为 NO，默认为 YES。
 *  @see albumViewControllerWillStartLoad: & albumViewControllerWillFinishLoad:
 */
@property(nonatomic, assign) BOOL shouldShowDefaultLoadingView;

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic,strong) NSMutableArray *albumsArray;

@end


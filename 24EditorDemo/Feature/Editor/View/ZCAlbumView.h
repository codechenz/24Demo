//
//  ZCAlbumView.h
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/26.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCAssetsGroup.h"

@protocol ZCAlbumViewDelegate <NSObject>

@optional

- (void)albumDidChange:(ZCAssetsGroup *)assetsGroup;
- (void)cancelChooseAlbum;

@end

@interface ZCAlbumViewTableViewCell : UITableViewCell

@property(nonatomic, assign) CGFloat albumNameFontSize UI_APPEARANCE_SELECTOR; // 相册名称的字号
@property(nonatomic, assign) CGFloat albumAssetsNumberFontSize UI_APPEARANCE_SELECTOR; // 相册资源数量的字号
@property(nonatomic, assign) UIEdgeInsets albumNameInsets UI_APPEARANCE_SELECTOR; // 相册名称的 insets

@end

@interface ZCAlbumView : UIView <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property(nonatomic, assign) CGFloat albumTableViewCellHeight UI_APPEARANCE_SELECTOR; // 相册列表 cell 的高度，同时也是相册预览图的宽高

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

@property(nonatomic, weak) id<ZCAlbumViewDelegate> albumViewDelegate;


@end

//
//  ZCEditorViewController.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/22.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCEditorViewController.h"
#import "YYText.h"
#import "ZCInputToolView.h"
#import "ZCImagePickerViewController.h"
#import "UIImage+ZCCate.h"
#import "NSAttributedString+Ashton.h"
#import "ZCDraftViewController.h"


@interface ZCEditorViewController () <YYTextViewDelegate, YYTextKeyboardObserver>
@property (nonatomic, strong) NSMutableAttributedString *contentString;

@property (nonatomic, strong) YYTextView *titleTextView;
@property (nonatomic, strong) YYTextView *contentTextView;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UIButton *saveButton;


@end

@implementation ZCEditorViewController {
    NSMutableArray *_albumsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Add News";
    _albumsArray = [[NSMutableArray alloc] init];
    [self setNavigationBar];
    [self initSubview];
    [[YYTextKeyboardManager defaultManager] addObserver:self];
}

// 实现点击方法

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}

- (void)setNavigationBar {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setImage:[UIImage imageWithIcon:kIFISave size:18 color:UIColorHex(#667587)] forState:UIControlStateDisabled];
    [btn setImage:[UIImage imageWithIcon:kIFISave size:18 color:UIColorHex(#0088cc)] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(handleSaveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)initSubview {
    
    YYTextView *titleTextView = [YYTextView new];
    titleTextView.frame = CGRectMake(0,  0, kScreenWidth, 44);
    titleTextView.tag = 1001;
    titleTextView.placeholderText = @"Title";
    titleTextView.font = [UIFont fontWithName:kFNRalewayRegular size:15];
    titleTextView.textColor = UIColorHex(#667587);
    titleTextView.placeholderTextColor = UIColorHex(#667587);
    titleTextView.placeholderFont = [UIFont fontWithName:kFNRalewayRegular size:15];
    
    titleTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    titleTextView.delegate = self;
    
    titleTextView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.view addSubview:titleTextView];
    self.titleTextView = titleTextView;
    
    ZCInputToolView *titleToolView = [[ZCInputToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44) HostView:titleTextView isShowTool:NO buttonTitle:@"Next"];
    
    titleTextView.inputAccessoryView = titleToolView;
    
    [titleToolView inputButtonOnClick:^(UIButton *sender) {
        [self.titleTextView resignFirstResponder];
        [self.contentTextView becomeFirstResponder
         ];
    }];
    
    UIView *separaView = [[UIView alloc] initWithFrame:CGRectMake(10, titleTextView.bottom, kScreenWidth - 20, 1)];
    separaView.backgroundColor = UIColorHex(#dfe6ee);
    [self.view addSubview:separaView];
    
    YYTextView *contentTextView = [YYTextView new];
    contentTextView.tag = 1002;
    
    contentTextView.font = [UIFont fontWithName:kFNRalewayRegular size:15];
    contentTextView.textColor = UIColorHex(#667587);
    contentTextView.placeholderText = @"content......";
    
    contentTextView.placeholderTextColor = UIColorHex(#667587);
    contentTextView.placeholderFont = [UIFont fontWithName:kFNRalewayRegular size:15];
    contentTextView.top = separaView.bottom;
    contentTextView.size = CGSizeMake(kScreenWidth, kScreenHeight - 109);
    contentTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    contentTextView.allowsPasteImage = YES;
    contentTextView.allowsPasteAttributedString = YES;
    contentTextView.delegate = self;
    
    if (kiOS7Later) {
        contentTextView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
        titleTextView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    } else {
        contentTextView.height -= 64;
        titleTextView.height -=64;
    }
    
    contentTextView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    contentTextView.scrollIndicatorInsets = contentTextView.contentInset;
    
    [self.view addSubview:contentTextView];
    self.contentTextView = contentTextView;
    
    ZCInputToolView *inputToolView = [[ZCInputToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44) HostView:_contentTextView isShowTool:YES buttonTitle:@"Send"];
    
    [inputToolView selectPhotoButtonClick:^(UIButton *sender) {
        [self handleImageButtonOnTouch:sender];
    }];
    
    [inputToolView inputButtonOnClick:^(UIButton *sender) {
        
    }];
    
    contentTextView.inputAccessoryView = inputToolView;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.titleTextView becomeFirstResponder];
    });
    
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.size = CGSizeMake(50, 15);
    promptLabel.right = self.view.right - 10;
    promptLabel.bottom = titleTextView.bottom - 5;
    promptLabel.font = [UIFont fontWithName:kFNRalewayRegular size:12];
    promptLabel.textColor = UIColorHex(#667587);
    promptLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview: promptLabel];
    self.promptLabel = promptLabel;
}

- (void)initContentStringIfNeed {
    if (!self.contentString) {
        self.contentString = [[NSMutableAttributedString alloc] init];
        self.contentString.yy_font = [UIFont fontWithName:kFNRalewayRegular size:15];
        self.contentString.yy_color = UIColorHex(#667587);
    }
}

#pragma mark - Custom Method

- (void)setDefaultAssetGroupToImagePickerViewController:(NSMutableArray *)ablumArray {
    if (ablumArray.count > 0) {
        ZCImagePickerViewController *imagePickerViewController = [[ZCImagePickerViewController alloc] init];
        imagePickerViewController.imagePickerViewControllerDelegate = self;
        [imagePickerViewController refreshWithAssetsGroup:ablumArray[0]];
        imagePickerViewController.title = [ablumArray[0] name];
        imagePickerViewController.albumsArray = ablumArray;
        [self.navigationController pushViewController:imagePickerViewController animated:YES];
    }else {
#warning - 当用户没有相册时，空表显示
    }
    
}

- (void)refreshEditorInputImage:(UIImage *)image {
    CGFloat imageWidth = self.contentTextView.width - 20;
    CGFloat imageHeight = imageWidth * image.size.height / image.size.width;
    UIFont *font = [UIFont fontWithName:kFNRalewayRegular size:15];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    NSMutableAttributedString *attachment = [NSMutableAttributedString yy_attachmentStringWithContent:imageView.layer contentMode:UIViewContentModeScaleAspectFill attachmentSize:CGSizeMake(imageWidth, imageHeight) alignToFont:font alignment:YYTextVerticalAlignmentCenter];
    
    [self initContentStringIfNeed];
    [self.contentString appendAttributedString:attachment];
    self.contentString.yy_font = [UIFont fontWithName:kFNRalewayRegular size:15];
    self.contentString.yy_color = UIColorHex(#667587);
    self.contentTextView.attributedText = self.contentString;
    self.contentTextView.selectedRange = NSMakeRange((self.contentString.length), 0);
}

#pragma mark - Event Handle

- (void)handleImageButtonOnTouch:(UIButton *)sender {
#warning - 检查权限详细提醒
    if (_albumsArray.count != 0) {
#warning - 缓存及检查是否有新照片
        [self setDefaultAssetGroupToImagePickerViewController:_albumsArray];
    }else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[ZCAssetsManager sharedInstance] enumerateAllAlbumsWithAlbumContentType:ZCAlbumContentTypeOnlyPhoto usingBlock:^(ZCAssetsGroup *resultAssetsGroup) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (resultAssetsGroup) {
                        [_albumsArray addObject:resultAssetsGroup];
                    } else {
                        [self setDefaultAssetGroupToImagePickerViewController:_albumsArray];
                    }
                });
            }];
        });
    }
}

- (void)handleSaveButtonClick:(UIButton *)sender {
    UIAlertController *saveAlertController = [UIAlertController alertControllerWithTitle:@"Save" message:@"test" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *htmlAction = [UIAlertAction actionWithTitle:@"log html" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *showString = [NSString stringWithFormat:@"{title:%@,content:%@}",[self.titleTextView.attributedText mn_HTMLRepresentationFromCoreTextAttributes],[self.contentTextView.attributedText mn_HTMLRepresentationFromCoreTextAttributes]];
        
        self.contentTextView.text = showString;
        self.contentTextView.selectedRange = NSMakeRange((self.contentTextView.text.length), 0);
        
    }];
    
    UIAlertAction *draftAction = [UIAlertAction actionWithTitle:@"open draft" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ZCDraftViewController *vc = [[ZCDraftViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [saveAlertController addAction:htmlAction];
    [saveAlertController addAction:draftAction];
    [self presentViewController:saveAlertController animated:YES completion:nil];
}

#pragma mark <YYTextViewDelegate>

- (void)textViewDidBeginEditing:(YYTextView *)textView {
    if (textView.tag == 1002) {
        self.promptLabel.hidden = YES;
    }else {
        self.promptLabel.hidden = NO;
    }
    
}

- (void)textViewDidEndEditing:(YYTextView *)textView {
    if (textView.tag == 1002) {
        [self initContentStringIfNeed];
        self.contentString = textView.attributedText.mutableCopy;
    }else {
        self.promptLabel.hidden = YES;
    }
}

- (void)textViewDidChange:(YYTextView *)textView {
    if (self.titleTextView.text.length > 0 || self.contentTextView.text.length > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    if (textView.tag == 1001) {
        self.promptLabel.text = [NSString stringWithFormat:@"%lu/20", textView.text.length];
        if (textView.text.length > 20) {
            textView.text = [textView.text substringToIndex:20];
        }
    }
}

#pragma mark - <ZCImagePickerViewControllerDelegate>

- (void)imagePickerViewController:(ZCImagePickerViewController *)imagePickerViewController didFinishPickingImageWithImagesAssetArray:(NSMutableArray<ZCAsset *> *)imagesAssetArray {
    for (ZCAsset *itemAsset in imagesAssetArray) {
        [self refreshEditorInputImage:itemAsset.originImage];
    }
}



@end

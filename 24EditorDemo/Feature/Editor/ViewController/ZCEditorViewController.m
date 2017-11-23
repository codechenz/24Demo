//
//  ZCEditorViewController.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/22.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCEditorViewController.h"
#import "YYText.h"
//#import "NSData+YYAdd.h"
//#import "NSBundle+YYAdd.h"
//#import "NSString+YYAdd.h"
//#import "UIControl+YYAdd.h"
//#import "UIGestureRecognizer+YYAdd.h"
//#import "CALayer+YYAdd.h"

#import "ZCInputToolView.h"
#import "ZCPhotoBrowerViewController.h"

@interface ZCEditorViewController () <YYTextViewDelegate, YYTextKeyboardObserver>

@property (nonatomic, strong) YYTextView *titleTextView;
@property (nonatomic, strong) YYTextView *contentTextView;

@end

@implementation ZCEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Add News";
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"It was the best of times, it was the worst of times, it was the age of wisdom, it was the age of foolishness, it was the season of light, it was the season of darkness, it was the spring of hope, it was the winter of despair, we had everything before us, we had nothing before us. We were all going direct to heaven, we were all going direct the other way.\n\n这是最好的时代，这是最坏的时代；这是智慧的时代，这是愚蠢的时代；这是信仰的时期，这是怀疑的时期；这是光明的季节，这是黑暗的季节；这是希望之春，这是失望之冬；人们面前有着各样事物，人们面前一无所有；人们正在直登天堂，人们正在直下地狱。"];
    
//    加入图片
//    UIImage *image = [UIImage imageNamed:@"InsertImage"];
//    UIFont *font = [UIFont systemFontOfSize:16];
//    NSMutableAttributedString *attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
//    [text appendAttributedString:attachment];
    
    text.yy_font = [UIFont fontWithName:@"Raleway-Regular" size:15];
    text.yy_color = UIColorHex(#667587);
    text.yy_lineSpacing = 4;
    
    YYTextView *titleTextView = [YYTextView new];
    titleTextView.frame = CGRectMake(0,  0, kScreenWidth, 44);
    titleTextView.tag = 1001;
//    titleTextView.attributedText = text;
    titleTextView.placeholderText = @"Title";
    titleTextView.font = [UIFont fontWithName:@"Raleway-Regular" size:15];
    titleTextView.placeholderTextColor = UIColorHex(#667587);
    titleTextView.placeholderFont = [UIFont fontWithName:@"Raleway-Regular" size:15];

//    titleTextView.size = CGSizeMake(kScreenWidth, 44);
    titleTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    titleTextView.delegate = self;
    
    titleTextView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.view addSubview:titleTextView];
    self.titleTextView = titleTextView;
    
    UIView *separaView = [[UIView alloc] initWithFrame:CGRectMake(10, titleTextView.bottom, kScreenWidth - 20, 1)];
    separaView.backgroundColor = UIColorHex(#dfe6ee);
    [self.view addSubview:separaView];
    
    NSString *contentPlaceholder = @"content......";
//    NSMutableAttributedString *contentPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"content..."];
//    contentPlaceholder.yy_font = [UIFont fontWithName:@"Raleway" size:30];
    
    
    YYTextView *contentTextView = [YYTextView new];
    contentTextView.tag = 1002;
    
//    contentTextView.attributedText = text;
    contentTextView.font = [UIFont fontWithName:@"Raleway-Regular" size:15];
    contentTextView.placeholderText = contentPlaceholder;
//    contentTextView.placeholderAttributedText = contentPlaceholder;
    contentTextView.placeholderTextColor = UIColorHex(#667587);
    contentTextView.placeholderFont = [UIFont fontWithName:@"Raleway-Regular" size:15];
    contentTextView.top = separaView.bottom;
    contentTextView.size = CGSizeMake(kScreenWidth, kScreenHeight - 109);
    contentTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    contentTextView.delegate = self;
    
//    ?
    if (kiOS7Later) {
        contentTextView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
        titleTextView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    } else {
        contentTextView.height -= 64;
        titleTextView.height -=64;
    }
    
    
    contentTextView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    contentTextView.scrollIndicatorInsets = contentTextView.contentInset;
    
//    ?
    contentTextView.selectedRange = NSMakeRange((text.length), 0);
    
    
    [self.view addSubview:contentTextView];
    self.contentTextView = contentTextView;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [contentTextView becomeFirstResponder];
    });
    
    ZCInputToolView *inputToolView = [[ZCInputToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44) HostView:_contentTextView];

    [inputToolView selectPhotoButtonOnTouch:^(UIButton *sender) {
        ZCPhotoBrowerViewController *vc = [[ZCPhotoBrowerViewController alloc] init];
        [self.navigationController pushViewController:vc animated:true];
    }];
    
    contentTextView.inputAccessoryView = inputToolView;
    
    
    
//    [[YYTextKeyboardManager defaultManager] addObserver:self];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
//    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}

//设置键盘响应状态
- (void)edit:(UIBarButtonItem *)item {
    if (_contentTextView.isFirstResponder) {
        [_contentTextView resignFirstResponder];
    } else {
        [_contentTextView becomeFirstResponder];
    }
}

#pragma mark text view

- (void)textViewDidBeginEditing:(YYTextView *)textView {
    if (textView.tag == 1002) {
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                    target:self
                                                                                    action:@selector(edit:)];
        self.navigationItem.rightBarButtonItem = buttonItem;
    }
    
}

- (void)textViewDidEndEditing:(YYTextView *)textView {
    if (textView.tag == 1002) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

@end

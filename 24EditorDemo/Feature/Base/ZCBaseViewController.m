//
//  ZCBaseViewController.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/22.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCBaseViewController.h"


@interface ZCBaseViewController ()

@end

@implementation ZCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavigationController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavigationController {
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.layer.shadowColor = UIColorHex(#3F4A56).CGColor;
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
    self.navigationController.navigationBar.layer.shadowOpacity = 0.3;

    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorHex(#3f4a56),NSFontAttributeName:[UIFont fontWithName:kFNMuliSemiBold size:16]}];
    
    if ([self.navigationController viewControllers].count > 1) {
        [self setCustomNavigationBackItem];
    }
}

- (void)setCustomNavigationBackItem {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setImage:[UIImage imageWithIcon:kIFIArrowLeft size:18 color:UIColorHex(#3F4A56)] forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UISegmentedControlSegmentLeft;
    [btn addTarget:self action:@selector(handleBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = -14.5;
    self.navigationItem.leftBarButtonItems = @[spacer, backBtn];
}

#pragma mark - Event Handle

- (void)handleBackButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

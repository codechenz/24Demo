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

    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorHex(#3f4a56),NSFontAttributeName:[UIFont fontWithName:@"Muli-SemiBold" size:16]}];
}

@end

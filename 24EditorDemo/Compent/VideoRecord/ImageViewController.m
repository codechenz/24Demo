//
//  ImageViewController.m
//  LLSimpleCameraExample
//
//  Created by Ömer Faruk Gül on 15/11/14.
//  Copyright (c) 2014 Ömer Faruk Gül. All rights reserved.
//

#import "ImageViewController.h"
#import "UIView+ZCCate.h"
#import "UIImage+ZCCate.h"

@interface ImageViewController ()
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *infoLabel;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *finshButton;
@end

@implementation ImageViewController

- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithNibName:nil bundle:nil];
    if(self) {
        _image = image;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.backgroundColor = [UIColor blackColor];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.image = self.image;
    [self.view addSubview:self.imageView];
    
    NSString *info = [NSString stringWithFormat:@"Size: %@  -  Orientation: %ld", NSStringFromCGSize(self.image.size), (long)self.image.imageOrientation];
    
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    self.infoLabel.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.7];
    self.infoLabel.textColor = [UIColor whiteColor];
    self.infoLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:13];
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    self.infoLabel.text = info;
//    [self.view addSubview:self.infoLabel];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_centerX).offset(-10);
        make.bottom.equalTo(self.view).offset(-20);
        make.size.equalTo(CGSizeMake(70, 70));
    }];
    [self.backButton setImage:[UIImage imageWithIcon:kIFIArrowLeft size:24 color:UIColorHex(#000000)] forState:UIControlStateNormal];
    self.backButton.clipsToBounds = YES;
    self.backButton.layer.masksToBounds = YES;
    self.backButton.layer.cornerRadius = 70 / 2.0f;
    self.backButton.layer.borderColor = UIColorHex(#ADA9A6).CGColor;
    self.backButton.layer.borderWidth = 2.0f;
    self.backButton.backgroundColor = UIColorHex(#ADA9A6);
    self.backButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.backButton.layer.shouldRasterize = YES;
    [self.backButton addTarget:self action:@selector(handleBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.finshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.finshButton];
    [self.finshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_centerX).offset(10);
        make.bottom.equalTo(self.view).offset(-20);
        make.size.equalTo(CGSizeMake(70, 70));
    }];
    [self.finshButton setImage:[UIImage imageWithIcon:kIFIFinsh size:24 color:UIColorHex(#83ce11)] forState:UIControlStateNormal];
    self.finshButton.clipsToBounds = YES;
    self.finshButton.layer.masksToBounds = YES;
    self.finshButton.layer.cornerRadius = 70 / 2.0f;
    self.finshButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.finshButton.layer.borderWidth = 2.0f;
    self.finshButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
    self.finshButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.finshButton.layer.shouldRasterize = YES;
    [self.finshButton addTarget:self action:@selector(handleFinishButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)handleBackButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)handleFinishButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    if ([self.delegate respondsToSelector:@selector(finishImagePicker)]) {
        [self.delegate finishImagePicker];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.imageView.frame = self.view.bounds;
    
    [self.infoLabel sizeToFit];
    self.infoLabel.width = self.view.width;
    self.infoLabel.top = 0;
    self.infoLabel.left = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

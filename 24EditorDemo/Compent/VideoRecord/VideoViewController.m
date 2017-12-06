//
//  TestVideoViewController.m
//  Memento
//
//  Created by Ömer Faruk Gül on 22/05/15.
//  Copyright (c) 2015 Ömer Faruk Gül. All rights reserved.
//

#import "VideoViewController.h"
#import "UIImage+ZCCate.h"
@import AVFoundation;

@interface VideoViewController ()
@property (strong, nonatomic) NSURL *videoUrl;
@property (strong, nonatomic) AVPlayer *avPlayer;
@property (strong, nonatomic) AVPlayerLayer *avPlayerLayer;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *finshButton;
@end

@implementation VideoViewController

- (instancetype)initWithVideoUrl:(NSURL *)url {
    self = [super init];
    if(self) {
        _videoUrl = url;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // the video player
    self.avPlayer = [AVPlayer playerWithURL:self.videoUrl];
    self.avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    self.avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    //self.avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.avPlayer currentItem]];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    self.avPlayerLayer.frame = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height);
    [self.view.layer addSublayer:self.avPlayerLayer];
    
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
    if ([self.delegate respondsToSelector:@selector(finishVideoPicker)]) {
        [self.delegate finishVideoPicker];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.avPlayer play];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

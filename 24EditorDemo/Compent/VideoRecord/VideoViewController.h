//
//  TestVideoViewController.h
//  Memento
//
//  Created by Ömer Faruk Gül on 22/05/15.
//  Copyright (c) 2015 Ömer Faruk Gül. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VideoViewControllerDelegate <NSObject>
@optional
- (void)finishVideoPicker;

@end

@interface VideoViewController : UIViewController
- (instancetype)initWithVideoUrl:(NSURL *)url;
@property (nonatomic, weak) id <VideoViewControllerDelegate> delegate;
@end

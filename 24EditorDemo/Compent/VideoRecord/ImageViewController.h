//
//  ImageViewController.h
//  LLSimpleCameraExample
//
//  Created by Ömer Faruk Gül on 15/11/14.
//  Copyright (c) 2014 Ömer Faruk Gül. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageViewControllerDelegate <NSObject>
@optional
- (void)finishImagePicker;

@end

@interface ImageViewController : UIViewController
@property (nonatomic, weak) id <ImageViewControllerDelegate> delegate;

- (instancetype)initWithImage:(UIImage *)image;
@end

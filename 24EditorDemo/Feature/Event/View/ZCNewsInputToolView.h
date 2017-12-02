//
//  ZCNewsInputToolView.h
//  24EditorDemo
//
//  Created by zhuchen on 2017/12/2.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddTypeButtonClickBlock)(UIButton *sender);
typedef void(^EditNewsTextButtonClickBlock)(UIButton *sender);

@interface ZCNewsInputToolView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, copy) AddTypeButtonClickBlock addTypeButtonClickBlock;
@property (nonatomic, copy) EditNewsTextButtonClickBlock editNewsTextButtonClickBlock;


- (instancetype)initWithFrame:(CGRect)frame;
- (void)addTypeButtonClick:(AddTypeButtonClickBlock)block;
- (void)editNewsTextButtonClick:(EditNewsTextButtonClickBlock)block;
@end

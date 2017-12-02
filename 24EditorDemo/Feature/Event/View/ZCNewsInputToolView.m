//
//  ZCNewsInputToolView.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/12/2.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCNewsInputToolView.h"
#import "UIImage+ZCCate.h"
#import "ZCInputTypeCollectionViewCell.h"

#define CollectionViewInsetHorizontal PreferredVarForDevices((PixelOne * 2), 1, 2, 2)
#define CollectionViewInset UIEdgeInsetsMake(CollectionViewInsetHorizontal, CollectionViewInsetHorizontal, CollectionViewInsetHorizontal, CollectionViewInsetHorizontal)
#define CollectionViewCellMargin CollectionViewInsetHorizontal

@interface ZCNewsInputToolView ()
@property (nonatomic, strong)NSArray *dataSource;
@end

@implementation ZCNewsInputToolView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = @[
  @{@"image":kIFIVote,@"title":@"Vote"},
  @{@"image":kIFIVideo,@"title":@"Video"},
  @{@"image":kIFIScore,@"title":@"Score"},
  @{@"image":kIFISave,@"title":@"Draft"},
  @{@"image":kIFICollaborator,@"title":@"Collaborator"},
  @{@"image":kIFIShare,@"title":@"Share"},
                            ];
        [self loadSubView];
    }
    return self;
}

- (void)loadSubView {
    self.backgroundColor = UIColorHex(#fafbfc);
    UIView *separaView = [UIView new];
    separaView.backgroundColor = UIColorHex(#dfe6ee);
    [self addSubview:separaView];
    [separaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.width.equalTo(self);
        make.height.equalTo(PixelOne);
    }];
    
    UIView *inputToolBar =[UIView new];
    [self addSubview:inputToolBar];
    
    [inputToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separaView.mas_bottom);
        make.left.and.width.equalTo(self);
        make.height.equalTo(45);
    }];
    
    UIButton *keyBoardButton = [UIButton new];
    keyBoardButton.backgroundColor = [UIColor whiteColor];
    [keyBoardButton setImage:[UIImage imageWithIcon:kIFIImage size:16 color:UIColorHex(#8091a5)] forState:UIControlStateNormal];
    keyBoardButton.layer.cornerRadius = 4;
    keyBoardButton.layer.masksToBounds = YES;
    keyBoardButton.layer.borderColor = UIColorHex(#dfe6ee).CGColor;
    keyBoardButton.layer.borderWidth = PixelOne;
    [keyBoardButton addTarget:self action:@selector(handleEditNewsTextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [inputToolBar addSubview:keyBoardButton];
    [keyBoardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(inputToolBar);
        make.left.equalTo(inputToolBar).offset(10);
        make.size.equalTo(CGSizeMake(33, 29));
    }];
    
    UIButton *addButton = [UIButton new];
    addButton.backgroundColor = [UIColor whiteColor];
    [addButton setImage:[UIImage imageWithIcon:kIFIAdd size:16 color:UIColorHex(#8091a5)] forState:UIControlStateNormal];
    addButton.layer.cornerRadius = 4;
    addButton.layer.masksToBounds = YES;
    addButton.layer.borderColor = UIColorHex(#dfe6ee).CGColor;
    addButton.layer.borderWidth = PixelOne;
    [addButton addTarget:self action:@selector(handleAddTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [inputToolBar addSubview:addButton];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(inputToolBar);
        make.right.equalTo(inputToolBar).offset(-10);
        make.size.equalTo(CGSizeMake(29, 29));
    }];
    
    UIButton *voiceButton = [UIButton new];
    voiceButton.backgroundColor = [UIColor whiteColor];
    [voiceButton setImage:[UIImage imageWithIcon:kIFIMike size:21 color:UIColorHex(#8091a5)] forState:UIControlStateNormal];
    [voiceButton setTitle:@"   Press and hold the talk" forState:UIControlStateNormal];
    voiceButton.titleLabel.font = [UIFont fontWithName:kFNRalewayMedium size:13];
    [voiceButton setTitleColor:UIColorHex(#8091a5) forState:UIControlStateNormal];
    voiceButton.layer.cornerRadius = 4;
    voiceButton.layer.masksToBounds = YES;
    voiceButton.layer.borderColor = UIColorHex(#dfe6ee).CGColor;
    voiceButton.layer.borderWidth = PixelOne;
    
    [inputToolBar addSubview:voiceButton];
    [voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(inputToolBar);
        make.left.equalTo(keyBoardButton.mas_right).offset(10);
        make.right.equalTo(addButton.mas_left).offset(-10);
        make.height.equalTo(29);
    }];
    
    UIView *separaViewB = [UIView new];
    separaViewB.backgroundColor = UIColorHex(#dfe6ee);
    [self addSubview:separaViewB];
    [separaViewB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(inputToolBar);
        make.top.equalTo(inputToolBar.mas_bottom);
        make.height.equalTo(PixelOne);
    }];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = CollectionViewInset;
    layout.minimumLineSpacing = CollectionViewCellMargin;
    layout.minimumInteritemSpacing = CollectionViewCellMargin;
#warning 改为横向滑动
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.delaysContentTouches = NO;
    
    collectionView.alwaysBounceHorizontal = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView registerClass:[ZCInputTypeCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([ZCInputTypeCollectionViewCell class])];
    
    [self addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separaViewB.mas_bottom);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self).offset(-25);
    }];
    
}

#pragma mark - Block

- (void)editNewsTextButtonClick:(EditNewsTextButtonClickBlock)block {
    self.editNewsTextButtonClickBlock = block;
}

- (void)addTypeButtonClick:(AddTypeButtonClickBlock)block {
    self.addTypeButtonClickBlock = block;
}

#pragma mark - Event Handle

- (void)handleEditNewsTextButtonClick:(UIButton *)sender {
    self.editNewsTextButtonClickBlock(sender);
}

- (void)handleAddTypeButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.addTypeButtonClickBlock(sender);
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(84, 84);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCInputTypeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZCInputTypeCollectionViewCell class]) forIndexPath:indexPath];
    if (!cell) {
        cell = [[ZCInputTypeCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, 84, 84)];
    }
    cell.dataSource = self.dataSource[indexPath.row];
    return cell;
}
@end

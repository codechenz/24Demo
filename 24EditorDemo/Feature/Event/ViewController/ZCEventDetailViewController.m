//
//  ZCEventDetailViewController.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/29.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCEventDetailViewController.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "ZCDraftTextTableViewCell.h"
#import "ZCNewsAudioTableViewCell.h"
#import "ZCNewsVoteTableViewCell.h"
#import "ZCEventCountView.h"
#import "ZCScoreView.h"
#import "ZCNewsModel.h"
#import "ZCAudioModel.h"
#import "ZCVoteModel.h"
#import <AVFoundation/AVFoundation.h>
#import "DOUAudioStreamer.h"
#import "DOUAudioVisualizer.h"
#import <DateTools.h>
#import "ZCNewsInputToolView.h"
#import "ZCEditorViewController.h"
#import <MJRefresh.h>
#import "NSAttributedString+Ashton.h"

static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;

@interface ZCEventDetailViewController () <UITableViewDelegate, UITableViewDataSource, ZCNewsAudioTableViewCellDelegate, ZCDraftTextTableViewCellDelegate, UIScrollViewDelegate> {
    @private
    DOUAudioStreamer *_streamer;
    DOUAudioVisualizer *_audioVisualizer;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong, readwrite) NSIndexPath *currentAudioIndex;
@property (nonatomic, strong) NSMutableArray *playedAudioIndexs;
@property (nonatomic, strong) ZCNewsInputToolView *toolView;

@end

@implementation ZCEventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.playedAudioIndexs = [[NSMutableArray alloc] init];
    self.title = @"Event Details";
    
   
    
    
    [self setNavigationBar];
    [self initTableView];
    
    self.dataSource = [[NSMutableArray alloc] init];
    [self getDataWithCache:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_streamer stop];
    [self cancelStreamer];
    [self cancelLastAudioPlay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)getDataWithCache:(BOOL)isFresh {
    [self.dataSource removeAllObjects];
    [ZCNetworking getWithUrl:@"/api/v1/c6befbb0d02311e78cd000163e30c008/comb" refreshCache:isFresh success:^(id response) {
        NSMutableArray *jsonArray = response[@"data"][@"list"];
        for (NSDictionary *dic in jsonArray) {
            NSNumber *type = dic[@"type"];
            if ([[dic allKeys] containsObject:@"type"]) {
                if (type.intValue == 0) {
                    ZCNewsModel *newsModel = [[ZCNewsModel alloc] initWithDictionary:dic];
                    [self.dataSource addObject:newsModel];
                }else {
                    ZCAudioModel *audioModel = [[ZCAudioModel alloc] initWithDictionary:dic];
                    [self.dataSource addObject:audioModel];
                }
            }else {
                ZCVoteModel *voteModel = [[ZCVoteModel alloc] initWithDictionary:dic];
                [self.dataSource addObject:voteModel];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        });
    } fail:^(NSError *error) {
        
    }];
}

- (void)setNavigationBar {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setImage:[UIImage imageWithIcon:kIFISite size:16 color:UIColorHex(#667587)] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(handleSiteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)initTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 45) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ZCDraftTextTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ZCDraftTextTableViewCell class])];
    [self.tableView registerClass:[ZCNewsAudioTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ZCNewsAudioTableViewCell class])];
    [self.tableView registerClass:[ZCNewsVoteTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ZCNewsVoteTableViewCell class])];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [self getDataWithCache:YES];
    }];
    
    [self.view addSubview:self.tableView];
    
    self.toolView = [[ZCNewsInputToolView alloc] initWithFrame:CGRectZero];
    
    [self.toolView editNewsTextButtonClick:^(UIButton *sender) {
        ZCEditorViewController *vc = [ZCEditorViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    self.toolView.layer.shadowColor = UIColorHex(#8091a56b).CGColor;
    self.toolView.layer.shadowOffset = CGSizeMake(0, 1);
    self.toolView.layer.shadowOpacity = 1;
    [self.view addSubview:self.toolView];

    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).offset(-45);
        make.left.equalTo(self.view);
        make.size.equalTo(CGSizeMake(kScreenWidth, 248));
    }];
    
    [self.toolView addTypeButtonClick:^(UIButton *sender) {
    if (sender.selected) {
#warning 适配X
        CGFloat height = kScreenHeight == 812 ? 812-20 : kScreenHeight;
        [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionTransitionNone animations:^{
            self.toolView.top = height - 248 - 64;
        } completion:nil];
    }else {
        [self hideToolView];
    }
    }];
}

#pragma mark - Custom Method

- (void)hideToolView {
    CGFloat height = kScreenHeight == 812 ? 812-20 : kScreenHeight;
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        self.toolView.top = height - 45 - 64;
    } completion:nil];
}

#pragma mark - Event Handle
- (void)handleSiteButtonClick:(UIButton *)sender {
    
}

- (void)presentAlertController {
    UIAlertController *saveAlertController = [UIAlertController alertControllerWithTitle:@"Artboard" message:@"Test Artboard Button On Click" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *htmlAction = [UIAlertAction actionWithTitle:@"do something" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *draftAction = [UIAlertAction actionWithTitle:@"do something" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [saveAlertController addAction:htmlAction];
    [saveAlertController addAction:draftAction];
    [self presentViewController:saveAlertController animated:YES completion:nil];
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self hideToolView];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id newsModel = self.dataSource[indexPath.row];
    if ([newsModel isKindOfClass:[ZCNewsModel class]]) {
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([ZCDraftTextTableViewCell class]) cacheByIndexPath:indexPath configuration:^(id cell) {
            [self configureTextCell:cell atIndexPath:indexPath];
        }];
    }else if ([newsModel isKindOfClass:[ZCAudioModel class]]) {
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([ZCNewsAudioTableViewCell class]) cacheByIndexPath:indexPath configuration:^(id cell) {
            [self configureAudioCell:cell atIndexPath:indexPath];
        }];
    }else {
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([ZCNewsVoteTableViewCell class]) cacheByIndexPath:indexPath configuration:^(id cell) {
            [self configureVoteCell:cell atIndexPath:indexPath];
        }];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 104;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id newsModel = self.dataSource[indexPath.row];
    if ([newsModel isKindOfClass:[ZCNewsModel class]]) {
        ZCDraftTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZCDraftTextTableViewCell class]) forIndexPath:indexPath];
        if (!cell) {
            cell = [[ZCDraftTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ZCDraftTextTableViewCell class])];
        }
        [self configureTextCell:cell atIndexPath:indexPath];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if ([newsModel isKindOfClass:[ZCAudioModel class]]) {
        ZCNewsAudioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZCNewsAudioTableViewCell class]) forIndexPath:indexPath];
        if (!cell) {
            cell = [[ZCNewsAudioTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ZCNewsAudioTableViewCell class])];
        }
        [self configureAudioCell:cell atIndexPath:indexPath];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        ZCNewsVoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZCNewsVoteTableViewCell class]) forIndexPath:indexPath];
        if (!cell) {
            cell = [[ZCNewsVoteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ZCNewsVoteTableViewCell class])];
        }
        [self configureVoteCell:cell atIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 104)];
    ZCEventCountView *header = [[ZCEventCountView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    [headerView addSubview:header];
    
    ZCScoreView *score = [[ZCScoreView alloc] initWithFrame:CGRectMake(0, header.height, kScreenWidth, 44)];
    [headerView addSubview:score];
    
    UIView *separaView = [[UIView alloc] initWithFrame:CGRectMake(0, header.height + score.height, kScreenWidth, PixelOne)];
    separaView.backgroundColor = UIColorHex(#dfe6ee);
    [headerView addSubview:separaView];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideToolView];
}

- (void)configureTextCell:(ZCDraftTextTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.newsModel = self.dataSource[indexPath.row];
}

- (void)configureAudioCell:(ZCNewsAudioTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.audioModel = self.dataSource[indexPath.row];
}

- (void)configureVoteCell:(ZCNewsVoteTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.voteModel = self.dataSource[indexPath.row];
}

#pragma mark - <ZCNewsAudioTableViewCellDelegate>

- (void)handleAudioPlayButtonClick:(UIButton *)sender cell:(ZCNewsAudioTableViewCell *)cell withAudioURL:(NSURL *)URL {
    self.currentAudioIndex = [self.tableView indexPathForCell:cell];
    [self resetStreamer];
    [self.playedAudioIndexs addObject:self.currentAudioIndex];
}

- (void)handleClapButtonClick:(ZCNewsAudioTableViewCell *)cell {
    ZCAudioModel *audioModel = cell.audioModel;
    if (audioModel.alert) {
        audioModel.alert = NO;
        if (audioModel.likes > 0) audioModel.likes--;
    }else {
        audioModel.alert = YES;
        audioModel.likes++;
    }
    [cell updateLikesWithAnimation];
}

- (void)audioCell:(ZCNewsAudioTableViewCell *)cell handleArtBoardButtonClick:(UIButton *)sender {
    [self presentAlertController];
}

#pragma mark - <ZCDraftTextTableViewCellDelegate>

- (void)draftTextHandleClapButtonClick:(ZCDraftTextTableViewCell *)cell {
    ZCNewsModel *newsModel = cell.newsModel;
    if (newsModel.alert) {
        newsModel.alert = NO;
        if (newsModel.likes > 0) newsModel.likes--;
    }else {
        newsModel.alert = YES;
        newsModel.likes++;
    }
    [cell updateLikesWithAnimation];
}

- (void)draftTextCell:(ZCDraftTextTableViewCell *)cell handleArtboardButtonClick:(UIButton *)sender {
    [self presentAlertController];
}

#pragma mark - 音频相关

- (void)cancelStreamer
{
    if (_streamer != nil) {
        [_streamer pause];
        [_streamer removeObserver:self forKeyPath:@"status"];
        [_streamer removeObserver:self forKeyPath:@"duration"];
        [_streamer removeObserver:self forKeyPath:@"bufferingRatio"];
        _streamer = nil;
    }
}

- (void)cancelLastAudioPlay {
    ZCNewsAudioTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.playedAudioIndexs.lastObject];
    ZCAudioModel *audioModel = cell.audioModel;
    audioModel.audioStreamerStatus = DOUAudioStreamerIdle;
    [cell updateAudioButtonStatus];
    
}

- (void)resetStreamer {
    [self cancelStreamer];
    [self cancelLastAudioPlay];
    if (0 == [self.dataSource count])
    {
#warning 无audio数据
    }
    else
    {
        ZCAudioModel *model = [self.dataSource objectAtIndex:self.currentAudioIndex.row];
        
        _streamer = [DOUAudioStreamer streamerWithAudioFile:model];
        [_streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
        [_streamer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
        [_streamer addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];
        
        [_streamer play];
        
        [self setupHintForStreamer];
    }
}

- (void)setupHintForStreamer
{
    NSUInteger nextIndex = self.currentAudioIndex.row + 1;
    
    if (nextIndex >= [self.dataSource count]) {
        nextIndex = 0;
    }
    
    if ([self.dataSource[nextIndex] isKindOfClass:[ZCAudioModel class]]) {
        [DOUAudioStreamer setHintWithAudioFile:[self.dataSource objectAtIndex:nextIndex]];
    }
}

- (void)updateStatus {
    ZCNewsAudioTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.currentAudioIndex];
    ZCAudioModel *audioModel = cell.audioModel;
    audioModel.audioStreamerStatus = [_streamer status];
    [cell updateAudioButtonStatus];
    switch ([_streamer status]) {
        case DOUAudioStreamerPlaying:
            DLog(@"Playing");
            break;
            
        case DOUAudioStreamerPaused:
            DLog(@"Paused");
            break;
            
        case DOUAudioStreamerIdle:
            DLog(@"Idle");
            break;
            
        case DOUAudioStreamerFinished:
            DLog(@"Finished");
//            [self autoPlayNextAudio];
            break;
            
        case DOUAudioStreamerBuffering:
            DLog(@"Buffering");
            break;
            
        case DOUAudioStreamerError:
            DLog(@"Error");
            break;
    }
}

- (void)updateAudioProgress{
    
    if ([_streamer duration] == 0.0) {

    }
    else {
        ZCNewsAudioTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.currentAudioIndex];
        ZCAudioModel *audioModel = cell.audioModel;
        float progress = [_streamer duration];
        audioModel.audioDuration = ceilf(progress);
        [cell updateAudioDurationLabel];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kStatusKVOKey) {
        [self performSelector:@selector(updateStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else if (context == kDurationKVOKey) {
        [self performSelector:@selector(updateAudioProgress)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else if (context == kBufferingRatioKVOKey) {
        //        [self performSelector:@selector(updateBufferingStatus)
        //                     onThread:[NSThread mainThread]
        //                   withObject:nil
        //                waitUntilDone:NO];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)actionPlayPause:(id)sender
{
    if ([_streamer status] == DOUAudioStreamerPaused ||
        [_streamer status] == DOUAudioStreamerIdle) {
        [_streamer play];
    }
    else {
        [_streamer pause];
    }
}

- (void)autoPlayNextAudio{
    NSInteger row = self.currentAudioIndex.row;
    if (++ row >= [self.dataSource count]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        self.currentAudioIndex = indexPath;
    }
    
    if ([self.dataSource[row] isKindOfClass:[ZCAudioModel class]]) {
        self.currentAudioIndex = [NSIndexPath indexPathForRow:row inSection:0];
        [self resetStreamer];
    }
}


@end

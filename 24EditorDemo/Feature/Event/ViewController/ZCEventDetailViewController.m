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
#import "ZCEventCountView.h"
#import "ZCScoreView.h"
#import "ZCNewsModel.h"
#import "ZCAudioModel.h"
#import <AVFoundation/AVFoundation.h>
#import "DOUAudioStreamer.h"
#import "DOUAudioVisualizer.h"
#import <DateTools.h>

static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;

@interface ZCEventDetailViewController () <UITableViewDelegate, UITableViewDataSource, ZCNewsAudioTableViewCellDelegate, ZCDraftTextTableViewCellDelegate> {
    @private
    DOUAudioStreamer *_streamer;
    DOUAudioVisualizer *_audioVisualizer;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSIndexPath *currentAudioIndex;

@end

@implementation ZCEventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Event Details";
    
    [self setNavigationBar];
    [self initTableView];
    
    self.dataSource = [[NSMutableArray alloc] init];
    [ZCNetworking getWithUrl:@"/api/v1/c6befbb0d02311e78cd000163e30c008/comb" refreshCache:YES success:^(id response) {
        NSMutableArray *jsonArray = response[@"data"][@"list"];
        for (NSDictionary *dic in jsonArray) {
            DLog(@"%@",dic[@"type"]);
            NSNumber *type = dic[@"type"];
            if (type.intValue == 0) {
                ZCNewsModel *newsModel = [[ZCNewsModel alloc] initWithDictionary:dic];
                [self.dataSource addObject:newsModel];
            }else if (type.intValue == 1) {
                ZCAudioModel *audioModel = [[ZCAudioModel alloc] initWithDictionary:dic];
                [self.dataSource addObject:audioModel];
            }
        }
        [self.dataSource removeObjectAtIndex:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } fail:^(NSError *error) {
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_streamer stop];
    [self _cancelStreamer];
}

- (void)_cancelStreamer
{
    if (_streamer != nil) {
        [_streamer pause];
        [_streamer removeObserver:self forKeyPath:@"status"];
        [_streamer removeObserver:self forKeyPath:@"duration"];
        [_streamer removeObserver:self forKeyPath:@"bufferingRatio"];
        _streamer = nil;
    }
}

- (void)resetStreamer {
    [self _cancelStreamer];
    
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
        
//        [self _updateBufferingStatus];
//        [self setupHintForStreamer];
    }
}

- (void)setupHintForStreamer
{
    NSUInteger nextIndex = self.currentAudioIndex.row + 1;
    if (nextIndex >= [self.dataSource count]) {
        nextIndex = 0;
    }
    
    [DOUAudioStreamer setHintWithAudioFile:[self.dataSource objectAtIndex:nextIndex]];
}

- (void)updateStatus
{
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
//            [self actionNext:nil];
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
    ZCNewsAudioTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.currentAudioIndex];
    
    
    if ([_streamer duration] == 0.0) {
//        [cell.audioYLProgressBar setProgress:0.0f animated:NO];
    }
    else {
//        = [NSString stringWithFormat:@"%f",[_streamer duration]];
        
        NSDate * date = [NSDate dateWithTimeIntervalSinceNow:[_streamer duration]];
        DLog(@"%@",date);
        NSString *dateString = [date formattedDateWithFormat:@"mm:ss"];
        cell.audioTime.text = dateString;
        
//        CGFloat progress = [_streamer currentTime] / [[_streamer duration];
//        [cell.audioYLProgressBar setProgress:progress animated:YES];
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

- (void)actionNext:(id)sender
{
//    if (++ self.currentAudioIndex.row >= [self.dataSource count]) {
//        self.currentAudioIndex.row = 0;
//    }
    
    [self resetStreamer];
}

- (void)actionSliderProgress:(id)sender
{
//    [_streamer setCurrentTime:[_streamer duration] * [_progressSlider value]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
//    if (timeObserve) {
//        self.player removeTimeObserver:<#(nonnull id)#>
//    }
}

- (void)setNavigationBar {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setImage:[UIImage imageWithIcon:kIFISite size:16 color:UIColorHex(#667587)] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(handleSiteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)initTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.height = kScreenHeight - 64;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ZCDraftTextTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ZCDraftTextTableViewCell class])];
    [self.tableView registerClass:[ZCNewsAudioTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ZCNewsAudioTableViewCell class])];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - Event Handle
- (void)handleSiteButtonClick:(UIButton *)sender {

}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCNewsModel *newsModel = self.dataSource[indexPath.row];
    if (newsModel.type == 0) {
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([ZCDraftTextTableViewCell class]) cacheByIndexPath:indexPath configuration:^(id cell) {
            [self configureTextCell:cell atIndexPath:indexPath];
        }];
    }else {
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([ZCNewsAudioTableViewCell class]) cacheByIndexPath:indexPath configuration:^(id cell) {
            [self configureAudioCell:cell atIndexPath:indexPath];
        }];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 104;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCNewsModel *newsModel = self.dataSource[indexPath.row];
    if (newsModel.type == 0) {
        ZCDraftTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZCDraftTextTableViewCell class]) forIndexPath:indexPath];
        if (!cell) {
            cell = [[ZCDraftTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ZCDraftTextTableViewCell class])];
        }else{
//            while ([cell.contentView.subviews lastObject] != nil) {
//                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
//            }
        }
        [self configureTextCell:cell atIndexPath:indexPath];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        ZCNewsAudioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZCNewsAudioTableViewCell class]) forIndexPath:indexPath];
        if (!cell) {
            cell = [[ZCNewsAudioTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ZCNewsAudioTableViewCell class])];
        }else{
//            while ([cell.contentView.subviews lastObject] != nil) {
//                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
//            }
        }
        [self configureAudioCell:cell atIndexPath:indexPath];
        cell.delegate = self;
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
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configureTextCell:(ZCDraftTextTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.newsModel = self.dataSource[indexPath.row];
}

- (void)configureAudioCell:(ZCNewsAudioTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.audioModel = self.dataSource[indexPath.row];
}

#pragma mark - <ZCNewsAudioTableViewCellDelegate>

- (void)handleAudioPlayButtonClick:(UIButton *)sender cell:(ZCNewsAudioTableViewCell *)cell withAudioURL:(NSURL *)URL {
    self.currentAudioIndex = [self.tableView indexPathForCell:cell];
    [self resetStreamer];
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

@end

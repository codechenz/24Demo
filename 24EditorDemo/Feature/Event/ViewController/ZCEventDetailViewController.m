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
#import "ZCEmptyViewController.h"
#import "ZCDraftViewController.h"

#import "BBVoiceRecordController.h"
#import "UIColor+BBVoiceRecord.h"
#import "BBHoldToSpeakButton.h"

#define kFakeTimerDuration       0.2
#define kMaxRecordDuration       60     //最长录音时长
#define kRemainCountingDuration  10     //剩余多少秒开始倒计时

#define kRecordAudioFile @"myRecord.caf"

static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;

@interface ZCEventDetailViewController () <UITableViewDelegate, UITableViewDataSource, ZCNewsAudioTableViewCellDelegate, ZCDraftTextTableViewCellDelegate, UIScrollViewDelegate, ZCNewsInputToolViewDelegate, AVAudioRecorderDelegate> {
    @private
    DOUAudioStreamer *_streamer;
    DOUAudioVisualizer *_audioVisualizer;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong, readwrite) NSIndexPath *currentAudioIndex;
@property (nonatomic, strong) NSMutableArray *playedAudioIndexs;
@property (nonatomic, strong) ZCNewsInputToolView *toolView;


@property (nonatomic, strong) BBVoiceRecordController *voiceRecordCtrl;
@property (nonatomic, assign) BBVoiceRecordState currentRecordState;
//@property (nonatomic, strong) BBHoldToSpeakButton *btnRecord;
@property (nonatomic, strong) NSTimer *fakeTimer;
@property (nonatomic, assign) float duration;
@property (nonatomic, assign) BOOL canceled;

@property (nonatomic,strong) AVAudioRecorder *audioRecorder;
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;//音频播放器，暂用于播放本地录音文件

@end

@implementation ZCEventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.playedAudioIndexs = [[NSMutableArray alloc] init];
    self.title = @"Event Details";
    [self setNavigationBar];
    [self initTableView];
    [self setAudioSession];
    
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

-(void)setAudioSession{
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryMultiRoute error:nil];
    [audioSession setActive:YES error:nil];
}

/** * 取得录音文件保存路径 * * @return 录音文件路径 */
-(NSURL *)getSavePath{
    NSString *urlStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr=[urlStr stringByAppendingPathComponent:kRecordAudioFile];
    DLog(@"file path:%@",urlStr);
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    return url;
}

-(NSDictionary *)getAudioSetting{
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
   [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey]; //设置录音格式
   [dicM setObject:@(8000) forKey:AVSampleRateKey]; //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];//设置通道,这里采用单声道
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];//每个采样点位数,分为8、16、24、32
   [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey]; //是否使用浮点数采样
    
    return dicM;
}

- (AVAudioRecorder *)audioRecorder {
    if (!_audioRecorder) {
             NSURL *url=[self getSavePath];//创建录音文件保存路径
            NSDictionary *setting=[self getAudioSetting];//创建录音格式设置
           NSError *error=nil; //创建录音机
            _audioRecorder=[[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
            _audioRecorder.delegate=self;
            _audioRecorder.meteringEnabled=YES;
            if (error) {
            DLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return nil;
            }
    }
    return _audioRecorder;
}

-(AVAudioPlayer *)audioPlayer{
    if (!_audioPlayer) {
        NSURL *url=[self getSavePath];
        NSError *error=nil;
        _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        _audioPlayer.numberOfLoops=0;
        [_audioPlayer prepareToPlay];
        if (error) {
            DLog(@"创建播放器过程中发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioPlayer;
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
    self.toolView.delegate = self;
    
    self.toolView.layer.shadowColor = UIColorHex(#8091a56b).CGColor;
    self.toolView.layer.shadowOffset = CGSizeMake(0, 1);
    self.toolView.layer.shadowOpacity = 1;
    [self.view addSubview:self.toolView];

    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).offset(-45);
        make.left.equalTo(self.view);
        make.size.equalTo(CGSizeMake(kScreenWidth, 248));
    }];
    
    [self.toolView editNewsTextButtonClick:^(UIButton *sender) {
        ZCEditorViewController *vc = [ZCEditorViewController new];
        [self.navigationController pushViewController:vc animated:YES];
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
    
    [self.toolView voiceRecordButtonClick:^(UIButton *sender) {
        
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
    if (![self.audioPlayer isPlaying]) {
        DLog(@"播放");
        [self.audioPlayer play];
    }
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

#pragma mark - <AVAudioRecorderDelegate>
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    NSString *str = [NSString stringWithFormat:@"录音完成、未做上传处理，存入本地路径为:%@;\n为演示录音效果，点击右上角设置按钮，播放录音。",[self getSavePath]];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Voice Record Success" message:str delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alertView show];
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

#pragma mark - <ZCNewsInputToolViewDelegate>

- (void)collectionCellDidSelected:(ZCInputTypeCollectionViewCell *)cell {
    NSString *type = cell.dataSource[@"title"];
    if ([type isEqualToString:@"Video"]) {
        DLog(@"oyeah");
    }else {
        ZCDraftViewController *vc = [[ZCDraftViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
        case DOUAudioStreamerFinished:
            DLog(@"Finished");
            [self performSelector:@selector(autoPlayNextAudio) withObject:nil afterDelay:0.5];
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

#pragma mark - Voice Record


- (void)startFakeTimer {
    if (_fakeTimer) {
        [_fakeTimer setFireDate:[NSDate distantFuture]];
        _fakeTimer = nil;
    }
    self.fakeTimer = [NSTimer scheduledTimerWithTimeInterval:kFakeTimerDuration target:self selector:@selector(onFakeTimerTimeOut) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.fakeTimer forMode:NSRunLoopCommonModes];
    [_fakeTimer setFireDate:[NSDate distantPast]];
    
}

- (void)stopFakeTimer {
    if (_fakeTimer) {
        [_fakeTimer setFireDate:[NSDate distantFuture]];
        _fakeTimer = nil;
    }
}

- (void)onFakeTimerTimeOut {
    self.duration += kFakeTimerDuration;
    DLog(@"+++duration+++ %f",self.duration);
    float remainTime = kMaxRecordDuration-self.duration;
    if ((int)remainTime == 0) {
        self.currentRecordState = BBVoiceRecordState_Normal;
        [self dispatchVoiceState];
    }
    else if ([self shouldShowCounting]) {
        self.currentRecordState = BBVoiceRecordState_RecordCounting;
        [self dispatchVoiceState];
        [self.voiceRecordCtrl showRecordCounting:remainTime];
    }
    else {
        [self.audioRecorder updateMeters];
        float power = [self.audioRecorder averagePowerForChannel:0];
        float progress = (1.0/160.0)*(power+160.0);
        NSLog(@"音量大小:%f",progress);
        [self.voiceRecordCtrl updatePower:progress];
        
    }
}

- (BOOL)shouldShowCounting
{
    if (self.duration >= (kMaxRecordDuration-kRemainCountingDuration) && self.duration < kMaxRecordDuration && self.currentRecordState != BBVoiceRecordState_ReleaseToCancel) {
        return YES;
    }
    return NO;
}

- (void)resetState
{
    [self stopFakeTimer];
    self.duration = 0;
    self.canceled = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    if (CGRectContainsPoint(CGRectMake(self.toolView.voiceButton.left, self.toolView.top + self.toolView.voiceButton.top, self.toolView.voiceButton.width, self.toolView.voiceButton.height), touchPoint)) {
        self.currentRecordState = BBVoiceRecordState_Recording;
        
        if (![self.audioRecorder isRecording]) {
            [self.audioRecorder record];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
        }
        
        [self dispatchVoiceState];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_canceled) {
        return;
    }
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    if (CGRectContainsPoint(CGRectMake(self.toolView.voiceButton.left, self.toolView.top + self.toolView.voiceButton.top, self.toolView.voiceButton.width, self.toolView.voiceButton.height), touchPoint)) {
        self.currentRecordState = BBVoiceRecordState_Recording;
    }
    else
    {
        self.currentRecordState = BBVoiceRecordState_ReleaseToCancel;
    }
    [self dispatchVoiceState];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_canceled) {
        return;
    }
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    if (CGRectContainsPoint(CGRectMake(self.toolView.voiceButton.left, self.toolView.top + self.toolView.voiceButton.top, self.toolView.voiceButton.width, self.toolView.voiceButton.height), touchPoint)) {
        if (self.duration < 1) {
            [self.voiceRecordCtrl showToast:@"Message Too Short."];
        }
        else
        {
            //upload voice
            [self.audioRecorder stop];
        }
    }
    self.currentRecordState = BBVoiceRecordState_Normal;
    [self dispatchVoiceState];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_canceled) {
        return;
    }
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    if (CGRectContainsPoint(CGRectMake(self.toolView.voiceButton.left, self.toolView.top + self.toolView.voiceButton.top, self.toolView.voiceButton.width, self.toolView.voiceButton.height), touchPoint)) {
        if (self.duration < 1) {
            [self.voiceRecordCtrl showToast:@"Message Too Short."];
        }
        else
        {
            [self.audioRecorder stop];
        }
    }
    self.currentRecordState = BBVoiceRecordState_Normal;
    [self dispatchVoiceState];
}

- (void)dispatchVoiceState
{
    if (_currentRecordState == BBVoiceRecordState_Recording) {
        self.canceled = NO;
        [self startFakeTimer];
    }
    else if (_currentRecordState == BBVoiceRecordState_Normal)
    {
        [self resetState];
    }
//    [_btnRecord updateRecordButtonStyle:_currentRecordState];
    [self.voiceRecordCtrl updateUIWithRecordState:_currentRecordState];
}

- (BBVoiceRecordController *)voiceRecordCtrl
{
    if (_voiceRecordCtrl == nil) {
        _voiceRecordCtrl = [BBVoiceRecordController new];
    }
    return _voiceRecordCtrl;
}

@end

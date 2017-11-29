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
#import "ZCModel.h"
#import "ZCEventCountView.h"
#import "ZCScoreView.h"

@interface ZCEventDetailViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation ZCEventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Event Details";
    
    NSDictionary *dic = @{
                          @"title":@"Joseph Simmons",
                          @"time":@"· 3 hours ago",
                          @"content":@"Etiam blandit nisi feugiat eros mollis, sed vehicula massatempus.Etiam blandit nisi feugiat eros mollis, sed vehicula massatempus.",
                          };
    ZCModel *model = [[ZCModel alloc] initWithDictionary:dic];
    self.dataSource = [[NSMutableArray alloc] init];
    [self.dataSource addObject:model];
    [self.dataSource addObject:model];
    [self.dataSource addObject:model];
    [self.dataSource addObject:model];
    [self.dataSource addObject:model];
    [self.dataSource addObject:model];
    
    [self setNavigationBar];
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setNavigationBar {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setImage:[UIImage imageWithIcon:kIFISite size:16 color:UIColorHex(#667587)] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(handleSaveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)initTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.height = kScreenHeight - 64;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[ZCDraftTextTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ZCDraftTextTableViewCell class])];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([ZCDraftTextTableViewCell class]) cacheByIndexPath:indexPath configuration:^(id cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 104;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCDraftTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZCDraftTextTableViewCell class]) forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configureCell:(ZCDraftTextTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.model = self.dataSource[indexPath.row];
}

@end

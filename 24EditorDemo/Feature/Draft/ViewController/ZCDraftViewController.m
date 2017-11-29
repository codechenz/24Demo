//
//  ZCDraftViewController.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/27.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCDraftViewController.h"
#import "ZCDraftTextTableViewCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "ZCModel.h"

@class ZCEditorViewController;

@interface ZCDraftViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *draftArray;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation ZCDraftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Draft";
    NSDictionary *dic = @{
                          @"title":@"Joseph Simmons",
                          @"time":@"· 3 hours ago",
                          @"content":@"Etiam blandit nisi feugiat eros mollis, sed vehicula massatempus.",
                          };
    ZCModel *model = [[ZCModel alloc] initWithDictionary:dic];
    self.dataSource = [[NSMutableArray alloc] init];
    [self.dataSource addObject:model];
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCDraftTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZCDraftTextTableViewCell class]) forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configureCell:(ZCDraftTextTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.model = self.dataSource[indexPath.row];
}

@end

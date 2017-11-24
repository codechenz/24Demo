//
//  UICollectionView+ZCCate.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/11/23.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "UICollectionView+ZCCate.h"

@implementation UICollectionView (ZCCate)

- (void)zc_clearsSelection {
    NSArray *selectedItemIndexPaths = [self indexPathsForSelectedItems];
    for (NSIndexPath *indexPath in selectedItemIndexPaths) {
        [self deselectItemAtIndexPath:indexPath animated:YES];
    }
}

- (void)zc_reloadDataKeepingSelection {
    NSArray *selectedIndexPaths = [self indexPathsForSelectedItems];
    [self reloadData];
    for (NSIndexPath *indexPath in selectedIndexPaths) {
        [self selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}

/// 递归找到view在哪个cell里，不存在则返回nil
- (UICollectionViewCell *)parentCellForView:(UIView *)view {
    if (!view.superview) {
        return nil;
    }
    
    if ([view.superview isKindOfClass:[UICollectionViewCell class]]) {
        return (UICollectionViewCell *)view.superview;
    }
    
    return [self parentCellForView:view.superview];
}

- (NSIndexPath *)zc_indexPathForItemAtView:(id)sender {
    if (sender && [sender isKindOfClass:[UIView class]]) {
        UIView *view = (UIView *)sender;
        UICollectionViewCell *parentCell = [self parentCellForView:view];
        if (parentCell) {
            return [self indexPathForCell:parentCell];
        }
    }
    
    return nil;
}

- (BOOL)zc_itemVisibleAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *visibleItemIndexPaths = self.indexPathsForVisibleItems;
    for (NSIndexPath *visibleIndexPath in visibleItemIndexPaths) {
        if ([indexPath isEqual:visibleIndexPath]) {
            return YES;
        }
    }
    return NO;
}

- (NSIndexPath *)zc_indexPathForFirstVisibleCell {
    NSArray *visibleIndexPaths = [self indexPathsForVisibleItems];
    if (!visibleIndexPaths || visibleIndexPaths.count <= 0) {
        return nil;
    }
    NSIndexPath *minimumIndexPath = nil;
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        if (!minimumIndexPath) {
            minimumIndexPath = indexPath;
            continue;
        }
        
        if (indexPath.section < minimumIndexPath.section) {
            minimumIndexPath = indexPath;
            continue;
        }
        
        if (indexPath.item < minimumIndexPath.item) {
            minimumIndexPath = indexPath;
            continue;
        }
    }
    return minimumIndexPath;
}

@end

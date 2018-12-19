//
//  RemoteTableViewController.m
//  Component
//
//  Created by Ansel on 16/3/10.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import "RefreshTableViewController.h"
#import "UIView+Coordinate.h"
#import "Masonry.h"

@interface RefreshTableViewController ()

@property(nonatomic, strong) TableViewComponent *tableViewComponent;

@property (nonatomic, assign) CGSize viewOldSize;

@end

@implementation RefreshTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildTableViewComponent];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!CGSizeEqualToSize(self.view.bounds.size, CGSizeZero) && !CGSizeEqualToSize(self.view.bounds.size, self.viewOldSize)) {
        self.viewOldSize = self.view.bounds.size;
        [self configRefreshAndLoadMore];
    }
}

- (void)updateSectionItems:(NSArray<TableViewSectionItem *> *)sectionItems {
    [self.tableViewComponent updateSectionItems:sectionItems];
}

- (void)reloadData {
    [self.tableViewComponent.tableView reloadData];
}

- (void)startRefreshing {
    [self.tableViewComponent.tableView.refreshView startRefreshing];
}

- (void)stopRefreshing {
    [self.tableViewComponent.tableView.refreshView stopRefreshing];
}

- (void)stopLoading {
    [self.tableViewComponent.tableView.loadMoreView stopLoading];
}

- (void)setHasMore:(BOOL)hasMore {
    [self.tableViewComponent.tableView.loadMoreView setHasMore:hasMore];
}

-(void)doRefresh {
    
}

- (void)loadMore {
    
}

- (void)mapItemClassToViewClassWithTableViewComponent:(TableViewComponent *)tableViewComponent {
    
}

- (void)tableViewComponent:(__kindof TableViewComponent *)tableViewComponent willDisplayCell:(__kindof UITableViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)tableViewComponent:(__kindof TableViewComponent *)tableViewComponent didEndDisplayingCell:(__kindof UITableViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
   
}

#pragma mark - PrivateUI

- (void)buildUI {
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self buildTableViewComponent];
}

- (void)buildTableViewComponent {
    __weak typeof(self) weakSelf = self;
    self.tableViewComponent = [[TableViewComponent alloc] initWithSectionItems:nil mapItemClassToViewClassBlock:^(TableViewComponent *tableViewComponent) {
        [weakSelf mapItemClassToViewClassWithTableViewComponent:tableViewComponent];
    } delegateBlock:^(__kindof TableViewComponent * _Nonnull tableViewComponent) {
        tableViewComponent.cellDelegate = weakSelf;
        tableViewComponent.headerOrFooterViewDelegate = weakSelf;
    }];
    [self.tableViewComponent setWillDisplayIndexPathBlock:^(__kindof TableViewComponent *tableViewComponent, __kindof UITableViewCell *cell, NSIndexPath *indexPath) {
        [weakSelf tableViewComponent:tableViewComponent willDisplayCell:cell forItemAtIndexPath:indexPath];
    }];
    [self.tableViewComponent setDidEndDisplayingIndexPathBlock:^(__kindof TableViewComponent *tableViewComponent, __kindof UITableViewCell *cell, NSIndexPath *indexPath) {
        [weakSelf tableViewComponent:tableViewComponent didEndDisplayingCell:cell forItemAtIndexPath:indexPath];
    }];
    
    [self.view addSubview:self.tableViewComponent.tableView];
    [self.tableViewComponent.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


- (void)configRefreshAndLoadMore {
    __weak typeof(self) weakSelf = self;
    self.tableViewComponent.tableView.refreshView = [RefreshView refreshWithFrame:CGRectMake(0.0f, 0.0f - self.tableViewComponent.tableView.height, self.tableViewComponent.tableView.width, self.tableViewComponent.tableView.height) refreshingBlock:^{
        [weakSelf doRefresh];
    }];
    
    self.tableViewComponent.tableView.loadMoreView = [LoadMoreView loadMoreWithFrame:CGRectMake(0.0f, 0.0f - self.tableViewComponent.tableView.height, self.tableViewComponent.tableView.width, self.tableViewComponent.tableView.height) loadingBlock:^{
        [weakSelf loadMore];
    }];
    
    [self startRefreshing];
}

@end

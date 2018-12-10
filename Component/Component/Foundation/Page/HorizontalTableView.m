//
//  HorizontalTableView.m
//  Component
//
//  Created by Ansel on 2018/12/6.
//  Copyright © 2018 MJK. All rights reserved.
//

#import "HorizontalTableView.h"

static const CGFloat DefaultCellWidth = 40.0;

@interface CellInfo : NSObject

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) CGRect frame;

@end

@implementation CellInfo

@end

@interface HorizontalTableView ()

@property (nonatomic, strong) NSSet<HorizontalTableViewCell*> *lastVisiableCellSet;
@property (nonatomic, strong) NSMutableSet<HorizontalTableViewCell*> *cacheCellSet;
@property (nonatomic, strong) NSMutableArray<CellInfo*> *cellInfoArray;

@property (nonatomic, assign) CGSize viewOldSize;

@end

@implementation HorizontalTableView

@dynamic delegate;

- (void)dealloc
{
    self.dataSource = nil;
    self.delegate = nil;
    
    [self removeObserver];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addObserver];
        [self buildUI];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!CGSizeEqualToSize(self.bounds.size, CGSizeZero) && !CGSizeEqualToSize(self.bounds.size, self.viewOldSize)) {
        self.viewOldSize = self.bounds.size;
        [self reloadData];
    }
}

- (__kindof HorizontalTableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    __block HorizontalTableViewCell *cell = nil;
    //1.先从可见的lastVisiableCellSet取
    [self.lastVisiableCellSet enumerateObjectsUsingBlock:^(HorizontalTableViewCell * _Nonnull obj, BOOL * _Nonnull stop) {
        if (![obj.reuseIdentifier isEqual:identifier]) {
            return;
        }
        
        if ((obj.indexPath.section ==  indexPath.section) && (obj.indexPath.row ==  indexPath.row)) {
            cell = obj;
            *stop = YES;
        }
    }];
    
    if (cell) {
        return cell;
    }
    
    //2.再从缓存的cacheCellSet取
    [self.cacheCellSet enumerateObjectsUsingBlock:^(HorizontalTableViewCell * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj.reuseIdentifier isEqual:identifier]) {
            cell = obj;
            *stop = YES;
        }
    }];
    
    if (cell) {
        [self.cacheCellSet removeObject:cell];
    }
    
    return cell;
}

- (void)reloadData
{
    //1. 分析CellInfo和计算contentSize
    [self analyzeCellInfosAndCalculateContentSize];
    
    //2. 布局cell
    [self layoutNeedDisplayCells];
}

#pragma mark - PrivateUI

- (void)buildUI {
    if (@available(iOS 11.0, *)) {
        [self setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    [self setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - PrivateProperty

- (NSMutableSet<HorizontalTableViewCell *> *)cacheCellSet
{
    if (nil == _cacheCellSet) {
        _cacheCellSet = [[NSMutableSet alloc] init];
    }
    
    return _cacheCellSet;
}

- (NSMutableArray<CellInfo *> *)cellInfoArray
{
    if (nil == _cellInfoArray) {
        _cellInfoArray = [[NSMutableArray alloc] init];
    }
    
    return _cellInfoArray;
}

#pragma mark -  PrivateNotification

- (void)addObserver
{
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)removeObserver
{
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (![keyPath isEqualToString:NSStringFromSelector(@selector(contentOffset))]) {
        return;
    }
    
    CGPoint contentOffsetOld  = [change[NSKeyValueChangeOldKey] CGPointValue];
    CGPoint contentOffset = [change[NSKeyValueChangeNewKey] CGPointValue];
    if (!CGPointEqualToPoint(contentOffsetOld, contentOffset)) {
        [self layoutNeedDisplayCells];
    }
}

#pragma mark - PrivateMethod

- (void)analyzeCellInfosAndCalculateContentSize
{
    if (!self.delegate) {
        return;
    }
    
    self.cellInfoArray = nil;
    NSInteger sections = 1;
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        sections = [self.dataSource numberOfSectionsInTableView:self];
    }
    
    CGFloat totalWidth = 0.0;
    for (NSInteger section = 0; section < sections; section++) {
        NSInteger rows = [self.dataSource tableView:self numberOfRowsInSection:section];
        for (NSInteger row = 0; row < rows ; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            CGFloat cellWidth = DefaultCellWidth;
            if ([self.delegate respondsToSelector:@selector(tableView:widthForRowAtIndexPath:)]) {
                cellWidth = [self.delegate tableView:self widthForRowAtIndexPath:indexPath];
            }
            
            //记录每一个Cell的位置
            CellInfo *cellInfo = [[CellInfo alloc] init];
            cellInfo.indexPath = indexPath;
            //当前的cell x就是之前all cell width
            cellInfo.frame = CGRectMake(totalWidth, 0, cellWidth, self.frame.size.height);
            [self.cellInfoArray addObject:cellInfo];
            
            totalWidth += cellWidth;
        }
    }
    
    CGSize size = CGSizeMake(totalWidth, self.frame.size.height);
    [self setContentSize:size];
}

- (void)layoutNeedDisplayCells
{
    if (!self.delegate) {
        return;
    }
    
    NSArray<CellInfo*> *needDisplayCellInfoArray = [self getNeedDisplayCellInfoArray];
    if ([needDisplayCellInfoArray count] <= 0) {
        return;
    }
    
    //把之前可见 现在不可见的放入到cacheCellMap后并父视图中移除
    [self.lastVisiableCellSet enumerateObjectsUsingBlock:^(HorizontalTableViewCell * _Nonnull cell, BOOL * _Nonnull stop) {
        BOOL result = NO;
        for (CellInfo *cellInfo in needDisplayCellInfoArray) {
            if ((cellInfo.indexPath.section == cell.indexPath.section) && (cellInfo.indexPath.row == cell.indexPath.row)) {
                result = YES;
                break;
            }
        }
        
        if (!result) {
            if ([self.delegate respondsToSelector:@selector(tableView:didEndDisplayingCell:forItemAtIndexPath:)]) {
                [self.delegate tableView:self didEndDisplayingCell:cell forItemAtIndexPath:cell.indexPath];
            }
    
            [self.cacheCellSet addObject:cell];
            [cell removeFromSuperview];
        }
    }];
    
    NSMutableSet<HorizontalTableViewCell*> *currentVisiableCellSet = [[NSMutableSet alloc] init];
    for (CellInfo *cellInfo in needDisplayCellInfoArray) {
        
        HorizontalTableViewCell *cell = [self.dataSource tableView:self cellForRowAtIndexPath:cellInfo.indexPath];
        cell.indexPath = cellInfo.indexPath;
        [cell setFrame:cellInfo.frame];
        //把cell标记为可见的cell
        [currentVisiableCellSet addObject:cell];
        
        if (![cell superview]) {
            //把cell添加到View上
            [self addSubview:cell];
            if ([self.delegate respondsToSelector:@selector(tableView:willDisplayCell:forItemAtIndexPath:)]) {
                [self.delegate tableView:self willDisplayCell:cell forItemAtIndexPath:cell.indexPath];
            }
        }
    }
    
    self.lastVisiableCellSet = currentVisiableCellSet;
}

- (NSArray<CellInfo*> *)getNeedDisplayCellInfoArray
{
    CGFloat beginXOffset = self.contentOffset.x;
    NSInteger beginIndex = [self getIndexForXOffset:beginXOffset startIndex:0 endIndex:[self.cellInfoArray count] -1 isStart:YES];
    if (beginIndex < 0) {
        return nil;
    }
    
    CGFloat endXOffset = self.contentOffset.x + self.frame.size.width;
    NSInteger endIndex = [self getEndIndexForXOffset:endXOffset startIndex:beginIndex endIndex:[self.cellInfoArray count] -1];
    if (endIndex < beginIndex) {
        endIndex = beginIndex;
    }
    
    NSMutableArray *needDisplayCellInfoArray = @[].mutableCopy;
    for (NSInteger index = beginIndex; index <= endIndex; index++) {
        CellInfo *cellInfo = [self.cellInfoArray objectAtIndex:index];
        [needDisplayCellInfoArray addObject:cellInfo];
    }
    
    return needDisplayCellInfoArray;
}

- (NSInteger)getIndexForXOffset:(CGFloat)xOffset startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex isStart:(BOOL)isStart
{
    if (endIndex < startIndex) {
        return -1;
    }
    
    NSInteger middleIndex = (startIndex + endIndex) / 2;
    if (middleIndex >= [self.cellInfoArray count]) {
        return -1;
    }
    
    CellInfo *cellInfo = [self.cellInfoArray objectAtIndex:middleIndex];
    BOOL result = NO;
    if (isStart) {
        result = cellInfo.frame.origin.x <= xOffset;
    } else {
        result = cellInfo.frame.origin.x < xOffset;
    }
    
    if (result && cellInfo.frame.origin.x + cellInfo.frame.size.width > xOffset) {
        //cell的x小于xOffset 但是cell的bottom一定要大于xOffset
        return middleIndex;
    } else if (cellInfo.frame.origin.x > xOffset) {
        //cell的x大于xOffset
        return [self getIndexForXOffset:xOffset startIndex:startIndex endIndex:middleIndex - 1 isStart:isStart];
    } else {
        //cell的x小于xOffset 切cell的bottom也要小于xOffset
        return [self getIndexForXOffset:xOffset startIndex:middleIndex + 1 endIndex:endIndex isStart:isStart];
    }
}

- (NSInteger)getEndIndexForXOffset:(CGFloat)xOffset startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex{
    //当所有cell的高度和都小于屏幕的高度时
    if (self.contentSize.width < self.frame.size.width) {
        return endIndex;
    }
    
    return [self getIndexForXOffset:xOffset startIndex:startIndex endIndex:endIndex isStart:NO];
}

@end


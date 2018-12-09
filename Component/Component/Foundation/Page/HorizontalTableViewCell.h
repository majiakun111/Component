//
//  TableViewCell.h
//  Component
//
//  Created by Ansel on 2018/12/6.
//  Copyright © 2018 MJK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HorizontalTableViewCell : UIView

@property (nonatomic, copy) NSString *reuseIdentifier;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (instancetype)initWithReuseIdentifer:(NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END

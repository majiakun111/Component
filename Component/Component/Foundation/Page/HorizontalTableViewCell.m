//
//  TableViewCell.m
//  Component
//
//  Created by Ansel on 2018/12/6.
//  Copyright © 2018 MJK. All rights reserved.
//

#import "HorizontalTableViewCell.h"

@implementation HorizontalTableViewCell

- (instancetype)initWithReuseIdentifer:(NSString *)reuseIdentifier
{
    self = [super init];
    if (self) {
        self.reuseIdentifier = reuseIdentifier;
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

@end

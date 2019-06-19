//
//  LSCell.m
//  LandscapeTableViewDemo
//
//  Created by 陈晨晖 on 2019/6/19.
//  Copyright © 2019 sunner. All rights reserved.
//

#import "LSCell.h"

@implementation LSCell

- (instancetype)init {
    self = [super init];
    if (self) {
        _titleLabel = [UILabel new];
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _titleLabel.center = self.contentView.center;
}

@end

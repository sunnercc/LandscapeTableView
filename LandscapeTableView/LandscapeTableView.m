//
//  LandscapeTableView.m
//  LandscapeTableView
//
//  Created by 陈晨晖 on 2019/6/19.
//  Copyright © 2019 sunner. All rights reserved.
//

#import "LandscapeTableView.h"

@interface ReusePoll : NSObject

@end

@implementation ReusePoll


@end

@implementation LandscapeTableViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super init];
    if (self) {
        _reuseIdentifier = reuseIdentifier;
        _contentView = [[UIView alloc] init];
        [self addSubview:_contentView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _contentView.frame = self.bounds;
}

@end

@implementation LandscapeTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //
    }
    return self;
}

- (LandscapeTableViewCell *)dequeueReuseableCellWithIdentifier:(NSString *)identifier forItem:(NSUInteger)item {
    return nil;
}

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier {
    
}

- (void)reloadData {

}

@end


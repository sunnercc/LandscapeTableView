//
//  LandscapeTableView.m
//  LandscapeTableView
//
//  Created by 陈晨晖 on 2019/6/19.
//  Copyright © 2019 sunner. All rights reserved.
//

#import "LandscapeTableView.h"

@interface ReusePoll : NSObject
{
    NSMutableArray *_stores;
}
- (void)pushReuseableCell:(LandscapeTableViewCell *)cell;
- (LandscapeTableViewCell *)dequeueReuseableCellWithIdentifier:(NSString *)identifier;
@end

@implementation ReusePoll
- (instancetype)init {
    self = [super init];
    if (self) {
        _stores = @[].mutableCopy;
    }
    return self;
}

- (void)pushReuseableCell:(LandscapeTableViewCell *)cell {
    [_stores addObject:cell];
}

- (LandscapeTableViewCell *)dequeueReuseableCellWithIdentifier:(NSString *)identifier {
    LandscapeTableViewCell *dequeueReuseableCell = nil;
    for (LandscapeTableViewCell *cell in _stores) {
        if ([cell.reuseIdentifier isEqualToString:identifier]) {
            dequeueReuseableCell = cell;
            break;
        }
    }
    if (dequeueReuseableCell) {
        [_stores removeObject:dequeueReuseableCell];
    }
    return dequeueReuseableCell;
}
@end

@interface LandscapeTableViewCell ()
@property (nonatomic, assign) NSInteger mark;
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

@interface LandscapeTableView ()
{
    NSUInteger _numberOfItems;
    NSUInteger _widthsTotal;
    NSUInteger _selectedMark;
    ReusePoll *_poll;
    LandscapeTableViewCell *_firstCell;
    LandscapeTableViewCell *_lastCell;
}

@end

@implementation LandscapeTableView
@dynamic delegate;
- (id<LandscapeTableViewDelegate>)delegate {
    id currentDelegate = [super delegate];
    return currentDelegate;
}
- (void)setDelegate:(id<LandscapeTableViewDelegate>)delegate {
    [super setDelegate:delegate];
}

- (void)setup {
    _poll = [[ReusePoll alloc] init];
    _selectedMark = -1;
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (LandscapeTableViewCell *)dequeueReuseableCellWithIdentifier:(NSString *)identifier {
    return [_poll dequeueReuseableCellWithIdentifier:identifier];
}

- (void)reloadData {
    _numberOfItems = [self.dataSource numberOfItemsInLandscapeTableView:self];
    for (int i = 0; i < _numberOfItems; i++) {
        CGFloat w = [self.dataSource landscapeTableView:self widthForItem:i];
        CGFloat h = self.frame.size.height;
        CGFloat x = i * w;
        CGFloat y = 0;
        LandscapeTableViewCell *cell = [self.dataSource landscapeTableView:self cellForItem:i];
        cell.frame = CGRectMake(x, y, w, h);
        if (![self.subviews containsObject:cell]) {
            [self addSubview:cell];
        }
        cell.mark = i;
        if (i == 0) {
            _firstCell = cell;
        }
        [self addTapWithCell:cell];
        _widthsTotal += w;
        if (_widthsTotal > self.frame.size.width) {
            _lastCell = cell;
            break;
        }
    }
    self.contentSize = CGSizeMake(_widthsTotal, self.frame.size.height);
}

- (void)addTapWithCell:(LandscapeTableViewCell *)cell {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCell:)];
    [cell addGestureRecognizer:tap];
}

- (void)tapCell:(UITapGestureRecognizer *)tap {
    LandscapeTableViewCell *selectedCell = (LandscapeTableViewCell *)tap.view;
    if (_selectedMark != -1
        && _selectedMark != selectedCell.mark
        && [self.delegate respondsToSelector:@selector(landscapeTableView:didDeselectForItem:)]) {
        [self.delegate landscapeTableView:self didDeselectForItem:_selectedMark];
    }
    
    _selectedMark = selectedCell.mark;
    if (_selectedMark != -1
        && [self.delegate respondsToSelector:@selector(landscapeTableView:didSelectForItem:)]) {
        [self.delegate landscapeTableView:self didSelectForItem:_selectedMark];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (CGRectGetMinX(_firstCell.frame) > self.contentOffset.x) {  // insert front
        if (_firstCell.mark != 0) {
            NSUInteger insert = _firstCell.mark - 1;
            CGFloat w = [self.dataSource landscapeTableView:self widthForItem:insert];
            LandscapeTableViewCell *insertCell = [self.dataSource landscapeTableView:self cellForItem:insert];
            CGFloat x = CGRectGetMinX(_firstCell.frame) - w;
            CGFloat y = 0;
            CGFloat h = self.frame.size.height;
            insertCell.frame = CGRectMake(x, y, w, h);
            insertCell.mark = insert;
            [self addSubview:insertCell];
            [self addTapWithCell:insertCell];
            _firstCell = insertCell;
        }
    }
    if (CGRectGetMaxX(_firstCell.frame) < self.contentOffset.x) { // remove first cell
        [_firstCell removeFromSuperview];
        [_poll pushReuseableCell:_firstCell];
        for (LandscapeTableViewCell *cell in self.subviews) {
            if ([cell isKindOfClass:[LandscapeTableViewCell class]]) {
                if (cell.mark - 1 == _firstCell.mark) {
                    _firstCell = cell;
                    break;
                }
            }
        }
    }
    if (CGRectGetMaxX(_lastCell.frame) < self.contentOffset.x + self.frame.size.width) { // append end
        if (_lastCell.mark + 1 != _numberOfItems) {
            NSUInteger append = _lastCell.mark + 1;
            CGFloat w = [self.dataSource landscapeTableView:self widthForItem:append];
            LandscapeTableViewCell *appendCell = [self.dataSource landscapeTableView:self cellForItem:append];
            CGFloat x = CGRectGetMaxX(_lastCell.frame);
            CGFloat y = 0;
            CGFloat h = self.frame.size.height;
            appendCell.frame = CGRectMake(x, y, w, h);
            appendCell.mark = append;
            [self addSubview:appendCell];
            [self addTapWithCell:appendCell];
            _widthsTotal += w;
            _lastCell = appendCell;
            self.contentSize = CGSizeMake(_widthsTotal, self.frame.size.height);
        }
    }
    if (CGRectGetMinX(_lastCell.frame) > self.contentOffset.x + self.frame.size.width) { // remove last cell
        [_lastCell removeFromSuperview];
        [_poll pushReuseableCell:_lastCell];
        self.contentSize = CGSizeMake(_widthsTotal, self.frame.size.height);
        for (LandscapeTableViewCell *cell in self.subviews.reverseObjectEnumerator.allObjects) {
            if ([cell isKindOfClass:[LandscapeTableViewCell class]]) {
                if (cell.mark + 1 == _lastCell.mark) {
                    _lastCell = cell;
                }
            }
        }
        _widthsTotal -= _lastCell.frame.size.width;
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"contentOffset"];
}

@end


//
//  LandscapeTableView.h
//  LandscapeTableView
//
//  Created by 陈晨晖 on 2019/6/19.
//  Copyright © 2019 sunner. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LandscapeTableView;
@class LandscapeTableViewCell;

@protocol LandscapeTableViewDelegate <NSObject, UIScrollViewDelegate>
@optional
- (void)landscapeTableView:(LandscapeTableView *)landscapeTableView didSelectForItem:(NSInteger)item;
- (void)landscapeTableView:(LandscapeTableView *)landscapeTableView didDeselectForItem:(NSInteger)item;
@end

@protocol LandscapeTableViewDataSource <NSObject>
@required
- (NSInteger)numberOfItemsInLandscapeTableView:(LandscapeTableView *)landscapeTableView;
- (LandscapeTableViewCell *)landscapeTableView:(LandscapeTableView *)landscapeTableView cellForItem:(NSInteger)item;
- (CGFloat)landscapeTableView:(LandscapeTableView *)landscapeTableView widthForItem:(NSInteger)item;
@end

@interface LandscapeTableViewCell : UIView
@property (nonatomic, readonly, strong) UIView *contentView;
@property (nonatomic, readonly, copy) NSString *reuseIdentifier;

- (instancetype)initWithReuseIdentifier:(nonnull NSString *)reuseIdentifier;
@end

@interface LandscapeTableView : UIScrollView
@property (nonatomic, weak) id <LandscapeTableViewDelegate> delegate;
@property (nonatomic, weak) id <LandscapeTableViewDataSource> dataSource;

- (LandscapeTableViewCell *)dequeueReuseableCellWithIdentifier:(NSString *)identifier;
- (void)reloadData;
@end


NS_ASSUME_NONNULL_END

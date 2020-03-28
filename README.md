an easy way to build landscape tableView for iOS platform.

![demo](https://landscapeTableView.gif)

## supported  LandscapeTableViewDelegate
``` objc 
@protocol LandscapeTableViewDelegate <NSObject, UIScrollViewDelegate>
@optional
- (void)landscapeTableView:(LandscapeTableView *)landscapeTableView didSelectForItem:(NSInteger)item;
- (void)landscapeTableView:(LandscapeTableView *)landscapeTableView didDeselectForItem:(NSInteger)item;
@end
```

## supported LandscapeTableViewDataSource
``` objc 
@protocol LandscapeTableViewDataSource <NSObject>
@required
- (NSInteger)numberOfItemsInLandscapeTableView:(LandscapeTableView *)landscapeTableView;
- (LandscapeTableViewCell *)landscapeTableView:(LandscapeTableView *)landscapeTableView cellForItem:(NSInteger)item;
- (CGFloat)landscapeTableView:(LandscapeTableView *)landscapeTableView widthForItem:(NSInteger)item;
@end
```

## use methods of LandscapeTableViewCell
``` objc 
@interface LandscapeTableViewCell : UIView
@property (nonatomic, readonly, strong) UIView *contentView;
@property (nonatomic, readonly, copy) NSString *reuseIdentifier;

- (instancetype)initWithReuseIdentifier:(nonnull NSString *)reuseIdentifier;
@end
```

## use methods of LandscapeTableView
``` objc 
@interface LandscapeTableView : UIScrollView
@property (nonatomic, weak) id <LandscapeTableViewDelegate> delegate;
@property (nonatomic, weak) id <LandscapeTableViewDataSource> dataSource;

- (LandscapeTableViewCell *)dequeueReuseableCellWithIdentifier:(NSString *)identifier;
- (void)reloadData;
@end
```

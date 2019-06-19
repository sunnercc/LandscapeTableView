//
//  ViewController.m
//  LandscapeTableView
//
//  Created by 陈晨晖 on 2019/6/19.
//  Copyright © 2019 sunner. All rights reserved.
//

#import "ViewController.h"
#import "../LandscapeTableView/LandscapeTableView.h"
#import "LSCell.h"
#define reuseID @"lscell"

@interface ViewController () <LandscapeTableViewDataSource, LandscapeTableViewDelegate>
@property (weak, nonatomic) IBOutlet LandscapeTableView *landscapeTableView;
@property (nonatomic, strong) NSArray<NSString *> *datas;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _datas = @[@"test",@"test",@"test",@"test",@"test",@"test",@"test",@"test",@"test"];
    
    self.landscapeTableView.delegate = self;
    self.landscapeTableView.dataSource = self;
    [self.landscapeTableView registerClass:[LSCell class] forCellReuseIdentifier:reuseID];
    [self.landscapeTableView reloadData];
}

#pragma mark LandscapeTableViewDataSource & LandscapeTableViewDelegate
- (NSInteger)numberOfItemsInLandscapeTableView:(LandscapeTableView *)landscapeTableView {
    return _datas.count;
}

- (LandscapeTableViewCell *)landscapeTableView:(LandscapeTableView *)landscapeTableView cellForItem:(NSInteger)item {
    LSCell *cell = (LSCell *)[landscapeTableView dequeueReuseableCellWithIdentifier:reuseID forItem:item];
    if (!cell) {
        cell = [[LSCell alloc] initWithReuseIdentifier:reuseID];
    }
    cell.titleLabel.text = _datas[item];
    return cell;
}
- (CGFloat)landscapeTableView:(LandscapeTableView *)landscapeTableView widthForItem:(NSInteger)item {
    return 30.f;
}
- (void)landscapeTableView:(LandscapeTableView *)landscapeTableView didSelectForItem:(NSInteger)item {
    NSLog(@"%ld select", (long)item);
}
- (void)landscapeTableView:(LandscapeTableView *)landscapeTableView didDeselectForItem:(NSInteger)item {
    NSLog(@"%ld deselect", (long)item);
}


@end

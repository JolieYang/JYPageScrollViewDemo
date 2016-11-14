//
//  JYViewController.m
//  JYScrollView
//
//  Created by Jolie_Yang on 2016/10/24.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "JYViewController.h"
#import "JYPageScrollView.h"
#import "JYPageClockScrollView.h"

@interface JYViewController ()<JYPageScrollViewDataSource, JYPageScrollViewDelegate, JYPageClockScrollViewDataSource> {
    NSArray *_dataArray;
}

@end

@implementation JYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray = @[[UIColor redColor], [UIColor purpleColor], [UIColor blueColor], [UIColor grayColor]];
//    _dataArray = @[[UIColor redColor], [UIColor purpleColor]];
//    _dataArray = @[[UIColor purpleColor]];
    
    // JYPageScrollView
    CGFloat scrollViewWidth = 300;
    CGFloat scrollViewHeight = 300;
//    JYPageScrollView *scrollView = [[JYPageScrollView alloc] initWithFrame: CGRectMake(0, 0, scrollViewWidth, scrollViewHeight) style:JYPageScrollViewStyleHorizontal];
//    scrollView.dataSource = self;
//    [self.view addSubview:scrollView];
    
    JYPageClockScrollView *clockScrollView = [[JYPageClockScrollView alloc] initWithFrame:CGRectMake(100, 200, scrollViewWidth, scrollViewHeight)];
    clockScrollView.dataSource = self;
    clockScrollView.clockInterval = 3;
    clockScrollView.showPageControl = YES;
    [clockScrollView startTimer];
    [self.view addSubview:clockScrollView];
}

#pragma mark JYPageScrollViewDataSource
- (NSInteger)numberOfViewsInScrollView:(nonnull UIScrollView *)scrollView {
    return _dataArray.count;
}
- (nonnull UIView *)scrollView:(nonnull UIScrollView *)scrollView cellForRowAtIndex:(NSInteger)index {
    UIView *view = [[UIView alloc] initWithFrame:scrollView.frame];
    view.backgroundColor = _dataArray[index];
    view.alpha = 0.7;
    
    return view;
}

@end

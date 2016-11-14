//
//  ViewController.m
//  JYScrollView
//
//  Created by Jolie_Yang on 2016/10/21.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "ViewController.h"

typedef NS_ENUM(NSInteger, JYPageScrollType) {
    JYPageScrollTypeLeft = 0, // 向左滑动
    JYPageScrolltypeRight = 1, //  向右滑动
    JYPageScrollTypeUp = 2, // 向上滑动
    JYPageScrollTypeDown = 3 // 向下滑动
};

@interface ViewController ()<UIScrollViewDelegate> 
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *viewArray;
@property (nonatomic, strong) NSMutableArray *currentDataArray;

@end

@implementation ViewController
// 数据源处理 dataSource

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.currentDataArray = [NSMutableArray arrayWithCapacity:3];
    self.dataArray = @[[UIColor redColor], [UIColor purpleColor], [UIColor blueColor]];
    
    CGFloat scrollViewWidth = 300;
    CGFloat scrollViewHeight = 300;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(100, 100, scrollViewWidth, scrollViewHeight)];
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(3*scrollViewWidth, scrollViewHeight);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollViewWidth, scrollViewHeight)];
    leftView.backgroundColor = self.dataArray[0];
    [scrollView addSubview:leftView];
    
    UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(1 * scrollViewWidth, 0, scrollViewWidth, scrollViewHeight)];
    middleView.backgroundColor = self.dataArray[1];
    [scrollView addSubview:middleView];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(2 * scrollViewWidth, 0, scrollViewWidth, scrollViewHeight)];
    rightView.backgroundColor = self.dataArray[2];
    
    scrollView.contentOffset = CGPointMake(scrollViewWidth, 0);
    [scrollView addSubview:rightView];
    self.viewArray = @[leftView, middleView, rightView];
    
    self.currentIndex = 1;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int contentOffsetX = scrollView.contentOffset.x;
    if (contentOffsetX >= 2 * scrollView.frame.size.width) { // 往左滑动
        [self updateDataSourceWithViews: self.viewArray scrollType: JYPageScrollTypeLeft];
        scrollView.contentOffset = CGPointMake(scrollView.frame.size.width, 0);
        
    } else if (contentOffsetX <= 0) {// 往右滑动
        [self updateDataSourceWithViews: self.viewArray scrollType: JYPageScrolltypeRight];
        scrollView.contentOffset = CGPointMake(scrollView.frame.size.width, 0);
        
    } else {
        return;
    }
}

- (void)updateDataSourceWithViews:(NSArray *)viewsArray scrollType:(JYPageScrollType)scrollType {
    switch (scrollType) {
        case JYPageScrollTypeLeft:
            [self updateViewArrayAtFirstIndex: self.currentIndex - 1 isIncrease: YES];
            break;
        case JYPageScrollTypeUp:
            [self updateViewArrayAtFirstIndex: [self validArrayIndex: self.currentIndex - 1] isIncrease: YES];
            break;
            
        case JYPageScrolltypeRight:
            [self updateViewArrayAtFirstIndex: self.currentIndex - 1 isIncrease: NO];
            break;
        case JYPageScrollTypeDown:
            [self updateViewArrayAtFirstIndex: [self validArrayIndex: self.currentIndex - 1] isIncrease: NO];
            break;
            
        default:
            break;
    }
}

- (void)updateViewArrayAtFirstIndex:(NSInteger)index isIncrease:(BOOL)increase {
    if (increase) {
        index = [self validArrayIndex: index + 1];
        self.currentIndex = [self validArrayIndex:self.currentIndex + 1];
    } else {
        index = [self validArrayIndex: index - 1];
        self.currentIndex--;
    }
    NSInteger firstIndex = [self validArrayIndex: index];
    self.currentDataArray[0] = self.dataArray[firstIndex];
    
    NSInteger secondIndex = [self validArrayIndex: index + 1];
    self.currentDataArray[1] = self.dataArray[secondIndex];
    
    NSInteger thirdIndex = [self validArrayIndex: index + 2];
    self.currentDataArray[2] = self.dataArray[thirdIndex];
    
    for (int i = 0; i < 3; i++) {
        ((UIView *)self.viewArray[i]).backgroundColor = self.currentDataArray[i];
    }
    
    NSLog(@"firstIndex:%i,secondeIndex:%i,thirdIndex:%i,currentIndex:%i", firstIndex,secondIndex,thirdIndex,self.currentIndex);
}

- (NSInteger)validArrayIndex:(NSInteger)index {
    NSLog(@"idnex:%i", index);
    if (index >= self.dataArray.count) {
        if (index < 0) {
            NSLog(@"show:%i", index % self.dataArray.count);
        }
        return index % self.dataArray.count;
    } else if (index < 0) {
        return [self validArrayIndex: index + self.dataArray.count * 100];
    } else {
        return index;
    }
}
@end

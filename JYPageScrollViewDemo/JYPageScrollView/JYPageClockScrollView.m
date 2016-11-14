//
//  JYPageClockScrollView.m
//  JYScrollView
//
//  Created by Jolie_Yang on 2016/10/25.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "JYPageClockScrollView.h"
#import "JYPageScrollView.h"

@interface JYPageClockScrollView()<JYPageScrollViewDataSource,JYPageScrollViewDelegate,JYPageClockScrollViewDataSource> {
    NSInteger _currentPageIndex;
    NSInteger _totalPageCount;
    BOOL _openTimer;
}
@property (nonatomic, strong, nonnull) JYPageScrollView *pageScrollView;
@property (nonatomic, nullable) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation JYPageClockScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self) {
        self = [super initWithFrame:frame];
        _showPageControl = YES;
        self.pageScrollView = [[JYPageScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:JYPageScrollViewStyleHorizontal];
        
        self.pageScrollView.pageScrollDelegate = self;
//        self.pageScrollView.delegate = self;
        
        [self addSubview:self.pageScrollView];
    }
    
    return self;
}

- (void)setShowPageControl:(BOOL)showPageControl {
    _showPageControl = showPageControl;
    if (_showPageControl == YES && _totalPageCount > 1) {
        _pageControl.hidden = NO;
    } else {
        _pageControl.hidden = YES;
    }
}

- (void)setDataSource:(id<JYPageClockScrollViewDataSource>)dataSource {
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        
        self.pageScrollView.dataSource = _dataSource;
    }
}

#pragma mark JYPageScrollViewDelegate
- (void)scrollViewDidEndPaging:(nonnull UIScrollView *)scrollView atIndex:(NSInteger)index {
    if (index < 0 || index >= self.pageScrollView.totalPageCount) {
        // 异常
        return;
    }
    if (self.showPageControl) {
        _pageControl.currentPage = index;
    }
    if ([_delegate respondsToSelector:@selector(scrollViewDidEndPaging:atIndex:)]) {
        [_delegate scrollViewDidEndPaging:scrollView atIndex:index];
    }
    NSLog(@"show index:%i", index);
}
- (void)scrollView:(nonnull UIScrollView *)scrollView DidGetPageCount:(NSInteger)pageCount {
    _totalPageCount = pageCount;
    [self addPageControlWithPageCount:pageCount];
    if ([_delegate respondsToSelector:@selector(scrollView:DidGetPageCount:)]) {
        [_delegate scrollView:scrollView DidGetPageCount:pageCount];
    }
}

- (void)scrollViewWillBeginDragging:(nonnull UIScrollView *)scrollView {
    if (_openTimer) {
        [self pauseTimer];
    }
    if ([_delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [_delegate scrollViewWillBeginDragging:scrollView];
    }
}
- (void)scrollViewDidEndDragging:(nonnull UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_openTimer) {
        [self startTimer];
    }
    if ([_delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [_delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

#pragma mark JYPageScrollViewDataSource
- (NSInteger)numberOfViewsInScrollView:(nonnull UIScrollView *)scrollView {
    if ([_dataSource respondsToSelector:@selector(numberOfViewsInScrollView:)]) {
        return [_dataSource numberOfViewsInScrollView:scrollView];
    } else {
        return 1;
    }
}
- (nonnull UIView *)scrollView:(nonnull UIScrollView *)scrollView cellForRowAtIndex:(NSInteger)index {
    if ([_dataSource respondsToSelector:@selector(scrollView:cellForRowAtIndex:)]) {
        return [_dataSource scrollView:scrollView cellForRowAtIndex:index];
    } else {
        return nil;
    }
}


#pragma mark PageControl
- (void)addPageControlWithPageCount:(NSInteger)pageCount {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = pageCount;
        _pageControl.currentPage = 0;
        _pageControl.bounds = CGRectMake(0, 0, self.frame.size.width, pageCount * 8);
        _pageControl.center = CGPointMake(self.frame.size.width/2, self.frame.size.height - 30);
        
        [self addSubview:_pageControl];
    }
}
- (void)pagingNext {
    [self.pageScrollView pagingNext];
}

#pragma mark Timer Tool
- (void)startTimer {
    if (!_openTimer) {
        _openTimer = YES;
    }
    
    if ([self.timer isValid]) { // 已经有定时器在执行
        [self pauseTimer];
    } else if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.clockInterval == 0 ? 1 : self.clockInterval target:self selector:@selector(pagingNext) userInfo:nil repeats:YES];
    }
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.clockInterval]];
}

- (void)pauseTimer {
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)closeTimer {
    [self.timer invalidate];
    self.timer = nil;
}


- (void)dealloc {
    [self closeTimer];
}
@end

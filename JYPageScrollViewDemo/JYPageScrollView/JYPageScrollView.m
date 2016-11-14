//
//  JYPageScrollView.m
//  JYScrollView
//
//  Created by Jolie_Yang on 2016/10/21.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "JYPageScrollView.h"

#define  ScrollWidth self.frame.size.width
#define  ScrollHeight self.frame.size.height


@interface JYPageScrollView()<UIScrollViewDelegate, JYPageScrollViewDataSource, JYPageScrollViewDelegate> {
    NSInteger _totalPageCount;
    NSInteger _currentIndex;
    NSInteger _pageIndex;
    NSArray *_viewContainerArray;
    JYPageScrollViewStyle _pageScrollViewStyle;
}

@end

@implementation JYPageScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self) {
        self = [super initWithFrame:frame];
        [self configScrollView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(JYPageScrollViewStyle)style {
    _pageScrollViewStyle = style;
    self = [self initWithFrame:frame];
    
    return self;
}

- (void)configScrollView {
    self.pagingEnabled = YES;
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    _pageIndex = 0;
    
    [self addThreeViewsContainer];// 添加三个滚动视图大小的UIView容器
}

- (void)addThreeViewsContainer {
    NSMutableArray *viewsArray = [NSMutableArray array];
    UIView *view;
    for (int i = 0; i < 3; i++) {
        if (_pageScrollViewStyle == JYPageScrollViewStyleHorizontal) {
            view = [[UIView alloc] initWithFrame:CGRectMake(i * ScrollWidth, 0, ScrollWidth, ScrollHeight)];
        } else {
            view = [[UIView alloc] initWithFrame:CGRectMake(0, i * ScrollHeight, ScrollWidth, ScrollHeight)];
        }
        [self addSubview:view];
        [viewsArray addObject:view];
    }
    _viewContainerArray = viewsArray;
}

#pragma mark JYPageScrollViewDataSource
- (void)setDataSource:(id<JYPageScrollViewDataSource>)dataSource {
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        
        _totalPageCount = [_dataSource numberOfViewsInScrollView:self];
        if ([_pageScrollDelegate respondsToSelector:@selector(scrollView:DidGetPageCount:)]) {
            [_pageScrollDelegate scrollView:self DidGetPageCount:_totalPageCount];
        }
//        if ([self.delegate respondsToSelector:@selector(scrollView:DidGetPageCount:)]) {
//            [self.delegate scrollView:self DidGetPageCount:_totalPageCount];
//        }
        if (_pageScrollViewStyle == JYPageScrollViewStyleHorizontal) {
            self.contentSize = CGSizeMake(ScrollWidth * (_totalPageCount > 1 ? 3 : 1), ScrollHeight);
        } else {
            self.contentSize = CGSizeMake(0, ScrollHeight * (_totalPageCount > 1 ? 3 : 1));
        }
        [self updateThreeViewsContainerContent];
    }
}

// 当前显示页面为三个subView中的第二个,所以第一个subView的index为当前页码的前一页
- (void)updateThreeViewsContainerContent {
    NSInteger firstViewIndex = [self validArrayIndex:_pageIndex - 1];
    for (int i = 0; i < 3; i++) {
        NSInteger validIndex = [self validArrayIndex:firstViewIndex + i];
        if (validIndex < 0 || validIndex > _totalPageCount) {
            // 异常
            break;
        }
        UIView *viewContainer = _viewContainerArray[i];
        if ([viewContainer subviews].count > 0) {
            UIView *subview = [viewContainer subviews][0];
            [subview removeFromSuperview];
        }
        UIView *subView = [_dataSource scrollView:self cellForRowAtIndex:validIndex];
        [subView setFrame:CGRectMake(0, 0, ScrollWidth, ScrollHeight)];
        [viewContainer addSubview: subView];
    }
    if (_pageScrollViewStyle == JYPageScrollViewStyleHorizontal) {
        self.contentOffset = CGPointMake(ScrollWidth, 0);
    } else {
        self.contentOffset = CGPointMake(0, ScrollHeight);
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_pageScrollViewStyle == JYPageScrollViewStyleHorizontal) {
        int offset = scrollView.contentOffset.x;
        [self pagingViewsWithOffset:offset PageOffset:ScrollWidth];
    } else {
        int offset = scrollView.contentOffset.y;
        [self pagingViewsWithOffset:offset PageOffset:ScrollHeight];
    }
}


#pragma mark JYPageScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([_pageScrollDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [_pageScrollDelegate scrollViewWillBeginDragging:scrollView];
    }
    // replace
//    if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
//        [self.delegate scrollViewWillBeginDragging:scrollView];
//    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([_pageScrollDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [_pageScrollDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
    // replace
//    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
//        [self.delegate scrollViewDidEndDragging:self willDecelerate:decelerate];
//    }
}


#pragma mark Tool
- (void)pagingViewsWithOffset:(CGFloat)offset PageOffset:(CGFloat)pageOffset{
    if (offset >= 2 * pageOffset) { //  下一页,包括向左滑动跟向上滑动
        [self pagingNext];
    } else if (offset <= 0) {// 上一页
        [self pagingPrevious];
    } else {
        return;// 不翻页
    }
}
- (void)pagingNext {
    [self pagingViewsWithPagingStyle:JYPageScrollViewPagingStyleNext];
}
- (void)pagingPrevious {
    [self pagingViewsWithPagingStyle:JYPageScrollViewPagingStylePrevious];
}

// 更新pageIndex，更新视图
- (void)pagingViewsWithPagingStyle:(JYPageScrollViewPagingStyle)pagingStyle {
    // 根据向前还是向后翻页，更新currentFirstIndex与currentPageIndex
    if (pagingStyle == JYPageScrollViewPagingStyleNext) {
        _pageIndex = [self validArrayIndex:_pageIndex + 1];
    } else if (pagingStyle == JYPageScrollViewPagingStylePrevious){
        _pageIndex = [self validArrayIndex:_pageIndex - 1];
    } else {
        return;
    }
    
    [self updateThreeViewsContainerContent];
    if ([_pageScrollDelegate respondsToSelector:@selector(scrollViewDidEndPaging:atIndex:)] && _totalPageCount > 1) {
        [_pageScrollDelegate scrollViewDidEndPaging:self atIndex:_pageIndex];
    }
    // replace
    //    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndPaging:atIndex:)] && _totalPageCount > 1) {
    //        [self.delegate scrollViewDidEndPaging:self atIndex:_currentPageIndex];
    //    }
    
}

- (NSInteger)validArrayIndex:(NSInteger)index {
    // 异常处理 _totalPageCount 为0
    if (index >= _totalPageCount) {
        return index % _totalPageCount;
    } else if (index < 0) {
        return [self validArrayIndex: index + _totalPageCount * 100];
    } else {
        return index;
    }
}

@end

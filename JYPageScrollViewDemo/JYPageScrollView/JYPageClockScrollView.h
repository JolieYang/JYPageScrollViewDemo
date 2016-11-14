//
//  JYPageClockScrollView.h
//  JYScrollView
//
//  Created by Jolie_Yang on 2016/10/25.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYPageScrollView.h"

@protocol JYPageClockScrollViewDelegate;

@protocol JYPageClockScrollViewDataSource <JYPageScrollViewDataSource>

@required
- (NSInteger)numberOfViewsInScrollView:(nonnull UIScrollView *)scrollView;
- (nonnull UIView *)scrollView:(nonnull UIScrollView *)scrollView cellForRowAtIndex:(NSInteger)index;

@end

@protocol JYPageClockScrollViewDelegate <NSObject, JYPageScrollViewDelegate>
@required

@optional
- (void)scrollViewWillBeginDragging:(nonnull UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(nonnull UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (void)scrollViewDidEndPaging:(nonnull UIScrollView *)scrollView atIndex:(NSInteger)index;// 翻页
- (void)scrollView:(nonnull UIScrollView *)scrollView DidGetPageCount:(NSInteger)pageCount;

@end

@interface JYPageClockScrollView : UIView

@property (nonatomic, weak, nullable) id <JYPageClockScrollViewDataSource> dataSource;
@property (nonatomic, weak, nullable) id <JYPageClockScrollViewDelegate> delegate;

@property (nonatomic, getter=isShowPageControl) BOOL showPageControl;// Default is NO.


@property (nonatomic) NSInteger clockInterval;// 翻页间隔时间设置,Default 1s.
- (void)startTimer;// 开启自动翻页
@end

//
//  JYPageScrollView.h
//  JYScrollView
//
//  Created by Jolie_Yang on 2016/10/21.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JYPageScrollViewStyle) {
    JYPageScrollViewStyleHorizontal = 0,// 水平方向
    JYPageScrollViewStyleVertical = 1// 垂直方向
};

typedef NS_ENUM(NSInteger, JYPageScrollViewPagingStyle) {
    JYPageScrollViewPagingStyleNext = 0,// 往后翻页
    JYPageScrollViewPagingStylePrevious = 1// 往前翻页
};

@protocol JYPageScrollViewDataSource <NSObject>

@required

- (NSInteger)numberOfViewsInScrollView:(nonnull UIScrollView *)scrollView;
- (nonnull UIView *)scrollView:(nonnull UIScrollView *)scrollView cellForRowAtIndex:(NSInteger)index;

@optional

@end

@protocol JYPageScrollViewDelegate <NSObject, UIScrollViewDelegate>

@optional
- (void)scrollViewWillBeginDragging:(nonnull UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(nonnull UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (void)scrollViewDidEndPaging:(nonnull UIScrollView *)scrollView atIndex:(NSInteger)index;// 翻页
- (void)scrollView:(nonnull UIScrollView *)scrollView DidGetPageCount:(NSInteger)pageCount;

@end

@interface JYPageScrollView : UIScrollView

- (nonnull instancetype)initWithFrame:(CGRect)frame;
- (nonnull instancetype)initWithFrame:(CGRect)frame style:(JYPageScrollViewStyle)style;

@property (nonatomic, weak, nullable) id <JYPageScrollViewDataSource> dataSource;
@property (nonatomic, weak, nullable) id <JYPageScrollViewDelegate> pageScrollDelegate;
//@property (nonatomic, weak, nullable) id <JYPageScrollViewDelegate> delegate;
@property (nonatomic, readonly) NSInteger pageIndex;
@property (nonatomic, readonly) NSInteger totalPageCount;

- (void)pagingNext;// 翻到下一页
- (void)pagingPrevious; // 翻到前一页
@end

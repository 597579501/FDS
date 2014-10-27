//
//  XHADScrollView.h
//  XieHui
//
//  Created by ngo on 13-4-28.
//  Copyright (c) 2013年 ngo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XHADScrollViewDelegate;
@protocol XHADScrollViewDatasource;

@interface XHADScrollView : UIView<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    
    id<XHADScrollViewDelegate> _delegate;
    id<XHADScrollViewDatasource> _datasource;
    
    NSInteger _totalPages;
    NSInteger _curPage;
    
    NSMutableArray *_curViews;
    
    NSTimer *autoscrollTimer;
}
@property (nonatomic) BOOL circle;

@property (nonatomic,readonly) UIScrollView *scrollView;
@property (nonatomic,readonly) UIPageControl *pageControl;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign,setter = setDataource:) id<XHADScrollViewDatasource> datasource;
@property (nonatomic,assign,setter = setDelegate:) id<XHADScrollViewDelegate> delegate;
@property(nonatomic,assign)BOOL autoScrollEnable;
-(UIView*)currentView;
- (void)reloadData;
- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index;
- (id)initWithFrame:(CGRect)frame isVisiable:(BOOL)isVisiable frame: (CGRect)pageControlframe circle:(BOOL)circle start:(int)start;

@end

@protocol XHADScrollViewDelegate <NSObject>

@optional
- (void)didClickPage:(XHADScrollView *)csView atIndex:(NSInteger)index;
- (void)switchPageDone:(XHADScrollView *)csView atIndex:(NSInteger)index :(UIView*)pageView;
@end

@protocol XHADScrollViewDatasource <NSObject>

@required
- (NSInteger)numberOfPages;
- (UIView *)pageAtIndex:(NSInteger)index;
@end

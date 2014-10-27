//
//  XHADScrollView.m
//  XieHui
//
//  Created by ngo on 13-4-28.
//  Copyright (c) 2013年 ngo. All rights reserved.
//

#import "XHADScrollView.h"

@implementation XHADScrollView

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize currentPage = _curPage;
@synthesize datasource = _datasource;
@synthesize delegate = _delegate;
@synthesize circle = _circle;

- (void)dealloc
{
    [_scrollView release];
    [_pageControl release];
    [_curViews release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame isVisiable:(BOOL)isVisiable frame: (CGRect)pageControlframe circle:(BOOL)circle start:(int)start
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
        
        self.circle=circle;
        
        //CGRect rect = self.bounds;
        
        //rect.size.height = 30;
        
        if(isVisiable)
        {
            _pageControl = [[UIPageControl alloc] initWithFrame:pageControlframe];
            _pageControl.userInteractionEnabled = NO;

            [self addSubview:_pageControl];
            [self bringSubviewToFront:_pageControl];
        }
        _curPage = start;
    }
    return self;
}
/*  设置代理  */
- (void)setDataource:(id<XHADScrollViewDatasource>)datasource
{
    _datasource = datasource;
    [self reloadData];
}

- (void)reloadData
{
    _totalPages = [_datasource numberOfPages];
    if (_totalPages == 0) {
        return;
    }
    _pageControl.numberOfPages = _totalPages;
    [self loadData];
}

- (void)loadData
{
    
    _pageControl.currentPage = _curPage;
    
    //从scrollView上移除所有的subview
    NSArray *subViews = [_scrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithCurpage:_curPage];
    
    for (int i = 0; i < _curViews.count; i++) {
        UIView *v = [_curViews objectAtIndex:i];
        v.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTap:)];
        [v addGestureRecognizer:singleTap];
        [singleTap release];
        v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
        NSLog(@"v %f",v.frame.origin.x);
        [_scrollView addSubview:v];
    }
    
    if(_curViews.count==3) {
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * _curViews.count, self.bounds.size.height);
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
    }
    else{
        if(_curPage==0)
            [_scrollView setContentOffset:CGPointMake(1.0, 0)];
        else
            [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
            _scrollView.contentSize = CGSizeMake(self.bounds.size.width * _curViews.count, self.bounds.size.height);
    }
    
    
}

- (void)getDisplayImagesWithCurpage:(int)page {
    
    int pre = [self validPageValue:_curPage-1];
    int last = [self validPageValue:_curPage+1];
    
    if (!_curViews) {
        _curViews = [[NSMutableArray alloc] init];
    }
    
    [_curViews removeAllObjects];
    if(pre >=0)
        [_curViews addObject:[_datasource pageAtIndex:pre]];
    [_curViews addObject:[_datasource pageAtIndex:page]];
    if(last >=0)
        [_curViews addObject:[_datasource pageAtIndex:last]];
}

- (int)validPageValue:(NSInteger)value {
    
    if(self.circle) {
        if(value == -1) value = _totalPages - 1;
        if(value == _totalPages) value = 0;
    }
    else {
        if((value == -1) ||value == _totalPages) {
            value =-1;
        }
    }
    
    return value;
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
   // DLog(@"tap");
    if ([_delegate respondsToSelector:@selector(didClickPage:atIndex:)]) {
        [_delegate didClickPage:self atIndex:_curPage];
    }
    
}
//local not use
- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index
{
    if (index == _curPage) {
        [_curViews replaceObjectAtIndex:1 withObject:view];
        for (int i = 0; i < 3; i++) {
            UIView *v = [_curViews objectAtIndex:i];
            v.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleTap:)];
            [v addGestureRecognizer:singleTap];
            [singleTap release];
            v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
            [_scrollView addSubview:v];
        }
    }
}

- (void)nextPage
{
    
    _pageControl.currentPage = _curPage;
    
    
    UIView *v;
    if(_curViews.count>2){
        [_curViews[0] removeFromSuperview];
        
        _curViews[0] = _curViews[1];
        v = [_curViews objectAtIndex:0];
        v.frame = CGRectOffset(v.frame, v.frame.size.width * -1, 0);
        
        _curViews[1] = _curViews[2];
        v = [_curViews objectAtIndex:1];
        v.frame = CGRectOffset(v.frame, v.frame.size.width * -1, 0);
    }
    else{
        
    }
    
    
    int last = [self validPageValue:_curPage+1];
    if(last >=0) {
        if(_curViews.count>2)
            _curViews[2] =[_datasource pageAtIndex:last];
        else{
            [_curViews addObject:[_datasource pageAtIndex:last]];
        }
        [_scrollView addSubview:_curViews[2]];
        v = [_curViews objectAtIndex:2];
        v.frame = CGRectOffset(v.frame, v.frame.size.width * 2, 0);
        v.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTap:)];
        [v addGestureRecognizer:singleTap];
        [singleTap release];
    }
    else if(_curViews.count>2){
        [_curViews removeObjectAtIndex:2];
    }
    
    
    _scrollView.contentSize = CGSizeMake(self.bounds.size.width * _curViews.count, self.bounds.size.height);
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}

- (void)prePage
{
    
    _pageControl.currentPage = _curPage;
    
    if(_curViews.count==3)
    {
        [_curViews[2] removeFromSuperview];
    }
    
    int pre = [self validPageValue:_curPage-1];
    
    if(pre>=0) {
        if(_curViews.count>2)
            _curViews[2] = _curViews[1];
        else{
            [_curViews addObject:_curViews[1]];
        }
        UIView *v = _curViews[2];
        v.frame = CGRectOffset(v.frame, v.frame.size.width * 1, 0);
        
        _curViews[1] = _curViews[0];
        v = _curViews[1];
        v.frame = CGRectOffset(v.frame, v.frame.size.width * 1, 0);
        
        _curViews[0] =[_datasource pageAtIndex:pre];
        [_scrollView addSubview:_curViews[0]];
        v = [_curViews objectAtIndex:0];
        v.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTap:)];
        [v addGestureRecognizer:singleTap];
        [singleTap release];
        
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * _curViews.count, self.bounds.size.height);
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
        
    }
    else
    {
        if(_curViews.count==3) {
            [_curViews removeObject:_curViews[2]];
        }
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * _curViews.count, self.bounds.size.height);
        [_scrollView setContentOffset:CGPointMake(1.0, 0)];
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    int x = aScrollView.contentOffset.x;
    
    //往下翻一张
    if(_curViews.count == 1){
        return;
    }
    if(x >= ((_curViews.count-1)*self.frame.size.width)) {
        int page = [self validPageValue:_curPage+1];
        if(page ==-1)
            return;
        _curPage =page;
        [self nextPage];
        
        if ([_delegate respondsToSelector:@selector(switchPageDone: atIndex: :)]) {
            [_delegate switchPageDone:self atIndex:_curPage :_curViews[1]];
        }
    }
    
    //往上翻
    if(x <= 0) {
        int page = [self validPageValue:_curPage-1];
        if(page ==-1)
            return;
        _curPage =page;
        [self prePage];
        
        if ([_delegate respondsToSelector:@selector(switchPageDone: atIndex: :)]) {
            [_delegate switchPageDone:self atIndex:_curPage :_curViews[1]];
        }
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    if(_curViews.count ==1 || (_curViews.count ==2 && _curPage ==0)) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else {
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
    }
}

-(void)setAutoScrollEnable:(BOOL)enable{
    _autoScrollEnable=enable;
    if (_autoScrollEnable==YES&&autoscrollTimer==nil) {
     autoscrollTimer = [NSTimer scheduledTimerWithTimeInterval:8.0
                                                            target:self
                                                          selector:@selector(ScrollToNextPage)
                                                          userInfo:nil
                                                           repeats:YES];
    }
    else{
        if ([autoscrollTimer isValid])
        {
            //需要设置失效  否则XHADScrollView不dealloc 自动滚动时导致crash
            [autoscrollTimer invalidate];
        }
       autoscrollTimer= nil;
    }
}

-(void)ScrollToNextPage{
    _scrollView.contentOffset=CGPointMake( ((_curViews.count-1)*self.frame.size.width)+1, 0);
}
-(UIView*)currentView{
    return _curViews[1];
}


@end

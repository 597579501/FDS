//
//  RecommendCell.h
//  FDS
//
//  Created by zhuozhongkeji on 13-12-23.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScrollClickInterface <NSObject>
@optional
- (void)handleScrollClick:(NSInteger)withCurrtag;
@end

@interface RecommendCell : UITableViewCell <UIScrollViewDelegate>

@property(nonatomic,assign)id<ScrollClickInterface>  scrollDelegate;
@property(nonatomic,strong)UIScrollView    *contentScroll;
@property(nonatomic,strong)UILabel         *moreLab;
@property(nonatomic,strong)UIPageControl   *pageControl;
@property(nonatomic,strong) NSMutableArray *textIconArr;
-(id)initScrollView:(NSArray*)withScrollData reuseIdentifier:(NSString *)reuseIdentifier;

@end

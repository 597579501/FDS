//
//  MenuButtonView.m
//  FDS
//
//  Created by zhuozhong on 14-3-14.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "MenuButtonView.h"
#import "Constants.h"

@implementation MenuButtonView

- (id)initWithFrame:(CGRect)frame :(NSArray*)typeArr :(NSInteger)spaceWidth
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _spaceWidth = spaceWidth;
        [self menuButtonInit:typeArr];
    }
    return self;
}

- (void)menuButtonInit:(NSArray*)typeArr
{
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kMSScreenWith, self.frame.size.height)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor clearColor];
    int count = typeArr.count;
    float width = (scrollView.frame.size.width-(count+1)*_spaceWidth)/count;
    [scrollView setContentSize:CGSizeMake(count*width+(count+1)*_spaceWidth, scrollView.frame.size.height)];
    
    for(int i = 0; i < count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(width*i+_spaceWidth*(i+1), 0, width, self.frame.size.height)];
        button.backgroundColor = [UIColor whiteColor];
        [button addTarget:self action:@selector(menuBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [button setTitle:[typeArr objectAtIndex:i] forState:UIControlStateNormal];
        button.tag = i;
        [button setTitleColor:COLOR(234, 234, 234, 1) forState:UIControlStateNormal];
        [scrollView addSubview:button];
    }

    // Indicator image
    indicatorImage = [[UIView alloc]initWithFrame:CGRectMake(_spaceWidth, 0, width, self.frame.size.height)];
    indicatorImage.backgroundColor = COLOR(250, 159, 63, 1);
    [scrollView addSubview:indicatorImage];
    [indicatorImage release];
    
    titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, self.frame.size.height)];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.text = [typeArr objectAtIndex:0];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    titleLab.font=[UIFont systemFontOfSize:13];
    [indicatorImage addSubview:titleLab];
    [titleLab release];

    
    
    [self addSubview:scrollView];
    [scrollView release];
    
    _selectIndex = 0;
}


- (void)menuBtnSelected:(id)sender
{
    if (_selectIndex == [sender tag])
    {
        return;
    }
    [self changeMenuState:[sender tag]];
    if ([self.delegate respondsToSelector:@selector(didSelectedBtnWithTag:)])
    {
        [self.delegate didSelectedBtnWithTag:[sender tag]];
    }
}

-(void)setSelectIndex:(NSInteger)selectIndex
{
    [self changeMenuState:selectIndex];
}

- (void)changeMenuState:(NSInteger)index
{
    _selectIndex = index;
    NSArray *array = [scrollView subviews];
    for (int i = 0; i < [array count]; i++)
    {
        if ([[array objectAtIndex:i] isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton*)[array objectAtIndex:i];
            if (btn.tag == index)
            {
                indicatorImage.center = CGPointMake(btn.center.x, indicatorImage.center.y);
                titleLab.text = btn.titleLabel.text;
                break;
            }
        }
    }
}


- (void)dealloc
{
    [super dealloc];
}

@end

//
//  MenuScrollView.m
//  SP2P
//
//  Created by xuym on 13-8-1.
//  Copyright (c) 2013年 sls001. All rights reserved.
//

#import "MenuScrollView.h"
#import "Constants.h"

@implementation MenuScrollView

-(id)initWithFrame:(CGRect)frame withTitles:(NSArray *)arr
{
    self = [super initWithFrame:frame];
    if (self) {
        _menu_titles = [[NSArray alloc]initWithArray:arr];
        self.hiddenimage=NO;
        [self initScrollView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withTitles:(NSArray *)arr WithBOOL:(BOOL)ishidden
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _menu_titles = [[NSArray alloc]initWithArray:arr];
        self.hiddenimage=ishidden;
        [self initScrollView];
    }
    return self;
}

- (void)initScrollView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.frame.size.height)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    int count = self.menu_titles.count;
    float width = 0;
    if (count >= 5||count == 3)
    {
        width = kMSScreenWith / 3;
    }
    else if (4 == count || 2 == count)
    {
        width = kMSScreenWith / count;
    }
    else
    {
        width = kMSScreenWith;
    }
    [self.scrollView setContentSize:CGSizeMake([self.menu_titles count] * width, self.scrollView.frame.size.height)];
    for(int i = 0; i < count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(width * i, 0, width, self.frame.size.height)];
        [button addTarget:self action:@selector(menuSelected:) forControlEvents:UIControlEventTouchUpInside];
//        [button setBackgroundImage:[UIImage imageNamed:@"henglan"] forState:UIControlStateNormal];
//        [button setBackgroundImage:[UIImage imageNamed:@"henglanback"] forState:UIControlStateHighlighted];
//        [button setBackgroundImage:[UIImage imageNamed:@"henglanback"] forState:UIControlStateSelected];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [button setTitle:[self.menu_titles objectAtIndex:i] forState:UIControlStateNormal];
        button.tag = 3*i;
        UIImageView *image=[[UIImageView alloc]init];
        NSString *textstr=[self.menu_titles objectAtIndex:i];
        if(textstr.length<=3)
        {
            image.frame= CGRectMake(width*i/2+width/2 * (i+1)+23, (self.frame.size.height-8)/2, 8, 8);
        }
        else
        {
           image.frame= CGRectMake(width*i/2+width/2 * (i+1)+40, (self.frame.size.height-8)/2, 8, 8);
        }
        if (i == 0)
        {
            [button setTitleColor:kMSBtnNormalColor forState:UIControlStateNormal];
//            [button setBackgroundImage:[UIImage imageNamed:@"henglanback"] forState:UIControlStateNormal];
            image.image=[UIImage imageNamed:@"pull_actgreen"];
        }
        else
        {
            [button setTitleColor:kMSTextColor forState:UIControlStateNormal];
            image.image=[UIImage imageNamed:@"pull_actblue"];
        }
        image.tag=3*i+1;
        
        [self.scrollView addSubview:button];
        
        if(!self.hiddenimage)
        {
            [self.scrollView addSubview:image];
        }
        [image release];
        //add Vertical view
//        if (i < [self.menu_titles count] - 1 )
//        {
//            UIImageView *image1 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_line_back"]];
//            image1.tag = -1;
//            image1.frame= CGRectMake(width*(i+1)-2, 0, 2, self.frame.size.height);
//            [_scrollView addSubview:image1];
//            [image1 release];
//        }
    }
    // Indicator image
    _indicatorImage = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-2, width, 2)];
    _indicatorImage.backgroundColor = kMSBtnNormalColor;
    [_scrollView addSubview:_indicatorImage];
    _selectIndex = 0;
    [self addSubview:self.scrollView];
}

- (void)menuSelected:(UIButton *)sender
{    
    // Change the current button's title Color,at the same time,change the previous button title color
    if (_selectIndex == sender.tag/3) //不变则不作任何操作
    {
        return;
    }
    [self changeMenuState:sender.tag/3];
    if ([self.delegate respondsToSelector:@selector(didSelectedButtonWithTag:)])
    {
        [self.delegate didSelectedButtonWithTag:sender.tag/3];
    }
}

-(void)setSelectIndex:(NSInteger)selectIndex
{
    [self changeMenuState:selectIndex];
}

- (void)changeMenuState:(NSInteger)index
{
    _selectIndex = index;
    [UIView animateWithDuration:0.1 animations:^{
        NSArray *array = [self.scrollView subviews];
        // The indicator image moving
        for (int i = 0; i < [array count]; i++)
        {
            if ([[array objectAtIndex:i] isKindOfClass:[UIButton class]])
            {
                UIButton *btn = [array objectAtIndex:i];
                if (btn.tag == 3*index)
                {
                    self.indicatorImage.center = CGPointMake(btn.center.x, self.indicatorImage.center.y);
                    
                    [btn setTitleColor:kMSBtnNormalColor forState:UIControlStateNormal];
//                    [btn setBackgroundImage:[UIImage imageNamed:@"henglanback"] forState:UIControlStateNormal];
                }
                else
                {
                    [btn setTitleColor:kMSTextColor forState:UIControlStateNormal];
//                    [btn setBackgroundImage:[UIImage imageNamed:@"henglan"] forState:UIControlStateNormal];
                }
            }
            else if ([[array objectAtIndex:i] isKindOfClass:[UIImageView class]])
            {
                UIImageView *imagview = [array objectAtIndex:i];
                if (imagview.tag == 3*index+1)
                {
                    imagview.image=[UIImage imageNamed:@"pull_actgreen"];
                }
                else if(imagview.tag == -1)
                {
                }
                else
                {
                    imagview.image=[UIImage imageNamed:@"pull_actblue"];
                }
            }
        }
    }];
}

- (void)dealloc
{
    [_indicatorImage release];
    [_scrollView release];
    [_menu_titles release];
    [super dealloc];
}

@end

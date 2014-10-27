//
//  MenuDropView.m
//  FDS
//
//  Created by zhuozhongkeji on 13-12-27.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "MenuDropView.h"
#import "Constants.h"

@implementation MenuDropView

-(id)initWithFrame:(CGRect)frame withTitles:(NSArray *)arr
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _menu_titles = [[NSArray alloc]initWithArray:arr];
        [self scrollInit];
    }
    return self;
}

- (void)scrollInit
{
    self.backgroundColor = [UIColor clearColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kMSScreenWith, 60)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, kMSScreenWith, self.frame.size.height-60)];
    secView.backgroundColor = [UIColor grayColor];
    secView.alpha = 0.5;
    [self addSubview:secView];
    [secView release];
    
    CGFloat width = 80.0f;
    NSInteger count = [_menu_titles count];
    if (4 <= count)
    {
        _scrollView.contentSize = CGSizeMake(80*count, 60);
    }
    else if(3 == count)
    {
        width = 107;//kMSScreenWith/count;
    }
    else
    {
        width = kMSScreenWith/count;
    }
    UIButton *btn;
    UILabel *lab;
    UIImageView *logoImg;
    for (int i = 0; i < count; i++)
    {
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.frame = CGRectMake(width*i,0,width,60);
        [btn setBackgroundImage:[UIImage imageNamed:@"com_btn_normal_bg"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"com_btn_highlight_bg"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
        
        logoImg = [[UIImageView alloc]initWithFrame:CGRectMake(width*i+(width-30)/2,5,30,30)];
        logoImg.image = [[_menu_titles objectAtIndex:i] objectForKey:@"Default"];
        [_scrollView addSubview:logoImg];
        [logoImg release];
        
        lab = [[UILabel alloc]initWithFrame:CGRectMake(width*i, 35, width, 20)];
        lab.backgroundColor = [UIColor clearColor];
        lab.textColor = [UIColor whiteColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font=[UIFont systemFontOfSize:14];
        lab.text = [NSString stringWithFormat:@"%@",[[_menu_titles objectAtIndex:i] objectForKey:@"title"]];
        [_scrollView addSubview:lab];
        [lab release];
    }
    [self addSubview:_scrollView];
}

- (void)buttonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(handleButtonWithTag::)])
    {
        [self.delegate handleButtonWithTag:[sender tag] :[[_menu_titles objectAtIndex:[sender tag]] objectForKey:@"title"]];
    }
}

- (void)dealloc
{
    [_menu_titles release];
    [_scrollView release];
    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

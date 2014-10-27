//
//  UnLoginView.m
//  FDS
//
//  Created by zhuozhongkeji on 14-1-21.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "UnLoginView.h"
#import "Constants.h"

@implementation UnLoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView  *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        bgImg.image = [UIImage imageNamed:@"meLogin_view_bg"];
        bgImg.userInteractionEnabled = YES;
        [self addSubview:bgImg];
        [bgImg release];
        
        UIImageView  *logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(110, 30, 100, 100)];
        logoImg.image = [UIImage imageNamed:@"meLogin_topview_bg"];
        [bgImg addSubview:logoImg];
        [logoImg release];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(60,140,200, 25)];
        lab.backgroundColor = [UIColor clearColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = COLOR(135, 135, 135, 1);
        lab.font=[UIFont systemFontOfSize:14];
        lab.text = @"您需要登录才可以查看信息哦";
        [bgImg addSubview:lab];
        [lab release];

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(54, 180, 211, 42);
        [btn setBackgroundImage:[UIImage imageNamed:@"meLogin_hl_bg"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"meLogin_normal_bg"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
        [bgImg addSubview:btn];
    }
    return self;
}

- (void)buttonClicked
{
    if ([self.delegate respondsToSelector:@selector(didselectLogin)])
    {
        [self.delegate didselectLogin];
    }
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

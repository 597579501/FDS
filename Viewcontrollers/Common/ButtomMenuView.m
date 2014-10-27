//
//  ButtomMenuView.m
//  FDS
//
//  Created by zhuozhongkeji on 14-1-17.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "ButtomMenuView.h"
#import "Constants.h"

@implementation ButtomMenuView

- (id)initWithFrame:(CGRect)frame withDataArr:(NSArray*)arr
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _operDataArr = [[NSArray alloc]initWithArray:arr];
        [self initWithButtomStyle];
    }
    return self;
}

- (void)initWithButtomStyle
{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    NSInteger count = [_operDataArr count];
    CGFloat per_w = width/count;
    UIButton *btn;
    UILabel *lab;
    UIImageView *logoImg;
    for (int i = 0; i < count; i++)
    {
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[[UIImage imageNamed:@"btn_press_hl_bg"]resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[[UIImage imageNamed:@"btn_press_normal_bg"]resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateHighlighted];
        btn.tag = i;
        btn.frame = CGRectMake(per_w*i,0,per_w,height);
        [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        logoImg = [[UIImageView alloc]initWithFrame:CGRectMake(per_w*i+per_w/2-30,(height-25)/2,25,25)];
        logoImg.image = [[_operDataArr objectAtIndex:i] objectForKey:@"Default"];
        [self addSubview:logoImg];
        [logoImg release];
        
        lab = [[UILabel alloc]initWithFrame:CGRectMake(per_w*i+per_w/2,(height-25)/2, 40, 25)];
        lab.backgroundColor = [UIColor clearColor];
        lab.textColor = COLOR(115, 115, 115, 1);;
        lab.font=[UIFont systemFontOfSize:16];
        lab.text = [NSString stringWithFormat:@"%@",[[_operDataArr objectAtIndex:i] objectForKey:@"title"]];
        [self addSubview:lab];
        [lab release];
    }
}

- (void)buttonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didSNSWithTag:)])
    {
        [self.delegate didSNSWithTag:[sender tag]];
    }
}

-(void)dealloc
{
    [_operDataArr release];
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

//
//  DropDownView.m
//  TicketProject
//
//  Created by sls002 on 13-7-12.
//  Copyright (c) 2013年 sls002. All rights reserved.
//

#import "DropDownView.h"

#define kItemSize CGSizeMake(120,44)

@implementation DropDownView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame Items:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.items = array;
        [self setupView];
    }
    return self;
}

-(void)setupView
{
    self.backgroundColor=[UIColor clearColor];

    for (int i = 0; i < _items.count; i++)
    {
        UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemBtn setFrame:CGRectMake(0, i * kItemSize.height, self.bounds.size.width, kItemSize.height)];
        [itemBtn setBackgroundImage:[UIImage imageNamed:@"search_drop_normal_btn"] forState:UIControlStateNormal];
        [itemBtn setBackgroundImage:[UIImage imageNamed:@"search_drop_hl_btn"] forState:UIControlStateHighlighted];
        [itemBtn setTag:i+1];
        [itemBtn addTarget:self action:@selector(selectedItem:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:itemBtn];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, 95, 30)];
        lab.backgroundColor= [UIColor clearColor];
        lab.text = [_items objectAtIndex:i];
        lab.textAlignment = NSTextAlignmentCenter;
        [lab setFont:[UIFont systemFontOfSize:16.0]];
        lab.textColor = [UIColor whiteColor];
        [itemBtn addSubview:lab];
        [lab release];
    }
    _selectIndex = 1;

    selectedView = [[UIImageView alloc]initWithFrame:CGRectMake(95, 12, 20, 20)];
    selectedView.tag = 0x100;
    selectedView.image = [UIImage imageNamed:@"search_drop_select"];
    [self addSubview:selectedView];
    [selectedView release];
}


-(void)selectedItem:(id)sender
{
    UIButton *btn = sender;
    [self hide];
    if (_selectIndex != btn.tag)
    {
        [self handleCommon:btn.tag];
    }
    if ([self.delegate respondsToSelector:@selector(dropItemDidSelectedText:AtIndex:)])
    {
        [self.delegate dropItemDidSelectedText:[_items objectAtIndex:btn.tag-1] AtIndex:btn.tag];
    }
    _selectIndex = btn.tag;
}

//设置选中
-(void)setSelectIndex:(NSInteger)selIndex
{
    if (_selectIndex == selIndex)
    {
        return;
    }
    [self handleCommon:selIndex];
    _selectIndex = selIndex;
}

-(void)handleCommon :(NSInteger)selIndex
{
    if ([[self viewWithTag:selIndex] isKindOfClass:[UIButton class]])
    {
        UIButton *btn = (UIButton *)[self viewWithTag:selIndex];
        selectedView.center = CGPointMake(selectedView.center.x, btn.center.y);
    }
}

//button处理
-(void)show
{
    self.hidden = !self.hidden;
}

-(void)hide
{
    [self setHidden:YES];
}

-(void)dealloc
{
    self.items = nil;
    [super dealloc];
}

@end

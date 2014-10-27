//
//  MoreTableViewCell.m
//  FDS
//
//  Created by zhuozhongkeji on 13-12-20.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "MoreTableViewCell.h"
#import "Constants.h"
#import "EGOImageButton.h"

@implementation MoreTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        // Initialization code
        _useLoadMore = YES;
        //*****more content
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 320, 111)];
        _imgView.userInteractionEnabled = YES;
        _imgView.image =[[UIImage imageNamed:@"rect_cell_bg"]resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];

        _moreLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 70, 30)];
        _moreLab.backgroundColor = [UIColor clearColor];
        _moreLab.textColor = kMSTextColor;
        _moreLab.font=[UIFont systemFontOfSize:14];
        [_imgView addSubview:_moreLab];
        
        _moreImg = [[UIImageView alloc] initWithFrame:CGRectMake(300, 10, 10, 10)];
        _moreImg.userInteractionEnabled = YES;
        _moreImg.image =[UIImage imageNamed:@"com_scroll_show_bg"];
        [_imgView addSubview:_moreImg];

        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        moreBtn.frame = CGRectMake(280, 0, 40, 30);
        [moreBtn addTarget:self action:@selector(handleHideScroll) forControlEvents:UIControlEventTouchUpInside];
        [_imgView addSubview:moreBtn];

        UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 320, 1)];
        tmpView.backgroundColor = kMSLineColor;
        [_imgView addSubview:tmpView];
        [tmpView release];
        
        _contentScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 31, 320, 80)];
        _contentScroll.showsHorizontalScrollIndicator = NO;
        [_imgView addSubview:_contentScroll];
        
        [self addSubview:_imgView];
        [_imgView release];
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(id)initScrollView:(NSArray*)withScrollData reuseIdentifier:(NSString *)reuseIdentifier :(BOOL)isneedRect
{
    [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    NSInteger count = [withScrollData count];
    self.textIconArr = [NSMutableArray arrayWithCapacity:count];
    if (4 < count)
    {
        _contentScroll.contentSize = CGSizeMake(80*count, 80);
    }
    EGOImageButton *btn;
    UILabel *lab;
    CGFloat width = 80.0f;
    for (int i = 0; i < count; i++)
    {
        btn = [EGOImageButton buttonWithType:UIButtonTypeCustom];
        btn.adjustsImageWhenHighlighted = NO;
        btn.tag = i;
        btn.frame = CGRectMake(width*i+15,5,50,50);
        if (isneedRect)
        {
            btn.layer.borderWidth = 1;
            btn.layer.cornerRadius = 4.0;
            btn.layer.masksToBounds=YES;
            btn.layer.borderColor = [[UIColor colorWithRed:242.0f/255 green:242.0f/255 blue:242.0f/255 alpha:1.0f] CGColor];
        }
        if ([[[withScrollData objectAtIndex:i] objectForKey:@"Default"]isEqualToString:@""] || ![[[withScrollData objectAtIndex:i] objectForKey:@"iconURL"]isEqualToString:@""])
        {
            btn.useBackGroundImg = YES;
            btn.placeholderImage = [UIImage imageNamed:@"send_image_default"];
            btn.imageURL = [NSURL URLWithString:[[withScrollData objectAtIndex:i] objectForKey:@"iconURL"]];
        }
        else
        {
            [btn setBackgroundImage:[UIImage imageNamed:[[withScrollData objectAtIndex:i] objectForKey:@"Default"]] forState:UIControlStateNormal];
        }
        [btn setImageEdgeInsets:UIEdgeInsetsMake(1, 5, 1, 5)];
        [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.textIconArr addObject:btn];
        [_contentScroll addSubview:btn];
        
        lab = [[UILabel alloc]initWithFrame:CGRectMake(width*i, 55, 80, 20)];
        lab.backgroundColor = [UIColor clearColor];
        lab.textColor = kMSTextColor;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font=[UIFont systemFontOfSize:14];
        lab.text = [NSString stringWithFormat:@"%@",[[withScrollData objectAtIndex:i] objectForKey:@"title"]];
        [_contentScroll addSubview:lab];
        [lab release];
    }
    return self;
}

- (void)buttonPressed:(UIButton*)sender
{
    if ([self.clickDelegate respondsToSelector:@selector(didClickedButtonWithTag:withMark:)])
    {
        [self.clickDelegate didClickedButtonWithTag:sender.tag withMark:self.marked];
    }
}

- (void)handleHideScroll
{
    _useLoadMore = !_useLoadMore;
    _contentScroll.hidden = !_contentScroll.hidden;
    if (!_useLoadMore)
    {
        _imgView.frame = CGRectMake(_imgView.frame.origin.x, _imgView.frame.origin.y, _imgView.frame.size.width, _imgView.frame.size.height-80);
        _moreImg.image =[UIImage imageNamed:@"com_scroll_hide_bg"];
    }
    else
    {
        _imgView.frame = CGRectMake(_imgView.frame.origin.x, _imgView.frame.origin.y, _imgView.frame.size.width, _imgView.frame.size.height+80);
        _moreImg.image =[UIImage imageNamed:@"com_scroll_show_bg"];
    }
    [_hideDelegate hideScrollview];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (_useLoadMore)
    {
    }
    else
    {
    }
}

-(void)dealloc
{
    [_contentScroll release];
    [_moreLab release];
    [_textIconArr release];
    [_moreImg release];
    [super dealloc];
}
@end

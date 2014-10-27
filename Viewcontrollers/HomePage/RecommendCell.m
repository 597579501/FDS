//
//  RecommendCell.m
//  FDS
//
//  Created by zhuozhongkeji on 13-12-23.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "RecommendCell.h"
#import "Constants.h"
#import "FDSCompany.h"
#import "EGOImageButton.h"

@implementation RecommendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        // Initialization code
        //*****more content
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        titleView.backgroundColor = COLOR(229, 229, 229, 1);
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 18, 18)];
        imgView.image =[UIImage imageNamed:@"yellow_recommand_bg"];
        [titleView addSubview:imgView];
        [imgView release];
        
        _moreLab = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, 280, 20)];
        _moreLab.backgroundColor = [UIColor clearColor];
        _moreLab.textColor = kMSTextColor;
        _moreLab.font=[UIFont boldSystemFontOfSize:16];
        [titleView addSubview:_moreLab];
        [_moreLab release];
        [self.contentView addSubview:titleView];
        [titleView release];
        
        _contentScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 41, kMSScreenWith, 190)];
        _contentScroll.showsHorizontalScrollIndicator = NO;
        _contentScroll.showsVerticalScrollIndicator = NO;
        _contentScroll.delegate = self;
        _contentScroll.pagingEnabled = YES;
        _contentScroll.bounces = NO;
        [self.contentView addSubview:_contentScroll];
        [_contentScroll release];

        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 231, kMSScreenWith, 20)];
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.currentPageIndicatorTintColor = COLOR(158, 158, 158, 1);
        _pageControl.pageIndicatorTintColor = COLOR(208, 208, 208, 1);
        [self.contentView addSubview:_pageControl];
        [_pageControl release];
    }
    return self;
}

-(id)initScrollView:(NSArray*)withScrollData reuseIdentifier:(NSString *)reuseIdentifier
{
    [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    NSInteger count = [withScrollData count];
    NSInteger page = 1; //推荐企业页数
    if (0 == count)
    {
        page = 1;
    }
    else if (0 == count%8)
    {
        page = count/8;
    }
    else
    {
        page = count/8+1;
    }
    EGOImageButton *btn;
    UILabel *lab;
    CGFloat width = 80.0f;
    for (int i = 0; i < page; i++)
    {
        UIView *pageView=[[UIView alloc] initWithFrame:CGRectMake(i*kMSScreenWith, 0, kMSScreenWith , 190)];
        [pageView setBackgroundColor:[UIColor clearColor]];
        
        [_contentScroll addSubview:pageView];
        [pageView release];
        
        int curPageCount = 0; //当前页总个数
        if (count-(i+1)*8 >= 0)
        {
            curPageCount = 8;
        }
        else
        {
            curPageCount = count-i*8;
        }
        for (int j=0; j<curPageCount; j++)
        {
            btn = [EGOImageButton buttonWithType:UIButtonTypeCustom];
            btn.layer.borderWidth = 1;
            btn.layer.cornerRadius = 4.0;
            btn.layer.masksToBounds=YES;
            btn.layer.borderColor = [[UIColor colorWithRed:242.0f/255 green:242.0f/255 blue:242.0f/255 alpha:1.0f] CGColor];

            btn.adjustsImageWhenHighlighted = NO;
            [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [pageView addSubview:btn];
            
            lab = [[UILabel alloc] init];
            lab.backgroundColor = [UIColor clearColor];
            lab.textColor = kMSTextColor;
            lab.textAlignment = NSTextAlignmentCenter;
            lab.font=[UIFont systemFontOfSize:14];
            [pageView addSubview:lab];
            [lab release];
            
            if (j <= 3) //0 1 2 3
            {
                btn.frame = CGRectMake(width*j+10,10,60,60);
                lab.frame = CGRectMake(width*j, 75, 80, 20);
            }
            else //4 5 6 7
            {
                btn.frame = CGRectMake(width*(j-4)+10,105,60,60);
                lab.frame = CGRectMake(width*(j-4), 170, 80, 20);
            }
            btn.tag = j+(i*8); //0到j 0到7
            
            FDSCompany *companyInfo = [withScrollData objectAtIndex:btn.tag];
            if (companyInfo.m_comIcon && companyInfo.m_comIcon.length >0)
            {
                btn.useBackGroundImg = YES;
                btn.placeholderImage = [UIImage imageNamed:@"send_image_default"];
                NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@",companyInfo.m_comIcon];
                if (urlStr.length >= 4)
                {
                    [urlStr insertString:@"_middle" atIndex:urlStr.length-4];
                }
                [btn setImageURL:[NSURL URLWithString:urlStr]];
            }
            else
            {
                [btn setBackgroundImage:[UIImage imageNamed:@"send_image_default"] forState:UIControlStateNormal];
            }
            lab.text = companyInfo.m_comName;
        }
        _pageControl.numberOfPages = page;
        _contentScroll.contentSize = CGSizeMake(page*kMSScreenWith, 190);
    }
    return self;
}

- (void)buttonClicked:(id)sender
{
    //****真实数据需要id来标示哪个button事件 再抛到页面具体处理
    if ([_scrollDelegate respondsToSelector:@selector(handleScrollClick:)])
    {
        [_scrollDelegate handleScrollClick:[sender tag]];
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}
@end

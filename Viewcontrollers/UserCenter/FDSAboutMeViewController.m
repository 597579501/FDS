//
//  FDSAboutMeViewController.m
//  FDS
//
//  Created by zhuozhongkeji on 14-1-11.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSAboutMeViewController.h"
#import "UIViewController+BarExtension.h"
#import "Constants.h"

@interface FDSAboutMeViewController ()

@end

@implementation FDSAboutMeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self homeNavbarWithTitle:@"关于我们" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith, kMSTableViewHeight-44)];
    _pageScroll.contentSize = CGSizeMake(kMSScreenWith, kMSTableViewHeight+100);
    _pageScroll.backgroundColor = COLOR(234, 234, 234, 1);
    _pageScroll.showsVerticalScrollIndicator = NO;
    
    //*****logo 介绍**********
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(95, 25, 130, 150)];
    headView.backgroundColor = [UIColor clearColor];
    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 100, 100)];
    iconImg.image = [UIImage imageNamed:@"icon7"];
    [headView addSubview:iconImg];
    [iconImg release];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 100, 120, 30)];
    titleLabel.textColor = COLOR(32, 32, 32, 1);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font =[UIFont boldSystemFontOfSize:20];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"欧碧乐";
    [headView addSubview:titleLabel];
    [titleLabel release];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 130, 120, 20)];
    titleLabel.textColor = COLOR(32, 32, 32, 1);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font =[UIFont systemFontOfSize:14];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"V 1.0.1";
    [headView addSubview:titleLabel];
    [titleLabel release];

    [_pageScroll addSubview:headView];
    [headView release];
    //*****logo 介绍**********
    
    //*****introduce data**********
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25+150+10, kMSScreenWith-20, 184)];
    titleLabel.numberOfLines = 10;
    titleLabel.text = @"       欧碧乐是在中国高尔夫业界耕耘近10年的深圳市欧必了巴网络有限公司（原福帝斯机构，以下简称欧必了巴）打造的，致力于为高尔夫、游艇等高消费群体提供服务的移动互联网平台。10年来，欧必了巴主要从事高尔夫会所设计业务、创办并运营《高尔夫黄页》数据库、开展NIKEGOLF新业务、创办并运营《高尔夫宝艇》、以及相关银行和奢侈品业务。欧碧乐的出台，标志着公司将在原有业务基础上，加上移动互联的翅膀";
    titleLabel.textColor = COLOR(32, 32, 32, 1);
    titleLabel.font =[UIFont systemFontOfSize:14];
    titleLabel.backgroundColor = [UIColor clearColor];
    [_pageScroll addSubview:titleLabel];
    [titleLabel release];
    //*****introduce data**********
    
    UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 25+150+184, 200, 60)];
    infoLab.numberOfLines = 3;
    infoLab.text = @"客服电话：18926046108\n客服邮箱：oblebgolf@163.com \n公司网站：www.obleb.com";
    infoLab.textAlignment = NSTextAlignmentLeft;
    infoLab.textColor = COLOR(32, 32, 32, 1);
    infoLab.font =[UIFont systemFontOfSize:14];
    infoLab.backgroundColor = [UIColor clearColor];
    [_pageScroll addSubview:infoLab];
    [infoLab release];
    
    //*****footer view**********
    UIView *buttomView = [[UIView alloc] initWithFrame:CGRectMake(10, titleLabel.frame.origin.y+titleLabel.frame.size.height +100, kMSScreenWith-20, 60)];
    buttomView.backgroundColor = [UIColor clearColor];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, kMSScreenWith-30, 20)];
    titleLabel.textColor = kMSTextColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font =[UIFont systemFontOfSize:14];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"欧必了巴公司  版权所有";
    [buttomView addSubview:titleLabel];
    [titleLabel release];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, kMSScreenWith-30, 20)];
    titleLabel.textColor = kMSTextColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font =[UIFont systemFontOfSize:14];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"Copyright (©) 2013";
    [buttomView addSubview:titleLabel];
    [titleLabel release];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, kMSScreenWith-30, 20)];
    titleLabel.textColor = kMSTextColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font =[UIFont systemFontOfSize:14];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"All Right Reserved";
    [buttomView addSubview:titleLabel];
    [titleLabel release];
    
    [_pageScroll addSubview:buttomView];
    [buttomView release];
    //*****footer view**********

    [self.view addSubview:_pageScroll];
    [_pageScroll release];
	// Do any additional setup after loading the view.
}


@end

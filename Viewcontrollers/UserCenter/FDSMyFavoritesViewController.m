//
//  FDSMyFavoritesViewController.m
//  FDS
//
//  Created by zhuozhongkeji on 14-1-13.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSMyFavoritesViewController.h"
#import "UIViewController+BarExtension.h"
#import "Constants.h"
#import "FDSPublicManage.h"
#import "FDSCollectListViewController.h"

@interface FDSMyFavoritesViewController ()

@end

@implementation FDSMyFavoritesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.collectTotalArr = nil;
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
    self.collectTotalArr = nil;
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    FDSCollectedInfo *collectInfo = nil;
    for (int i=0; i<self.collectTotalArr.count; i++)
    {
        collectInfo = [self.collectTotalArr objectAtIndex:i];
        UILabel *tpmLab = (UILabel*)[_bgView viewWithTag:i+1];
        tpmLab.text = [NSString stringWithFormat:@"%@（ %d ）",collectInfo.m_typeTitle,collectInfo.m_collectList.count];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self homeNavbarWithTitle:@"我的收藏" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith, kMSTableViewHeight-44)];
    _pageScroll.contentSize = CGSizeMake(kMSScreenWith, kMSTableViewHeight);
    _pageScroll.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_back"]];
    _pageScroll.showsVerticalScrollIndicator = NO;
    
    //*****group data**********
    UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 300, 30)];
    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.textColor = kMSTextColor;
    topLabel.font=[UIFont systemFontOfSize:14];
    topLabel.text = @"你所有的收藏将会在下面显示";
    [_pageScroll addSubview:topLabel];
    [topLabel release];

    
    self.collectTotalArr = [[FDSPublicManage sharePublicManager] getCollectedInfo];

    _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15+35, kMSScreenWith-20, self.collectTotalArr.count*51)];
    _bgView.image = [[UIImage imageNamed:@"round_white_cellbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    _bgView.userInteractionEnabled = YES;
    
    FDSCollectedInfo *collectInfo = nil;
    for (int i=0; i<self.collectTotalArr.count; i++)
    {
        collectInfo = [self.collectTotalArr objectAtIndex:i];
        
        UIButton *midBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        midBtn.frame = CGRectMake(0, 51*i, kMSScreenWith-20, 51);
        [midBtn addTarget:self action:@selector(didSelected:) forControlEvents:UIControlEventTouchUpInside];
        midBtn.tag = i;
        
        UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        [iconImg setImage:[UIImage imageNamed:collectInfo.m_typeIcon]];
        [midBtn addSubview:iconImg];
        [iconImg release];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 200, 40)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = COLOR(69, 69, 69, 1);
        titleLabel.font=[UIFont systemFontOfSize:15];
        titleLabel.tag = i+1;
        [midBtn addSubview:titleLabel];
        [titleLabel release];
        
        UIImageView *detailCellImg = [[UIImageView alloc] initWithFrame:CGRectMake(280, 19, 8, 12)];
        [detailCellImg setImage:[UIImage imageNamed:@"cell_more_identify_bg"]];
        [midBtn addSubview:detailCellImg];
        [detailCellImg release];
        if (i < self.collectTotalArr.count-1)
        {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, kMSScreenWith-20, 1)];
            lineView.backgroundColor = [UIColor colorWithRed:195/255.0f green:195/255.0f blue:195/255.0f alpha:1.0f];
            [midBtn addSubview:lineView];
            [lineView release];
        }
        [_bgView addSubview:midBtn];
    }
    
    [_pageScroll addSubview:_bgView];
    [_bgView release];
    //*****group data**********
    
    
    [self.view addSubview:_pageScroll];
    [_pageScroll release];
	// Do any additional setup after loading the view.
}

- (void)didSelected:(id)sender
{
    FDSCollectListViewController *listVC = [[FDSCollectListViewController alloc] init];
    listVC.collectInfo = [self.collectTotalArr objectAtIndex:[sender tag]];
    [self.navigationController pushViewController:listVC animated:YES];
    [listVC release];
}


@end

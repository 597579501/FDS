//
//  FDSHomePageViewController.m
//  FDS
//
//  Created by zhuozhong on 13-12-3.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "FDSHomePageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FDSYellowPageViewController.h"
#import "Constants.h"
#import "UIViewController+BarExtension.h"
#import "UIToastAlert.h"
#import "FDSPosBarInfoViewController.h"
#import "FDSBarCommentViewController.h"
#import "FDSCollectedInfo.h"
#import "FDSPublicManage.h"

@interface FDSHomePageViewController ()

@end

@implementation FDSHomePageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.homeData = nil;
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
    self.homeData = nil;
    [xhaScroll setAutoScrollEnable:NO];
    [super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[FDSCompanyMessageManager sharedManager]unRegisterObserver:self];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[ZZSessionManager sharedSessionManager] unRegisterObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[FDSCompanyMessageManager sharedManager]registerObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[ZZSessionManager sharedSessionManager] registerObserver:self];
    
    enum ZZSessionManagerState state = [[ZZSessionManager sharedSessionManager] getSessionState];
    if (ZZSessionManagerState_NET_FAIL == state)
    {
        networkView.hidden = NO;
    }
    else
    {
        networkView.hidden = YES;
        if (!self.homeData)
        {
            [[FDSCompanyMessageManager sharedManager]getHomePageRecommendeds];
        }
    }
}

/*   获取首页的推荐  */
- (void)getHomePageRecommendedsCB:(NSMutableArray*)recommandList;
{
    self.homeData = recommandList;
    [xhaScroll reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    [self Root];
    [self careat];
}

-(void)Root
{
    [self homeNavbarWithTitle:@"首页" andLeftButtonName:nil andRightButtonName:nil];
    _ScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith, kMSTableViewHeight-44-49)];
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _ScrollView.frame = CGRectMake(_ScrollView.frame.origin.x, _ScrollView.frame.origin.y, _ScrollView.frame.size.width, _ScrollView.frame.size.height+20+49);
    }
    _ScrollView.showsVerticalScrollIndicator=NO;
    xhaScroll.backgroundColor = [UIColor lightGrayColor];
    _ScrollView.contentSize = CGSizeMake(kMSScreenWith, kMSTableViewHeight);
    xhaScroll = [[XHADScrollView alloc]initWithFrame:CGRectMake(0, 0, kMSScreenWith, 160) isVisiable:YES frame:CGRectMake(110, 145, 100, 15) circle:YES start:0];
    xhaScroll.datasource = self;
    xhaScroll.delegate = self;
    xhaScroll.autoScrollEnable = YES;
    xhaScroll.pageControl.backgroundColor = [UIColor clearColor];
    [_ScrollView addSubview:xhaScroll];
    [xhaScroll release];
    
    _ScrollView1 =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 161, kMSScreenWith, kMSTableViewHeight-44-49-160)];
    _ScrollView1.showsVerticalScrollIndicator=NO;
    _ScrollView1.showsHorizontalScrollIndicator=NO;
    _ScrollView1.backgroundColor=[UIColor whiteColor];
    [_ScrollView addSubview:_ScrollView1];
    [_ScrollView1 release];
    
    [self.view addSubview:_ScrollView];
    [_ScrollView release];
    
    /*  网络不可用提示   */
    networkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMSScreenWith, 40)];
    networkView.backgroundColor = [UIColor whiteColor];
    [_ScrollView addSubview:networkView];
    [networkView release];
    
    UIImageView *networkImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 25, 25)];
    networkImg.image = [UIImage imageNamed:@"network_no_avalible"];
    [networkView addSubview:networkImg];
    [networkImg release];
    
    UILabel *promptLab = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 200, 30)];
    promptLab.backgroundColor = [UIColor clearColor];
    promptLab.textColor = [UIColor redColor];
    promptLab.text = @"当前网络不可用";
    promptLab.font=[UIFont systemFontOfSize:15];
    [networkView addSubview:promptLab];
    [promptLab release];
    
    networkView.hidden = YES;
    /*  网络不可用提示   */
}

-(void)careat
{
    UIButton *button1 =[[UIButton alloc]initWithFrame:CGRectMake(5, 5, 152.5, 113.5)];
    button1.tag = 1;
    [button1 setAdjustsImageWhenHighlighted:NO];
    [button1 setBackgroundImage:[UIImage imageNamed:@"yellow_page_bg"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(handleBtnReq:) forControlEvents:UIControlEventTouchUpInside];
    [_ScrollView1 addSubview:button1];
    [button1 release];
    
    UIButton *button2 =[[UIButton alloc]initWithFrame:CGRectMake(10+152.5, 5, 152.5, 113.5)];
    button2.tag = 2;
    [button2 setAdjustsImageWhenHighlighted:NO];
    [button2 setBackgroundImage:[UIImage imageNamed:@"Info_page_bg"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(handleBtnReq:) forControlEvents:UIControlEventTouchUpInside];
    [_ScrollView1 addSubview:button2];
    [button2 release];
}

- (void)handleBtnReq:(id)sender
{
    if (1 == [sender tag])
    {
        FDSYellowPageViewController *fdsYpage = [[FDSYellowPageViewController alloc]init];
        fdsYpage.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:fdsYpage animated:YES];
        [fdsYpage release];
    }
    else
    {
        FDSPosBarInfoViewController *barVC = [[FDSPosBarInfoViewController alloc] init];
        FDSPosBar *postBar = [[FDSPosBar alloc] init];
        postBar.m_barID = @"00000923";
        postBar.m_barName = @"直播间";
        barVC.lastPageBar = postBar;
        barVC.bar_type = BAR_POST_TYPE_OTHER;
        [postBar release];
        barVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:barVC animated:YES];
        [barVC release];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该功能暂未开放 敬请期待！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
//        UIToastAlert *toast = [UIToastAlert shortToastForMessage:@"" atPosition:UIToastAlertPositionTop];
//        toast._tintColor = [UIColor grayColor];
//        [toast show:self.view];
    }
}

-(void)sessionManagerStateNotice:(enum ZZSessionManagerState)sessionManagerState
{
  switch(sessionManagerState)
    {
//        case ZZSessionManagerState_NONE:
        case ZZSessionManagerState_NET_FAIL:
        {
            networkView.hidden = NO;
        }
            break;
        case ZZSessionManagerState_NET_OK:
        {
            networkView.hidden = YES;
        }
            break;
        default:
            break;
    }
}

#pragma mark - XHADScrollViewDatasource,XHADScrollViewDelegate Methods
- (NSInteger)numberOfPages
{
    if (self.homeData)
    {
        return [self.homeData count];
    }
    return 0;
}

- (UIView *)pageAtIndex:(NSInteger)index
{
    EGOImageButton *tmpImg = [EGOImageButton buttonWithType:UIButtonTypeCustom];
    tmpImg.adjustsImageWhenHighlighted = NO;
    tmpImg.frame = CGRectMake(0, 0, kMSScreenWith, 160);
    FDSBarPostInfo *postInfo = [self.homeData objectAtIndex:index];
    if (postInfo.m_images.count > 0)
    {
        NSString *tmpStr = [postInfo.m_images objectAtIndex:0];
        if (tmpStr && tmpStr.length>0)
        {
            tmpImg.useBackGroundImg = YES;
            tmpImg.placeholderImage = [UIImage imageNamed:@"loading_logo_bg"];
            NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@",tmpStr];
            tmpImg.imageURL = [NSURL URLWithString:urlStr];/* 待解决问题  大图片存储处理 */
        }
        else
        {
            [tmpImg setBackgroundImage:[UIImage imageNamed:@"loading_logo_bg"] forState:UIControlStateNormal];
        }
    }
    else
    {
        [tmpImg setBackgroundImage:[UIImage imageNamed:@"loading_logo_bg"] forState:UIControlStateNormal];
    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 135, kMSScreenWith, 25)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.5;
    [tmpImg addSubview:bgView];
    [bgView release];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 135, 280, 25)];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.text = postInfo.m_title;
    titleLab.font=[UIFont systemFontOfSize:15];
    [tmpImg addSubview:titleLab];
    [titleLab release];

    return tmpImg;
}

- (void)didClickPage:(XHADScrollView *)csView atIndex:(NSInteger)index
{
    FDSBarPostInfo *barInfo = [self.homeData objectAtIndex:index];
    
    FDSBarCommentViewController *barCommentVC = [[FDSBarCommentViewController alloc] init];
    
    FDSBarPostInfo *tempBar = [[FDSBarPostInfo alloc] init];
    
    NSMutableArray *collectTypeData = [[FDSPublicManage sharePublicManager]getCollectedDataWithType:FDS_COLLECTED_MESSAGE_POSTBAR];
    if (collectTypeData && collectTypeData.count > 0)
    {
        BOOL isExist = NO;
        FDSCollectedInfo *tempCollect = nil;
        for (int ii=0; ii<collectTypeData.count; ii++)
        {
            tempCollect = [collectTypeData objectAtIndex:ii];
            
            if ([barInfo.m_postID isEqualToString:tempCollect.m_collectID])
            {
                isExist = YES;
                break;
            }
        }
        if (isExist)
        {
            tempBar.m_isCollect = YES;
        }
        else
        {
            tempBar.m_isCollect = NO;
        }
    }
    else
    {
        tempBar.m_isCollect = NO;
    }
    
    tempBar.m_postID = barInfo.m_postID; //对应跳到详情页面的ID
    barCommentVC.barPostInfo = tempBar;
    [tempBar release];
    barCommentVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:barCommentVC animated:YES];
    [barCommentVC release];
}

- (void)switchPageDone:(XHADScrollView *)csView atIndex:(NSInteger)index :(UIView*)pageView
{
    
}

@end

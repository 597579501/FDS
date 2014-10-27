//
//  FDSUserCenterViewController.m
//  FDS
//
//  Created by zhuozhongkeji on 14-1-8.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSUserCenterViewController.h"
#import "UIViewController+BarExtension.h"
#import "FDSSettingViewController.h"
#import "FDSCorporateManageViewController.h"
#import "FDSMyFavoritesViewController.h"
#import "FDSMeProfileViewController.h"
#import "FDSMySpaceViewController.h"
#import "FDSLoginViewController.h"
#import "SchemeTableViewCell.h"
#import "FDSUserManager.h"
#import "FDSPublicManage.h"

@interface FDSUserCenterViewController ()

@end

@implementation FDSUserCenterViewController

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

- (void)handlePageShow
{
    BOOL isExistLogin = NO; //是否存在提示登录页面
    NSArray *array = [self.view subviews];
    for (int i = 0; i < [array count]; i++)
    {
        if ([[array objectAtIndex:i] isKindOfClass:[UnLoginView class]])
        {
            isExistLogin = YES;
            break;
        }
    }
    if (USERSTATE_LOGIN == [[FDSUserManager sharedManager] getNowUserState])
    {
        if (isExistLogin)  //存在提示登录页面
        {
            [_unLoginview removeFromSuperview];
        }
        [self homeNavbarWithTitle:@"我" andLeftButtonName:nil andRightButtonName:@"navbar_setting_bg"];
        [_profileTable reloadData];
    }
    else
    {
        if (!isExistLogin)//不存在提示登录页面
        {
            _unLoginview = [[UnLoginView alloc] initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith, kMSTableViewHeight-44-49)];
            _unLoginview.delegate = self;
            [self.view addSubview:_unLoginview];
            [_unLoginview release];
            [self.view bringSubviewToFront:_unLoginview];
        }
        [self homeNavbarWithTitle:@"我" andLeftButtonName:nil andRightButtonName:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[FDSUserCenterMessageManager sharedManager]registerObserver:self];
    [[ZZSessionManager sharedSessionManager] registerObserver:self];
    [self handlePageShow];
    
    enum ZZSessionManagerState state = [[ZZSessionManager sharedSessionManager] getSessionState];
    if (ZZSessionManagerState_NET_FAIL == state)
    {
        [self handeNewWorkShow:YES];
    }
    else
    {
        [self handeNewWorkShow:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[FDSUserCenterMessageManager sharedManager]unRegisterObserver:self];
    [[ZZSessionManager sharedSessionManager] unRegisterObserver:self];
}

-(void)sessionManagerStateNotice:(enum ZZSessionManagerState)sessionManagerState
{
    switch(sessionManagerState)
    {
//        case ZZSessionManagerState_NONE:
        case ZZSessionManagerState_NET_FAIL:
        {
            [self handeNewWorkShow:YES];
        }
            break;
        case ZZSessionManagerState_NET_OK:
        {
            [self handeNewWorkShow:NO];
        }
            break;
        default:
            break;
    }
}

- (void)handeNewWorkShow:(BOOL)show
{
    if (USERSTATE_LOGIN == [[FDSUserManager sharedManager] getNowUserState])
    {
        if (show)
        {
            networkView.hidden = NO;
            _profileTable.frame = CGRectMake(0, kMSNaviHight+40, kMSScreenWith,kMSTableViewHeight-44-49-40);
        }
        else
        {
            networkView.hidden = YES;
            _profileTable.frame = CGRectMake(0, kMSNaviHight, kMSScreenWith,kMSTableViewHeight-44-49);
        }
    }
}

-(void)dealloc
{
    [super dealloc];
}

- (void)netWorkViewInit
{
    /*  网络不可用提示   */
    networkView = [[UIView alloc] initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith, 40)];
    networkView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:networkView];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _profileTable = [[UITableView alloc]initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith,kMSTableViewHeight-44-49) style:UITableViewStylePlain];
    _profileTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _profileTable.delegate = self;
    _profileTable.dataSource = self;
    [self.view addSubview:_profileTable];
    [_profileTable release];
    
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_back"]];
    if ([_profileTable respondsToSelector:@selector(setBackgroundView:)])
    {
        [_profileTable setBackgroundView:backImg];
    }
    [backImg release];
    
    _unLoginview = [[UnLoginView alloc] initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith, kMSTableViewHeight-44-49)];
    _unLoginview.delegate = self;
    [self.view addSubview:_unLoginview];
    [_unLoginview release];
    [self.view bringSubviewToFront:_unLoginview];
    
    [self netWorkViewInit];
	// Do any additional setup after loading the view.
}

- (void)handleRightEvent
{
    FDSSettingViewController *setVC = [[FDSSettingViewController alloc]init];
    setVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setVC animated:YES];
    [setVC release];
}

#pragma mark - FDSUserCenterMessageInterface Method
//自动登录CB
- (void)userLoginCB:(NSString *)result :(NSString *)reason :(FDSUser *)user
{
    if([result isEqualToString:@"OK"])
    {
        [self handlePageShow];
    }
}

#pragma mark - LoginBtnDelegate Method
- (void)didselectLogin
{
    FDSLoginViewController *loginVC = [[FDSLoginViewController alloc]init];
    loginVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginVC animated:YES];
    [loginVC release];
}

#pragma mark - UITableViewDelegate UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            return 130.0f;
        }
        case 1:
        {
            return 162.f;
        }
        default:
            break;
    }
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FDSUser *userInfo = [[FDSUserManager sharedManager] getNowUser];
    if (0 == indexPath.row)
    {
        CommonHeaderTableViewCell *headCell = [[[CommonHeaderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommonHeaderTableViewCell" isAppend:NO isPlat:NO] autorelease];
        [headCell loadCellFrame:userInfo.m_name withDetail:@""];
        if (userInfo.m_company.length == 0 && userInfo.m_job.length == 0)
        {
            headCell.detailLab.text = @"";
        }
        else if(userInfo.m_company.length == 0 && userInfo.m_job.length > 0)
        {
            headCell.detailLab.text = [NSString stringWithFormat:@"%@  %@",@"",userInfo.m_job];
        }
        else if(userInfo.m_company.length > 0 && userInfo.m_job.length == 0)
        {
            headCell.detailLab.text = [NSString stringWithFormat:@"%@  %@",userInfo.m_company,@""];
        }
        else if (userInfo.m_company.length > 0 && userInfo.m_job.length > 0)
        {
            headCell.detailLab.text = [NSString stringWithFormat:@"%@  %@",userInfo.m_company,userInfo.m_job];
        }
        [headCell loadImgView:userInfo.m_icon];

//        UIButton *buttomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        buttomBtn.frame = CGRectMake(0, 0, 300, 100);
//        buttomBtn.tag = 0x01;
//        [buttomBtn addTarget:self action:@selector(handleMoreEvent:) forControlEvents:UIControlEventTouchUpInside];
//        [headCell.bgImg addSubview:buttomBtn];

        return headCell;
    }
    else
    {
        UITableViewCell *buttomDetailCell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"buttomDetailCell"] autorelease];
        UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 152)];
        bgImg.userInteractionEnabled = YES;
        bgImg.image = [[UIImage imageNamed:@"round_white_cellbg"]resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
        [buttomDetailCell.contentView addSubview:bgImg];
        [bgImg release];
        
        //*first*
        UIImageView *logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 16, 18, 18)];
        logoImg.image = [UIImage imageNamed:@"myfavorite_logo_bg"];
        [bgImg addSubview:logoImg];
        [logoImg release];

        UILabel *detailKeyLab = [[UILabel alloc]initWithFrame:CGRectMake(28+10, 5, 60, 40)];
        detailKeyLab.backgroundColor = [UIColor clearColor];
        detailKeyLab.textColor = kMSTextColor;
        detailKeyLab.text = @"我的收藏";
        detailKeyLab.font=[UIFont systemFontOfSize:15];
        [bgImg addSubview:detailKeyLab];
        [detailKeyLab release];
        
        UILabel *detailValueLab = [[UILabel alloc]initWithFrame:CGRectMake(28+10+60, 5, 80, 40)];
        detailValueLab.backgroundColor = [UIColor clearColor];
        detailValueLab.textColor = kMSTextColor;
        detailValueLab.text = [NSString stringWithFormat:@"（ %d ）",[[FDSPublicManage sharePublicManager] getCollectedTotal]];
        detailValueLab.font=[UIFont systemFontOfSize:14];
        [bgImg addSubview:detailValueLab];
        [detailValueLab release];
        
        UIImageView *detailImg = [[UIImageView alloc] initWithFrame:CGRectMake(280, 19, 8, 12)];
        [detailImg setImage:[UIImage imageNamed:@"cell_more_identify_bg"]];
        [bgImg addSubview:detailImg];
        [detailImg release];
        
        UIButton *buttomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        buttomBtn.frame = CGRectMake(0, 0, 300, 50);
        buttomBtn.tag = 0x02;
        [buttomBtn addTarget:self action:@selector(handleMoreEvent:) forControlEvents:UIControlEventTouchUpInside];
        [bgImg addSubview:buttomBtn];

        //line
        UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(1, 50, 298, 1)];
        tmpView.backgroundColor = COLOR(202, 202, 202, 1);
        [bgImg addSubview:tmpView];
        [tmpView release];
        
        /*  sec  */
        logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 16+51, 18, 18)];
        logoImg.image = [UIImage imageNamed:@"mycompany_logo_bg"];
        [bgImg addSubview:logoImg];
        [logoImg release];

        detailKeyLab = [[UILabel alloc]initWithFrame:CGRectMake(28+10, 5+51, 180, 40)];
        detailKeyLab.backgroundColor = [UIColor clearColor];
        detailKeyLab.textColor = kMSTextColor;
        detailKeyLab.text = @"我的企业";
        detailKeyLab.font=[UIFont systemFontOfSize:15];
        [bgImg addSubview:detailKeyLab];
        [detailKeyLab release];
        
        detailImg = [[UIImageView alloc] initWithFrame:CGRectMake(280, 19+51, 8, 12)];
        [detailImg setImage:[UIImage imageNamed:@"cell_more_identify_bg"]];
        [bgImg addSubview:detailImg];
        [detailImg release];
        
        buttomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        buttomBtn.frame = CGRectMake(0, 51, 300, 50);
        buttomBtn.tag = 0x03;
        [buttomBtn addTarget:self action:@selector(handleMoreEvent:) forControlEvents:UIControlEventTouchUpInside];
        [bgImg addSubview:buttomBtn];

        //line
        tmpView = [[UIView alloc] initWithFrame:CGRectMake(1, 101, 298, 1)];
        tmpView.backgroundColor = COLOR(202, 202, 202, 1);
        [bgImg addSubview:tmpView];
        [tmpView release];

        /* Third */
        logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 16+102, 18, 18)];
        logoImg.image = [UIImage imageNamed:@"myspace_logo_bg"];
        [bgImg addSubview:logoImg];
        [logoImg release];
        
        detailKeyLab = [[UILabel alloc]initWithFrame:CGRectMake(28+10, 5+102, 180, 40)];
        detailKeyLab.backgroundColor = [UIColor clearColor];
        detailKeyLab.textColor = kMSTextColor;
        detailKeyLab.text = @"我的动态";
        detailKeyLab.font=[UIFont systemFontOfSize:15];
        [bgImg addSubview:detailKeyLab];
        [detailKeyLab release];
        
        detailImg = [[UIImageView alloc] initWithFrame:CGRectMake(280, 19+102, 8, 12)];
        [detailImg setImage:[UIImage imageNamed:@"cell_more_identify_bg"]];
        [bgImg addSubview:detailImg];
        [detailImg release];
        
        buttomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        buttomBtn.frame = CGRectMake(0, 102, 300, 50);
        buttomBtn.tag = 0x04;
        [buttomBtn addTarget:self action:@selector(handleMoreEvent:) forControlEvents:UIControlEventTouchUpInside];
        [bgImg addSubview:buttomBtn];
        

        buttomDetailCell.backgroundColor = [UIColor clearColor];
        buttomDetailCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return buttomDetailCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        FDSMeProfileViewController *meInfoVC = [[FDSMeProfileViewController alloc]init];
        meInfoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:meInfoVC animated:YES];
        [meInfoVC release];
    }
}

- (void)handleMoreEvent:(id)sender
{
    switch ([sender tag])
    {
        case 0x01:
        {
            FDSMeProfileViewController *meInfoVC = [[FDSMeProfileViewController alloc]init];
            meInfoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:meInfoVC animated:YES];
            [meInfoVC release];
        }
            break;
        case 0x02: //我的收藏
        {
            FDSMyFavoritesViewController *favoriteVC = [[FDSMyFavoritesViewController alloc]init];
            favoriteVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:favoriteVC animated:YES];
            [favoriteVC release];
        }
            break;
        case 0x03://我的企业
        {
            FDSCorporateManageViewController *companyVC = [[FDSCorporateManageViewController alloc]init];
            companyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:companyVC animated:YES];
            [companyVC release];
        }
            break;
        case 0x04: //我的动态
        {
            FDSMySpaceViewController *spaceVC = [[FDSMySpaceViewController alloc]init];
            spaceVC.hidesBottomBarWhenPushed = YES;
            spaceVC.isMeInfo = YES;
            [self.navigationController pushViewController:spaceVC animated:YES];
            [spaceVC release];
        }
            break;
        default:
            break;
    }
}


@end

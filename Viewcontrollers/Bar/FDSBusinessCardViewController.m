//
//  FDSBusinessCardViewController.m
//  FDS
//
//  Created by zhuozhong on 14-2-28.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSBusinessCardViewController.h"
#import "UIViewController+BarExtension.h"
#import "Constants.h"
#import "EGOImageView.h"
#import "FDSPosBarInfoViewController.h"
#import "SVProgressHUD.h"
#import "FDSUserManager.h"
#import "FDSLoginViewController.h"
#import "FDSPublicManage.h"

@interface FDSBusinessCardViewController ()

@end

@implementation FDSBusinessCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.posBarInfo = nil;
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
    self.posBarInfo = nil;
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[FDSBarMessageManager sharedManager]registerObserver:self];
    [[FDSCompanyMessageManager sharedManager] registerObserver:self];

    _followedNumLab.text = self.posBarInfo.m_joinedNumber;
    _posbarNumLab.text = self.posBarInfo.m_postNumber;

    if (self.posBarInfo.m_relation.length <= 0 || [self.posBarInfo.m_relation isEqualToString:@"no"])
    {
        _followImg.image = [UIImage imageNamed:@"follow_posbar_icon"];
        _followLab.text = @"关注";
    }
    else
    {
        _followImg.image = [UIImage imageNamed:@"followed_posbar_icon"];
        _followLab.text = @"已关注";
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[FDSBarMessageManager sharedManager]unRegisterObserver:self];
    [[FDSCompanyMessageManager sharedManager] unRegisterObserver:self];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR(234, 234, 234, 1);
    
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self homeNavbarWithTitle:@"贴吧简介" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    
    EGOImageView *companyLogoImg = [[EGOImageView alloc] initWithFrame:CGRectMake(10, kMSNaviHight+15, 70, 70)];
    companyLogoImg.layer.borderWidth = 1;
    companyLogoImg.layer.cornerRadius = 4.0;
    companyLogoImg.layer.masksToBounds=YES;
    companyLogoImg.layer.borderColor = [[UIColor colorWithRed:242.0f/255 green:242.0f/255 blue:242.0f/255 alpha:1.0f] CGColor];
    [companyLogoImg initWithPlaceholderImage:[UIImage imageNamed:@"posbar_common_load"]];
    companyLogoImg.imageURL = [NSURL URLWithString:self.posBarInfo.m_barIcon];
    companyLogoImg.userInteractionEnabled = YES;
    [self.view addSubview:companyLogoImg];
    [companyLogoImg release];
    
    UILabel *companyNameLab = [[UILabel alloc] initWithFrame:CGRectMake(80+10, kMSNaviHight+5, 235, 60)];
    companyNameLab.backgroundColor = [UIColor clearColor];
    companyNameLab.textColor = COLOR(61, 61, 61, 1);
    companyNameLab.font = [UIFont systemFontOfSize:17.0f];
    companyNameLab.text = self.posBarInfo.m_barName;
    companyNameLab.numberOfLines = 2;
    [self.view addSubview:companyNameLab];
    [companyNameLab release];
    
    /* 关注 帖子  */
    UILabel *followedLab = [[UILabel alloc]initWithFrame:CGRectMake(80+10, kMSNaviHight+60, 35, 20)];
    followedLab.backgroundColor = [UIColor clearColor];
    followedLab.textColor = kMSTextColor;
    followedLab.text = @"关注";
    followedLab.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:followedLab];
    [followedLab release];
    
    _followedNumLab = [[UILabel alloc]initWithFrame:CGRectMake(80+10+35, kMSNaviHight+60, 45, 20)];
    _followedNumLab.backgroundColor = [UIColor clearColor];
    _followedNumLab.textColor = COLOR(233, 172, 136, 1);
    _followedNumLab.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:_followedNumLab];
    [_followedNumLab release];
    
    UILabel *posbarLab = [[UILabel alloc]initWithFrame:CGRectMake(80+10+90, kMSNaviHight+60, 35, 20)];
    posbarLab.backgroundColor = [UIColor clearColor];
    posbarLab.textColor = kMSTextColor;
    posbarLab.text = @"帖子";
    posbarLab.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:posbarLab];
    [posbarLab release];
    
    _posbarNumLab = [[UILabel alloc]initWithFrame:CGRectMake(80+10+125, kMSNaviHight+60, 85, 20)];
    _posbarNumLab.backgroundColor = [UIColor clearColor];
    _posbarNumLab.textColor = COLOR(233, 172, 136, 1);
    _posbarNumLab.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:_posbarNumLab];
    [_posbarNumLab release];

    /* 简介  */
    UILabel *briefLab = [[UILabel alloc] initWithFrame:CGRectMake(10, kMSNaviHight+98, 100, 20)];
    briefLab.backgroundColor = [UIColor clearColor];
    briefLab.textColor = kMSTextColor;
    briefLab.font = [UIFont systemFontOfSize:15.0f];
    briefLab.text = @"简介";
    [self.view addSubview:briefLab];
    [briefLab release];

    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, kMSNaviHight+120, kMSScreenWith-10,kMSTableViewHeight-44-200)];
    bgView.image = [[UIImage imageNamed:@"round_white_cellbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
    [bgView release];
    
    _textview = [[UITextView alloc] initWithFrame:CGRectMake(5, 1, kMSScreenWith-20, kMSTableViewHeight-44-202)];
    _textview.editable = NO;
    _textview.textColor = COLOR(31, 31, 31, 1);
    _textview.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:_textview];
    [_textview release];
    
    /* 关注和进吧按钮  */
    UIView *buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, kMSNaviHight+kMSTableViewHeight-44-60, kMSScreenWith, 60)];
    buttomView.backgroundColor = COLOR(215, 215, 215, 1);
    [self.view addSubview:buttomView];
    [buttomView release];
    
    _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _followBtn.frame = CGRectMake(20, 10, 130, 40);
    [_followBtn setBackgroundImage:[UIImage imageNamed:@"system_agree_normal_bg"] forState:UIControlStateNormal];
    [_followBtn setBackgroundImage:[UIImage imageNamed:@"system_agree_hl_bg"] forState:UIControlStateHighlighted];
    _followBtn.tag = 0x01;
    [_followBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:_followBtn];
    
    _followImg = [[UIImageView alloc] initWithFrame:CGRectMake(35, 10, 20, 20)];
    [_followBtn addSubview:_followImg];
    [_followImg release];
    
    _followLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 6, 50, 30)];
    _followLab.backgroundColor = [UIColor clearColor];
    _followLab.textColor = [UIColor whiteColor];
    _followLab.font = [UIFont systemFontOfSize:16.0f];
    [_followBtn addSubview:_followLab];
    [_followLab release];

    //进吧
    UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    enterBtn.frame = CGRectMake(170, 10, 130, 40);
    [enterBtn setBackgroundImage:[UIImage imageNamed:@"system_agree_normal_bg"] forState:UIControlStateNormal];
    [enterBtn setBackgroundImage:[UIImage imageNamed:@"system_agree_hl_bg"] forState:UIControlStateHighlighted];
    enterBtn.tag = 0x02;
    [enterBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:enterBtn];
    
    UIImageView *enterImg = [[UIImageView alloc] initWithFrame:CGRectMake(35, 10, 20, 20)];
    enterImg.image = [UIImage imageNamed:@"enter_posbar_icon"];
    [enterBtn addSubview:enterImg];
    [enterImg release];
    
    UILabel *enterLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 6, 50, 30)];
    enterLab.backgroundColor = [UIColor clearColor];
    enterLab.textColor = [UIColor whiteColor];
    enterLab.font = [UIFont systemFontOfSize:16.0f];
    enterLab.text = @"进吧";
    [enterBtn addSubview:enterLab];
    [enterLab release];

	// Do any additional setup after loading the view.
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [[FDSBarMessageManager sharedManager]getBarInfo:self.posBarInfo.m_barID];//得到一个贴吧信息
}


- (void)btnPressed:(id)sender
{
    if (0x01 == [sender tag]) //关注
    {
        if(USERSTATE_LOGIN != [[FDSUserManager sharedManager] getNowUserState]) /* 未登录成功 */
        {
            FDSLoginViewController *loginVC = [[FDSLoginViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
            [loginVC release];
            return;
        }
        if ([self.posBarInfo.m_relation isEqualToString:@"no"])
        {
            //发送加入请求
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
            [[FDSCompanyMessageManager sharedManager]joinGroup:@"bar" :self.posBarInfo.m_barID];//”company”,”bar”,”team”
        }
        else
        {
            //发送取消加入请求
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
            [[FDSCompanyMessageManager sharedManager]quitGroup:@"bar" :self.posBarInfo.m_barID];//”company”,”bar”,”team”
        }
    }
    else   //进吧
    {
        FDSPosBarInfoViewController *barVC = [[FDSPosBarInfoViewController alloc] init];
        barVC.lastPageBar = self.posBarInfo;
        if (self.posBarInfo.m_companyID && self.posBarInfo.m_companyID.length > 0)
        {
            barVC.bar_type = BAR_POST_TYPE_COMPANY;
        }
        else
        {
            barVC.bar_type = BAR_POST_TYPE_OTHER;
        }
        [self.navigationController pushViewController:barVC animated:YES];
        [barVC release];
    }
}

#pragma mark - FDSBarMessageInterface Methods
- (void)getBarInfoCB:(FDSPosBar *)posBarInfo
{
    [SVProgressHUD popActivity];
    self.posBarInfo.m_relation = posBarInfo.m_relation;
    self.posBarInfo.m_joinedNumber = posBarInfo.m_joinedNumber;
    self.posBarInfo.m_postNumber = posBarInfo.m_postNumber;
    self.posBarInfo.m_companyID = posBarInfo.m_companyID;
    self.posBarInfo.m_introduce = posBarInfo.m_introduce;
    if ([self.posBarInfo.m_relation isEqualToString:@"no"])
    {
        _followImg.image = [UIImage imageNamed:@"follow_posbar_icon"];
        _followLab.text = @"关注";
    }
    else
    {
        _followImg.image = [UIImage imageNamed:@"followed_posbar_icon"];
        _followLab.text = @"已关注";
    }
    _followedNumLab.text = self.posBarInfo.m_joinedNumber;
    _posbarNumLab.text = self.posBarInfo.m_postNumber;
    _textview.text = self.posBarInfo.m_introduce;
}

#pragma mark - FDSCompanyMessageInterface Method
- (void)joinGroupCB:(NSString *)result :(NSString *)reason
{
    [SVProgressHUD popActivity];
    if ([result isEqualToString:@"OK"])
    {
        NSInteger tempjoinCount = [self.posBarInfo.m_joinedNumber integerValue];
        tempjoinCount+=1;
        self.posBarInfo.m_joinedNumber = [NSString stringWithFormat:@"%d",tempjoinCount];
        self.posBarInfo.m_relation = @"member";
        _followedNumLab.text = self.posBarInfo.m_joinedNumber;
        
        _followImg.image = [UIImage imageNamed:@"followed_posbar_icon"];
        _followLab.text = @"已关注";
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"添加关注失败"];
    }
}

- (void)quitGroupCB:(NSString *)result
{
    [SVProgressHUD popActivity];
    if ([result isEqualToString:@"OK"])
    {
        NSInteger tempjoinCount = [self.posBarInfo.m_joinedNumber integerValue];
        tempjoinCount-=1;
        self.posBarInfo.m_joinedNumber = [NSString stringWithFormat:@"%d",tempjoinCount];
        self.posBarInfo.m_relation = @"no";
        _followedNumLab.text = self.posBarInfo.m_joinedNumber;

        _followImg.image = [UIImage imageNamed:@"follow_posbar_icon"];
        _followLab.text = @"关注";
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"取消关注失败"];
    }
}


@end

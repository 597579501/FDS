//
//  FDSSettingViewController.m
//  FDS
//
//  Created by zhuozhongkeji on 14-1-8.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSSettingViewController.h"
#import "UIViewController+BarExtension.h"
#import "Constants.h"
#import "FDSMsgRemindViewController.h"
#import "FDSFeedToMasterViewController.h"
#import "FDSAboutMeViewController.h"
#import "FDSUserManager.h"
#import "SVProgressHUD.h"
#import "ZZUserDefaults.h"
#import "FDSPublicManage.h"
#import "FDSChangePwdViewController.h"
#import "FDSGuideViewController.h"

@interface FDSSettingViewController ()

@end

@implementation FDSSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.updateURL = nil;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[FDSUserCenterMessageManager sharedManager]registerObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[FDSUserCenterMessageManager sharedManager]unRegisterObserver:self];
}

- (void)dealloc
{
    self.updateURL = nil;

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self homeNavbarWithTitle:@"设置" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _setTable = [[UITableView alloc]initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith,kMSTableViewHeight-44) style:UITableViewStyleGrouped];
    _setTable.delegate = self;
    _setTable.dataSource = self;
    [self.view addSubview:_setTable];
    [_setTable release];
    
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_back"]];
    if ([_setTable respondsToSelector:@selector(setBackgroundView:)])
    {
        [_setTable setBackgroundView:backImg];
    }
    [backImg release];
	// Do any additional setup after loading the view.
}

#pragma mark - UITableViewDelegate UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            return 2;
        }
        case 1:
        {
            return  5;
        }
        default:
            break;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section)
    {
        return 8.0f;
    }
    else
    {
        return 15.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (1 == section)
    {
        return 90.0f;
    }
    else
    {
        return 0.0f;
    }
}

// custom view for footer. will be adjusted to default or specified footer height
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (1 == section)
    {
        UIView* myView = [[[UIView alloc] init] autorelease];
        myView.backgroundColor = [UIColor clearColor];
        UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        logoutBtn.frame = CGRectMake(10, 25, 300, 50);
        [logoutBtn setBackgroundImage:[UIImage imageNamed:@"red_cell_normal_bg"] forState:UIControlStateNormal];
        [logoutBtn setBackgroundImage:[UIImage imageNamed:@"red_cell_hl_bg"] forState:UIControlStateHighlighted];
        [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [logoutBtn setTitleShadowColor:COLOR(173, 22, 18, 1) forState:UIControlStateNormal];
        [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [logoutBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [logoutBtn addTarget:self action:@selector(btnLogoutPressed) forControlEvents:UIControlEventTouchUpInside];
        [myView addSubview:logoutBtn];
        return myView;
    }
    else
    {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"settingTableViewCell";
    SettingTableViewCell *setCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (setCell == nil)
    {
        setCell = [[[SettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    if(0 == indexPath.section)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                setCell.logoImg.image = [UIImage imageNamed:@"set_new_message"];
                setCell.titleTextLab.text = @"新消息提示";
            }
                break;
            case 1:
            {
                setCell.logoImg.image = [UIImage imageNamed:@"set_modify_pwd"];
                setCell.titleTextLab.text = @"修改密码";
            }
                break;
            default:
                break;
        }
    }
    else if(1 == indexPath.section)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                setCell.logoImg.image = [UIImage imageNamed:@"set_promt_sug"];
                setCell.titleTextLab.text = @"站长反馈";
            }
                break;
            case 1:
            {
                setCell.logoImg.image = [UIImage imageNamed:@"set_clear_cache"];
                setCell.titleTextLab.text = @"清除全部缓存";
            }
                break;
            case 2:
            {
                setCell.logoImg.image = [UIImage imageNamed:@"set_welcome_page"];
                setCell.titleTextLab.text = @"欢迎页";
            }
                break;
            case 3:
            {
                setCell.logoImg.image = [UIImage imageNamed:@"set_check_update"];
                setCell.titleTextLab.text = @"检测升级";
            }
                break;
            case 4:
            {
                setCell.logoImg.image = [UIImage imageNamed:@"set_about_me"];
                setCell.titleTextLab.text = @"关于我们";
            }
                break;
            default:
                break;
        }
    }
    return setCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {
        switch (indexPath.row) {
            case 0://新消息提示
            {
                FDSMsgRemindViewController *fdsVC = [[FDSMsgRemindViewController alloc]init];
                [self.navigationController pushViewController:fdsVC animated:YES];
                [fdsVC release];
            }
                break;
            case 1://修改密码
            {
                FDSChangePwdViewController *changePwdVC = [[FDSChangePwdViewController alloc]init];
                [self.navigationController pushViewController:changePwdVC animated:YES];
                [changePwdVC release];
            }
                break;
            default:
                break;
        }
    }
    else if(1 == indexPath.section)
    {
        switch (indexPath.row) {
            case 0://站长反馈
            {
                FDSFeedToMasterViewController *feedPVC = [[FDSFeedToMasterViewController alloc]init];
                [self.navigationController pushViewController:feedPVC animated:YES];
                [feedPVC release];
            }
                break;
            case 1://清空全部缓存
            {
                [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
                [[EGOImageLoader sharedImageLoader]clearAllCache];
                [self performSelector:@selector(updatePage) withObject:nil afterDelay:3.0];
            }
                break;
            case 2://欢迎页
            {
                FDSGuideViewController *guideVC = [[FDSGuideViewController alloc]init];
                [self.navigationController pushViewController:guideVC animated:YES];
                [guideVC release];
            }
                break;
            case 3://检查更新
            {
                [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
                [[FDSUserCenterMessageManager sharedManager] checkVersion];
            }
                break;
            case 4://关于我们
            {
                FDSAboutMeViewController *aboutVC = [[FDSAboutMeViewController alloc]init];
                [self.navigationController pushViewController:aboutVC animated:YES];
                [aboutVC release];
            }
                break;
            default:
                break;
        }
    }
}

- (void)updatePage
{
    [SVProgressHUD popActivity];
    [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"缓存已清除"];
}

- (void)btnLogoutPressed //logout
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定退出登录吗 ?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 0x01;
    [alert show];
    [alert release];
}

#pragma mark - UIAlertViewDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0x01 == alertView.tag && 1 == buttonIndex)
    {
        /* 登出 */
        FDSUser *userInfo = [[FDSUserManager sharedManager]getNowUser];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        [[FDSUserCenterMessageManager sharedManager] userLogout:userInfo.m_userID];
    }
    else if(0x02 == alertView.tag && 1 == buttonIndex)
    {
        /* 更新到最新版本 跳到appStore */
        if (self.updateURL && self.updateURL.length > 0)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateURL]];
        }
    }
}

#pragma mark - FDSUserCenterMessageInterface Method
//用户注销
- (void)userLogoutCB:(NSString*)result
{
    [SVProgressHUD popActivity];
    if ([result isEqualToString:@"OK"])
    {
        [ZZUserDefaults setUserDefault:ISLOGOUT :@"yes"];  //取消默认设置的自动登录
        [[FDSUserManager sharedManager] setNowUserState:USERSTATE_HAVE_ACCOUNT_NO_LOGIN_LOGINOUT];
        [[FDSUserManager sharedManager]getNowUser].m_userID = nil;  //登出后userID置空
        [[FDSPublicManage sharePublicManager]handleLogoutAccount];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"退出登录失败"];
    }
}

- (void)checkVersionCB:(NSString *)version :(NSString *)downloadURL
{
    [SVProgressHUD popActivity];
    
    self.updateURL = downloadURL;
    
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
//    NSString*appName =[infoDict objectForKey:@"CFBundleDisplayName"];
//    NSLog(@"%@",[NSString stringWithFormat:@"程序当前版本%@ app名%@",versionNum,appName]);
    
    if ([version isEqualToString:versionNum])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前已经是最新版本" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"有新版本,是否更新" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 0x02;
        [alert show];
        [alert release];
    }
}

@end

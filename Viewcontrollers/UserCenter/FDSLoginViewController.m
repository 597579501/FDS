//
//  FDSLoginViewController.m
//  FDS
//
//  Created by zhuozhongkeji on 14-1-21.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSLoginViewController.h"
#import "UIViewController+BarExtension.h"
#import "Constants.h"
#import "FDSUserManager.h"
#import "ZZUserDefaults.h"
#import "SVProgressHUD.h"
#import "FDSRegisterViewController.h"
#import "FDSPublicManage.h"
#import "UnderLineButton.h"
#import "FDSForgetPwdViewController.h"

@interface FDSLoginViewController ()

@end

@implementation FDSLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.account = nil;
        self.password = nil;
    }
    return self;
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
    if ([_phoneText isFirstResponder]) {
        [_phoneText resignFirstResponder];
    }
    else if ([_pwdText isFirstResponder]) {
        [_pwdText resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.account = nil;
    self.password = nil;
    [super dealloc];
}

- (void)handleRightEvent
{
    FDSRegisterViewController *registerVC = [[FDSRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
    [registerVC release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self homeNavbarWithTitle:@"登录" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"注册" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont  systemFontOfSize:17.0f];
    rightButton.frame = CGRectMake(0, 0, 51, 44);
    [rightButton addTarget:self action:@selector(handleRightEvent) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* rightButtonItem = [[UIBarButtonItem alloc] init];
    rightButtonItem.customView = rightButton;
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    [rightButtonItem release];

    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    _scrollView = [[MSKeyboardScrollView alloc] initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith, kMSTableViewHeight-44)];
    
    //******手机号 密码******
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25, kMSScreenWith-20, 101)];
    bgView.image = [[UIImage imageNamed:@"round_white_cellbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    bgView.userInteractionEnabled = YES;
    [_scrollView addSubview:bgView];
    [bgView release];
    
    UILabel *tmpLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 50, 40)];
    tmpLab.backgroundColor = [UIColor clearColor];
    tmpLab.textColor = kMSTextColor;
    tmpLab.font=[UIFont systemFontOfSize:15];
    tmpLab.text = @"手机号";
    [bgView addSubview:tmpLab];
    [tmpLab release];
    
    _phoneText = [[UITextField alloc] initWithFrame:CGRectMake(60, 11+KFDSTextOffset, 200, 30)];
    _phoneText.borderStyle = UITextBorderStyleNone;
    _phoneText.placeholder = @"请输入你的手机号";
    _phoneText.text = [[FDSUserManager sharedManager] getNowUser].m_account;
    _phoneText.font = [UIFont systemFontOfSize:16.0f];
    _phoneText.delegate = self;
    _phoneText.returnKeyType = UIReturnKeyDone;
    _phoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [bgView addSubview:_phoneText];
    [_phoneText release];
    
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(1, 50, 298, 1)];
    tmpView.backgroundColor = COLOR(226, 226, 226, 1);
    [bgView addSubview:tmpView];
    [tmpView release];
    
    tmpLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 56, 50, 40)];
    tmpLab.backgroundColor = [UIColor clearColor];
    tmpLab.textColor = kMSTextColor;
    tmpLab.font=[UIFont systemFontOfSize:15];
    tmpLab.text = @"密码";
    [bgView addSubview:tmpLab];
    [tmpLab release];
    
    _pwdText = [[UITextField alloc] initWithFrame:CGRectMake(60, 62+KFDSTextOffset, 200, 30)];
    _pwdText.borderStyle = UITextBorderStyleNone;
    _pwdText.secureTextEntry = YES;
    _pwdText.delegate = self;
    _pwdText.text = [[FDSUserManager sharedManager] getNowUser].m_password;
    _pwdText.placeholder = @"请输入你的密码";
    _pwdText.font = [UIFont systemFontOfSize:16.0f];
    _pwdText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pwdText.returnKeyType = UIReturnKeyDone;
    [bgView addSubview:_pwdText];
    [_pwdText release];
    
    
    //******忘记密码******
    UnderLineButton *forgetBtn = [UnderLineButton underLineButton];
    forgetBtn.frame = CGRectMake(230, 128, 70, 30);
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:COLOR(103, 186, 15, 1) forState:UIControlStateNormal];
    [forgetBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    forgetBtn.tag = 0x01;
    [forgetBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:forgetBtn];
    
    
    //******登录button******
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(10, 188, kMSScreenWith-20, 45);
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"loginbtn_normal_bg"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"loginbtn_hl_bg"] forState:UIControlStateHighlighted];
    loginBtn.tag = 0x02;
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:loginBtn];
    
    _scrollView.backgroundColor = COLOR(234, 234, 234, 1);
    [self.view addSubview:_scrollView];
    [_scrollView release];
    
	// Do any additional setup after loading the view.
}

- (BOOL)isValidLogin
{
    BOOL temp = NO;
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    if (_phoneText.text)
    {
        self.account= [_phoneText.text stringByTrimmingCharactersInSet:whitespace];
        if (0 >= self.account.length)
        {
            [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"账号不能为空"];
            return temp;
        }
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"账号不能为空"];
        return temp;
    }
    if (_pwdText.text)
    {
        self.password = [_pwdText.text stringByTrimmingCharactersInSet:whitespace];
        if (0 >= self.password.length)
        {
            [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"密码不能为空"];
            return temp;
        }
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"密码不能为空"];
        return temp;
    }
    
    temp = YES;
    return temp;
}

- (void)buttonClicked:(id)sender
{
    NSInteger tag = [sender tag];
    if (0x01 == tag)
    {
        FDSForgetPwdViewController *forgotVC = [[FDSForgetPwdViewController alloc] init];
        [self.navigationController pushViewController:forgotVC animated:YES];
        [forgotVC release];
    }
    else if(0x02 == tag)
    {
        if ([_phoneText isFirstResponder]) {
            [_phoneText resignFirstResponder];
        }
        else if ([_pwdText isFirstResponder]) {
            [_pwdText resignFirstResponder];
        }
        if ([self isValidLogin])
        {
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
            [[FDSUserCenterMessageManager sharedManager]userLogin:self.account :self.password];
        }
    }
}


#pragma mark - FDSUserCenterMessageInterface Method
//登录CB
-(void)userLoginCB:(NSString *)result :(NSString *)reason :(FDSUser *)user
{
    [SVProgressHUD popActivity];
    if ([result isEqualToString:@"OK"])
    {
        [ZZUserDefaults setUserDefault:USER_COUNT :self.account];
        [ZZUserDefaults setUserDefault:USER_PASSWORD :self.password];
        [ZZUserDefaults setUserDefault:ISLOGOUT :@"no"];  //默认设置自动登录
        user.m_account = self.account;
        user.m_password = self.password;
        [[FDSUserManager sharedManager]modifyNowUser:user]; //切换账号时应该记住最后一个登录账号信息（账号密码两个字段）
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:[NSString stringWithFormat:@"%@,登录失败",reason]];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end

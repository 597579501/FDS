//
//  FDSVerifyRegisterViewController.m
//  FDS
//
//  Created by zhuozhongkeji on 14-1-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSVerifyRegisterViewController.h"
#import "UIViewController+BarExtension.h"
#import "Constants.h"
#import "SVProgressHUD.h"
#import "ZZUserDefaults.h"
#import "FDSUserManager.h"
#import "FDSPublicManage.h"

@interface FDSVerifyRegisterViewController ()

@end

@implementation FDSVerifyRegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.phoneNumber = nil;
        self.password = nil;
        self.authCode = nil;
        self.timeout = nil;
        isValidauthCode = YES;
        _isRegister = NO;
        self.sessionID = nil;
        _isForget = NO;
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
    if ([_authCodeText isFirstResponder]) {
        [_authCodeText resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_timeLab invalidTime];
    self.phoneNumber = nil;
    self.password = nil;
    self.authCode = nil;
    self.timeout = nil;
    self.sessionID = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self homeNavbarWithTitle:@"填写验证码" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
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
    
    //提示验证码已发送
    UILabel *tmpLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 15, 300, 20)];
    tmpLab.backgroundColor = [UIColor clearColor];
    tmpLab.textColor = kMSTextColor;
    tmpLab.textAlignment = NSTextAlignmentCenter;
    tmpLab.font=[UIFont systemFontOfSize:15];
    tmpLab.text = @"我们已经发送了验证码到你的手机:";
    [_scrollView addSubview:tmpLab];
    [tmpLab release];

    tmpLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 40, 300, 20)];
    tmpLab.backgroundColor = [UIColor clearColor];
    tmpLab.textColor = kMSTextColor;
    tmpLab.textAlignment = NSTextAlignmentCenter;
    tmpLab.font=[UIFont systemFontOfSize:15];
    tmpLab.text = [NSString stringWithFormat:@"+86  %@",self.phoneNumber];
    [_scrollView addSubview:tmpLab];
    [tmpLab release];

    //验证码
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 70, kMSScreenWith-20, 50)];
    bgView.image = [[UIImage imageNamed:@"round_white_cellbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    bgView.userInteractionEnabled = YES;
    [_scrollView addSubview:bgView];
    [bgView release];
    
    _authCodeText = [[UITextField alloc] initWithFrame:CGRectMake(5, 11+KFDSTextOffset, 280, 30)];
    _authCodeText.borderStyle = UITextBorderStyleNone;
    _authCodeText.placeholder = @"请输入手机验证码";
    _authCodeText.keyboardType = UIKeyboardTypeNumberPad;
    _authCodeText.font = [UIFont systemFontOfSize:16.0f];
    _authCodeText.delegate = self;
    [bgView addSubview:_authCodeText];
    [_authCodeText release];
    
    //时间倒计时
    _timeLab = [[TimerLabel alloc]initWithFrame:CGRectMake(5, 130, 300, 20)];
    _timeLab.backgroundColor = [UIColor clearColor];
    _timeLab.textColor = kMSTextColor;
    _timeLab.delegate = self;
    _timeLab.textAlignment = NSTextAlignmentCenter;
    _timeLab.font=[UIFont systemFontOfSize:15];
    [_timeLab updateLabelPerSecondOnBackground:self.timeout]; //服务器返回3600s
//    [_timeLab updateLabelPerSecondOnBackground:@"180"]; //服务器返回180s
    [_scrollView addSubview:_timeLab];
    [_timeLab release];
    
    _scrollView.backgroundColor = COLOR(234, 234, 234, 1);
    [self.view addSubview:_scrollView];
    [_scrollView release];
	// Do any additional setup after loading the view.
}


- (BOOL)isValidauthCode
{
    /*是否有效验证码*/
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    if (_authCodeText.text)
    {
        NSString *authcode = [_authCodeText.text stringByTrimmingCharactersInSet:whitespace];
        if (0 >= authcode.length)
        {
            [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"验证码不能为空"];
            return NO;
        }
        else if (![authcode isEqualToString:self.authCode])
        {
            [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"验证码错误"];
            return NO;
        }
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"验证码不能为空"];
        return NO;
    }
    return YES;
}

- (void)handleRightEvent
{
    if ([_authCodeText isFirstResponder]) {
        [_authCodeText resignFirstResponder];
    }
    /*发送验证码注册*/
    if (!isValidauthCode)
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"验证码已过期,请重新发送获取"];
        return;
    }
    [_timeLab invalidTime];
    _timeLab.hidden = YES;
    if ([self.authCode isEqualToString:@"000000"])//当验证码为000000的时候，则客户端无需要短信验
    {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        if (_isRegister)
        {
            [[FDSUserCenterMessageManager sharedManager]userRegister:self.phoneNumber :self.password :@"" :self.sessionID];
        }
        else
        {
            if (_isForget)
            {
                [[FDSUserCenterMessageManager sharedManager]modifyNewPassword:self.sessionID :self.authCode :self.password :self.phoneNumber];
            }
            else
            {
                [[FDSUserCenterMessageManager sharedManager]modifyNewPassword:self.sessionID :self.authCode :self.password];
            }
        }
    }
    else if ([self isValidauthCode])  //验证码有效且未过期
    {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        if (_isRegister)
        {
            [[FDSUserCenterMessageManager sharedManager]userRegister:self.phoneNumber :self.password :self.authCode :self.sessionID];
        }
        else
        {
            if (_isForget)
            {
                [[FDSUserCenterMessageManager sharedManager]modifyNewPassword:self.sessionID :self.authCode :self.password :self.phoneNumber];
            }
            else
            {
                [[FDSUserCenterMessageManager sharedManager]modifyNewPassword:self.sessionID :self.authCode :self.password];
            }
        }
    }
}


#pragma mark - TimerLabelDelegate Method
- (void)comebackaction
{
    /* 限定时间时间到了*/
    isValidauthCode = NO;
    [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"验证码已过期"];
}

#pragma mark - UITextFieldDelegate Method
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_scrollView adjustOffsetToIdealIfNeeded];
}

//如果输入超过规定的字数10，就不再让输入
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 10)
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"最多只能输入10位数字验证码"];
        return  NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark - FDSUserCenterMessageInterface Method
//发送验证码注册
- (void)userRegisterCB:(NSString*)result;
{
    [SVProgressHUD popActivity];
    if ([result isEqualToString:@"OK"])
    {
        /* 注册成功后做自动登录*/
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        [[FDSUserCenterMessageManager sharedManager]userLogin:self.phoneNumber :self.password];
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"注册时发送验证码失败"];
    }
}

- (void)modifyNewPasswordCB:(NSString *)result :(NSString *)reason
{
    [SVProgressHUD popActivity];
    if ([result isEqualToString:@"OK"])
    {
        /* 更改密码成功后做自动登录*/
        if (!_isForget)
        {
            [ZZUserDefaults setUserDefault:USER_PASSWORD :self.password];
            [ZZUserDefaults setUserDefault:ISLOGOUT :@"no"];  //默认设置自动登录
            [[FDSUserManager sharedManager] getNowUser].m_password = self.password; //切换账号时应该记住最后一个登录账号信息（账号密码两个字段）
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            /*   忘记密码  */
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
            [[FDSUserCenterMessageManager sharedManager]userLogin:self.phoneNumber :self.password];
        }
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:[NSString stringWithFormat:@"%@,修改新密码失败",reason]];
    }
}

-(void)userLoginCB:(NSString *)result :(NSString *)reason :(FDSUser *)user
{
    //登录CB
    [SVProgressHUD popActivity];
    if ([result isEqualToString:@"OK"])
    {
        [ZZUserDefaults setUserDefault:USER_COUNT :self.phoneNumber];
        [ZZUserDefaults setUserDefault:USER_PASSWORD :self.password];
        [ZZUserDefaults setUserDefault:ISLOGOUT :@"no"];  //默认设置自动登录
        user.m_account = self.phoneNumber;
        user.m_password = self.password;
        [[FDSUserManager sharedManager]modifyNowUser:user]; //切换账号时应该记住最后一个登录账号信息（账号密码两个字段）
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:[NSString stringWithFormat:@"%@,自动登录失败",reason]];
    }
}



@end

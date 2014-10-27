//
//  FDSChangePwdViewController.m
//  FDS
//
//  Created by zhuozhongkeji on 14-1-9.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSChangePwdViewController.h"
#import "UIViewController+BarExtension.h"
#import "Constants.h"
#import "FDSPublicManage.h"
#import "FDSUserManager.h"
#import "SVProgressHUD.h"
#import "FDSPublicManage.h"
#import "FDSVerifyRegisterViewController.h"

@interface FDSChangePwdViewController ()

@end

@implementation FDSChangePwdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.newPassword = nil;
        self.sessionID = nil;
        self.phoneNum = nil;
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
    self.phoneNum = nil;
    self.newPassword = nil;
    self.sessionID = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = COLOR(234, 234, 234, 1);
    [self homeNavbarWithTitle:@"更改密码" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UILabel *tmpLab = [[UILabel alloc]initWithFrame:CGRectMake(12, kMSNaviHight+20, 300, 30)];
    tmpLab.backgroundColor = [UIColor clearColor];
    tmpLab.textColor = kMSTextColor;
    tmpLab.font=[UIFont systemFontOfSize:15];
    tmpLab.text = @"修改密码前请确保您的手机能接收到验证码";
    [self.view addSubview:tmpLab];
    [tmpLab release];

    //******手机号 密码******
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, kMSNaviHight+50, kMSScreenWith-20, 101)];
    bgView.image = [[UIImage imageNamed:@"round_white_cellbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
    [bgView release];
    
//    tmpLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 50, 40)];
//    tmpLab.backgroundColor = [UIColor clearColor];
//    tmpLab.textColor = kMSTextColor;
//    tmpLab.font=[UIFont systemFontOfSize:15];
//    tmpLab.text = @"原密码:";
//    [bgView addSubview:tmpLab];
//    [tmpLab release];
//    
//    _oldPwd = [[UITextField alloc] initWithFrame:CGRectMake(60, 11+KFDSTextOffset, 200, 30)];
//    _oldPwd.borderStyle = UITextBorderStyleNone;
//    _oldPwd.placeholder = @"请输入你的原密码";
//    _oldPwd.secureTextEntry = YES;
//    _oldPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
//    _oldPwd.font = [UIFont systemFontOfSize:16.0f];
//    _oldPwd.delegate = self;
//    [bgView addSubview:_oldPwd];
//    [_oldPwd release];
//    
//    /****new****/
//    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(1, 50, 298, 1)];
//    tmpView.backgroundColor = COLOR(226, 226, 226, 1);
//    [bgView addSubview:tmpView];
//    [tmpView release];
    
    tmpLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 56-51, 50, 40)];
    tmpLab.backgroundColor = [UIColor clearColor];
    tmpLab.textColor = kMSTextColor;
    tmpLab.font=[UIFont systemFontOfSize:15];
    tmpLab.text = @"新密码:";
    [bgView addSubview:tmpLab];
    [tmpLab release];
    
    _newPwd = [[UITextField alloc] initWithFrame:CGRectMake(60, 62+KFDSTextOffset-51, 200, 30)];
    _newPwd.borderStyle = UITextBorderStyleNone;
    _newPwd.secureTextEntry = YES;
    _newPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    _newPwd.delegate = self;
    _newPwd.placeholder = @"请输入你的新密码";
    _newPwd.font = [UIFont systemFontOfSize:16.0f];
    [bgView addSubview:_newPwd];
    [_newPwd release];

    /****repeat new pwd****/
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(1, 101-51, 298, 1)];
    tmpView.backgroundColor = COLOR(226, 226, 226, 1);
    [bgView addSubview:tmpView];
    [tmpView release];
    
    tmpLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 107-51, 90, 40)];
    tmpLab.backgroundColor = [UIColor clearColor];
    tmpLab.textColor = kMSTextColor;
    tmpLab.font=[UIFont systemFontOfSize:15];
    tmpLab.text = @"重复新密码:";
    [bgView addSubview:tmpLab];
    [tmpLab release];
    
    _repeatNewPwd = [[UITextField alloc] initWithFrame:CGRectMake(100, 112+KFDSTextOffset-51, 180, 30)];
    _repeatNewPwd.borderStyle = UITextBorderStyleNone;
    _repeatNewPwd.secureTextEntry = YES;
    _repeatNewPwd.delegate = self;
    _repeatNewPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    _repeatNewPwd.placeholder = @"请输入你的新密码";
    _repeatNewPwd.font = [UIFont systemFontOfSize:16.0f];
    [bgView addSubview:_repeatNewPwd];
    [_repeatNewPwd release];

    /****确定****/
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(10, kMSNaviHight+232-51, kMSScreenWith-20, 45);
    [okBtn setBackgroundImage:[UIImage imageNamed:@"loginbtn_normal_bg"] forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage imageNamed:@"loginbtn_hl_bg"] forState:UIControlStateHighlighted];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [okBtn addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGes:)];
    tap.cancelsTouchesInView=NO;
    [self.view addGestureRecognizer:tap];
    [tap release];
	// Do any additional setup after loading the view.
}

- (void)handleGes:(UIGestureRecognizer *)guestureRecognizer
{
//    if ([_oldPwd isFirstResponder] )
//    {
//        [_oldPwd resignFirstResponder];
//    }
    if([_newPwd isFirstResponder])
    {
        [_newPwd resignFirstResponder];
    }
    else if([_repeatNewPwd isFirstResponder])
    {
        [_repeatNewPwd resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)isValidHChangePwd
{
    BOOL temp = NO;
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
//    if (_oldPwd.text)
//    {
//        NSString *oldpwd= [_oldPwd.text stringByTrimmingCharactersInSet:whitespace];
//        if (0 >= oldpwd.length)
//        {
//            [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"原密码不能为空"];
//            return temp;
//        }
//        
//        else if(![oldpwd isEqualToString:[[FDSUserManager sharedManager]getNowUser].m_password])
//        {
//            [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"原密码输入错误"];
//            return temp;
//        }
//    }
//    else
//    {
//        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"原密码不能为空"];
//        return temp;
//    }
    
    NSString *password = nil;
    if (_newPwd.text)
    {
        password = [_newPwd.text stringByTrimmingCharactersInSet:whitespace];
        if (0 >= password.length)
        {
            [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"新密码不能为空"];
            return temp;
        }
        else if(password.length < 6)
        {
            [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"新密码不能少于6位"];
            return temp;
        }
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"新密码不能为空"];
        return temp;
    }
    
    if (_repeatNewPwd.text)
    {
        self.newPassword = [_repeatNewPwd.text stringByTrimmingCharactersInSet:whitespace];
        if (0 >= self.newPassword.length)
        {
            [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"重复新密码不能为空"];
            return temp;
        }
        else if(![self.newPassword isEqualToString:password])
        {
            [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"两次新密码输入不相同"];
            return temp;
        }
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"重复新密码不能为空"];
        return temp;
    }
    
    return YES;
}

- (void)buttonClicked
{
    if ([self isValidHChangePwd])
    {
        self.sessionID = [[FDSPublicManage sharePublicManager] getGUID];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        if (self.phoneNum)
        {
            [[FDSUserCenterMessageManager sharedManager]modifyPassword:self.sessionID :self.phoneNum];
        }
        else
        {
            [[FDSUserCenterMessageManager sharedManager]modifyPassword:self.sessionID];
        }
    }
}

- (void)modifyPasswordCB:(NSString *)result :(NSString *)authCode :(NSString *)timeout :(NSString *)sessionID
{
    [SVProgressHUD popActivity];
    
    if ([result isEqualToString:@"OK"])
    {
        FDSVerifyRegisterViewController *verifyVC = [[FDSVerifyRegisterViewController alloc] init];
        verifyVC.sessionID = self.sessionID;
        verifyVC.authCode = authCode;
        verifyVC.timeout = timeout;
        verifyVC.isRegister = NO;
        verifyVC.password = self.newPassword;
        if (self.phoneNum)
        {
            verifyVC.phoneNumber = self.phoneNum;
            verifyVC.isForget = YES;
        }
        else
        {
            verifyVC.phoneNumber = [[FDSUserManager sharedManager] getNowUser].m_account;
            verifyVC.isForget = NO;
        }
        
        [self.navigationController pushViewController:verifyVC animated:YES];
        [verifyVC release];
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"更改密码失败"];
    }
}




@end

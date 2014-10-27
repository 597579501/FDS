//
//  FDSRegisterViewController.m
//  FDS
//
//  Created by zhuozhongkeji on 14-1-21.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSRegisterViewController.h"
#import "UIViewController+BarExtension.h"
#import "Constants.h"
#import "FDSUserManager.h"
#import "ZZUserDefaults.h"
#import "SVProgressHUD.h"
#import "FDSVerifyRegisterViewController.h"
#import "FDSPublicManage.h"
#import "FDSAgreementViewController.h"

@interface FDSRegisterViewController ()

@end

@implementation FDSRegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.account = nil;
        self.password = nil;
        self.sessionID = nil;
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
    self.sessionID = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self homeNavbarWithTitle:@"注册" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
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
        
    _phoneText = [[UITextField alloc] initWithFrame:CGRectMake(5, 11+KFDSTextOffset, 280, 30)];
    _phoneText.borderStyle = UITextBorderStyleNone;
    _phoneText.placeholder = @"请输入你的手机号";
    _phoneText.keyboardType = UIKeyboardTypeNumberPad;
    _phoneText.font = [UIFont systemFontOfSize:16.0f];
    _phoneText.delegate = self;
    _pwdText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [bgView addSubview:_phoneText];
    [_phoneText release];
    
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(1, 50, 298, 1)];
    tmpView.backgroundColor = COLOR(226, 226, 226, 1);
    [bgView addSubview:tmpView];
    [tmpView release];
    
    _pwdText = [[UITextField alloc] initWithFrame:CGRectMake(5, 62+KFDSTextOffset, 280, 30)];
    _pwdText.borderStyle = UITextBorderStyleNone;
    _pwdText.secureTextEntry = YES;
    _pwdText.delegate = self;
    _pwdText.placeholder = @"请设置密码（6-14位,字母区分大小写）";
    _pwdText.font = [UIFont systemFontOfSize:16.0f];
    _pwdText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [bgView addSubview:_pwdText];
    [_pwdText release];
    
    //******阅读操作等协议******
    UIView *userAgreeView = [[UIView alloc] initWithFrame:CGRectMake(10, 138, kMSScreenWith-20, 40)];
    userAgreeView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:userAgreeView];
    [userAgreeView release];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 10, 18, 18);
    btn.tag = 0x01;
    [btn setBackgroundImage:[UIImage imageNamed:@"select_btn_bg"] forState:UIControlStateNormal];
    btn.adjustsImageWhenHighlighted = NO;
    [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [userAgreeView addSubview:btn];
    
    UILabel *tmpLab = [[UILabel alloc]initWithFrame:CGRectMake(23, 9, 173, 20)];
    tmpLab.backgroundColor = [UIColor clearColor];
    tmpLab.textColor = kMSTextColor;
    tmpLab.font=[UIFont systemFontOfSize:13];
    tmpLab.text = @"已阅读并同意欧碧乐";
    [userAgreeView addSubview:tmpLab];
    [tmpLab release];
    
    UILabel *serverLab = [[UILabel alloc] initWithFrame:CGRectMake(196-55, 9, 90, 20)];
    serverLab.backgroundColor = [UIColor clearColor];
    serverLab.textColor = COLOR(221, 146, 85, 1);
    serverLab.font=[UIFont systemFontOfSize:13];
    serverLab.text = @"注册使用协议";
    [userAgreeView addSubview:serverLab];
    [serverLab release];
    
    UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeBtn.frame = CGRectMake(196-50, 6, 100, 30);
    agreeBtn.tag = 0x03;
    [agreeBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [userAgreeView addSubview:agreeBtn];

    //******注册button******
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(10, 188, kMSScreenWith-20, 45);
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"registerbtn_normal_bg"] forState:UIControlStateNormal];
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"registerbtn_hl_bg"] forState:UIControlStateHighlighted];
    registerBtn.tag = 0x02;
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [registerBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:registerBtn];
    
    _scrollView.backgroundColor = COLOR(234, 234, 234, 1);
    [self.view addSubview:_scrollView];
    [_scrollView release];
    
	// Do any additional setup after loading the view.
}

- (BOOL)isValidRegister
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
        else if(self.account.length != 11)
        {
            [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"请输入11位的手机号码"];
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
        else if(self.password.length < 6)
        {
            [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"密码不能少于6位"];
            return temp;
        }
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"密码不能为空"];
        return temp;
    }
    
    UIButton *currBtn = (UIButton*)[_scrollView viewWithTag:0x01];
    if ([currBtn currentBackgroundImage] == [UIImage imageNamed:@"unselect_btn_bg"])
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"请先阅读高尔夫门户用户服务协议"];
    }
    else
    {
        temp = YES;
    }
    return temp;
}

- (void)buttonClicked:(id)sender
{
    NSInteger tag = [sender tag];
    if (0x01 == tag)
    {
        UIButton *currBtn = (UIButton*)sender;
        if ([currBtn currentBackgroundImage] == [UIImage imageNamed:@"select_btn_bg"])
        {
            [currBtn setBackgroundImage:[UIImage imageNamed:@"unselect_btn_bg"] forState:UIControlStateNormal];
        }
        else
        {
            [currBtn setBackgroundImage:[UIImage imageNamed:@"select_btn_bg"] forState:UIControlStateNormal];
        }
    }
    else if(0x02 == tag)
    {
        if ([_phoneText isFirstResponder]) {
            [_phoneText resignFirstResponder];
        }
        else if ([_pwdText isFirstResponder]) {
            [_pwdText resignFirstResponder];
        }
        if ([self isValidRegister])
        {
            self.sessionID = [[FDSPublicManage sharePublicManager] getGUID];
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
            [[FDSUserCenterMessageManager sharedManager]userRegisterRequest:self.account :self.sessionID];
        }
    }
    else
    {
        FDSAgreementViewController *agreeVC = [[FDSAgreementViewController alloc] init];
        [self.navigationController pushViewController:agreeVC animated:YES];
        [agreeVC release];
    }
}


#pragma mark - FDSUserCenterMessageInterface Method
//注册获取验证码
- (void)userRegisterRequestCB:(NSString*)result :(NSString*)authCode :(NSString*)timeout
{
    [SVProgressHUD popActivity];
    if ([result isEqualToString:@"OK"])
    {
        FDSVerifyRegisterViewController *verifyVC = [[FDSVerifyRegisterViewController alloc] init];
        verifyVC.phoneNumber = self.account;
        verifyVC.password = self.password;
        verifyVC.sessionID = self.sessionID;
        verifyVC.authCode = authCode;
        verifyVC.timeout = timeout;
        verifyVC.isRegister = YES;
        [self.navigationController pushViewController:verifyVC animated:YES];
        [verifyVC release];
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"该手机号已经注册"];
    }
}


#pragma mark - UITextFieldDelegate Method
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_scrollView adjustOffsetToIdealIfNeeded];
}

//如果输入超过规定的字数KMSMAXLENGTH，就不再让输入
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger maxLength;
    if (_phoneText == textField)
    {
        maxLength = 11;
    }
    else
    {
        maxLength = 14;
    }
    if (range.location >= maxLength)
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:[NSString stringWithFormat:@"最多只能输入%d字数",maxLength]];
        return  NO;
    }
    else
    {
        return YES;
    }
}



@end

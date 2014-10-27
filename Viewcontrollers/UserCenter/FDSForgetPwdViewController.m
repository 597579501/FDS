//
//  FDSForgetPwdViewController.m
//  FDS
//
//  Created by zhuozhong on 14-4-8.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSForgetPwdViewController.h"
#import "Constants.h"
#import "UIViewController+BarExtension.h"
#import "FDSChangePwdViewController.h"
#import "FDSPublicManage.h"


@interface FDSForgetPwdViewController ()

@end

@implementation FDSForgetPwdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.phoneNum = nil;
    }
    return self;
}

- (void)dealloc
{
    self.phoneNum = nil;
    [super dealloc];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.phoneText resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    [self homeNavbarWithTitle:@"忘记密码" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith, kMSTableViewHeight-44)];
    scrollView.backgroundColor = COLOR(234, 234, 234, 1);
    [self.view addSubview:scrollView];
    [scrollView release];
    
    UILabel *tmpLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 300, 25)];
    tmpLab.backgroundColor = [UIColor clearColor];
    tmpLab.textColor = COLOR(69, 69, 69, 1);
    tmpLab.font=[UIFont systemFontOfSize:15];
    tmpLab.text = @"请输入忘记密码的手机号码";
    [scrollView addSubview:tmpLab];
    [tmpLab release];
    
    /*   手机号    */
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 35, kMSScreenWith-20, 50)];
    bgView.image = [[UIImage imageNamed:@"round_white_cellbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    bgView.userInteractionEnabled = YES;
    [scrollView addSubview:bgView];
    [bgView release];
    
    tmpLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 65, 40)];
    tmpLab.backgroundColor = [UIColor clearColor];
    tmpLab.textColor = COLOR(69, 69, 69, 1);
    tmpLab.font=[UIFont systemFontOfSize:15];
    tmpLab.text = @"手机号码:";
    [bgView addSubview:tmpLab];
    [tmpLab release];
    
    _phoneText = [[UITextField alloc] initWithFrame:CGRectMake(80, 11+KFDSTextOffset, 200, 30)];
    _phoneText.borderStyle = UITextBorderStyleNone;
    _phoneText.placeholder = @"请输入手机号";
    _phoneText.font = [UIFont systemFontOfSize:16.0f];
    _phoneText.delegate = self;
    _phoneText.returnKeyType = UIReturnKeyDone;
    _phoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [bgView addSubview:_phoneText];
    [_phoneText release];
    [_phoneText becomeFirstResponder];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(15, 25+50+30, kMSScreenWith-30, 45);
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"loginbtn_normal_bg"] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"loginbtn_hl_bg"] forState:UIControlStateHighlighted];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [nextBtn addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:nextBtn];
	// Do any additional setup after loading the view.
}


- (void)buttonClicked
{
    [_phoneText resignFirstResponder];
    
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    if (_phoneText.text)
    {
        self.phoneNum= [_phoneText.text stringByTrimmingCharactersInSet:whitespace];
        if (0 >= self.phoneNum.length)
        {
            [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"手机号不能为空"];
            return ;
        }
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"手机号不能为空"];
        return ;
    }
    
    FDSChangePwdViewController *changeVC = [[FDSChangePwdViewController alloc] init];
    changeVC.phoneNum = self.phoneNum;
    [self.navigationController pushViewController:changeVC animated:YES];
    [changeVC release];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}




@end

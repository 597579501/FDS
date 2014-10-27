//
//  FDSFeedToMasterViewController.m
//  FDS
//
//  Created by zhuozhongkeji on 14-1-10.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSFeedToMasterViewController.h"
#import "UIViewController+BarExtension.h"
#import "Constants.h"
#import "FDSPublicManage.h"
#import "SVProgressHUD.h"

#define KMSMAXMESSAGELENGTH 200

@interface FDSFeedToMasterViewController ()

@end

@implementation FDSFeedToMasterViewController

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
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self homeNavbarWithTitle:@"站长反馈" andLeftButtonName:@"btn_caculate" andRightButtonName:@"发送"];
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _scrollView = [[MSKeyboardScrollView alloc] initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith, kMSTableViewHeight-44)];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, kMSScreenWith-20, 125)];
    bgView.image = [[UIImage imageNamed:@"round_white_cellbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    bgView.userInteractionEnabled = YES;
    
    _sugTextView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(5, 5, kMSScreenWith-30, 100)];
    _sugTextView.placeholder = @"请留下您的宝贵意见";
    _sugTextView.delegate = self;
    _sugTextView.font = [UIFont systemFontOfSize:16.0f];
    [bgView addSubview:_sugTextView];
    [_sugTextView release];
    
    numLab = [[UILabel alloc]initWithFrame:CGRectMake(110, 105, 180, 20)];
    numLab.textAlignment = NSTextAlignmentRight;
    numLab.backgroundColor = [UIColor clearColor];
    numLab.textColor = kMSTextColor;
    numLab.font=[UIFont systemFontOfSize:15];
    numLab.text = [NSString stringWithFormat:@"%d/%d",0,KMSMAXMESSAGELENGTH];
    [bgView addSubview:numLab];
    [numLab release];

    
    [_scrollView addSubview:bgView];
    [bgView release];
    
    //手机号
    bgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 145, kMSScreenWith-20, 50)];
    bgView.image = [[UIImage imageNamed:@"round_white_cellbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    bgView.userInteractionEnabled = YES;
    
    _emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 15, kMSScreenWith-30, 30)];
    _emailTextField.placeholder = @"手机号／Email: 方便我们及时给您回复";
    _emailTextField.delegate = self;
    _emailTextField.font = [UIFont systemFontOfSize:16.0f];
    [bgView addSubview:_emailTextField];
    [_emailTextField release];
    
    [_scrollView addSubview:bgView];
    [bgView release];
    
    _scrollView.backgroundColor = COLOR(234, 234, 234, 1);
    [self.view addSubview:_scrollView];
    [_scrollView release];
	// Do any additional setup after loading the view.
}

#pragma mark - UITextFieldDelegate Method
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_scrollView adjustOffsetToIdealIfNeeded];
}

/*   发送操作  */
- (void)handleRightEvent
{
    [_sugTextView resignFirstResponder];
    [_emailTextField resignFirstResponder];
    NSString *suggest = nil;
    NSString *email = nil;
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    if (_sugTextView.text)
    {
        suggest = [_sugTextView.text stringByTrimmingCharactersInSet:whitespace];
        if (0 >= suggest.length)
        {
            [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"意见不能为空"];
            return ;
        }
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"意见不能为空"];
        return ;
    }
    
    if (_emailTextField.text)
    {
        email = [_emailTextField.text stringByTrimmingCharactersInSet:whitespace];
        if (0 >= email.length)
        {
            [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"邮箱或手机号不能为空"];
            return ;
        }
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"邮箱或手机号不能为空"];
        return ;
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [[FDSUserCenterMessageManager sharedManager]feedback:suggest :email];
}


- (void)feedbackCB:(NSString *)result
{
    [SVProgressHUD popActivity];
    if ([result isEqualToString:@"OK"])
    {
        _sugTextView.text = nil;
        _emailTextField.text = nil;
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"反馈成功"];
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"反馈失败"];
    }
}

//在这个地方计算输入的字数
- (void)textViewDidChange:(UITextView *)textView
{
    int existTextNum = [textView.text length];
    numLab.text = [NSString stringWithFormat:@"%d/%d",existTextNum,KMSMAXMESSAGELENGTH];
}

//如果输入超过规定的字数KMSMAXLENGTH，就不再让输入
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location >= KMSMAXMESSAGELENGTH)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"最多只能输入%d字数",KMSMAXMESSAGELENGTH] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return  NO;
    }
    else
    {
        return YES;
    }
}

// return NO to not change text
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 50)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"最多只能输入%d字数",50] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return  NO;
    }
    else
    {
        return YES;
    }
}


@end

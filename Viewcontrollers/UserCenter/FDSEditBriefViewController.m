//
//  FDSEditBriefViewController.m
//  FDS
//
//  Created by zhuozhongkeji on 14-1-23.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSEditBriefViewController.h"
#import "UIViewController+BarExtension.h"
#import "FDSUserManager.h"
#import "SVProgressHUD.h"
#import "FDSPublicManage.h"

#define KMSMAXLENGTH  200

@interface FDSEditBriefViewController ()

@end

@implementation FDSEditBriefViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.modifyContent = nil;
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
    [_dataField becomeFirstResponder];
    [[FDSUserCenterMessageManager sharedManager]registerObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([_dataField isFirstResponder])
    {
        [_dataField resignFirstResponder];
    }
    [[FDSUserCenterMessageManager sharedManager]unRegisterObserver:self];
}

- (void)dealloc
{
    self.modifyContent = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self homeNavbarWithTitle:@"个人简介" andLeftButtonName:@"btn_caculate" andRightButtonName:@"navbar_profile_send_bg"];
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _scrollView = [[MSKeyboardScrollView alloc] initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith, kMSTableViewHeight-44)];

    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, kMSScreenWith-20, 150)];
    bgView.image = [[UIImage imageNamed:@"round_white_cellbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    bgView.userInteractionEnabled = YES;
    [_scrollView addSubview:bgView];
    [bgView release];
    
    NSString *brief = [[FDSUserManager sharedManager] getNowUser].m_brief;
    
    _dataField = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(5, 5, 290, 125)];
    _dataField.font = [UIFont systemFontOfSize:15.0f];
    _dataField.textColor = kMSTextColor;
    _dataField.text = brief;
    _dataField.delegate = self;
    [bgView addSubview:_dataField];
    [_dataField release];
    
    _numLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 130, 190, 20)];
    _numLab.textAlignment = NSTextAlignmentRight;
    _numLab.backgroundColor = [UIColor clearColor];
    _numLab.textColor = kMSTextColor;
    _numLab.font=[UIFont systemFontOfSize:15];
    _numLab.text = [NSString stringWithFormat:@"%d/%d",brief.length,KMSMAXLENGTH];
    [bgView addSubview:_numLab];
    [_numLab release];
    
    _scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_back"]];
    [self.view addSubview:_scrollView];
    [_scrollView release];
	// Do any additional setup after loading the view.
}

-(void)handleRightEvent
{
    BOOL isBack = YES;
    FDSUser *userInfo = [[FDSUserManager sharedManager]getNowUser];
    if (userInfo.m_userID && userInfo.m_userID.length > 0)
    {
        NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        if (_dataField.text)
        {
            self.modifyContent = [_dataField.text stringByTrimmingCharactersInSet:whitespace];
            if (self.modifyContent.length > 0 && ![self.modifyContent isEqualToString:userInfo.m_brief]) //修改为不同原来内容才发送
            {
                isBack = NO;
                [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
                [[FDSUserCenterMessageManager sharedManager]modifyUserCard:userInfo.m_userID :self.modifyContent :MODIFY_PROFILE_BRIEF];
            }
        }
    }
    if (isBack)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - FDSUserCenterMessageInterface Method
//修改个人名片
- (void)modifyUserCardCB:(NSString*)result
{
    [SVProgressHUD popActivity];
    if ([result isEqualToString:@"OK"])
    {
//        FDSUser *m_user = [[FDSUser alloc] init];
//        m_user.m_brief = self.modifyContent;
//        [[FDSUserManager sharedManager] modifyNowUser:m_user];
//        [m_user release];
        [[FDSUserManager sharedManager]setNowUserWithStyle:MODIFY_PROFILE_BRIEF withContext:self.modifyContent];
        if ([self.delegate respondsToSelector:@selector(didRefreshCurrPage)])
        {
            [self.delegate didRefreshCurrPage];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"修改个人简介失败"];
    }
}

#pragma mark - UITextViewDelegate Methods
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [_scrollView adjustOffsetToIdealIfNeeded];
}

//在这个地方计算输入的字数
- (void)textViewDidChange:(UITextView *)textView
{
    int existTextNum = [textView.text length];
    _numLab.text = [NSString stringWithFormat:@"%d/%d",existTextNum,KMSMAXLENGTH];
}

//如果输入超过规定的字数KMSMAXLENGTH，就不再让输入
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location >= KMSMAXLENGTH)
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:[NSString stringWithFormat:@"最多只能输入%d字数",KMSMAXLENGTH]];
        return  NO;
    }
    else
    {
        return YES;
    }
}

@end

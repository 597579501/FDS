//
//  FDSEditProfileViewController.m
//  FDS
//
//  Created by zhuozhongkeji on 14-1-22.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSEditProfileViewController.h"
#import "UIViewController+BarExtension.h"
#import "Constants.h"
#import "FDSUserManager.h"
#import "SVProgressHUD.h"
#import "FDSPublicManage.h"

@interface FDSEditProfileViewController ()

@end

@implementation FDSEditProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.titleStr = nil;
        self.contentStr = nil;
        self.modifyContent = nil;
        self.modifyStyle = MODIFY_PROFILE_NONE;
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
    self.titleStr = nil;
    self.contentStr = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self homeNavbarWithTitle:_titleStr andLeftButtonName:@"btn_caculate" andRightButtonName:@"navbar_profile_send_bg"];
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _scrollView = [[MSKeyboardScrollView alloc] initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith, kMSTableViewHeight-44)];

    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, kMSScreenWith-20, 50)];
    bgView.image = [[UIImage imageNamed:@"round_white_cellbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    bgView.userInteractionEnabled = YES;
    [_scrollView addSubview:bgView];
    [bgView release];
    
    _dataField = [[UITextField alloc] initWithFrame:CGRectMake(5, 10+KFDSTextOffset, 290, 30)];
    _dataField.delegate = self;
    if (MODIFY_PROFILE_HANDICAP == self.modifyStyle || MODIFY_PROFILE_GOLFAGE == self.modifyStyle)
    {
        _dataField.keyboardType = UIKeyboardTypeNumberPad;
    }
    _dataField.borderStyle = UITextBorderStyleNone;
    _dataField.font = [UIFont systemFontOfSize:18.0f];
    _dataField.textColor = kMSTextColor;
    _dataField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _dataField.text = self.contentStr;
    [bgView addSubview:_dataField];
    [_dataField release];
    
    _scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_back"]];
    [self.view addSubview:_scrollView];
    [_scrollView release];
	// Do any additional setup after loading the view.
}

-(void)handleRightEvent
{
    BOOL isBack = YES;
    FDSUser *userInfo = [[FDSUserManager sharedManager]getNowUser];
    if (self.modifyStyle != MODIFY_PROFILE_NONE && userInfo.m_userID && userInfo.m_userID.length > 0)
    {
        NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        if (_dataField.text)
        {
            self.modifyContent = [_dataField.text stringByTrimmingCharactersInSet:whitespace];
            if (self.modifyContent.length > 0 && ![self.modifyContent isEqualToString:self.contentStr]) //修改为不同原来内容才发送
            {
                isBack = NO;
                [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
                [[FDSUserCenterMessageManager sharedManager]modifyUserCard:userInfo.m_userID :self.modifyContent :self.modifyStyle];
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
        /*
        FDSUser *m_user = [[FDSUser alloc] init];
        switch (self.modifyStyle)
        {
            case MODIFY_PROFILE_NAME:
            {
                m_user.m_name = self.modifyContent;
            }
                break;
            case MODIFY_PROFILE_ICON:
            {
                m_user.m_icon = self.modifyContent;
            }
                break;
            case MODIFY_PROFILE_SEX:
            {
                m_user.m_sex = self.modifyContent;
            }
                break;
            case MODIFY_PROFILE_COMPANY:
            {
                m_user.m_company = self.modifyContent;
            }
                break;
            case MODIFY_PROFILE_JOB:
            {
                m_user.m_job = self.modifyContent;
            }
                break;
            case MODIFY_PROFILE_PHONE:
            {
                m_user.m_phone = self.modifyContent;
            }
                break;
            case MODIFY_PROFILE_TEL:
            {
                m_user.m_tel = self.modifyContent;
            }
                break;
            case MODIFY_PROFILE_GOLFAGE:
            {
                m_user.m_golfAge = self.modifyContent;
            }
                break;
            case MODIFY_PROFILE_BRIEF:
            {
                m_user.m_brief = self.modifyContent;
            }
                break;
            case MODIFY_PROFILE_HANDICAP:
            {
                m_user.m_handicap = self.modifyContent;
            }
                break;
            case MODIFY_PROFILE_EMAIL:
            {
                m_user.m_email = self.modifyContent;
            }
                break;
                
            default:
                break;
        }
        [[FDSUserManager sharedManager] modifyNowUser:m_user];
        [m_user release];
         */
        [[FDSUserManager sharedManager]setNowUserWithStyle:self.modifyStyle withContext:self.modifyContent];
        if ([self.delegate respondsToSelector:@selector(didRefreshCurrPage)])
        {
            [self.delegate didRefreshCurrPage];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:[NSString stringWithFormat:@"修改%@失败",self.titleStr]];
    }
}


#pragma mark - UITextFieldDelegate Method
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_scrollView adjustOffsetToIdealIfNeeded];
}

@end

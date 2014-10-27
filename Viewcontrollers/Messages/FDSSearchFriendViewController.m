//
//  FDSSearchFriendViewController.m
//  FDS
//
//  Created by zhuozhong on 14-2-17.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSSearchFriendViewController.h"
#import "UIViewController+BarExtension.h"
#import "SVProgressHUD.h"
#import "FDSSeachResultViewController.h"
#import "FDSUser.h"
#import "FDSDBManager.h"
#import "FDSComListViewController.h"

@interface FDSSearchFriendViewController ()

@end

@implementation FDSSearchFriendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.addStyle = ADD_FRIEND_STYLE_NONE;
        self.modifyText = nil;
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
    self.friendInfo = nil;
    self.modifyText = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 200, 22)];
    titleLabel.textColor = kMSTextColor;
    titleLabel.font =[UIFont systemFontOfSize:16];
    titleLabel.backgroundColor = [UIColor clearColor];

    if (ADD_FRIEND_STYLE_CONTACT == self.addStyle)
    {
        [self homeNavbarWithTitle:@"添加好友" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
        titleLabel.text = @"请输入手机号／ID号";
    }
    else if (ADD_FRIEND_STYLE_COMPANY == self.addStyle)
    {
        [self homeNavbarWithTitle:@"添加企业号" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
        titleLabel.text = @"请输入企业号／公司名";
    }
    else if(MODIFY_FRIEND_REMARK_NAME == self.addStyle)
    {
        [self homeNavbarWithTitle:@"备注名" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
        titleLabel.hidden = YES;
    }
    
    _scrollView = [[MSKeyboardScrollView alloc] initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith, kMSTableViewHeight-44)];
    
    [_scrollView addSubview:titleLabel];
    [titleLabel release];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15+22, kMSScreenWith-20, 50)];
    bgView.image = [[UIImage imageNamed:@"round_white_cellbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    bgView.userInteractionEnabled = YES;
    [_scrollView addSubview:bgView];
    [bgView release];
    
    _dataField = [[UITextField alloc] initWithFrame:CGRectMake(5, 10+KFDSTextOffset, 290, 30)];
    _dataField.delegate = self;
    _dataField.borderStyle = UITextBorderStyleNone;
    _dataField.font = [UIFont systemFontOfSize:18.0f];
    _dataField.textColor = kMSTextColor;
    _dataField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [bgView addSubview:_dataField];
    [_dataField release];
    
    _scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_back"]];
    [self.view addSubview:_scrollView];
    [_scrollView release];
	// Do any additional setup after loading the view.
}


-(void)handleRightEvent
{
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    self.modifyText = [_dataField.text stringByTrimmingCharactersInSet:whitespace];
    if (0 >= self.modifyText.length)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"输入不能为空！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    if (ADD_FRIEND_STYLE_CONTACT == self.addStyle)
    {
        /* 搜索好友 */
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        [[FDSUserCenterMessageManager sharedManager]searchFriends:self.modifyText];
    }
    else if (ADD_FRIEND_STYLE_COMPANY == self.addStyle)
    {
        /* 搜索企业 */
        FDSComListViewController *fdsCpage = [[FDSComListViewController alloc]init];
        fdsCpage.titStr = @"搜索结果";
        fdsCpage.typeId = self.modifyText;
        fdsCpage.showType = @"key";
        [self.navigationController pushViewController:fdsCpage animated:YES];
        [fdsCpage release];
    }
    else if(MODIFY_FRIEND_REMARK_NAME == self.addStyle)
    {
        /* 好友备注名修改 */
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        [[FDSUserCenterMessageManager sharedManager]modifyFriendsRemarkName:self.friendInfo.m_friendID :self.modifyText];
    }
}


#pragma mark - FDSUserCenterMessageInterface Methods
- (void)searchFriendsCB:(NSMutableArray*)friendList
{
    /* 搜索好友 */
    [SVProgressHUD popActivity];
    FDSSeachResultViewController *resultVC = [[FDSSeachResultViewController alloc] init];
    resultVC.resultList = friendList;
    [self.navigationController pushViewController: resultVC animated:YES];
    [resultVC release];
}

- (void)modifyFriendsRemarkNameCB:(NSString*)result
{
    /* 好友备注名修改 */
    [SVProgressHUD popActivity];
    if ([result isEqualToString:@"OK"])
    {
        self.friendInfo.m_remarkName = self.modifyText;
        
        [[FDSDBManager sharedManager] updateSenderName:self.friendInfo];
        [[FDSDBManager sharedManager]updateRemarkName:self.friendInfo];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改备注名失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}


#pragma mark - UITextFieldDelegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_scrollView adjustOffsetToIdealIfNeeded];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ( range.location == 0 && string.length >0 )
    {
        [self setRightNavBar:@"navbar_profile_send_bg"];
    }
    else if(range.location == 0 && [string length] == 0)
    {
        [self setRightNavBar:nil];
    }
    return YES;
}

// called when 'return' key pressed. return NO to ignore.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_dataField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self setRightNavBar:nil];
    return YES;
}

- (void)setRightNavBar:(NSString*)rightImg
{
    if (rightImg)
    {
        if (ADD_FRIEND_STYLE_CONTACT == self.addStyle)
        {
            [self homeNavbarWithTitle:@"添加好友" andLeftButtonName:@"btn_caculate" andRightButtonName:rightImg];
        }
        else if (ADD_FRIEND_STYLE_COMPANY == self.addStyle)
        {
            [self homeNavbarWithTitle:@"添加企业号" andLeftButtonName:@"btn_caculate" andRightButtonName:rightImg];
        }
        else if (MODIFY_FRIEND_REMARK_NAME == self.addStyle)
        {
            [self homeNavbarWithTitle:@"备注名" andLeftButtonName:@"btn_caculate" andRightButtonName:rightImg];
        }
    }
    else
    {
        if (ADD_FRIEND_STYLE_CONTACT == self.addStyle)
        {
            [self homeNavbarWithTitle:@"添加好友" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
        }
        else if (ADD_FRIEND_STYLE_COMPANY == self.addStyle)
        {
            [self homeNavbarWithTitle:@"添加企业号" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
        }
        else if (MODIFY_FRIEND_REMARK_NAME == self.addStyle)
        {
            [self homeNavbarWithTitle:@"备注名" andLeftButtonName:@"btn_caculate" andRightButtonName:rightImg];
        }
    }
}

@end

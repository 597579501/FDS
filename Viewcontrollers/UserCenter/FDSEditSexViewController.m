//
//  FDSEditSexViewController.m
//  FDS
//
//  Created by zhuozhongkeji on 14-1-23.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSEditSexViewController.h"
#import "UIViewController+BarExtension.h"
#import "Constants.h"
#import "FDSUserManager.h"
#import "SVProgressHUD.h"
#import "FDSPublicManage.h"

@interface FDSEditSexViewController ()
{
    NSInteger   currentIndex;
}
@end

@implementation FDSEditSexViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.modifyContent = nil;
        FDSUser *userInfo = [[FDSUserManager sharedManager] getNowUser];
        if (userInfo.m_sex && [userInfo.m_sex isEqualToString:@"女"])
        {
            currentIndex = 1;
        }
        else
        {
            currentIndex = 0;
        }
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
    self.modifyContent = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self homeNavbarWithTitle:@"性别" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith,kMSTableViewHeight-44) style:UITableViewStyleGrouped];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [self.view addSubview:_tableview];
    [_tableview release];
    
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_back"]];
    if ([_tableview respondsToSelector:@selector(setBackgroundView:)])
    {
        [_tableview setBackgroundView:backImg];
    }
    [backImg release];
	// Do any additional setup after loading the view.
}

#pragma mark - UITableViewDelegate UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath row];
    static NSString *CellIdentifier = @"sexCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    //config the cell
    cell.textLabel.textColor = kMSTextColor;
    if (0 == index)
    {
        cell.textLabel.text = @"   男";
    }
    else if (1 == index)
    {
        cell.textLabel.text = @"   女";
    }
    if(index == currentIndex)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.row != currentIndex)
    {
        NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        if (newCell.accessoryType == UITableViewCellAccessoryNone)
        {
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
        if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            oldCell.accessoryType = UITableViewCellAccessoryNone;
        }
        currentIndex=indexPath.row;
    }
    [self handleSendEvent];
}

-(void)handleSendEvent
{
    BOOL isBack = YES;
    if (0 == currentIndex)
    {
        self.modifyContent = @"男";
    }
    else
    {
        self.modifyContent = @"女";
    }
    FDSUser *userInfo = [[FDSUserManager sharedManager]getNowUser];
    if (userInfo.m_userID && userInfo.m_userID.length > 0)
    {
        if (userInfo.m_sex.length == 0 || ![self.modifyContent isEqualToString:userInfo.m_sex]) //修改为不同原来内容才发送
        {
            isBack = NO;
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
            [[FDSUserCenterMessageManager sharedManager]modifyUserCard:userInfo.m_userID :self.modifyContent :MODIFY_PROFILE_SEX];
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
//        m_user.m_sex = self.modifyContent;
//        [[FDSUserManager sharedManager] modifyNowUser:m_user];
//        [m_user release];
        [[FDSUserManager sharedManager]setNowUserWithStyle:MODIFY_PROFILE_SEX withContext:self.modifyContent];
        if ([self.delegate respondsToSelector:@selector(didRefreshCurrPage)])
        {
            [self.delegate didRefreshCurrPage];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"修改性别失败"];
    }
}

@end

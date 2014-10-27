//
//  FDSMsgRemindViewController.m
//  FDS
//
//  Created by zhuozhongkeji on 14-1-9.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSMsgRemindViewController.h"
#import "UIViewController+BarExtension.h"
#import "Constants.h"
#import "SVProgressHUD.h"
#import "FDSPublicManage.h"

@interface FDSMsgRemindViewController ()

@end

@implementation FDSMsgRemindViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        titleArr = [[NSArray alloc]initWithObjects:@"免打扰",@"信息提醒", nil];
        self.resetMode = nil;
        self.systemPushMessage = nil;
        self.friendPushMessage = nil;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [titleArr release];
    
    self.resetMode = nil;
    self.systemPushMessage = nil;
    self.friendPushMessage = nil;

    [super dealloc];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = COLOR(234, 234, 234, 1);
    [self homeNavbarWithTitle:@"新信息提醒" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [[FDSUserCenterMessageManager sharedManager] getPushSetting];
	// Do any additional setup after loading the view.
}

- (void)settingTableInit
{
    _msgSetingTable = [[UITableView alloc]initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith,kMSTableViewHeight-44) style:UITableViewStyleGrouped];
    _msgSetingTable.delegate = self;
    _msgSetingTable.dataSource = self;
    [self.view addSubview:_msgSetingTable];
    [_msgSetingTable release];
    
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_back"]];
    if ([_msgSetingTable respondsToSelector:@selector(setBackgroundView:)])
    {
        [_msgSetingTable setBackgroundView:backImg];
    }
    [backImg release];
}


#pragma mark - UITableViewDelegate UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section)
    {
        return 1;
    }
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* myView = [[[UIView alloc] init] autorelease];
    myView.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 200, 22)];
    titleLabel.textColor = kMSTextColor;
    titleLabel.font =[UIFont systemFontOfSize:16];
    titleLabel.backgroundColor = [UIColor clearColor];
    
    if (section >= 0 && section < [titleArr count])
    {
        titleLabel.text = [NSString stringWithFormat:@"%@",[titleArr objectAtIndex:section]];
    }
    else
    {
        titleLabel.text = @"Unknow";
    }
    [myView addSubview:titleLabel];
    [titleLabel release];
    return myView;
}

// custom view for footer. will be adjusted to default or specified footer height
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (0 == section)
    {
        UILabel *contentLab = [[[UILabel alloc] initWithFrame:CGRectMake(10, 8, 280, 22)]autorelease];
        contentLab.textColor = kMSTextColor;
        contentLab.textAlignment = NSTextAlignmentCenter;
        contentLab.font =[UIFont systemFontOfSize:13];
        contentLab.backgroundColor = [UIColor clearColor];
        contentLab.text = @"夜间免打扰时间段 23:00-08:00";
        return contentLab;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (0 == section)
    {
        return 30.0f;
    }
    else
    {
        return 0.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"NewMsgSetingTableViewCell";
    NewMsgSetingTableViewCell *msgCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (msgCell == nil)
    {
        msgCell = [[[NewMsgSetingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    switch (section)
    {
        case 0:
        {
            msgCell.titleTextLab.text = @"夜间免打扰模式";
            if ([self.resetMode isEqualToString:@"on"])
            {
                msgCell.onOffSwitch.on = YES;
            }
            else
            {
                msgCell.onOffSwitch.on = NO;
            }
        }
            break;
//        case 1:
//        {
//            if (0 == row)
//            {
//                msgCell.titleTextLab.text = @"声音提示";
//                msgCell.onOffSwitch.on = YES;
//            }
//            else
//            {
//                msgCell.titleTextLab.text = @"震动提示";
//                msgCell.onOffSwitch.on = NO;
//            }
//        }
//            break;
        case 1:
        {
            if (0 == row)
            {
                msgCell.titleTextLab.text = @"系统通知";
                if ([self.systemPushMessage isEqualToString:@"on"])
                {
                    msgCell.onOffSwitch.on = YES;
                }
                else
                {
                    msgCell.onOffSwitch.on = NO;
                }
            }
            else
            {
                msgCell.titleTextLab.text = @"好友信息通知";
                if ([self.friendPushMessage isEqualToString:@"on"])
                {
                    msgCell.onOffSwitch.on = YES;
                }
                else
                {
                    msgCell.onOffSwitch.on = NO;
                }
            }
        }
            break;
        default:
            break;
    }
    NSInteger temp = 0;
    for (int i=0; i<section; i++) {
        temp += [self tableView:_msgSetingTable numberOfRowsInSection:i];
    }
    temp += row;
    msgCell.currentIndex = temp;
    msgCell.delegate = self;
    return msgCell;
}


#pragma mark - MsgSetingListenDelegate Method
- (void)notifyChageSetingWithTag:(BOOL)status :(NSInteger)currentIndex
{
    NSLog( @"%d",currentIndex);
    selectIndex = currentIndex;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    if (status)
    {
        [[FDSUserCenterMessageManager sharedManager]setPushSetting:@"on" :currentIndex];
    }
    else
    {
        [[FDSUserCenterMessageManager sharedManager]setPushSetting:@"off" :currentIndex];
    }
}

#pragma mark - FDSUserCenterMessageInterface Methods
- (void)getPushSettingCB:(NSString *)result :(NSString *)restMode :(NSString *)systemPushMessage :(NSString *)friendPushMessage
{
    [SVProgressHUD popActivity];
    if ([result isEqualToString:@"OK"])
    {
        self.resetMode = restMode;
        self.systemPushMessage = systemPushMessage;
        self.friendPushMessage = friendPushMessage;
        
        [self settingTableInit];
    }
    else
    {
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"获取推送设置失败"];
    }
}

- (void)setPushSettingCB:(NSString *)result
{
    [SVProgressHUD popActivity];
    if ([result isEqualToString:@"OK"])
    {
        if (selectIndex == 0)
        {
            if ([self.resetMode isEqualToString:@"on"])
            {
                self.resetMode = @"off";
            }
            else
            {
                self.resetMode = @"on";
            }
        }
        else if (selectIndex == 1)
        {
            if ([self.systemPushMessage isEqualToString:@"on"])
            {
                self.systemPushMessage = @"off";
            }
            else
            {
                self.systemPushMessage = @"on";
            }
        }
        else if (selectIndex == 2)
        {
            if ([self.friendPushMessage isEqualToString:@"on"])
            {
                self.friendPushMessage = @"off";
            }
            else
            {
                self.friendPushMessage = @"on";
            }
        }
    }
    else
    {
        NSIndexPath *indexPath = nil;
        if (selectIndex == 0)
        {
            indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        }
        else if (selectIndex == 1)
        {
            indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        }
        else if (selectIndex == 2)
        {
            indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
        }
        
        if (indexPath)
        {
            [_msgSetingTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        }
        else
        {
            [_msgSetingTable reloadData];
        }
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"修改失败"];
    }
}

@end

//
//  FDSPrivacySettingViewController.m
//  FDS
//
//  Created by zhuozhongkeji on 14-1-9.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSPrivacySettingViewController.h"
#import "FDSChangePwdViewController.h"
#import "UIViewController+BarExtension.h"
#import "ProfileTableViewCell.h"
#import "Constants.h"

@interface FDSPrivacySettingViewController ()

@end

@implementation FDSPrivacySettingViewController

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

- (void)dealloc
{
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self homeNavbarWithTitle:@"隐私设置" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _privacySetingTable = [[UITableView alloc]initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith,kMSTableViewHeight-44) style:UITableViewStyleGrouped];
    _privacySetingTable.delegate = self;
    _privacySetingTable.dataSource = self;
    [self.view addSubview:_privacySetingTable];
    [_privacySetingTable release];
    
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_back"]];
    if ([_privacySetingTable respondsToSelector:@selector(setBackgroundView:)])
    {
        [_privacySetingTable setBackgroundView:backImg];
    }
    [backImg release];
	// Do any additional setup after loading the view.
}

#pragma mark - UITableViewDelegate UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section+1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (1 == section)
    {
        UIView* myView = [[[UIView alloc] init] autorelease];
        myView.backgroundColor = [UIColor clearColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 200, 22)];
        titleLabel.textColor = kMSTextColor;
        titleLabel.font =[UIFont systemFontOfSize:16];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = @"动态权限";
        [myView addSubview:titleLabel];
        [titleLabel release];
        return myView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (1 == section) {
        return 35.0f;
    }
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (0 == section)
    {
        SettingTableViewCell *changePwdCell = [[[SettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChangePwdCell"] autorelease];
        changePwdCell.titleTextLab.text = @"更改密码";
        return changePwdCell;
    }
    else if(1 == section)
    {
        UITableViewCell *dynamicCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChangePwdCell"] autorelease];
        dynamicCell.textLabel.textColor = kMSTextColor;
        dynamicCell.textLabel.font=[UIFont systemFontOfSize:15];
        if (0 == row)
        {
            dynamicCell.textLabel.text= @"  所有人";
            dynamicCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            dynamicCell.textLabel.text = @"  仅限自己";
        }
        dynamicCell.backgroundColor = [UIColor whiteColor];
        dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return dynamicCell;
    }
    else
    {
        static NSString *cellIdentifier = @"ClearDataCell";
        UITableViewCell *clearDataCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (clearDataCell == nil)
        {
            clearDataCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        }
        clearDataCell.textLabel.textColor = kMSTextColor;
        clearDataCell.textLabel.textAlignment = NSTextAlignmentCenter;
        clearDataCell.textLabel.font=[UIFont systemFontOfSize:15];
        if (0 == row)
        {
            clearDataCell.textLabel.text= @"清空消息列表";
        }
        else if(1 ==  row)
        {
            clearDataCell.textLabel.text = @"清空缓存数据";
        }
        else
        {
            clearDataCell.textLabel.text = @"清空所有聊天记录";
        }

        clearDataCell.backgroundColor = [UIColor whiteColor];
        clearDataCell.selectionStyle = UITableViewCellSelectionStyleGray;
        return clearDataCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {
        FDSChangePwdViewController *changePwdVC = [[FDSChangePwdViewController alloc]init];
        [self.navigationController pushViewController:changePwdVC animated:YES];
        [changePwdVC release];
    }
    else if (1 == indexPath.section)
    {
        switch (indexPath.row) {
            case 0:
            {
                
            }
                break;
            case 1:
            {
            }
                break;
            default:
                break;
        }
    }
    else if(2 == indexPath.section)
    {
        switch (indexPath.row) {
            case 0:
            {
                
            }
                break;
            case 1:
            {
                
            }
                break;
            case 2:
            {
                
            }
                break;
            default:
                break;
        }
    }
}

@end

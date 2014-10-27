//
//  FDSAddFriendViewController.m
//  FDS
//
//  Created by zhuozhong on 14-2-17.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSAddFriendViewController.h"
#import "UIViewController+BarExtension.h"
#import "ProfileTableViewCell.h"
#import "FDSSearchFriendViewController.h"
#import "FDSPublicManage.h"
#import "FDSContactMatchViewController.h"

@interface FDSAddFriendViewController ()

@end

@implementation FDSAddFriendViewController

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
    
    [self homeNavbarWithTitle:@"添加" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _operatorTable = [[UITableView alloc]initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith,kMSTableViewHeight-44) style:UITableViewStyleGrouped];
    _operatorTable.delegate = self;
    _operatorTable.dataSource = self;
    [self.view addSubview:_operatorTable];
    [_operatorTable release];
    
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_back"]];
    if ([_operatorTable respondsToSelector:@selector(setBackgroundView:)])
    {
        [_operatorTable setBackgroundView:backImg];
    }
    [backImg release];

	// Do any additional setup after loading the view.
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
        return 2;
    }
    else
    {
        return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* myView = [[[UIView alloc] init] autorelease];
    myView.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 200, 22)];
    titleLabel.textColor = kMSTextColor;
    titleLabel.font =[UIFont systemFontOfSize:16];
    titleLabel.backgroundColor = [UIColor clearColor];
    if (0 == section)
    {
        titleLabel.text = @"点击对应项进行添加";
    }
    else if(1 == section)
    {
        titleLabel.text = @"特别推荐";
    }
    [myView addSubview:titleLabel];
    [titleLabel release];
    return myView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    static NSString *cellIdentifier = @"operatorTableViewCell";
    ProfileTableViewCell *profileCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (profileCell == nil)
    {
        profileCell = [[[ProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier cellIndefy:YES] autorelease];
    }

    //config cell
    if (0 == section)
    {
        if (0 == row)
        {
            profileCell.logoImg.image = [UIImage imageNamed:@"search_friend_bg"];
            profileCell.titleTextLab.text = @"搜索好友";
        }
        else if (1 == row)
        {
            profileCell.logoImg.image = [UIImage imageNamed:@"search_contact_record_bg"];
            profileCell.titleTextLab.text = @"通讯录添加";
        }
    }
    else
    {
        profileCell.logoImg.image = [UIImage imageNamed:@"search_recommand_bg"];
        profileCell.titleTextLab.text = @"好友推荐";
    }
    return profileCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (0 == section)
    {
        if (0 == row) //搜索好友
        {
            FDSSearchFriendViewController *searchFriendVC = [[FDSSearchFriendViewController alloc] init];
            searchFriendVC.addStyle = ADD_FRIEND_STYLE_CONTACT;
            [self.navigationController pushViewController: searchFriendVC animated:YES];
            [searchFriendVC release];
        }
        else if (1 == row) //通讯录添加
        {
            FDSContactMatchViewController *matchVC = [[FDSContactMatchViewController alloc] init];
            [self.navigationController pushViewController:matchVC animated:YES];
            [matchVC release];
        }
    }
    else //好友推荐
    {
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"此功能尚未开通"];
    }
}

@end

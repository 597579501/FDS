//
//  FDSGroupCardViewController.m
//  FDS
//
//  Created by zhuozhong on 14-3-13.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSGroupCardViewController.h"
#import "UIViewController+BarExtension.h"
#import "Constants.h"
#import "AddressBookTableViewCell.h"
#import "SVProgressHUD.h"
#import "FDSFriendProfileViewController.h"
#import "FDSPublicManage.h"

@interface FDSGroupCardViewController ()

@end

@implementation FDSGroupCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.resultList = nil;
        self.groupID = nil;
        self.groupType = nil;
        self.groupName = nil;
        self.groupIcon = nil;
        self.relation = nil;
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
    [[FDSUserCenterMessageManager sharedManager] registerObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[FDSUserCenterMessageManager sharedManager] unRegisterObserver:self];
}

- (void)dealloc
{
    [self.resultList removeAllObjects];
    self.resultList = nil;
    
    self.groupID = nil;
    self.groupType = nil;
    self.groupName = nil;
    self.groupIcon = nil;
    self.relation = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self homeNavbarWithTitle:@"群名片" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.view.backgroundColor = COLOR(234, 234, 234, 1);
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [[FDSUserCenterMessageManager sharedManager]getGroupMembers:self.groupID :self.groupType];
	// Do any additional setup after loading the view.
}

- (void)tableViewInit
{
    _groupTable = [[UITableView alloc]initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith,kMSTableViewHeight-44) style:UITableViewStylePlain];
    _groupTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _groupTable.delegate = self;
    _groupTable.dataSource = self;
    [self.view addSubview:_groupTable];
    [_groupTable release];
    
    _groupTable.backgroundColor = COLOR(234, 234, 234, 1);
}

#pragma mark - FDSUserCenterMessageInterface Method
- (void)getGroupMembersCB:(NSString*)groupName :(NSString*)groupIcon :(NSString*)relation :(NSMutableArray*)friendList
{
    [SVProgressHUD popActivity];
    
    self.groupName = groupName;
    self.groupIcon = groupIcon;
    self.resultList = friendList;
    self.relation = relation;
    
    [self tableViewInit];
}

/*   删除群成员   */
- (void)deleteGroupMemberCB:(NSString*)result
{
    
}


#pragma mark - UITableViewDelegate UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_resultList)
    {
        return [_resultList count]+1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        return 90.0f;
    }
    else
    {
        return 60.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath row];
    if (0 == index)
    {
        UITableViewCell *firstcell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"firstGroupCell"] autorelease];
        
        EGOImageView *companyLogoImg = [[EGOImageView alloc] initWithFrame:CGRectMake(15, 15, 60, 60)];
        companyLogoImg.layer.borderWidth = 1;
        companyLogoImg.layer.cornerRadius = 4.0;
        companyLogoImg.layer.masksToBounds=YES;
        companyLogoImg.layer.borderColor = [[UIColor colorWithRed:242.0f/255 green:242.0f/255 blue:242.0f/255 alpha:1.0f] CGColor];
        [companyLogoImg initWithPlaceholderImage:[UIImage imageNamed:@"send_image_default"]];
        companyLogoImg.imageURL = [NSURL URLWithString:self.groupIcon];
        companyLogoImg.userInteractionEnabled = YES;
        [firstcell.contentView addSubview:companyLogoImg];
        [companyLogoImg release];
        
        UILabel *companyNameLab = [[UILabel alloc] initWithFrame:CGRectMake(90, 20, 225, 30)];
        companyNameLab.backgroundColor = [UIColor clearColor];
        companyNameLab.textColor = COLOR(69, 69, 69, 1);
        companyNameLab.numberOfLines = 1;
        companyNameLab.font = [UIFont systemFontOfSize:15.0f];
        companyNameLab.text = self.groupName;
        [firstcell.contentView addSubview:companyNameLab];
        [companyNameLab release];
        
        UILabel *memberLab = [[UILabel alloc] initWithFrame:CGRectMake(90, 50, 225, 25)];
        memberLab.backgroundColor = [UIColor clearColor];
        memberLab.textColor = COLOR(69, 69, 69, 1);
        memberLab.numberOfLines = 1;
        memberLab.font = [UIFont systemFontOfSize:15.0f];
        memberLab.text = [NSString stringWithFormat:@"成员:  %d/40人",[self.resultList count]];
        [firstcell.contentView addSubview:memberLab];
        [memberLab release];

        UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 89, kMSScreenWith, 0.5)];
        tmpView.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
        [firstcell.contentView addSubview:tmpView];
        [tmpView release];

        firstcell.contentView.backgroundColor = [UIColor whiteColor];
        firstcell.selectionStyle=UITableViewCellSelectionStyleNone;
        return firstcell;
    }
    static NSString *CellIdentifier = @"groupResultTableViewCell";
    AddressBookTableViewCell *groupCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (groupCell == nil)
    {
        groupCell = [[[AddressBookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier addCellIndentify:NO] autorelease];
    }
    //config the cell
    FDSUser * userInfo = [self.resultList objectAtIndex:index-1];
    groupCell.headImg.placeholderImage = [UIImage imageNamed:@"headphoto_s"];
    groupCell.headImg.imageURL = [NSURL URLWithString:userInfo.m_icon];
    groupCell.nameLab.text = userInfo.m_name;
    groupCell.contentView.backgroundColor = [UIColor whiteColor];
    return groupCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath row];
    if (index >= 1)
    {
        FDSFriendProfileViewController *fpVC = [[FDSFriendProfileViewController alloc]init];
        fpVC.friendInfo = [self.resultList objectAtIndex:index-1];
        [self.navigationController pushViewController:fpVC animated:YES];
        [fpVC release];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.relation isEqualToString:@"superadmin"] || [self.relation isEqualToString:@"admin"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle  forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        enum ZZSessionManagerState state = [[ZZSessionManager sharedSessionManager] getSessionState];
        if (ZZSessionManagerState_CONNECTED == state)
        {
            NSInteger index = [indexPath row];
            FDSUser * userInfo = [self.resultList objectAtIndex:index-1];
            [[FDSUserCenterMessageManager sharedManager] deleteGroupMember:userInfo.m_friendID :self.groupID :self.groupType];
            [self.resultList removeObjectAtIndex:index-1]; //delete page cache
            NSArray *indexs = [NSArray arrayWithObject:indexPath];
            [tableView deleteRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationLeft];
        }
        else
        {
            [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"服务器未连接"];
        }
    }
}


@end

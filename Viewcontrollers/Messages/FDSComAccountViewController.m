//
//  FDSComAccountViewController.m
//  FDS
//
//  Created by zhuozhong on 14-3-13.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSComAccountViewController.h"
#import "UIViewController+BarExtension.h"
#import "Constants.h"
#import "AddressBookTableViewCell.h"
#import "SVProgressHUD.h"
#import "FDSCompany.h"
#import "FDSChatViewController.h"
#import "FDSMessageCenter.h"
#import "FDSDBManager.h"

@interface FDSComAccountViewController ()

@end

@implementation FDSComAccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.companyInfoList = nil;
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

-(void)dealloc
{
    [self.companyInfoList removeAllObjects];
    self.companyInfoList = nil;
    
    [super dealloc];
}

- (void)companyTableInit
{
    _companyTable = [[UITableView alloc]initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith,kMSTableViewHeight-44) style:UITableViewStylePlain];
    _companyTable.delegate = self;
    _companyTable.dataSource = self;
    _companyTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_companyTable];
    [_companyTable release];
    
    _companyTable.backgroundColor = COLOR(234, 234, 234, 1);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self homeNavbarWithTitle:@"企业号" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [[FDSUserCenterMessageManager sharedManager] getJoinedCompanyList];
	// Do any additional setup after loading the view.
}


#pragma mark - FDSUserCenterMessageInterface Methods
- (void)getJoinedCompanyListCB:(NSMutableArray *)companyList
{
    [SVProgressHUD popActivity];
    self.companyInfoList = companyList;
    
    [self companyTableInit];
}


#pragma mark - UITableViewDelegate UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.companyInfoList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"companyTableViewMIXCell";
    AddressBookTableViewCell *companyCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (companyCell == nil)
    {
        companyCell = [[[AddressBookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier addCellIndentify:YES]autorelease];
        CGRect rect = companyCell.nameLab.frame;
        rect.origin.x-=10;
        rect.size.width+=18;
        companyCell.nameLab.frame = rect;
        
        rect = companyCell.cellImg.frame;
        rect.origin.x+=13;
        companyCell.cellImg.frame = rect;
    }
    FDSCompany *company = [self.companyInfoList objectAtIndex:indexPath.row];
    companyCell.headImg.placeholderImage = [UIImage imageNamed:@"headphoto_s"];
    companyCell.headImg.imageURL = [NSURL URLWithString:company.m_companyIcon];
    companyCell.nameLab.text = company.m_companyNameZH;
    companyCell.contentView.backgroundColor = [UIColor whiteColor];
    return companyCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FDSCompany *company = [self.companyInfoList objectAtIndex:indexPath.row];
    
    FDSChatViewController *chatVC = [[FDSChatViewController alloc] init];
    /* 针对群聊操作 */
    FDSMessageCenter *messageCenter = [[FDSMessageCenter alloc] init];
    messageCenter.m_messageClass = FDSMessageCenterMessage_Class_USER; //个人信息
    messageCenter.m_messageType = FDSMessageCenterMessage_Type_CHAT_GROUP;//群消息
    messageCenter.m_icon = company.m_companyIcon; //消息中心头像都显示群头像
    messageCenter.m_senderName = @"";
    messageCenter.m_senderID = @"";
    messageCenter.m_param1 = company.m_comId;
    messageCenter.m_param2 = company.m_companyNameZH;
    messageCenter.m_newMessageCount = [[FDSDBManager sharedManager] getChatMessageUnread:messageCenter];
    
    chatVC.centerMessage = messageCenter;
    [messageCenter release];
    
    [self.navigationController pushViewController: chatVC animated:YES];
    [chatVC release];
}

@end

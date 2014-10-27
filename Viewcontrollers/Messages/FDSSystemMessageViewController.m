//
//  FDSSystemMessageViewController.m
//  FDS
//
//  Created by zhuozhong on 14-2-19.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSSystemMessageViewController.h"
#import "UIViewController+BarExtension.h"
#import "FDSDBManager.h"
#import "FDSUser.h"

@interface FDSSystemMessageViewController ()

@end

@implementation FDSSystemMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        systemList = nil;
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
    [systemList removeAllObjects];
    [systemList release];
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[FDSUserCenterMessageManager sharedManager]registerObserver:self];
    
    if (_isUpdateDB) //需要更新已读
    {
        [[FDSDBManager sharedManager]updateAllSystemMessageCenterDoRead];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[FDSUserCenterMessageManager sharedManager]unRegisterObserver:self];
}


- (void)handleCurPageAddMessage:(FDSMessageCenter*)centerMessage
{
    BOOL isExist = NO; //判断该消息是否存在当前缓存中
    NSInteger findLoc = 0;
    FDSMessageCenter *cacheMessage = nil;
    for (int i=0; i<systemList.count; i++)
    {
        cacheMessage = [systemList objectAtIndex:i];
        if (cacheMessage.m_id == centerMessage.m_id)
        {
            findLoc = i;
            isExist = YES;
            break;
        }
    }
    
    /* 接收到的消息肯定为当前用户  所以无需判断 */
    if (isExist) //找到则更新对应缓存  此时messageCenter和cacheMessage都有原来添加成功的数据库ID
    {
        cacheMessage.m_param1 = centerMessage.m_param1;
        cacheMessage.m_sendTime = centerMessage.m_sendTime;
        
        //only refresh row in chatTable
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:findLoc inSection:0];
        [_systemTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    else //不存在则插入到数组最前面  messageCenter这时候有对应messageCenter表中的messageID
    {
        [systemList insertObject:centerMessage atIndex:0];
        [_systemTable reloadData];
        [_systemTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }

    /*  处理当前页面新收到的消息为已读 */
    centerMessage.m_state = FDS_MSG_STATE_READED;
    [[FDSDBManager sharedManager] updateSystemMessageCenterDoRead:centerMessage];
}

/* push消息 收到对方的添加好友请求 */
- (void)addFriendRequestCB:(FDSMessageCenter*)centerMessage :(FDSUser*)friendInfo
{
    [self handleCurPageAddMessage:centerMessage];
}

/* push消息 发出添加好友请求后收到的回复 */
- (void)addFriendReplyCB:(FDSUser*)friendInfo :(FDSMessageCenter*)messageCenter
{
    [self handleCurPageAddMessage:messageCenter];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self homeNavbarWithTitle:@"系统消息" andLeftButtonName:@"btn_caculate" andRightButtonName:@"清空"];
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _systemTable = [[UITableView alloc]initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith,kMSTableViewHeight-44) style:UITableViewStylePlain];
    _systemTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _systemTable.delegate = self;
    _systemTable.dataSource = self;
    [self.view addSubview:_systemTable];
    [_systemTable release];
    
    systemList = [[FDSDBManager sharedManager]getSystemInfoNowUserFromDB];
	// Do any additional setup after loading the view.
}

- (void)handleRightEvent
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"清空系统消息" message:@"确定要清空吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    [alertView release];
}


// Called when a button is clicked. The view will be automatically dismissed after this call returns
#pragma mark - UIAlertViewDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex) //send
    {
        /* 清空所有系统消息 */
        [systemList removeAllObjects];
        [_systemTable reloadData];
        
        [[FDSDBManager sharedManager]deleteAllSystemMessageFromDB];
    }
}

#pragma mark - UITableViewDelegate UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (systemList)
    {
        return [systemList count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MsgSystemTableViewCell";
    MsgSystemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[MsgSystemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    //config the cell
    NSInteger index = [indexPath row];
    [cell loadCellWithData:[systemList objectAtIndex:index] withDelegate:self withCellTag:index];
    
    return cell;
}


#pragma mark - OperFriendDelegate Method
- (void)didOperWithTag:(NSInteger)currentTag :(NSInteger)withCellIndex
{
    FDSMessageCenter *messageCenter = [systemList objectAtIndex:withCellIndex];
    switch (currentTag)
    {
        case 0x01://同意
        {
            [[FDSUserCenterMessageManager sharedManager] addFriendRequestReply:messageCenter.m_senderID :@"OK"]; //发送请求
            
            messageCenter.m_messageType = FDSMessageCenterMessage_Type_ADD_FRIEND_AGREE; //更新缓存
            
            [[FDSDBManager sharedManager]updateSystemMessageCenter:messageCenter]; //更新数据库messageType 字段
            
            /* 添加该好友到数据库中的userFriends表 */
            FDSUser *friendInfo = [[FDSUser alloc]init];
            friendInfo.m_name = messageCenter.m_senderName;
            friendInfo.m_icon = messageCenter.m_icon;
            friendInfo.m_friendID = messageCenter.m_senderID;
            
            [[FDSDBManager sharedManager]AddFriendToDB:friendInfo];
        }
            break;
        case 0x02://拒绝  不发请求
        {
            messageCenter.m_messageType = FDSMessageCenterMessage_Type_ADD_FRIEND_REJECT;//更新缓存
            
            [[FDSDBManager sharedManager]updateSystemMessageCenter:messageCenter]; //更新数据库messageType 字段
        }
            break;
        default:
            break;
    }
    
    //only refresh row in chatTable
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:withCellIndex inSection:0];
    [_systemTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
}

@end

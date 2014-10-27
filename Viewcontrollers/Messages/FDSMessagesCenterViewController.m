//
//  FDSMessagesCenterViewController.m
//  FDS
//
//  Created by zhuozhong on 14-1-26.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSMessagesCenterViewController.h"
#import "FDSAdressBookViewController.h"
#import "FDSLoginViewController.h"
#import "FDSChatViewController.h"
#import "UIViewController+BarExtension.h"
#import "Constants.h"
#import "MsgCenterTableViewCell.h"
#import "FDSUserManager.h"
#import "FDSDBManager.h"
#import "FDSMessageCenter.h"
#import "FDSSystemMessageViewController.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"

@interface FDSMessagesCenterViewController ()

@end

@implementation FDSMessagesCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.centerMesageList = nil;
        self.filteredListContent = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handlePageShow
{
    BOOL isExistLogin = NO; //是否存在提示登录页面
    NSArray *array = [self.view subviews];
    for (int i = 0; i < [array count]; i++)
    {
        if ([[array objectAtIndex:i] isKindOfClass:[UnLoginView class]])
        {
            isExistLogin = YES;
            break;
        }
    }
    if (USERSTATE_LOGIN == [[FDSUserManager sharedManager] getNowUserState] || USERSTATE_HAVE_ACCOUNT_NO_LOGIN_NOTNET == [[FDSUserManager sharedManager] getNowUserState])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:SYSTEM_NOTIFICATION_TAB_MESSAGE_SUB_MARK object:nil];
        if (isExistLogin)  //存在提示登录页面
        {
            [_unLoginview removeFromSuperview];
        }
        
        [self homeNavbarWithTitle:@"信息" andLeftButtonName:nil andRightButtonName:@"navbar_contactlist_bg"];
        
        /* 每次都需要去查询最新messageCenter表情况 因为后台可能收到未读消息 */
        self.centerMesageList = [[FDSDBManager sharedManager] getMessageCenterNowUserFromDB];
        FDSMessageCenter *messageCenter = nil;
        for (int i=0; i<self.centerMesageList.count; i++)
        {
            messageCenter = [self.centerMesageList objectAtIndex:i];
            if(FDSMessageCenterMessage_Class_USER == messageCenter.m_messageClass)
            {
                if (FDSMessageCenterMessage_Type_CHAT_PERSON == messageCenter.m_messageType || FDSMessageCenterMessage_Type_CHAT_GROUP == messageCenter.m_messageType)
                {
                    if (FDS_MSG_STATE_UNREADED == messageCenter.m_state) //未读状态才去查询未读数
                    {
                        messageCenter.m_newMessageCount = [[FDSDBManager sharedManager] getChatMessageUnread:messageCenter];
                    }
                }
            }
        }
        [_msgTable reloadData];
    }
    else
    {
        if (!isExistLogin)//不存在提示登录页面
        {
            _unLoginview = [[UnLoginView alloc] initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith, kMSTableViewHeight-44-49)];
            _unLoginview.delegate = self;
            [self.view addSubview:_unLoginview];
            [_unLoginview release];
            [self.view bringSubviewToFront:_unLoginview];
        }
        [self homeNavbarWithTitle:@"信息" andLeftButtonName:nil andRightButtonName:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[FDSUserCenterMessageManager sharedManager]registerObserver:self];
    [[ZZSessionManager sharedSessionManager] registerObserver:self];

    [self handlePageShow];
    
    enum ZZSessionManagerState state = [[ZZSessionManager sharedSessionManager] getSessionState];
    if (ZZSessionManagerState_NET_FAIL == state)
    {
        [self handeNewWorkShow:YES];
    }
    else
    {
        [self handeNewWorkShow:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[FDSUserCenterMessageManager sharedManager]unRegisterObserver:self];
    [[ZZSessionManager sharedSessionManager] unRegisterObserver:self];
    [self.searchDisplayController setActive:NO animated:YES];
}


-(void)sessionManagerStateNotice:(enum ZZSessionManagerState)sessionManagerState
{
    switch(sessionManagerState)
    {
        case ZZSessionManagerState_NET_FAIL:
        {
            [self handeNewWorkShow:YES];
        }
            break;
        case ZZSessionManagerState_NET_OK:
        {
            [self handeNewWorkShow:NO];
        }
            break;
        default:
            break;
    }
}

- (void)handeNewWorkShow:(BOOL)show
{
    if (USERSTATE_LOGIN == [[FDSUserManager sharedManager] getNowUserState])
    {
        if (show)
        {
            networkView.hidden = NO;
            _msgTable.frame = CGRectMake(0, kMSNaviHight+40, kMSScreenWith,kMSTableViewHeight-44-49-40);
        }
        else
        {
            networkView.hidden = YES;
            _msgTable.frame = CGRectMake(0, kMSNaviHight, kMSScreenWith,kMSTableViewHeight-44-49);
        }
    }
}

#pragma mark - FDSUserCenterMessageInterface Method
//自动登录CB
- (void)userLoginCB:(NSString *)result :(NSString *)reason :(FDSUser *)user
{
    if([result isEqualToString:@"OK"])
    {
        [self handlePageShow];
    }
}

/*    好友修改名称 修改头像消息推送     */
- (void)cardInfoModifyCB:(NSString*)cardType :(NSString*)modifyName :(NSString*)modifyIcon :(NSString*)userID
{
    FDSMessageCenter *cacheMessage = nil;
    BOOL isExist = NO;
    for (int i=0; i<self.centerMesageList.count; i++)
    {
        cacheMessage = [self.centerMesageList objectAtIndex:i];
        if ([cacheMessage.m_senderID isEqualToString:userID])
        {
            isExist = YES;
            if (modifyName && modifyName.length>0)
            {
                cacheMessage.m_senderName = modifyName;
            }
        }
    }
    if (isExist)
    {
        [self performSelector:@selector(updateContactImg) withObject:nil afterDelay:0.5];
    }
}

- (void)updateContactImg
{
    [_msgTable reloadData];
}

/* push 收消息 */
- (void)getIMCB:(FDSChatMessage*)chatMessage :(FDSMessageCenter*)messageCenter
{
    if(USERSTATE_LOGIN == [[FDSUserManager sharedManager] getNowUserState])
    {
        BOOL isExist = NO; //判断该消息是否存在当前缓存中
        NSInteger findLoc = 0;
        FDSMessageCenter *cacheMessage = nil;
        for (int i=0; i<self.centerMesageList.count; i++)
        {
            cacheMessage = [self.centerMesageList objectAtIndex:i];
            if (messageCenter.m_id == cacheMessage.m_id)
            {
                findLoc = i;
                isExist = YES;
                break;
            }
        }
        
        /* 接收到的消息肯定为当前用户  所以无需判断 */
        if (isExist) //找到则更新对应缓存  此时messageCenter和cacheMessage都有原来添加成功的数据库ID
        {
//            NSLog(@"messageCenter对应ID: %d",messageCenter.m_id);
//            NSLog(@"cacheMessage对应ID: %d",cacheMessage.m_id);
            cacheMessage.m_newMessageCount +=1; //每次都加1
            cacheMessage.m_content = messageCenter.m_content;
            cacheMessage.m_msgContent = messageCenter.m_msgContent;
            cacheMessage.m_sendTime = messageCenter.m_sendTime;
            cacheMessage.m_senderName = messageCenter.m_senderName;
            
            //only refresh row in chatTable
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:findLoc inSection:0];
            [_msgTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        }
        else //不存在则插入到数组最前面  messageCenter这时候有对应messageCenter表中的messageID
        {
            /* 新收到一个好友发来的消息 */
            messageCenter.m_newMessageCount = 1; //此时为1
            [self.centerMesageList insertObject:messageCenter atIndex:0];
            [_msgTable reloadData];
            [_msgTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
        /* 以上两种情况当前页面收到push消息后 当前页面都拿到了对应数据库中得MessageID 所以删除消息时都可以根据messageID去删除对应MessageCenter表中对应信息 */
    }
}

/*  处理系统／添加好友相关push消息  */
- (void)handlePushMessage:(FDSMessageCenter*)messageCenter
{
    if (USERSTATE_LOGIN == [[FDSUserManager sharedManager] getNowUserState])
    {
        BOOL isExist = NO; //判断该消息是否存在当前缓存中
        NSInteger findLoc = 0;
        FDSMessageCenter *cacheMessage = nil;
        for (int i=0; i<self.centerMesageList.count; i++)
        {
            cacheMessage = [self.centerMesageList objectAtIndex:i];
            if (FDSMessageCenterMessage_Class_SYSTEM == cacheMessage.m_messageClass ||  FDSMessageCenterMessage_Type_ADD_FRIEND_REQUEST== cacheMessage.m_messageType || FDSMessageCenterMessage_Type_ADD_FRIEND_AGREE == cacheMessage.m_messageType || FDSMessageCenterMessage_Type_ADD_FRIEND_REJECT == cacheMessage.m_messageType || FDSMessageCenterMessage_Type_ADD_FRIEND_SUC_RESULT == cacheMessage.m_messageType || FDSMessageCenterMessage_Type_ADD_FRIEND_FAIL_RESULT == cacheMessage.m_messageType)
            {
                findLoc = i;
                isExist = YES;
                break;
            }
        }
        
        /* 接收到的消息肯定为当前用户  所以无需判断 */
        if (isExist) //找到则更新对应缓存  此时messageCenter和cacheMessage都有原来添加成功的数据库ID
        {
            if (messageCenter.m_id != cacheMessage.m_id)  //不同的好友发过来才添加  同一人发送未读数不增加  只更新其他字段
            {
                cacheMessage.m_newMessageCount +=1; //每次都加1
            }
            cacheMessage.m_content = messageCenter.m_content;
            cacheMessage.m_senderName = messageCenter.m_senderName;
            cacheMessage.m_msgContent = messageCenter.m_msgContent;
            cacheMessage.m_sendTime = messageCenter.m_sendTime;
            
            //only refresh row in chatTable
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:findLoc inSection:0];
            [_msgTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        }
        else //不存在则插入到数组最前面  messageCenter这时候有对应messageCenter表中的messageID
        {
            /* 新收到一个好友发来的消息 */
            messageCenter.m_newMessageCount = 1; //此时为1
            [self.centerMesageList insertObject:messageCenter atIndex:0];
            [_msgTable reloadData];
            [_msgTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}

/* push消息 收到对方的添加好友请求 */
- (void)addFriendRequestCB:(FDSMessageCenter*)centerMessage :(FDSUser*)friendInfo
{
    /* 更新一条消息到MessageCenter */
    [self handlePushMessage:centerMessage];
}

/* push消息 发出添加好友请求后收到的回复 */
- (void)addFriendReplyCB:(FDSUser*)friendInfo :(FDSMessageCenter*)messageCenter;
{
    if (messageCenter)
    {
        [self handlePushMessage:messageCenter];
    }
}

- (void)setCenterMesageList:(NSMutableArray *)centerMesageList
{
    [self.centerMesageList removeAllObjects];
    [_centerMesageList release];
    _centerMesageList = [centerMesageList retain];
}

- (void)dealloc
{
    self.filteredListContent = nil;
    [_mySearchDisplayController release];
    self.centerMesageList = nil;
    [super dealloc];
}

- (void)netWorkViewInit
{
    /*  网络不可用提示   */
    networkView = [[UIView alloc] initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith, 40)];
    networkView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:networkView];
    [networkView release];
    
    UIImageView *networkImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 25, 25)];
    networkImg.image = [UIImage imageNamed:@"network_no_avalible"];
    [networkView addSubview:networkImg];
    [networkImg release];
    
    UILabel *promptLab = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 200, 30)];
    promptLab.backgroundColor = [UIColor clearColor];
    promptLab.textColor = [UIColor redColor];
    promptLab.text = @"当前网络不可用";
    promptLab.font=[UIFont systemFontOfSize:15];
    [networkView addSubview:promptLab];
    [promptLab release];
    
    networkView.hidden = YES;
    /*  网络不可用提示   */
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
        
    _msgTable = [[UITableView alloc]initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith,kMSTableViewHeight-44-49) style:UITableViewStylePlain];
    _msgTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _msgTable.delegate = self;
    _msgTable.dataSource = self;
    [self.view addSubview:_msgTable];
    [_msgTable release];
    
    [self loadSearchBarView];

    _unLoginview = [[UnLoginView alloc] initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith, kMSTableViewHeight-44-49)];
    _unLoginview.delegate = self;
    [self.view addSubview:_unLoginview];
    [_unLoginview release];
    [self.view bringSubviewToFront:_unLoginview];
    
    [self netWorkViewInit];
	// Do any additional setup after loading the view.
}

- (void)handleRightEvent
{
    /*切到联系人页面*/
    FDSAdressBookViewController *contactsVC = [[FDSAdressBookViewController alloc]init];
    contactsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:contactsVC animated:YES];
    [contactsVC release];
}

#pragma mark - LoginBtnDelegate Method
- (void)didselectLogin
{
    FDSLoginViewController *loginVC = [[FDSLoginViewController alloc]init];
    loginVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginVC animated:YES];
    [loginVC release];
}

#pragma mark - UITableViewDelegate UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return self.filteredListContent.count;
    }
    else
    {
        return self.centerMesageList.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentify = @"MSGTableViewCell";
    MsgCenterTableViewCell *msgCell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIndentify];
    if (nil == msgCell)
    {
        msgCell = [[[MsgCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify] autorelease];
    }
    
    //***config cell***
    FDSMessageCenter *messageCenter = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        messageCenter = [self.filteredListContent objectAtIndex:indexPath.row];
    }
    else
    {
        messageCenter = [self.centerMesageList objectAtIndex:indexPath.row];
    }
    
    if (0 == messageCenter.m_newMessageCount) //未读消息为0
    {
        msgCell.unReadImg.hidden = YES;
    }
    else
    {
        msgCell.unReadImg.hidden = NO;
        msgCell.unReadNum.text = [NSString stringWithFormat:@"%d",messageCenter.m_newMessageCount];
    }
    if (messageCenter.m_messageClass == FDSMessageCenterMessage_Class_SYSTEM || FDSMessageCenterMessage_Type_ADD_FRIEND_REQUEST== messageCenter.m_messageType || FDSMessageCenterMessage_Type_ADD_FRIEND_AGREE == messageCenter.m_messageType|| FDSMessageCenterMessage_Type_ADD_FRIEND_REJECT == messageCenter.m_messageType || FDSMessageCenterMessage_Type_ADD_FRIEND_SUC_RESULT == messageCenter.m_messageType || FDSMessageCenterMessage_Type_ADD_FRIEND_FAIL_RESULT == messageCenter.m_messageType)
    {
        msgCell.headImg.image = [UIImage imageNamed:@"system_message_bg"]; //系统通知icon
    }
    else
    {
        [msgCell.headImg initWithPlaceholderImage:[UIImage imageNamed:@"headphoto_s"]];
        msgCell.headImg.imageURL = [NSURL URLWithString:messageCenter.m_icon];
    }
    
    if (FDSMessageCenterMessage_Type_CHAT_GROUP == messageCenter.m_messageType)
    {
        msgCell.nameLab.text = messageCenter.m_param2;  //群名
    }
    else
    {
        msgCell.nameLab.text = messageCenter.m_senderName;
    }
    [msgCell.contentLab showContentMessage:messageCenter.m_msgContent];

    NSTimeInterval timeValue = [messageCenter.m_sendTime doubleValue];
    NSDate *confromTime = [NSDate dateWithTimeIntervalSince1970:timeValue/1000];
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    msgCell.timeLab.text = [formatter stringFromDate:confromTime];
    return msgCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FDSMessageCenter *messageCenter = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        messageCenter = [self.filteredListContent objectAtIndex:indexPath.row];
    }
    else
    {
        messageCenter = [self.centerMesageList objectAtIndex:indexPath.row];
    }
    if (messageCenter.m_messageClass == FDSMessageCenterMessage_Class_SYSTEM || FDSMessageCenterMessage_Type_ADD_FRIEND_REQUEST== messageCenter.m_messageType || FDSMessageCenterMessage_Type_ADD_FRIEND_AGREE == messageCenter.m_messageType|| FDSMessageCenterMessage_Type_ADD_FRIEND_REJECT == messageCenter.m_messageType || FDSMessageCenterMessage_Type_ADD_FRIEND_SUC_RESULT == messageCenter.m_messageType || FDSMessageCenterMessage_Type_ADD_FRIEND_FAIL_RESULT == messageCenter.m_messageType)
    {
        //系统消息列表
        FDSSystemMessageViewController *sysytemVC = [[FDSSystemMessageViewController alloc] init];
        if (messageCenter.m_newMessageCount > 0) //存在未读数
        {
            sysytemVC.isUpdateDB = YES;
        }
        else
        {
            sysytemVC.isUpdateDB = NO;
        }
        sysytemVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController: sysytemVC animated:YES];
        [sysytemVC release];
    }
    else
    {
        FDSChatViewController *chatVC = [[FDSChatViewController alloc] init];
        chatVC.hidesBottomBarWhenPushed = YES;
        
        chatVC.centerMessage = messageCenter;
        
        [self.navigationController pushViewController: chatVC animated:YES];
        [chatVC release];
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        FDSMessageCenter *messageCenter = [self.centerMesageList objectAtIndex:indexPath.row];
        if (messageCenter.m_messageClass == FDSMessageCenterMessage_Class_SYSTEM || FDSMessageCenterMessage_Type_ADD_FRIEND_REQUEST== messageCenter.m_messageType || FDSMessageCenterMessage_Type_ADD_FRIEND_AGREE == messageCenter.m_messageType|| FDSMessageCenterMessage_Type_ADD_FRIEND_REJECT == messageCenter.m_messageType || FDSMessageCenterMessage_Type_ADD_FRIEND_SUC_RESULT == messageCenter.m_messageType || FDSMessageCenterMessage_Type_ADD_FRIEND_FAIL_RESULT == messageCenter.m_messageType)
        {
            //清空消息列表
            [[FDSDBManager sharedManager]deleteAllSystemMessageFromDB];
            [self.centerMesageList removeObjectAtIndex:indexPath.row];
            [_msgTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            // Delete the row from the data source.
            [[FDSDBManager sharedManager] deleteMessageCenterFromDB:messageCenter.m_id];
            [self.centerMesageList removeObjectAtIndex:indexPath.row];
            [_msgTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}



#pragma mark -
#pragma mark -----------Load SearchBarView--------------------
-(void)loadSearchBarView
{
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    if (!IOS_7)
    {
        searchBar.backgroundColor=COLOR(229, 229, 229, 1);
        [[searchBar.subviews objectAtIndex:0]removeFromSuperview];
    }
    
    [searchBar setPlaceholder:@"请输入搜索内容"];
    [searchBar setDelegate:self];
    [searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [searchBar sizeToFit];
    self.msgTable.tableHeaderView = searchBar;
    [searchBar release];
    
    _mySearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    _mySearchDisplayController.active = NO;
    _mySearchDisplayController.searchResultsTableView.dataSource=self;
    _mySearchDisplayController.searchResultsTableView.delegate=self;
    [_mySearchDisplayController setDelegate:self];
    [_mySearchDisplayController setSearchResultsDataSource:self];
    [_mySearchDisplayController setSearchResultsDelegate:self];
}


#pragma mark --------SearchBar delegate---------------------
-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    NSLog(@"here scope");
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)hsearchBar
{
    if (!IOS_7)
    {
        [hsearchBar setShowsCancelButton:YES animated:NO];
        for(id cc in [searchBar subviews])
        {
            if([cc isKindOfClass:[UIButton class]])
            {
                UIButton *btn = (UIButton *)cc;
                [btn setBackgroundImage:[UIImage imageNamed:@"system_reject_hl_bg"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"system_reject_hl_bg"] forState:UIControlStateHighlighted];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
                [btn setTitle:@"取消"  forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                break;
            }
        }
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)aSearchBar
{
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar
{
//	[self.searchDisplayController setActive:NO animated:NO];
//	[self.msgTable reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar
{
}

#pragma mark -
#pragma mark ContentFiltering
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [_filteredListContent removeAllObjects];
    if (searchText.length>0 && ![ChineseInclude isIncludeChineseInString:searchText])
    {
        for (FDSMessageCenter *message in self.centerMesageList)
        {
            if ([ChineseInclude isIncludeChineseInString:message.m_senderName])
            {
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:message.m_senderName];
                NSRange titleResult=[tempPinYinStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleResult.length>0)
                {
                    [_filteredListContent addObject:message];
                    continue;
                }
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:message.m_senderName];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleHeadResult.length>0)
                {
                    [_filteredListContent addObject:message];
                    continue;
                }
            }
            else
            {
                NSRange titleResult=[message.m_senderName rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleResult.length>0)
                {
                    [_filteredListContent addObject:message];
                    continue;
                }
            }
            
            /*  能执行以下代码证明还未匹配到名字  接着匹配聊天内容  */
            if ([ChineseInclude isIncludeChineseInString:message.m_content])
            {
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:message.m_content];
                NSRange titleResult=[tempPinYinStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleResult.length>0)
                {
                    [_filteredListContent addObject:message];
                    continue;
                }
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:message.m_content];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleHeadResult.length>0)
                {
                    [_filteredListContent addObject:message];
                    continue;
                }
            }
            else
            {
                NSRange titleResult=[message.m_content rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleResult.length>0)
                {
                    [_filteredListContent addObject:message];
                    continue;
                }
            }
        }
    }
    else if (searchText.length>0&&[ChineseInclude isIncludeChineseInString:searchText])
    {
        for (FDSMessageCenter *message in self.centerMesageList)
        {
            NSRange titleResult=[message.m_senderName rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (titleResult.length>0)
            {
                [_filteredListContent addObject:message];
                continue;
            }
            
            /*  能执行以下代码证明还未匹配到名字  接着匹配聊天内容  */
            titleResult=[message.m_content rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (titleResult.length>0)
            {
                [_filteredListContent addObject:message];
                continue;
            }
        }
    }
    
    
    
}

#pragma mark -
#pragma mark UISearchDisplayControllerDelegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if (searchString)
    {
        [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    return YES;
}

@end

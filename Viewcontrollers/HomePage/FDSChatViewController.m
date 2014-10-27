 //
//  FDSChatViewController.m
//  FDS
//
//  Created by zhuozhongkeji on 14-1-3.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSChatViewController.h"
#import "FDSFriendProfileViewController.h"
#import "UIViewController+BarExtension.h"
#import "FDSChatMessage.h"
#import "FDSDBManager.h"
#import "FDSUserManager.h"
#import "FDSMessageCenter.h"
#import "FDSPublicManage.h"
#import "TimerLabel.h"
#import "FDSPublicManage.h"
#import "FDSPathManager.h"
#import "FDSGroupCardViewController.h"
#import "FDSBarCommentViewController.h"
#import "FDSBarPostInfo.h"
#import "FDSMySpaceViewController.h"

#define KChatPageCount   10
#define SnapTime         60*3

@interface FDSChatViewController ()

@end

@implementation FDSChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (!self.messageList)
        {
            _messageList = [[NSMutableArray alloc] init];
        }
        self.centerMessage = nil;
        lastShowDate = nil;
        nowReadCount =  KChatPageCount;
    }
    return self;
}

/** ################################  ################################ **/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/* 更新最后一次显示得时间 */
- (void)updateLastDate :(NSDate*)time
{
    lastShowDate = [time copy];
}

/*  聊天信息是否显示时间  */
-(enum CHAT_MESSAGE_SHOW_TIME)handleShowTime:(NSString*)time
{
    if ([time longLongValue]/1000 - lastShowDate.timeIntervalSince1970 >= SnapTime)
    {
        return CHAT_MESSAGE_SHOW_TIP;
    }
    return CHAT_MESSAGE_SHOW_NO_TIP;
}

- (void)updateChatInfo:(FDSChatMessage*)chatMessage
{
    if (0 == self.messageList.count)//第一条默认显示时间
    {
        chatMessage.m_showtime = CHAT_MESSAGE_SHOW_TIP;
    }
    else
    {
        chatMessage.m_showtime = [self handleShowTime:chatMessage.m_chatTime];
    }
    if (CHAT_MESSAGE_SHOW_TIP == chatMessage.m_showtime) //更新最后一次显示得时间
    {
        [self updateLastDate:[[FDSPublicManage sharePublicManager] getDateFromInterval:chatMessage.m_chatTime]];
    }
}

/* 拉取一定条数 */
-(void)reloadAllMessage:(NSInteger)count
{
    NSMutableArray *array = [[FDSDBManager sharedManager] getChatMessageWithID :self.centerMessage :count];
    if(array && [array count] > 0)
    {
        for (int i = [array count]-1;i >= 0 ;i --)
        {
            FDSChatMessage *chatRecord = [array objectAtIndex:i];
            
            [self updateChatInfo:chatRecord]; //更新显示时间字段
            
            [self.messageList addObject:chatRecord];
        }
    }
    [array removeAllObjects];
    [array release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[FDSUserCenterMessageManager sharedManager] registerObserver:self];
    [[ZZUploadManager sharedUploadManager] registerObserver:self];

    needUpdateDB = NO; //默认不更新
    /* 每次都需要去查询最新chatMessage表情况 因为后台可能收到未读消息 */
    if (self.centerMessage)
    {
        [self.messageList removeAllObjects];
        [sizeList removeAllObjects];
        [self reloadAllMessage:nowReadCount];
        
        /* 设置该好友的消息全部已读  处理未有聊天数据添加的场景*/
        if (self.centerMessage.m_newMessageCount > 0) //有未读数才去更新
        {
            [[FDSDBManager sharedManager]updateChatRecordDoRead:self.centerMessage];
        }
    }

    if (self.messageList.count > 0)
    {
        [messageListView reloadData]; //防止聊天数据变化crash
        [messageListView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageList.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[FDSUserCenterMessageManager sharedManager] unRegisterObserver:self];
    [[ZZUploadManager sharedUploadManager] unRegisterObserver:self];

    /* 更新最后一条消息到messageCenter表中 */
    if (self.messageList.count > 0  && needUpdateDB)
    {
        FDSChatMessage *chatMessage = [self.messageList objectAtIndex:self.messageList.count-1];
        FDSMessageCenter *messageCenter = [[FDSMessageCenter alloc] init];
        messageCenter.m_messageClass = FDSMessageCenterMessage_Class_USER; //个人信息
        messageCenter.m_messageType = self.centerMessage.m_messageType;
        messageCenter.m_sendTime = chatMessage.m_chatTime;
        messageCenter.m_state = FDS_MSG_STATE_READED; //此时对应聊天未读数目为0
        messageCenter.m_icon = self.centerMessage.m_icon; //消息中心头像都显示好友头像
        if (FDSMessageCenterMessage_Type_CHAT_PERSON == self.centerMessage.m_messageType)
        {
            messageCenter.m_senderName = self.centerMessage.m_senderName;//消息中心名字都显示好友名字
            messageCenter.m_param1 = @""; //群ID
            messageCenter.m_param2 = @""; //群组名
            messageCenter.m_senderID = self.centerMessage.m_senderID;//好友ID
        }
        else if(FDSMessageCenterMessage_Type_CHAT_GROUP == self.centerMessage.m_messageType)
        {
            messageCenter.m_senderName = chatMessage.m_senderName;
            messageCenter.m_param1 = self.centerMessage.m_param1; //群ID
            messageCenter.m_param2 = self.centerMessage.m_param2; //群组名
            messageCenter.m_senderID = chatMessage.m_senderID;
        }
        if (chatMessage.m_tmpImg.length > 0 || (![chatMessage.m_imageURL isEqualToString:@"(null)"] && chatMessage.m_imageURL.length > 0))
        {
            messageCenter.m_content = @"[图片]";
        }
        else
        {
            messageCenter.m_content = chatMessage.m_content;
        }
        
        /* 更新一条消息到MessageCenter */
        [[FDSDBManager sharedManager]updateMessageCenterToDB:messageCenter];
        /* 设置该好友的消息全部已读 */
        [[FDSDBManager sharedManager]updateChatRecordDoRead:messageCenter];
        [messageCenter release];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    [faceBoard release];
    [self.messageList removeAllObjects];
    self.messageList = nil;
    [sizeList release];
    [lastShowDate release];
    self.centerMessage = nil;
    [super dealloc];
}

- (void)handleRightEvent
{
    /* 点击进入好友的profile */
    if (FDSMessageCenterMessage_Type_CHAT_GROUP == self.centerMessage.m_messageType)
    {
        FDSGroupCardViewController *groupVC = [[FDSGroupCardViewController alloc] init];
        
        groupVC.groupID = self.centerMessage.m_param1;
        groupVC.groupType = @"company";//目前只支持公司群
        
        [self.navigationController pushViewController:groupVC animated:YES];
        [groupVC release];
    }
    else
    {
        FDSFriendProfileViewController *fpVC = [[FDSFriendProfileViewController alloc]init];
        
        FDSUser *friendInfo = [[FDSUser alloc] init];
        friendInfo.m_friendID = self.centerMessage.m_senderID;
        friendInfo.m_name = self.centerMessage.m_senderName;
        friendInfo.m_icon = self.centerMessage.m_icon;
        fpVC.friendInfo = friendInfo;
        
        [self.navigationController pushViewController:fpVC animated:YES];
        [fpVC release];
        [friendInfo release];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    if (FDSMessageCenterMessage_Type_CHAT_GROUP == self.centerMessage.m_messageType)
    {
        [self homeNavbarWithTitle:self.centerMessage.m_param2 andLeftButtonName:@"btn_caculate" andRightButtonName:@"navbar_contactlist_bg"]; //群名
    }
    else
    {
        [self homeNavbarWithTitle:self.centerMessage.m_senderName andLeftButtonName:@"btn_caculate" andRightButtonName:@"navbar_contact_bg"];
    }

    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self allSubViewInit];
    
    if ( !sizeList )
    {
        sizeList = [[NSMutableDictionary alloc] init];
    }
    isFirstShowKeyboard = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)handleGes:(UIGestureRecognizer *)guestureRecognizer
{
    if (isKeyboardShowing)
    {
        [textView resignFirstResponder];
    }
}

- (void)allSubViewInit
{
    /* 聊天列表 */
    messageListView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith,kMSTableViewHeight-44-44) style:UITableViewStylePlain];
    messageListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    messageListView.pullingDelegate = self;
    messageListView.delegate = self;
    messageListView.dataSource = self;
    messageListView.headerOnly = YES;
    [self.view addSubview:messageListView];
    [messageListView release];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGes:)];
    tap.cancelsTouchesInView=NO;
    [messageListView addGestureRecognizer:tap];
    [tap release];

    /* 信息操作view */
    toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, kMSNaviHight+(kMSTableViewHeight-88), kMSScreenWith, 44)];
    toolBar.backgroundColor = COLOR(34, 34, 34, 1);
    [self.view addSubview:toolBar];
    [toolBar release];
    
    photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    photoBtn.frame = CGRectMake(10, 8, 28, 28);
    photoBtn.adjustsImageWhenHighlighted = NO;
    [photoBtn addTarget:self action:@selector(didSelectPhoto) forControlEvents:UIControlEventTouchUpInside];
    [photoBtn setBackgroundImage:[UIImage imageNamed:@"chat_photo_bg"] forState:UIControlStateNormal];
    [toolBar addSubview:photoBtn];
    
    keyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    keyboardButton.frame = CGRectMake(48, 8, 28, 28);
    keyboardButton.adjustsImageWhenHighlighted = NO;
    [keyboardButton addTarget:self action:@selector(exchangeTextAndEmoji:) forControlEvents:UIControlEventTouchUpInside];
    [keyboardButton setBackgroundImage:[UIImage imageNamed:@"board_emoji"] forState:UIControlStateNormal];
    [toolBar addSubview:keyboardButton];

    textView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(86, 5, 270-86, 34)];
    textView.font = [UIFont systemFontOfSize:16.0f];
    textView.textColor = kMSTextColor;
    textView.placeholder = @"输入信息内容";
    textView.delegate = self;
    [textView.layer setCornerRadius:6];
    [textView.layer setMasksToBounds:YES];
    [toolBar addSubview:textView];
    [textView release];

    sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake(270, 0, 50, 44);
    sendButton.adjustsImageWhenHighlighted = NO;
    [sendButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:sendButton];
    
    /* 表情view */
    if (!faceBoard)
    {
        faceBoard = [[FaceBoard alloc] init];
        faceBoard.delegate = self;
        faceBoard.inputTextView = textView;
    }
}

/** ################################ UIKeyboardNotification################################ **/

- (void)keyboardWillShow:(NSNotification *)notification
{
    isKeyboardShowing = YES;
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         CGRect frame = messageListView.frame;
                         frame.size.height += keyboardHeight;
                         frame.size.height -= keyboardRect.size.height;
                         messageListView.frame = frame;
                         
                         frame = toolBar.frame;
                         frame.origin.y += keyboardHeight;
                         frame.origin.y -= keyboardRect.size.height;
                         toolBar.frame = frame;
                         
                         keyboardHeight = keyboardRect.size.height;
                     }];
    if ( isFirstShowKeyboard )
    {
        isFirstShowKeyboard = NO;
        isSystemBoardShow = YES;
    }
    
    if ( isSystemBoardShow )//显示键盘时
    {
        [keyboardButton setBackgroundImage:[UIImage imageNamed:@"board_emoji"] forState:UIControlStateNormal];
    }
    else//显示表情时
    {
        [keyboardButton setBackgroundImage:[UIImage imageNamed:@"board_system"] forState:UIControlStateNormal];
    }
    
    if ( self.messageList.count )
    {
        [messageListView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageList.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         CGRect frame = messageListView.frame;
                         frame.size.height += keyboardHeight;
                         messageListView.frame = frame;
                         
                         frame = toolBar.frame;
                         frame.origin.y += keyboardHeight;
                         toolBar.frame = frame;
                         
                         keyboardHeight = 0;
                     }];
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    isKeyboardShowing = NO;
    isFirstShowKeyboard = YES;
    
    textView.inputView = nil;
    
    [keyboardButton setBackgroundImage:[UIImage imageNamed:@"board_emoji"]
                              forState:UIControlStateNormal];
}

/** ################################ ViewController ################################ **/
- (void)exchangeTextAndEmoji:(id)sender
{
    if ( isKeyboardShowing )
    {
        if ( ![textView.inputView isEqual:faceBoard] )
        {
            isSystemBoardShow = NO;
            textView.inputView = faceBoard;
        }
        else
        {
            isSystemBoardShow = YES;
            textView.inputView = nil;
        }
        [textView reloadInputViews];
    }
    else
    {
        if ( isFirstShowKeyboard )
        {
            isFirstShowKeyboard = NO;
            isSystemBoardShow = NO;
        }
        if ( !isSystemBoardShow )
        {
            textView.inputView = faceBoard;
        }
        [textView becomeFirstResponder];
    }
}

- (void)sendMessage:(id)sender
{
    needReload = NO;
    if ( ![textView.text isEqualToString:@""] && self.centerMessage)
    {
        needReload = YES;
        
        FDSChatMessage *chatmsg = [[FDSChatMessage alloc] init];
        chatmsg.m_chatContent = [[[NSMutableArray alloc] init] autorelease];
        [[FDSPublicManage sharePublicManager] getMessageRange:textView.text :chatmsg.m_chatContent];
        chatmsg.m_content = textView.text;  //该字段方便数据库存取方便
        chatmsg.m_owner = YES;
        chatmsg.m_send_state = MSG_STATE_SENDING;
        chatmsg.m_state = FDS_MSG_STATE_READED; //已读
        chatmsg.m_messageID = arc4random() % 5 ; //随机生成
        chatmsg.m_chatTime = [[FDSPublicManage sharePublicManager]getNowDate];
        if (FDSMessageCenterMessage_Type_CHAT_PERSON == self.centerMessage.m_messageType)
        {
            chatmsg.m_recevierID = self.centerMessage.m_senderID;
            chatmsg.m_messageType = CHAT_MESSAGE_TYPE_CHAT_PERSON;
            chatmsg.m_groupID = @"";
            chatmsg.m_roleType = FDS_Role_Type_User;
        }
        else if (FDSMessageCenterMessage_Type_CHAT_GROUP == self.centerMessage.m_messageType)
        {
            chatmsg.m_recevierID = @"";
            chatmsg.m_messageType = CHAT_MESSAGE_TYPE_CHAT_GROUP;
            chatmsg.m_groupID = self.centerMessage.m_param1;
            chatmsg.m_roleType = FDS_Role_Type_Group_Company;
        }
        FDSUser *userInfo = [[FDSUserManager sharedManager]getNowUser];
        chatmsg.m_senderID = userInfo.m_userID;  //发送者为自己
        chatmsg.m_senderName = userInfo.m_name;
        chatmsg.m_senderIcon = userInfo.m_icon;

        /*  发送聊天信息 */
        [[FDSUserCenterMessageManager sharedManager] sendIM:chatmsg];
        
        [self updateChatInfo:chatmsg]; //更新显示时间字段

        /* 添加发送信息到缓存中 */
        [self.messageList addObject:chatmsg];
        [chatmsg release];
        
        textView.text = nil;
        textView.contentSize = CGSizeMake(184, 36);
        [self textViewDidChange:textView];
    }
    
    if ( needReload )
    {
        [messageListView reloadData];
        [messageListView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageList.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        needReload = NO;
    }
}

- (void)didSelectPhoto
{
    UIActionSheet*alert = [[UIActionSheet alloc]
                           initWithTitle:@"选择照相还是相册"
                           delegate:self
                           cancelButtonTitle:NSLocalizedString(@"取消",nil)
                           destructiveButtonTitle:nil
                           otherButtonTitles:NSLocalizedString(@"相机拍摄",nil),
                           NSLocalizedString(@"手机相册",nil),
                           nil];
    [alert showInView:self.view];
    [alert release];
}

#pragma UIActionSheetDelegate method
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([actionSheet.title isEqualToString:@"选择照相还是相册"])
    {
        switch(buttonIndex)
        {
            case 1:
            {
                UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
                [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                [imagePicker setDelegate:self];
                [imagePicker setAllowsEditing:NO];

                [self presentViewController:imagePicker animated:YES completion:nil];
                [imagePicker release];
            }
                break;
            case 0:
            {
                UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
                
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                {
                    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
                    [imagePicker setDelegate:self];
                    [imagePicker setAllowsEditing:YES];
                }
                [self presentViewController:imagePicker animated:YES completion:nil];
                [imagePicker release];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark Picker Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img = nil;
	if (!img)
	{
		img = [info objectForKey:UIImagePickerControllerOriginalImage]; //原始图片
	}
	
//    //裁减图片到指定高宽
//    UIImage *newImage = [UIImageSize thumbnailOfImage:img Size:CGSizeMake(80.0, 80.0)];
//	NSData *thumbData = [NSData dataWithData:UIImagePNGRepresentation(newImage)];
    
	[picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *filepath = [FDSPublicManage fitSmallWithImage:img];
    
    [[ZZUploadManager sharedUploadManager]beginUploadRequest:[[FDSPathManager sharePathManager]getMessageImagePath] :[[FDSPublicManage sharePublicManager] getGUID] :@"" :@"all" :[NSData dataWithContentsOfFile:filepath] :@"jpg" ];

    [self sendImageMessage:filepath];
}


- (void)sendImageMessage:(NSString*)tmpImagePath
{
    /*  开始把图片信息加入到消息列表  */
    sendmesssgaeImg = [[FDSChatMessage alloc] init];
    /* 聊天发送时间 */
    sendmesssgaeImg.m_chatTime = [[FDSPublicManage sharePublicManager]getNowDate];
    sendmesssgaeImg.m_chatContent = [[[NSMutableArray alloc] init] autorelease];
    sendmesssgaeImg.m_tmpImg = tmpImagePath; //发送前存本地图片路径
    sendmesssgaeImg.m_owner = YES;
    sendmesssgaeImg.m_send_state = MSG_STATE_SENDING;
    if (FDSMessageCenterMessage_Type_CHAT_PERSON == self.centerMessage.m_messageType)
    {
        sendmesssgaeImg.m_recevierID = self.centerMessage.m_senderID;
        sendmesssgaeImg.m_messageType = CHAT_MESSAGE_TYPE_CHAT_PERSON;
        sendmesssgaeImg.m_groupID = @"";
        sendmesssgaeImg.m_roleType = FDS_Role_Type_User;
    }
    else if (FDSMessageCenterMessage_Type_CHAT_GROUP == self.centerMessage.m_messageType)
    {
        sendmesssgaeImg.m_recevierID = @"";
        sendmesssgaeImg.m_messageType = CHAT_MESSAGE_TYPE_CHAT_GROUP;
        sendmesssgaeImg.m_groupID = self.centerMessage.m_param1;
        sendmesssgaeImg.m_roleType = FDS_Role_Type_Group_Company;
    }
    FDSUser *userInfo = [[FDSUserManager sharedManager]getNowUser];
    sendmesssgaeImg.m_senderID = userInfo.m_userID;  //发送者为自己
    sendmesssgaeImg.m_senderName = userInfo.m_name;
    sendmesssgaeImg.m_senderIcon = userInfo.m_icon;
    sendmesssgaeImg.m_state = FDS_MSG_STATE_READED; //已读
    sendmesssgaeImg.m_messageID = arc4random() % 5 ; //随机生成
    

    [self updateChatInfo:sendmesssgaeImg]; //更新显示时间字段
    /* 添加发送信息到缓存中 */
    [self.messageList addObject:sendmesssgaeImg];
    [sendmesssgaeImg release];
    
    [messageListView reloadData];
    [messageListView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageList.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}


#pragma mark ZZUploadInterface Delegate Method
- (void)uploadStateNotice:(ZZUploadRequest*)uploadRequest
{
    if (ZZUploadState_UPLOAD_OK == uploadRequest.m_uploadState || ZZUploadState_UPLOAD_FAIL == uploadRequest.m_uploadState)
    {
        if (ZZUploadState_UPLOAD_OK == uploadRequest.m_uploadState) //上传图片到文件服务器成功
        {
            /*  发送聊天信息 */
            sendmesssgaeImg.m_imageURL = uploadRequest.m_filePath;
            [[FDSUserCenterMessageManager sharedManager] sendIM:sendmesssgaeImg];
        }
        else //fail
        {
            
        }
    }
}

#pragma mark - FDSUserCenterMessageInterface Methods
- (void)sendIMCB:(NSString *)result :(NSString *)messageID
{
    needUpdateDB = YES;
    /* 通过messageID可以获取对哪条消息操作 */
    NSInteger msgID = [messageID integerValue];
    FDSChatMessage *chatmsg = nil;
    BOOL isExist = NO;
    NSInteger findIndex = 0;
    for (int i= self.messageList.count-1; i>=0; i--) //从消息数组最后一个开始匹配
    {
        chatmsg = [self.messageList objectAtIndex:i];
        if (msgID == chatmsg.m_messageID)
        {
            isExist = YES;
            findIndex = i;
            break;
        }
    }
    if (isExist && chatmsg) //匹配到对应发送的消息
    {
        /* 添加该条数据到数据库 */
        //同时更新了chatmsg 缓存的 messageID 此时页面获取到了数据库的消息ID
        [[FDSDBManager sharedManager]AddChatMessageToDB:chatmsg];

        if ([result isEqualToString:@"OK"])
        {
//            NSLog(@"----发送成功-----");
            chatmsg.m_send_state = MSG_STATE_SEND_SUCCESS;
        }
        else
        {
            chatmsg.m_send_state = MSG_STATE_SEND_FAILED;
        }
        //only refresh row in chatTable
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:findIndex inSection:0];
        [messageListView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    }
}

/* push 收消息 */
- (void)getIMCB:(FDSChatMessage*)chatMessage :(FDSMessageCenter*)messageCenter
{
    /* 判断该push消息是否为当前页面好友发送  */
    if ( (CHAT_MESSAGE_TYPE_CHAT_PERSON == chatMessage.m_messageType &&[chatMessage.m_senderID isEqualToString:self.centerMessage.m_senderID])
        || (CHAT_MESSAGE_TYPE_CHAT_GROUP == chatMessage.m_messageType && [self.centerMessage.m_param1 isEqualToString:chatMessage.m_groupID])
        )
    {
        // 此时页面获取到了数据库对应的消息ID
        needUpdateDB = YES; //只针对当前页面好友收到消息做DB更新
        
        [self updateChatInfo:chatMessage];
        
        [self.messageList addObject:chatMessage];
        /* 更新消息为已读 */
//        NSLog(@"FDSChatViewController中消息messageID = %d",chatMessage.m_messageID);
        
        [messageListView reloadData];
        [messageListView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageList.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

/**
 *  获取文本尺寸
 */
- (void)getContentSize:(NSIndexPath *)indexPath
{
    @synchronized ( self )
    {
        CGFloat viewWidth;
        
        CGFloat viewHeight;
        
        FDSChatMessage *chatMessage = [self.messageList objectAtIndex:indexPath.row];
        if (chatMessage.m_tmpImg.length > 0 || (![chatMessage.m_imageURL isEqualToString:@"(null)"] && chatMessage.m_imageURL.length > 0))
        {
            NSValue *sizeValue = [NSValue valueWithCGSize:CGSizeMake(80, 80)];
            [sizeList setValue:sizeValue forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
            return;
        }
        NSMutableArray *messageRange = chatMessage.m_chatContent;
        
        NSDictionary *faceMap = [[NSUserDefaults standardUserDefaults] objectForKey:@"FaceMap"];
        
        UIFont *font = [UIFont systemFontOfSize:16.0f];
        
        isLineReturn = NO;
        
        upX = VIEW_LEFT;
        upY = VIEW_TOP;
        
        for (int index = 0; index < [messageRange count]; index++)
        {
            NSString *str = [messageRange objectAtIndex:index];
            if ( [str hasPrefix:FACE_NAME_HEAD] )
            {
                NSArray *imageNames = [faceMap allKeysForObject:str];
                NSString *imageName = nil;
                NSString *imagePath = nil;
                if ( imageNames.count > 0 )
                {
                    imageName = [NSString stringWithFormat:@"%@@2x",[imageNames objectAtIndex:0]];
                    imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
                }
                if ( imagePath )
                {
                    if ( upX > VIEW_WIDTH_MAX )
                    {
                        isLineReturn = YES;
                        upX = VIEW_LEFT;
                        upY += VIEW_LINE_HEIGHT;
                    }
                    upX += KFacialSizeWidth;
                }
                else
                {
                    [self getTextHeight:str :font];
                }
            }
            else
            {
                NSRange range = [str rangeOfString:POST_NAME_HEAD];
                NSRange range2 = [str rangeOfString:DYNAMIC_NAME_HEAD];
                if (range.length > 0)
                {
                    if (range.location > 0)
                    {
                        [self getTextHeight:[str substringToIndex:range.location] :font];
                        str = [str substringFromIndex:range.location];
                        [self getMessageHeight:str :font];
                    }
                }
                else if (range2.length > 0)
                {
                    if (range2.location > 0)
                    {
                        [self getTextHeight:[str substringToIndex:range2.location] :font];
                        str = [str substringFromIndex:range2.location];
                        [self getDynamicHeight:str :font];
                    }
                }
                else
                {
                    [self getTextHeight:str :font];
                }
            }
        }
        
        if ( isLineReturn )
        {
            viewWidth = VIEW_WIDTH_MAX + VIEW_LEFT;//*2;
        }
        else
        {
            viewWidth = upX + VIEW_LEFT;
        }
        
        viewHeight = upY + VIEW_LINE_HEIGHT + VIEW_TOP;
        NSValue *sizeValue = [NSValue valueWithCGSize:CGSizeMake( viewWidth, viewHeight )];
        [sizeList setValue:sizeValue forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    }
}

- (void)getDynamicHeight:(NSString*)string :(UIFont*)font
{
    if (string.length >= DYNAMIC_NAME_LEN)
    {
        string = [string substringFromIndex:12];/* 去除［userRecord: 字符 */
        /*   反向查找  */
        NSRange range = [string rangeOfString:@":" options:NSBackwardsSearch];
        
        string = [string substringToIndex:string.length-1];
        NSString *dynamicTitle = [string substringToIndex:range.location];
        
        isLineReturn = YES;
        upX = VIEW_LEFT;
        upY += VIEW_LINE_HEIGHT;
        
        [self getTextHeight:dynamicTitle :font];
    }
    else
    {
        [self getTextHeight:string :font];
    }
}

- (void)getMessageHeight:(NSString*)string :(UIFont*)font
{
    if (string.length >= POST_NAME_LEN)
    {
        string = [string substringFromIndex:6];/* 去除［post: 字符 */
        /*   反向查找  */
        NSRange range = [string rangeOfString:@":" options:NSBackwardsSearch];
        
        string = [string substringToIndex:string.length-1];
        NSString *postTitle = [string substringToIndex:range.location];
        
        isLineReturn = YES;
        upX = VIEW_LEFT;
        upY += VIEW_LINE_HEIGHT;
        
        [self getTextHeight:postTitle :font];
    }
    else
    {
        [self getTextHeight:string :font];
    }
}

- (void)getTextHeight:(NSString*)string :(UIFont*)font
{
    for ( int index = 0; index < string.length; index++)
    {
        NSString *character = [string substringWithRange:NSMakeRange( index, 1 )];
        CGSize size = [character sizeWithFont:font
                            constrainedToSize:CGSizeMake(VIEW_WIDTH_MAX, VIEW_LINE_HEIGHT * 1.5)];
        if ( upX > VIEW_WIDTH_MAX )
        {
            isLineReturn = YES;
            upX = VIEW_LEFT;
            upY += VIEW_LINE_HEIGHT;
        }
        upX += size.width;
    }
}

/** ################################ UITextViewDelegate ################################ **/
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if( [text length] == 0 )//点击了删除键
    {
        if ( range.length > 1 )
        {
            return YES;
        }
        else
        {
            [faceBoard backFace];
            return NO;
        }
    }
    else //点击了非删除键
    {
        return YES;
    }
}

- (void)textViewDidChange:(UITextView *)_textView
{
    CGSize size;
    if (IOS_7)
    {
        CGSize constraint = CGSizeMake(textView.contentSize.width - 8.0f, CGFLOAT_MAX);
        size = [textView.text sizeWithFont: textView.font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        size.height += 16.0f;
        size.width = textView.contentSize.width;
    }
    else
    {
        size = textView.contentSize;
//        textView.contentOffset = CGPointMake(textView.frame.origin.x, textView.frame.origin.y+13);
//        size.height -= 2;
    }
    
    if ( size.height > 82 )
    {
        size.height = 82;
    }
    else if ( size.height < 34 )
    {
        size.height = 34;
    }
    if ( size.height != textView.frame.size.height )
    {
        if (size.height != 34)
        {
            size.height -= 2;
        }

        CGFloat span = size.height - textView.frame.size.height;
        
        CGRect frame = toolBar.frame;
        frame.origin.y -= span;
        frame.size.height += span;
        toolBar.frame = frame;
        
        CGFloat centerY = frame.size.height / 2;
        
        frame = messageListView.frame;
        frame.size.height -= span;
        messageListView.frame = frame;
        
        frame = textView.frame;
        frame.size = size;
        textView.frame = frame;
        
        CGPoint center = textView.center;
        center.y = centerY;
        textView.center = center;
        
        center = keyboardButton.center;
        center.y = centerY;
        keyboardButton.center = center;
        
        center = photoBtn.center;
        center.y = centerY;
        photoBtn.center = center;

        center = sendButton.center;
        center.y = centerY;
        sendButton.center = center;
        
        //只针对刷新messageListView 的frame变化，但聊天数目未变
        if ( self.messageList.count && !needReload)
        {
            [messageListView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageList.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}

/** ################################ UITableViewDataSource ################################ **/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MessageListCell";
    MessageListCell *cell = (MessageListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MessageListCell" owner:self options:nil] lastObject];
    }

    cell.currentIndexRow = indexPath.row;
    cell.delegate = self;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FDSChatMessage *message = [self.messageList objectAtIndex:indexPath.row];
    NSValue *sizeValue = [sizeList valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    CGSize size = [sizeValue CGSizeValue];
    
    if ( message.m_owner ) //自己发的
    {
        [cell refreshForOwnMsg:message withSize:size];
    }
    else //收到好友发的
    {
        [cell refreshForFrdMsg:message withSize:size];
    }

    [cell addMenuItemInMessageView];
    [cell setBordRect];
    return cell;
}

/** ################################ UITableViewDelegate ################################ **/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSValue *sizeValue = [sizeList valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    if ( !sizeValue )
    {
        [self getContentSize:indexPath];
        sizeValue = [sizeList valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    }
    CGSize size = [sizeValue CGSizeValue];
    CGFloat span = size.height - MSG_VIEW_MIN_HEIGHT;
    CGFloat height = MSG_CELL_MIN_HEIGHT + span;
    return height;
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    nowReadCount += KChatPageCount;
    [self.messageList removeAllObjects];
    [sizeList removeAllObjects];
    
    [self reloadAllMessage:nowReadCount];
    [messageListView reloadData];
    
    [messageListView tableViewDidFinishedLoading];
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
}

- (NSDate *)pullingTableViewRefreshingFinishedDate
{
    NSDate *date = [NSDate date];
    return date;
}

#pragma mark - MessageListDelegate Methods
- (void)didSelectCopy:(NSInteger)currentIndex
{
    /* 拷贝 */
    FDSChatMessage *message = [self.messageList objectAtIndex:currentIndex];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:message.m_content];
}

- (void)didSelectDel:(NSInteger)currentIndex
{
    needUpdateDB = YES;
    /* 删除某条消息 */
    FDSChatMessage *message = [self.messageList objectAtIndex:currentIndex];
    
    [[FDSDBManager sharedManager] deleteChatMessageFromDB:message.m_messageID]; //delete DB
    
    
    /* 移除指定key得值  再重新获取对应高度 */
    NSMutableArray *delList = [NSMutableArray arrayWithCapacity:1];
    for (int i=0; i<self.messageList.count; i++)
    {
        if (i >= currentIndex)//将排在 指定删除消息 之后得所有消息都需要调整高度
        {
            [delList addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    [sizeList removeObjectsForKeys:delList];
    /* 移除指定key得值  再重新获取对应高度 */
    
    
    [self.messageList removeObjectAtIndex:currentIndex];//delete page cache

    [messageListView reloadData]; //因为currentIndex需要重新调整赋值

    if (0 == self.messageList.count)  //删除到为空消息数
    {
        /* 删除消息中心表（messageCenter）得对应好友数据 */
        [[FDSDBManager sharedManager]deleteMessageCenter:self.centerMessage];
    }
}


- (void)didSelectFrdIcon:(NSInteger)currentIndex
{
    FDSFriendProfileViewController *fpVC = [[FDSFriendProfileViewController alloc]init];
    FDSChatMessage *chatMsg = [self.messageList objectAtIndex:currentIndex];
    
    FDSUser *friendInfo = [[FDSUser alloc] init];
    friendInfo.m_friendID = chatMsg.m_senderID;
    if (FDSMessageCenterMessage_Type_CHAT_PERSON == self.centerMessage.m_messageType)
    {
        friendInfo.m_name = self.centerMessage.m_senderName;
        fpVC.refreshNavbar = NO;
    }
    else
    {
        fpVC.refreshNavbar = YES;
    }
    friendInfo.m_icon = chatMsg.m_senderIcon;
    fpVC.friendInfo = friendInfo;
    
    [self.navigationController pushViewController:fpVC animated:YES];
    [fpVC release];
    [friendInfo release];
}

- (void)didSelectDetail:(NSString*)messageID :(NSString*)messageType
{
    if ([messageType isEqualToString:@"POST"])
    {
        /*  帖子详情  */
        FDSBarCommentViewController *barCommentVC = [[FDSBarCommentViewController alloc] init];
        FDSBarPostInfo *tempBar = [[FDSBarPostInfo alloc] init];
        NSMutableArray *collectTypeData = [[FDSPublicManage sharePublicManager]getCollectedDataWithType:FDS_COLLECTED_MESSAGE_POSTBAR];
        if (collectTypeData && collectTypeData.count > 0)
        {
            BOOL isExist = NO;
            FDSCollectedInfo *tempCollect = nil;
            for (int ii=0; ii<collectTypeData.count; ii++)
            {
                tempCollect = [collectTypeData objectAtIndex:ii];
                
                if ([messageID isEqualToString:tempCollect.m_collectID])
                {
                    isExist = YES;
                    break;
                }
            }
            if (isExist)
            {
                tempBar.m_isCollect = YES;
            }
            else
            {
                tempBar.m_isCollect = NO;
            }
        }
        else
        {
            tempBar.m_isCollect = NO;
        }

        tempBar.m_postID = messageID; //对应跳到详情页面的ID
        barCommentVC.barPostInfo = tempBar;
        [tempBar release];
        [self.navigationController pushViewController:barCommentVC animated:YES];
        [barCommentVC release];
    }
    
    else if([messageType isEqualToString:@"userRecord"])
    {
        /*  他人动态  */
        FDSMySpaceViewController *spaceVC = [[FDSMySpaceViewController alloc]init];
        if ([[[FDSUserManager sharedManager] getNowUser].m_userID isEqualToString:messageID])
        {
            spaceVC.isMeInfo = YES;
        }
        else
        {
            spaceVC.isMeInfo = NO;
        }
        spaceVC.friendID = messageID;
        [self.navigationController pushViewController:spaceVC animated:YES];
        [spaceVC release];
    }
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [messageListView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [messageListView tableViewDidEndDragging:scrollView];
}

@end

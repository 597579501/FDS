//
//  FDSUserCenterMessageManager.m
//  FDS
//
//  Created by zhuozhong on 13-12-3.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "FDSUserCenterMessageManager.h"
#import "FDSUserManager.h"
#import "FDSMessageCenter.h"
#import "FDSChatMessage.h"
#import "FDSPublicManage.h"
#import "FDSCompany.h"
#import "FDSComment.h"
#import "FDSRevert.h"
#import "FDSComDesigner.h"

#define FDSUserCenterMessageClass @"fdsUserCenterMessageManager"

@implementation FDSUserCenterMessageManager
static FDSUserCenterMessageManager *instance = nil;
+(FDSUserCenterMessageManager*)sharedManager
{
    if(nil == instance)
    {
        instance = [FDSUserCenterMessageManager alloc ];
        [instance initManager];
    }
    return instance;
}

- (void)initManager
{
    self.observerArray = [[NSMutableArray alloc]initWithCapacity:0];
    [self registerMessageManager:self :FDSUserCenterMessageClass];
    [[ZZSessionManager sharedSessionManager] registerObserver:self];
}

- (void)registerObserver:(id<FDSUserCenterMessageInterface>)observer
{
    if ([self.observerArray containsObject:observer] == NO)
    {
        [self.observerArray addObject:observer];
    }
}

- (void)unRegisterObserver:(id<FDSUserCenterMessageInterface>)observer
{
    if ([self.observerArray containsObject:observer])
    {
        [self.observerArray removeObject:observer];
    }
}

- (void)parseMessageData:(NSDictionary *)data
{
    NSString* messageType = [data objectForKey:@"messageType"];
    if ([messageType isEqualToString:@"userRegisterRequestReply"] == YES)
    {
        /* 注册获取验证码 */
        NSString *result = [data objectForKey:@"result"];
        NSString *authCode  = [data objectForKey:@"authCode"];//验证码,当验证码为000000的时候，则客户端无需要短信验证。
        NSString *timeout = [data objectForKey:@"timeout"];//单位为秒
        for(id<FDSUserCenterMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(userRegisterRequestCB:::)])
                [interface userRegisterRequestCB:result:authCode:timeout];
        }
    }
    else if ([messageType isEqualToString:@"userRegisterReply"] == YES)
    {
        /* 注册 */
        NSString *result = [data objectForKey:@"result"];
        for(id<FDSUserCenterMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(userRegisterCB:)])
                [interface userRegisterCB:result];
        }
    }
    else if([messageType isEqualToString:@"userLoginReply"] == YES)
    {
        /* 登录  */
        NSString *result = [data objectForKey:@"result"];
        NSString *reason  = [data objectForKey:@"reason"];//”accountError”,”passwordError”
        FDSUser *userInfo = [[FDSUser alloc] init];
        userInfo.m_name = [data objectForKey:@"userName"];
        userInfo.m_icon = [data objectForKey:@"userIcon"];
        userInfo.m_phone = [data objectForKey:@"phoneNumber"];
        userInfo.m_job = [data objectForKey:@"job"];
        userInfo.m_company = [data objectForKey:@"company"];
        userInfo.m_userID = [data objectForKey:@"userID"];
        userInfo.m_sex = [data objectForKey:@"sex"];
        userInfo.m_handicap = [data objectForKey:@"handicap"];
        userInfo.m_tel = [data objectForKey:@"tel"];
        userInfo.m_email = [data objectForKey:@"email"];
        userInfo.m_brief = [data objectForKey:@"brief"];
        userInfo.m_golfAge = [data objectForKey:@"golfAge"];
        if ([@"null" isEqualToString:userInfo.m_golfAge])
        {
            userInfo.m_golfAge = @"0.0";
        }
        
        for(id<FDSUserCenterMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(userLoginCB:::)])
                [interface userLoginCB:result:reason:userInfo];
        }
        [userInfo release];
    }
    else if([messageType isEqualToString:@"modifyUserCardReply"] == YES)
    {
        /* 修改个人名片  */
        NSString *result = [data objectForKey:@"result"];
        for(id<FDSUserCenterMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(modifyUserCardCB:)])
                [interface modifyUserCardCB:result];
        }
    }
    else if([messageType isEqualToString:@"userLogoutReply"] == YES)
    {
        /* 用户注销  */
        NSString *result = [data objectForKey:@"result"];
        for(id<FDSUserCenterMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(userLogoutCB:)])
                [interface userLogoutCB:result];
        }
    }
    else if([messageType isEqualToString:@"getUserFriendsReply"] == YES)
    {
        /* 个人的好友列表  */
        NSMutableArray *friendList = [[NSMutableArray alloc] init];
        NSArray *tmpArr = [data objectForKey:@"friends"];
        for (int i=0; i < tmpArr.count; i++)
        {
            NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
            FDSUser *userInfo = [[FDSUser alloc] init];
            userInfo.m_friendID = [tmpDic objectForKey:@"friendID"];
            userInfo.m_name = [tmpDic objectForKey:@"friendName"];
            userInfo.m_icon = [tmpDic objectForKey:@"friendIcon"];
            [friendList addObject:userInfo];
            [userInfo release];
        }
        for(id<FDSUserCenterMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(getUserFriendsCB:)])
                [interface getUserFriendsCB:friendList];
        }
        [friendList removeAllObjects];
        [friendList release];
    }
    else if([messageType isEqualToString:@"sendIMReply"] == YES)
    {
        /* 即时聊天 */
        NSString *result = [data objectForKey:@"result"];
        NSString *messageID = [data objectForKey:@"messageID"];
        for(id<FDSUserCenterMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(sendIMCB::)])
                [interface sendIMCB:result:messageID];
        }
    }
    else if([messageType isEqualToString:@"getIM"] == YES)
    {
        /* 聊天push消息 */
        FDSChatMessage *chatMessage = [[FDSChatMessage alloc] init];
        chatMessage.m_senderID = [data objectForKey:@"senderID"];
        chatMessage.m_senderName = [data objectForKey:@"senderName"];
        chatMessage.m_senderIcon = [data objectForKey:@"senderIcon"];
        chatMessage.m_recevierID = [[FDSUserManager sharedManager]getNowUser].m_userID;
        chatMessage.m_owner = NO; //收到的都是好友信息
        chatMessage.m_send_state = MSG_STATE_SEND_SUCCESS;
        chatMessage.m_state = FDS_MSG_STATE_UNREADED;//未读
        chatMessage.m_chatTime = [data objectForKey:@"sendTime"];
        
        NSString *chatRoomType = [data objectForKey:@"chatRoomType"];
        if ([chatRoomType isEqualToString:@"person"])
        {
            chatMessage.m_messageType = CHAT_MESSAGE_TYPE_CHAT_PERSON;
            chatMessage.m_groupID = @"";
            chatMessage.m_groupName = @"";
            chatMessage.m_groupIcon = @"";
            chatMessage.m_roleType = FDS_Role_Type_User;
        }
        else if ([chatRoomType isEqualToString:@"group"])
        {
            chatMessage.m_messageType = CHAT_MESSAGE_TYPE_CHAT_GROUP;
            chatMessage.m_groupID = [data objectForKey:@"groupID"];
            chatMessage.m_groupName = [data objectForKey:@"groupName"];
            chatMessage.m_groupIcon = [data objectForKey:@"groupIcon"];
            //现在只支持公司有群聊天室
            if ([[data objectForKey:@"groupType"]isEqualToString:@"company"])
            {
                chatMessage.m_roleType = FDS_Role_Type_Group_Company;
            }
            else if ([[data objectForKey:@"groupType"]isEqualToString:@"bar"])
            {
                chatMessage.m_roleType = FDS_Role_Type_Group_Bar; // 贴吧
            }
            else if ([[data objectForKey:@"groupType"]isEqualToString:@"team"])
            {
                chatMessage.m_roleType = FDS_Role_Type_Group_Team;// 球队
            }
        }

        chatMessage.m_imageURL = [data objectForKey:@"imageURL"];
        if (![chatMessage.m_imageURL isEqualToString:@"(null)"] && chatMessage.m_imageURL.length > 0)
        {
            chatMessage.m_content = @"[图片]";
        }
        else
        {
            chatMessage.m_content = [data objectForKey:@"content"];
        }
        chatMessage.m_chatContent = [[[NSMutableArray alloc] init] autorelease];
        [[FDSPublicManage sharePublicManager] getMessageRange:chatMessage.m_content :chatMessage.m_chatContent];
        
        FDSMessageCenter *messageCenter = [[FDSMessageCenter alloc] init];
        [messageCenter copyMessage:chatMessage];
        messageCenter.m_messageClass = FDSMessageCenterMessage_Class_USER; //个人信息

        for(id<FDSUserCenterMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(getIMCB::)])
                [interface getIMCB:chatMessage:messageCenter];
        }
        [chatMessage release];
        [messageCenter release];
    }
    else if([messageType isEqualToString:@"addFriendReply"] == YES)
    {
        /* push消息 发出添加好友请求后收到的回复 */
        NSString *result = [data objectForKey:@"result"];
        //            [data objectForKey:@"replywords"];
        //            [data objectForKey:@"friendType"];
        FDSUser *friendInfo = nil;
        FDSMessageCenter *messageCenter = nil;
        if ([result isEqualToString:@"OK"]) //成功  FAIL 拒绝不显示再页面
        {
            friendInfo = [[FDSUser alloc] init];
            friendInfo.m_friendID = [data objectForKey:@"friendID"];
            friendInfo.m_name = [data objectForKey:@"friendName"];
            friendInfo.m_icon = [data objectForKey:@"friendIcon"];
            
            messageCenter = [[FDSMessageCenter alloc] init];
            messageCenter.m_senderID = friendInfo.m_friendID; //需和该好友聊天信息共存在消息主列表
            messageCenter.m_state = FDS_MSG_STATE_UNREADED;
            messageCenter.m_senderName = friendInfo.m_name;
            messageCenter.m_icon = friendInfo.m_icon;
            messageCenter.m_sendTime = [data objectForKey:@"time"];
            
            messageCenter.m_messageClass = FDSMessageCenterMessage_Class_USER;
            messageCenter.m_messageType = FDSMessageCenterMessage_Type_ADD_FRIEND_SUC_RESULT;// 添加好友成功结果
            messageCenter.m_content = [NSString stringWithFormat:@"%@已添加你为好友",friendInfo.m_name];
            messageCenter.m_msgContent = [[[NSMutableArray alloc] init]autorelease];
            [[FDSPublicManage sharePublicManager] getMessageRange:messageCenter.m_content :messageCenter.m_msgContent];
        }
        for(id<FDSUserCenterMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(addFriendReplyCB::)])
                [interface addFriendReplyCB:friendInfo :messageCenter];  //需要nil判断
        }
        [friendInfo release];
        [messageCenter release];
    }
    else if([messageType isEqualToString:@"addFriendRequest"] == YES)
    {
        /* push消息 收到对方的添加好友请求 */
        //            [data objectForKey:@"friendType"];
        FDSUser *friendInfo = [[FDSUser alloc] init];
        friendInfo.m_friendID = [data objectForKey:@"friendID"];
        friendInfo.m_name = [data objectForKey:@"name"];
        friendInfo.m_icon = [data objectForKey:@"friendIcon"];
        
        FDSMessageCenter *messageCenter = [[FDSMessageCenter alloc] init];
        messageCenter.m_senderID = friendInfo.m_friendID; //需和该好友聊天信息共存在消息主列表
        messageCenter.m_state = FDS_MSG_STATE_UNREADED;
        messageCenter.m_senderName = friendInfo.m_name;
        messageCenter.m_icon = friendInfo.m_icon;
        messageCenter.m_sendTime = [data objectForKey:@"time"];

        messageCenter.m_messageClass = FDSMessageCenterMessage_Class_USER;
        messageCenter.m_messageType = FDSMessageCenterMessage_Type_ADD_FRIEND_REQUEST;//添加好友申请
        messageCenter.m_content = [NSString stringWithFormat:@"%@申请添加你为好友",friendInfo.m_name];
        messageCenter.m_msgContent = [[[NSMutableArray alloc] init] autorelease];
        messageCenter.m_param1 = [data objectForKey:@"accesswords"]; //储存别人添加你为好友的理由
        [[FDSPublicManage sharePublicManager] getMessageRange:messageCenter.m_content :messageCenter.m_msgContent];

        for(id<FDSUserCenterMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(addFriendRequestCB::)])
                [interface addFriendRequestCB:messageCenter :friendInfo];
        }
        [friendInfo release];
        [messageCenter release];
    }
    else if([messageType isEqualToString:@"searchFriendsReply"] == YES)
    {
        /* 查找好友 */
        NSMutableArray *friendList = [[NSMutableArray alloc] init];
        NSArray *tmpArr = [data objectForKey:@"friends"];
        for (int i=0; i < tmpArr.count; i++)
        {
            NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
            FDSUser *userInfo = [[FDSUser alloc] init];
            userInfo.m_friendID = [tmpDic objectForKey:@"userID"];
            userInfo.m_name = [tmpDic objectForKey:@"userName"];
            userInfo.m_icon = [tmpDic objectForKey:@"userIcon"];
            userInfo.m_company = [tmpDic objectForKey:@"company"];
            userInfo.m_job = [tmpDic objectForKey:@"job"];
            [friendList addObject:userInfo];
            [userInfo release];
        }
        for(id<FDSUserCenterMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(searchFriendsCB:)])
                [interface searchFriendsCB:friendList];
        }
        [friendList release];
    }
    else if([messageType isEqualToString:@"subFriendReply"] == YES)
    {
        /*  主动删除好友 */
        FDSUser *friendInfo = [[FDSUser alloc] init];
        friendInfo.m_friendID = [data objectForKey:@"friendID"];
        friendInfo.m_icon = [data objectForKey:@"friendIcon"];
        
        NSString *result = [data objectForKey:@"result"];//”OK”
        for(id<FDSUserCenterMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(subFriendCB::)])
                [interface subFriendCB:result :friendInfo];
        }
        [friendInfo release];
    }
    else if([messageType isEqualToString:@"subedFriend"] == YES)
    {
        /*  push消息  被好友对方删除  */
        FDSUser *friendInfo = [[FDSUser alloc] init];
        friendInfo.m_friendID = [data objectForKey:@"friendID"];
        friendInfo.m_icon = [data objectForKey:@"friendIcon"];
        
        for(id<FDSUserCenterMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(subedFriend:)])
                [interface subedFriend:friendInfo];
        }
        [friendInfo release];
    }
    else if([messageType isEqualToString:@"modifyFriendsRemarkNameReply"] == YES)
    {
        /*    修改好友备注名   */
        NSString *result = [data objectForKey:@"result"];//”OK”
        for(id<FDSUserCenterMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(modifyFriendsRemarkNameCB:)])
                [interface modifyFriendsRemarkNameCB:result];
        }
    }
    else if([messageType isEqualToString:@"getUserCardReply"] == YES)
    {
        /* 获取好友的个人名片 */
        NSString *result = [data objectForKey:@"result"];//”OK”
        FDSUser *friendInfo = [[FDSUser alloc] init];
        friendInfo.m_friendID = [data objectForKey:@"friendID"];
        friendInfo.m_name = [data objectForKey:@"name"];
        friendInfo.m_icon = [data objectForKey:@"icon"];
        friendInfo.m_sex = [data objectForKey:@"sex"];
        friendInfo.m_job = [data objectForKey:@"job"];
        
        
        friendInfo.m_company = [data objectForKey:@"company"];
        friendInfo.m_phone = [data objectForKey:@"phone"];
        friendInfo.m_tel = [data objectForKey:@"tel"];
        friendInfo.m_email = [data objectForKey:@"email"];
        friendInfo.m_golfAge = [data objectForKey:@"golfAge"];
        friendInfo.m_handicap = [data objectForKey:@"handicap"];
        friendInfo.m_brief = [data objectForKey:@"brief"];
        
        friendInfo.m_remarkName = [data objectForKey:@"remarkName"];
        friendInfo.m_joinedCompanyCount = [data objectForKey:@"joinedCompanyCount"];
        friendInfo.m_joinedBarCount = [data objectForKey:@"joinedBarCount"];
        friendInfo.m_friendType = [data objectForKey:@"friendtype"];//”no”,”friend”

        for(id<FDSUserCenterMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(getUserCardCB::)])
                [interface getUserCardCB:friendInfo :result];
        }
        [friendInfo release];
    }
    else if([messageType isEqualToString:@"getJoinedCompanyListReply"] == YES)
    {
        /*    获取加入企业列表       */
        NSMutableArray *companyList = [[NSMutableArray alloc] init];
        NSArray *tmpArr = [data objectForKey:@"companys"];
        for (int i=0; i < tmpArr.count; i++)
        {
            NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
            FDSCompany *companyInfo = [[FDSCompany alloc] init];
            companyInfo.m_companyNameZH = [tmpDic objectForKey:@"companyName"];
            companyInfo.m_companyIcon = [tmpDic objectForKey:@"companyIcon"];
            companyInfo.m_comId = [tmpDic objectForKey:@"companyID"];
            companyInfo.m_memberNumber = [tmpDic objectForKey:@"memberNumber"];
            companyInfo.m_relation = [tmpDic objectForKey:@"relation"];
            [companyList addObject:companyInfo];
            [companyInfo release];
        }
        for(id<FDSUserCenterMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(getJoinedCompanyListCB:)])
                [interface getJoinedCompanyListCB:companyList];
        }
        [companyList release];
    }
    else if([messageType isEqualToString:@"getUserRecordReply"] == YES)
    {
        /*    得到个人动态       */
        NSMutableArray *recordList = [[NSMutableArray alloc] init];
        NSArray *tmpArr = [data objectForKey:@"records"];
        FDSComment *commentInfo = nil;
        for (int i=0; i<tmpArr.count; i++)
        {
            commentInfo = [[FDSComment alloc] init];
            NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
            commentInfo.m_commentID = [tmpDic objectForKey:@"recordID"];
            
            commentInfo.m_content = [tmpDic objectForKey:@"content"];
            commentInfo.m_senderID = [tmpDic objectForKey:@"senderID"];
            commentInfo.m_senderIcon = [tmpDic objectForKey:@"senderIcon"];
            commentInfo.m_senderName = [tmpDic objectForKey:@"senderName"];
            commentInfo.m_sendTime = [tmpDic objectForKey:@"sendTime"];
            
            commentInfo.m_images = [[[NSMutableArray alloc] init]autorelease];
            NSArray *urlArr = [tmpDic objectForKey:@"images"];
            for (int j=0; j<urlArr.count; j++)
            {
                NSDictionary *urlDic = [urlArr objectAtIndex:j];
                [commentInfo.m_images addObject:[urlDic objectForKey:@"URL"]];
            }
            
            commentInfo.m_revertsList = [[[NSMutableArray alloc] init] autorelease];
            NSArray *revertsArr = [tmpDic objectForKey:@"comments"];
            FDSRevert *revert = nil;
            for (int ii=0; ii<revertsArr.count; ii++)
            {
                NSDictionary *revertDic = [revertsArr objectAtIndex:ii];
                revert = [[FDSRevert alloc] init];
                
                revert.m_revertID = [revertDic objectForKey:@"commentID"];
                revert.m_senderID = [revertDic objectForKey:@"senderID"];
                revert.m_senderName = [revertDic objectForKey:@"senderName"];
                revert.m_reveredName = [revertDic objectForKey:@"reveredName"]; //回复的人 不一定是发动态的人
                revert.m_sendTime = [revertDic objectForKey:@"sendTime"];
                revert.m_content = [revertDic objectForKey:@"content"];
                [commentInfo.m_revertsList addObject:revert];
                [revert release];
            }
            
            [recordList addObject:commentInfo];
            [commentInfo release];
        }
        for(id<FDSUserCenterMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(getUserRecordCB:)])
                [interface getUserRecordCB:recordList];
        }
        [recordList release];
    }
    else if([messageType isEqualToString:@"sendUserRecordReply"] == YES)
    {
        /*  发表个人动态   */
        NSString *result = [data objectForKey:@"result"];
        NSString *recordID = [data objectForKey:@"recordID"];
        for(id<FDSUserCenterMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(sendUserRecordCB::)])
                [interface sendUserRecordCB:result :recordID];
        }
    }
    else if([messageType isEqualToString:@"sendRecordCommentRevertReply"] == YES)
    {
        /*    发表评论，回复(都不支持图片)     */
        NSString *result = [data objectForKey:@"result"];
        NSString *commentID = [data objectForKey:@"commentID"];
        for(id<FDSUserCenterMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(sendRecordCommentRevertCB::)])
                [interface sendRecordCommentRevertCB:result :commentID];
        }
    }
    else if([messageType isEqualToString:@"deleteRecordCommentRevertReply"] == YES)
    {
        /*    删除动态，评论，回复     */
        NSString *result = [data objectForKey:@"result"];
        for(id<FDSUserCenterMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(deleteRecordCommentRevertCB:)])
                [interface deleteRecordCommentRevertCB:result];
        }
    }
    else if([messageType isEqualToString:@"feedbackReply"] == YES)
    {
        /*   意见反馈     */
        NSString *result = [data objectForKey:@"result"];
        for(id<FDSUserCenterMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(feedbackCB:)])
                [interface feedbackCB:result];
        }
    }
    else if([messageType isEqualToString:@"modifyPassword01Reply"] == YES)
    {
        /*    修改密码     */
        NSString *result = [data objectForKey:@"result"];
        NSString *authCode = [data objectForKey:@"authCode"];
        NSString *timeout = [data objectForKey:@"timeout"];
        NSString *sessionID = [data objectForKey:@"sessionID"];
        
        for(id<FDSUserCenterMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(modifyPasswordCB::::)])
                [interface modifyPasswordCB:result :authCode :timeout :sessionID];
        }
    }
    else if([messageType isEqualToString:@"modifyPassword02Reply"] == YES)
    {
        /*    修改密码     */
        NSString *result = [data objectForKey:@"result"];
        NSString *reason = [data objectForKey:@"reason"];
        
        for(id<FDSUserCenterMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(modifyNewPasswordCB::)])
                [interface modifyNewPasswordCB:result :reason];
        }
    }
    else if([messageType isEqualToString:@"getGroupMembersReply"] == YES)
    {
        /*  获取群成员   */
        NSString *groupName = [data objectForKey:@"groupName"];
        NSString *groupIcon = [data objectForKey:@"groupIcon"];
        NSString *relation = [data objectForKey:@"relation"];
        NSMutableArray *friendList = [NSMutableArray arrayWithCapacity:1];
        FDSUser *useInfo = nil;
        NSArray *tmpArr = [data objectForKey:@"users"];
        for (int i=0; i<tmpArr.count; i++)
        {
            NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
            useInfo = [[FDSUser alloc] init];
            useInfo.m_friendID = [tmpDic objectForKey:@"userID"];
            useInfo.m_icon = [tmpDic objectForKey:@"userIcon"];
            useInfo.m_name = [tmpDic objectForKey:@"userName"];
            [friendList addObject:useInfo];
            [useInfo release];
        }
        for(id<FDSUserCenterMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(getGroupMembersCB::::)])
                [interface getGroupMembersCB:groupName :groupIcon :relation :friendList];
        }
    }
    else if([messageType isEqualToString:@"deleteGroupMemberReply"] == YES)
    {
        /*   删除群成员   */
        NSString *result = [data objectForKey:@"result"];
        for(id<FDSUserCenterMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(deleteGroupMemberCB:)])
                [interface deleteGroupMemberCB:result];
        }
    }
    else if([messageType isEqualToString:@"checkUsersMembersByPhoneReply"] == YES)
    {
        /*    验证用户为平台用户     */
        NSMutableArray *resultList = [NSMutableArray arrayWithCapacity:1];
        NSArray *tmpArr = [data objectForKey:@"results"];
//        FDSUser *userInfo = nil;
        FDSComDesigner *desigener = nil;
        for (int i=0; i<tmpArr.count; i++)
        {
            NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
//            userInfo = [[FDSUser alloc] init];
//            userInfo.m_sectionNumber = [[tmpDic objectForKey:@"index"] integerValue];
//            userInfo.m_friendID = [tmpDic objectForKey:@"userID"];
//            userInfo.m_phone = [tmpDic objectForKey:@"phoneNumber"];
//            userInfo.m_friendType = [tmpDic objectForKey:@"relation"];//relation” = no //=friend
//            [resultList addObject:userInfo];
//            [userInfo release];
            desigener = [[FDSComDesigner alloc] init];
            desigener.m_index = [[tmpDic objectForKey:@"index"] integerValue];
            desigener.m_userID = [tmpDic objectForKey:@"userID"];
            desigener.m_phone = [tmpDic objectForKey:@"phoneNumber"];
            desigener.m_introduce = [tmpDic objectForKey:@"relation"];
            [resultList addObject:desigener];
            [desigener release];
        }
        
        for(id<FDSUserCenterMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(checkUsersMembersByPhoneCB:)])
                [interface checkUsersMembersByPhoneCB:resultList];
        }
    }
    else if([messageType isEqualToString:@"cardInfoModify"] == YES)
    {
        /*    好友修改名称 修改头像消息推送(name icon 两字段选一)     */
        NSString *cardType =  [data objectForKey:@"cardType"];
        NSString *name =  [data objectForKey:@"name"];
        NSString *icon =  [data objectForKey:@"icon"];
        NSString *userID =  [data objectForKey:@"userID"];
        
        for(id<FDSUserCenterMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(cardInfoModifyCB::::)])
                [interface cardInfoModifyCB:cardType :name :icon :userID];
        }
    }
    else if([messageType isEqualToString:@"getPushSettingReply"] == YES)
    {
        /*      获取推送设置       */
        NSString *result = [data objectForKey:@"result"];
        NSString *restMode = [data objectForKey:@"restMode"];
        NSString *systemPushMessage = [data objectForKey:@"systemPushMessage"];
        NSString *friendPushMessage = [data objectForKey:@"friendPushMessage"];

        for(id<FDSUserCenterMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(getPushSettingCB::::)])
                [interface getPushSettingCB:result :restMode :systemPushMessage :friendPushMessage];
        }
    }
    else if([messageType isEqualToString:@"setPushSettingReply"] == YES)
    {
        /*        修改推送设置        */
        NSString *result = [data objectForKey:@"result"];
        for(id<FDSUserCenterMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(setPushSettingCB:)])
                [interface setPushSettingCB:result];
        }
    }
    else if([messageType isEqualToString:@"checkVersionReply"] == YES)
    {
        NSString *version = [data objectForKey:@"version"];
        NSString *downloadURL = [data objectForKey:@"downloadURL"];
        for(id<FDSUserCenterMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(checkVersionCB::)])
                [interface checkVersionCB:version :downloadURL];
        }
    }
}

- (void)sendMessage:(NSMutableDictionary *)message
{
    [message setObject:FDSUserCenterMessageClass forKey:@"messageClass"];
    [super sendMessage:message];
}

//********用户注册***********
- (void)userRegisterRequest:(NSString*)phoneNumber :(NSString*)sessionID
{
    /* 注册获取验证码 */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"userRegisterRequest" forKey:@"messageType"];
    [dic setObject:phoneNumber forKey:@"phoneNumber"];
    [dic setObject:sessionID forKey:@"sessionID"];  //sessionID待定
    [self sendMessage:dic];
}

- (void)userRegister:(NSString*)phoneNumber :(NSString*)password :(NSString*)authCode :(NSString*)sessionID
{
    /* 注册 */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"userRegister" forKey:@"messageType"];
    [dic setObject:sessionID forKey:@"sessionID"];  //sessionID待定
    [dic setObject:phoneNumber forKey:@"phoneNumber"];
    [dic setObject:authCode forKey:@"authCode"];
    [dic setObject:password forKey:@"password"];
    [self sendMessage:dic];
}

- (void)userLogin:(NSString*)userAccount :(NSString*)passsword
{
    /* 登录  */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"userLogin" forKey:@"messageType"];
    [dic setObject:userAccount forKey:@"userID"];
    [dic setObject:@"ios" forKey:@"phoneType"];
    NSString *device = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    if (device && device.length >0)
    {
        [dic setObject:device forKey:@"deviceTokenID"];  //获取设备tokenID
    }
    else
    {
        [dic setObject:@"" forKey:@"deviceTokenID"];
    }
    [dic setObject:passsword forKey:@"password"];
    [self sendMessage:dic];
}

- (void)userLogout:(NSString*)userID
{
    /* 用户注销  */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"userLogout" forKey:@"messageType"];
    [dic setObject:userID forKey:@"userID"];
    [self sendMessage:dic];
}

- (void)modifyUserCard:(NSString*)userID :(NSString*)modifyText :(enum MODIFY_PROFILE)modifyStyle
{
    /* 修改个人名片  */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"modifyUserCard" forKey:@"messageType"];
    [dic setObject:userID forKey:@"userID"];
    switch (modifyStyle) {
        case MODIFY_PROFILE_NAME:
        {
            [dic setObject:modifyText forKey:@"name"];
        }
            break;
        case MODIFY_PROFILE_ICON:
        {
            [dic setObject:modifyText forKey:@"icon"];
        }
            break;
        case MODIFY_PROFILE_SEX:
        {
            [dic setObject:modifyText forKey:@"sex"];
        }
            break;
        case MODIFY_PROFILE_COMPANY:
        {
            [dic setObject:modifyText forKey:@"company"];
        }
            break;
        case MODIFY_PROFILE_JOB:
        {
            [dic setObject:modifyText forKey:@"job"];
        }
            break;
        case MODIFY_PROFILE_PHONE:
        {
            [dic setObject:modifyText forKey:@"phone"];
        }
            break;
        case MODIFY_PROFILE_TEL:
        {
            [dic setObject:modifyText forKey:@"tel"];
        }
            break;
        case MODIFY_PROFILE_GOLFAGE:
        {
            [dic setObject:modifyText forKey:@"golfAge"];
        }
            break;
        case MODIFY_PROFILE_BRIEF:
        {
            [dic setObject:modifyText forKey:@"brief"];
        }
            break;
        case MODIFY_PROFILE_HANDICAP:
        {
            [dic setObject:modifyText forKey:@"handicap"];
        }
            break;
        case MODIFY_PROFILE_EMAIL:
        {
            [dic setObject:modifyText forKey:@"email"];
        }
            break;

        default:
            break;
    }
    [self sendMessage:dic];
}


- (void)getUserFriends:(NSString*)userID
{
    /* 得到个人的好友列表 */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getUserFriends" forKey:@"messageType"];
    [dic setObject:userID forKey:@"userID"];
    [self sendMessage:dic];
}

- (void)sendIM:(FDSChatMessage*)chatMessage
{
    /*  发送即时聊天  */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"sendIM" forKey:@"messageType"];
    [dic setObject:chatMessage.m_senderID forKey:@"userID"]; // 发送者而言sendID即是UserID
    [dic setObject:[NSString stringWithFormat:@"%d",chatMessage.m_messageID] forKey:@"messageID"];
    
    if(chatMessage.m_content && chatMessage.m_content.length > 0)
    {
        [dic setObject:chatMessage.m_content forKey:@"content"];
    }
    else if(chatMessage.m_imageURL && chatMessage.m_imageURL.length > 0)
    {
        [dic setObject:chatMessage.m_imageURL forKey:@"imageURL"];
    }
    else
    {
        [dic setObject:@"" forKey:@"content"];
    }
    
    if(CHAT_MESSAGE_TYPE_CHAT_GROUP == chatMessage.m_messageType)//群聊
    {
        [dic setObject:@"group" forKey:@"chatRoomType"];
        [dic setObject:@"company" forKey:@"groupType"];//现在只支持公司有群聊天室
        [dic setObject:chatMessage.m_groupID forKey:@"groupID"];
    }
    else //default 个人点对点聊天 CHAT_MESSAGE_TYPE_CHAT_PERSON
    {
        [dic setObject:@"person" forKey:@"chatRoomType"];
        [dic setObject:chatMessage.m_recevierID forKey:@"friendID"];
    }
    
    [self sendMessage:dic];
}


- (void)addFriend:(NSString*)friendID :(NSString*)queryInfo
{
    /* 发送添加好友请求 */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"addFriend" forKey:@"messageType"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    [dic setObject:friendID forKey:@"friendID"];
    [dic setObject:@"friend" forKey:@"friendType"];
    [dic setObject:queryInfo forKey:@"accesswords"];
    [self sendMessage:dic];
}

- (void)addFriendRequestReply:(NSString*)friendID :(NSString*)result
{
    /* 回复加好友请求 */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"addFriendRequestReply" forKey:@"messageType"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    [dic setObject:friendID forKey:@"friendID"];
    [dic setObject:result forKey:@"result"]; //ok or reject
    [dic setObject:@"friend" forKey:@"friendType"];  //?
    [dic setObject:@"" forKey:@"replywords"];
    [self sendMessage:dic];
}

- (void)searchFriends:(NSString*)KeyWord
{
    /*    查找好友请求  */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"searchFriends" forKey:@"messageType"];
    [dic setObject:@"phoneNumber" forKey:@"searchWay"];// “userID”,”name”,”email”
    [dic setObject:KeyWord forKey:@"keyword"];
    [self sendMessage:dic];
}

- (void)getUserCard:(NSString*)friendID
{
    /*    获取好友的个人名片  */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getUserCard" forKey:@"messageType"];
    NSString *userID = [[FDSUserManager sharedManager] getNowUser].m_userID;
    if (userID && userID.length>0)
    {
        [dic setObject:userID forKey:@"userID"];
    }
    else
    {
        [dic setObject:@"" forKey:@"userID"];
    }
    [dic setObject:friendID forKey:@"friendID"];
    [self sendMessage:dic];
}


- (void)subFriend:(NSString*)friendID
{
    /*    删除好友  */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"subFriend" forKey:@"messageType"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    [dic setObject:friendID forKey:@"friendID"];
    [self sendMessage:dic];
}


- (void)modifyFriendsRemarkName:(NSString*)friendID :(NSString*)remarkName
{
    /*    修改好友备注名   */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"modifyFriendsRemarkName" forKey:@"messageType"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    [dic setObject:friendID forKey:@"friendID"];
    [dic setObject:remarkName forKey:@"remarkName"];
    [self sendMessage:dic];
}


- (void)getJoinedCompanyList
{
    /*    得到用户企业列表   */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getJoinedCompanyList" forKey:@"messageType"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    [self sendMessage:dic];
}

- (void)getUserRecord:(NSString*)friendID :(NSString*)recordID :(NSString*)getWay :(NSInteger)count
{
    /*    得到个人动态    */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getUserRecord" forKey:@"messageType"];
    NSString *userID = [[FDSUserManager sharedManager] getNowUser].m_userID;
    if (userID && userID.length>0)
    {
        [dic setObject:userID forKey:@"userID"];
    }
    else
    {
        [dic setObject:@"" forKey:@"userID"];
    }
    [dic setObject:friendID forKey:@"friendID"];
    [dic setObject:recordID forKey:@"recordID"];
    [dic setObject:getWay forKey:@"getWay"];
    [dic setObject:[NSString stringWithFormat:@"%d",count] forKey:@"count"];

    [self sendMessage:dic];
}


- (void)sendUserRecord:(NSString*)content :(NSMutableArray*)images
{
    /*    发表个人动态     */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"sendUserRecord" forKey:@"messageType"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    [dic setObject:content forKey:@"content"];
    if (images && images.count > 0)
    {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:5];
        for (int i=0; i<images.count; i++)
        {
            NSDictionary *dic = [NSDictionary dictionaryWithObject:[images objectAtIndex:i] forKey:@"URL"];
            [arr addObject:dic];
        }
        [dic setObject:arr forKey:@"images"];
    }
    [self sendMessage:dic];
}


- (void)sendRecordCommentRevert:(NSString*)recordID :(NSString*)content :(NSString*)type :(NSString*)revertedID
{
    /*    发表评论，回复(都不支持图片)     */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"sendRecordCommentRevert" forKey:@"messageType"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    [dic setObject:recordID forKey:@"recordID"];
    [dic setObject:content forKey:@"content"];
    [dic setObject:type forKey:@"type"];
    [dic setObject:revertedID forKey:@"revertedID"];

    [self sendMessage:dic];
}


- (void)deleteRecordCommentRevert:(NSString*)commentObjectID :(NSString*)type :(NSString*)objectID
{
    /*    删除动态，评论，回复     */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"deleteRecordCommentRevert" forKey:@"messageType"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    [dic setObject:commentObjectID forKey:@"commentObjectID"];
    [dic setObject:type forKey:@"type"];
    [dic setObject:objectID forKey:@"id"];
    
    [self sendMessage:dic];
}

- (void)feedback:(NSString*)content :(NSString*)contactWay
{
    /*    意见反馈     */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"feedback" forKey:@"messageType"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    [dic setObject:content forKey:@"content"];
    [dic setObject:contactWay forKey:@"contactWay"];
    
    [self sendMessage:dic];
}

- (void)modifyPassword:(NSString*)sessionID
{
    /*     修改密码    */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"modifyPassword01" forKey:@"messageType"];
    [dic setObject:sessionID forKey:@"sessionID"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    
    [self sendMessage:dic];
}

- (void)modifyPassword:(NSString*)sessionID :(NSString*)phoneNum
{
    /*     修改密码    */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"modifyPassword01" forKey:@"messageType"];
    [dic setObject:sessionID forKey:@"sessionID"];
    [dic setObject:phoneNum forKey:@"userID"];
    
    [self sendMessage:dic];
}

- (void)modifyNewPassword:(NSString*)sessionID :(NSString*)authCode :(NSString*)newPassword
{
    /*     修改密码    */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"modifyPassword02" forKey:@"messageType"];
    [dic setObject:sessionID forKey:@"sessionID"];
    [dic setObject:authCode forKey:@"authCode"];
    [dic setObject:newPassword forKey:@"newPassword"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];

    [self sendMessage:dic];
}

- (void)modifyNewPassword:(NSString*)sessionID :(NSString*)authCode :(NSString*)newPassword :(NSString*)phoneNum
{
    /*     修改密码    */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"modifyPassword02" forKey:@"messageType"];
    [dic setObject:sessionID forKey:@"sessionID"];
    [dic setObject:authCode forKey:@"authCode"];
    [dic setObject:newPassword forKey:@"newPassword"];
    [dic setObject:phoneNum forKey:@"userID"];
    
    [self sendMessage:dic];
}

- (void)getGroupMembers:(NSString*)groupID :(NSString*)groupType
{
    /*      得到群成员    */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getGroupMembers" forKey:@"messageType"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    [dic setObject:groupID forKey:@"groupID"];
    [dic setObject:groupType forKey:@"groupType"];

    [self sendMessage:dic];
}

- (void)deleteGroupMember:(NSString*)deletedorID :(NSString*)groupID :(NSString*)groupType
{
    /*   删除群成员   */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"deleteGroupMember" forKey:@"messageType"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    [dic setObject:deletedorID forKey:@"deletedorID"];
    [dic setObject:groupType forKey:@"groupType"];
    [dic setObject:groupID forKey:@"groupID"];
    
    [self sendMessage:dic];
}

- (void)checkUsersMembersByPhone:(NSMutableArray*)userList
{
    /*    验证用户为平台用户     */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"checkUsersMembersByPhone" forKey:@"messageType"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    if (userList && userList.count > 0)
    {
        [dic setObject:userList forKey:@"users"];
    }
    
    [self sendMessage:dic];
}


- (void)getPushSetting
{
    /*    获取推送设置     */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getPushSetting" forKey:@"messageType"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    
    [self sendMessage:dic];
}

- (void)setPushSetting:(NSString*)ONOFF :(NSInteger)setType
{
    /*    修改推送设置     */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"setPushSetting" forKey:@"messageType"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    if (0 == setType)//免打扰
    {
        [dic setObject:ONOFF forKey:@"restMode"];
    }
    else if(1 == setType)//系统通知
    {
        [dic setObject:ONOFF forKey:@"systemPushMessage"];
    }
    else //2 好友通知
    {
        [dic setObject:ONOFF forKey:@"friendPushMessage"];
    }
    
    [self sendMessage:dic];
}

- (void)checkVersion
{
    /*  检查版本更新  */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"checkVersion" forKey:@"messageType"];
    [dic setObject:@"ios" forKey:@"platform"];
    
    [self sendMessage:dic];
}

@end

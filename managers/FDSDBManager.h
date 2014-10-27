//
//  DBManager.h
//  FDS
//
//  Created by zhuozhong on 14-1-22.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "FDSUserCenterMessageManager.h"
#import "FDSChatMessage.h"
#import "FDSCollectedInfo.h"

@class FDSMessageCenter;
@interface FDSDBManager : NSObject
{
    sqlite3  *fdsInfoDB;
}

@property(nonatomic,retain)NSMutableArray  *contactList;

+(FDSDBManager*)sharedManager;

/*  创建或打开用户数据库  */
- (BOOL)createOrOpenUserDB;


#pragma UserFriend 表操作
/*  查询对应用户好友列表  */
- (NSMutableArray*)getUserFriendsWithUserID;

/*  添加单个好友到本地  */
- (void)AddFriendToDB:(FDSUser*)friendInfo;

/*  添加好友到本地  */
- (void)AddFriendListToLocal:(NSMutableArray*)contactArr;

/*  刷新好友列表信息  */
-(void)refreshAllFriends:(NSMutableArray*)contactArr;

/*  是否存在当前ID的好友  */
- (BOOL)existFriend:(NSString*)frinedID;

/*  删除某个好友  */
- (void)deleteUserFriend:(FDSUser*)friendInfo;

/*  删除某个好友  通过ID*/
- (void)deleteFriend:(int)friendID;

/* 更新某个好友信息到本地 */
- (void)updateUserFriend:(FDSUser*)friendInfo;

/* 更新某个好友备注名到本地 */
- (void)updateRemarkName:(FDSUser*)friendInfo;

/* 更新某个好友昵称到本地 */
- (void)updateNickName:(NSString*)friendID :(NSString*)nickeName;

/* 更新某个好友头像到本地 */
- (void)updateIconPath:(NSString*)friendID :(NSString*)iconPath;









#pragma ChatMessage 表操作
/*  添加一条聊天消息到DB  */
- (void)AddChatMessageToDB:(FDSChatMessage*)chatMessage;

/*  查询对应好友的聊天信息 群聊 */
- (NSMutableArray*)getChatMessageWithID:(FDSMessageCenter*)centerMessage :(NSInteger)count;

/* 查询chatMessage表中未读消息数目 */
- (NSInteger)getChatMessageUnread:(FDSMessageCenter*)messageCenter;//好友发送的消息才有可能是未读

/* 更新某一条聊天信息为已读 */
- (void)updateChatMessageDoRead:(NSInteger)chatMessageID;

/* 更新与某一 好友/某群 的所有聊天信息为已读 */
- (void)updateChatRecordDoRead:(FDSMessageCenter*)messageCenter;

/*  删除chatMessages表中对应messageID的消息 */
- (void)deleteChatMessageFromDB:(NSInteger)chatMessageID;






#pragma MessageCenter 表操作
/* 更新一条消息到MessageCenter */
- (void)updateMessageCenterToDB:(FDSMessageCenter*)messageCenter;

/*  更新备注名到消息中心表的发送名字段  */
- (void)updateSenderName:(FDSUser*)friendInfo;

/* 更新当前用户所有未读的系统消息为已读到MessageCenter  针对当前用户*/
- (void)updateAllSystemMessageCenterDoRead;

/* 更新当前用户某条系统消息为已读到MessageCenter */
- (void)updateSystemMessageCenterDoRead:(FDSMessageCenter*)messageCenter;

/* 更新当前用户某条系统消息的操作状态到MessageCenter */
- (void)updateSystemMessageCenter:(FDSMessageCenter*)messageCenter;

/* 获取当前用户MessageCenter表中的消息列表 按时间降序排列 */
- (NSMutableArray*)getMessageCenterNowUserFromDB;

/* 查询当前用户MessageCenter 表中系统消息数据 */
- (NSMutableArray*)getSystemInfoNowUserFromDB;

/*  删除messageCenter表中对应messageID的消息 */
- (void)deleteMessageCenterFromDB:(NSInteger)centerMessageID;

/*  删除messageCenter表中对应的消息 */
- (void)deleteMessageCenter:(FDSMessageCenter*)messageCenter;

/*  删除当前用户messageCenter表中全部系统的消息 */
- (void)deleteAllSystemMessageFromDB;

/*  更新发送消息者昵称字段到MessageCenter  针对当前用户*/
- (void)updateMessageCenterSendName:(NSString*)sendID :(NSString*)sendName;




#pragma collectMsgInfo 表操作
/*  获取当前用户的收藏数据  */
- (NSMutableArray*)getNowUserFromCollectedDB;

/*  增加一条收藏数据  */
- (void)addCollectedInfoToDB:(FDSCollectedInfo*)collectedInfo;

/*  删除一条收藏数据  */
- (void)deleteCollectedInfoFromDB:(NSInteger)messageID;

@end

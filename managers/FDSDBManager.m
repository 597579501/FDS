//
//  DBManager.m
//  FDS
//
//  Created by zhuozhong on 14-1-22.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSDBManager.h"
#import "FDSPathManager.h"
#import "FDSFileManage.h"
#import "FDSUserManager.h"
#import "FDSMessageCenter.h"
#import "FDSPublicManage.h"

@implementation FDSDBManager

static FDSDBManager* manager = nil;

+ (FDSDBManager*)sharedManager
{
    if(nil == manager)
    {
        manager = [[FDSDBManager alloc]init];
        [manager managerInit];
    }
    return manager;
}

- (void)dealloc
{
    [self.contactList removeAllObjects];
    self.contactList = nil;
    
    [super dealloc];
}

- (void)managerInit
{
    self.contactList = nil;
    [[FDSFileManage shareFileManager]creatUserInfoDataBase];
}

/*  创建或打开用户数据库  */
- (BOOL)createOrOpenUserDB
{
    NSString *path = [[FDSPathManager sharePathManager] getUserDatabasePath];
    int result = sqlite3_open([path UTF8String], &fdsInfoDB);
    if (result == SQLITE_OK)
    {
//        NSLog(@"open User Database OK...");
        return YES;
    }
    else
    {
//        NSLog(@"open User Database Fail...");
        sqlite3_close(fdsInfoDB);
        return NO;
    }
}

-(void)closeDatabase
{
    sqlite3_close(fdsInfoDB);
}

/*  执行数据库  */
-(void)execSql:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(fdsInfoDB, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK)
    {
//        NSLog(@"数据库操作数据失败!");
    }
    else
    {
//        NSLog(@"数据库操作数据成功!");
    }
}

/*  查询对应用户好友列表  */
- (NSMutableArray*)getUserFriendsWithUserID
{
    if ([self createOrOpenUserDB])
    {
        NSString *nowUserID = [[FDSUserManager sharedManager]getNowUser].m_userID;
        NSString *selectSQL = [NSString stringWithFormat:@"select * from userFriends where userID = '%@'",nowUserID];
        sqlite3_stmt *stmt;
        FDSUser * friend = nil;
        NSMutableArray *friendList = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        if(sqlite3_prepare_v2(fdsInfoDB, [selectSQL UTF8String], -1, &stmt, nil) == SQLITE_OK)
        {
            while(sqlite3_step(stmt) == SQLITE_ROW)
            {
                friend = [[FDSUser alloc]init];
                friend.m_messageID = sqlite3_column_int(stmt,0);
                friend.m_userID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
                friend.m_friendID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
                friend.m_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)];
                friend.m_icon = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 4)];
                friend.m_remarkName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 5)];
                friend.m_company = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 6)];
                friend.m_job = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 7)];
                friend.m_golfAge = [NSString stringWithFormat:@"%d",sqlite3_column_int(stmt,8)];
                friend.m_phone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 9)];
                
                [friendList addObject:friend];
                [friend release];
            }
            sqlite3_finalize(stmt);
        }
        [self closeDatabase];
        return friendList;
    }
    return nil;
}

/*  添加单个好友到本地  */
- (void)AddFriendToDB:(FDSUser*)friendInfo
{
    if ([self createOrOpenUserDB])
    {
        NSString *nowUserID = [[FDSUserManager sharedManager]getNowUser].m_userID;
        NSString *selectSQL = [NSString stringWithFormat:@"select * from userFriends where userID = '%@' and friendID = '%@'",nowUserID,friendInfo.m_friendID];
        sqlite3_stmt *stmt;
        if(sqlite3_prepare_v2(fdsInfoDB, [selectSQL UTF8String], -1, &stmt, nil) == SQLITE_OK)
        {
            if (sqlite3_step(stmt) != SQLITE_ROW)
            {
                NSLog(@"AddFriendToDB插入一条好友数据...");//插入之前查询有没有此条数据
                NSString *insertSQL = [NSString stringWithFormat:@"insert into userFriends (userID,friendID,name,icon,remarkName,company,job,golfage,phoneNumber) values ('%@','%@','%@','%@','%@','%@','%@','%d','%@')",nowUserID,friendInfo.m_friendID,friendInfo.m_name,friendInfo.m_icon,friendInfo.m_remarkName,friendInfo.m_company,friendInfo.m_job,[friendInfo.m_golfAge integerValue],friendInfo.m_phone];
                [self execSql:insertSQL];
                friendInfo.m_messageID = (int)sqlite3_last_insert_rowid(fdsInfoDB);
            }
            sqlite3_finalize(stmt);  //查询之后不能忘记调用  否则将会导致之后的数据库表操作都失败
        }
        [self closeDatabase];
    }
}


/*  添加好友到本地  */
- (void)AddFriendListToLocal:(NSMutableArray*)contactArr
{
    if ([self createOrOpenUserDB])
    {
        /* 逐条添加最新好友列表 */
        NSString *nowUserID = [[FDSUserManager sharedManager]getNowUser].m_userID;
        for(FDSUser *user in contactArr)
        {
            NSString *selectSQL = [NSString stringWithFormat:@"select * from userFriends where userID = '%@' and friendID = '%@'",nowUserID,user.m_friendID];
            sqlite3_stmt *stmt;
            if(sqlite3_prepare_v2(fdsInfoDB, [selectSQL UTF8String], -1, &stmt, nil) == SQLITE_OK)
            {
                if (sqlite3_step(stmt) != SQLITE_ROW)
                {
                    NSLog(@"AddFriendListToLocal插入一条好友数据...");//插入之前查询有没有此条数据
                    NSString *insertSQL = [NSString stringWithFormat:@"insert into userFriends (userID,friendID,name,icon,remarkName,company,job,golfage,phoneNumber) values ('%@','%@','%@','%@','%@','%@','%@','%d','%@')",nowUserID,user.m_friendID,user.m_name,user.m_icon,user.m_remarkName,user.m_company,user.m_job,[user.m_golfAge integerValue],user.m_phone];
                    [self execSql:insertSQL];
                    user.m_messageID = (int)sqlite3_last_insert_rowid(fdsInfoDB);
                }
                sqlite3_finalize(stmt);  //查询之后不能忘记调用  否则将会导致之后的数据库表操作都失败
            }
        }
        [self closeDatabase];
    }
}

/*  刷新好友列表信息  */
-(void)refreshAllFriends:(NSMutableArray*)contactArr
{
    self.contactList = contactArr;
    if ([self createOrOpenUserDB])
    {
        /* 首先全部删除该用户的所有好友 */
        NSString *nowUserID = [[FDSUserManager sharedManager]getNowUser].m_userID;
        NSString *sql = [NSString stringWithFormat:@"DELETE  FROM  userFriends where userID = '%@' ",nowUserID];
        [self execSql:sql];
        
        /* 逐条添加最新好友列表 */
        for(FDSUser *user in self.contactList)
        {
            NSString *insertSQL = [NSString stringWithFormat:@"insert into userFriends (userID,friendID,name,icon,remarkName,company,job,golfage,phoneNumber) values ('%@','%@','%@','%@','%@','%@','%@','%d','%@')",nowUserID,user.m_friendID,user.m_name,user.m_icon,user.m_remarkName,user.m_company,user.m_job,[user.m_golfAge integerValue],user.m_phone];
            [self execSql:insertSQL];
            user.m_messageID = (int)sqlite3_last_insert_rowid(fdsInfoDB);
        }
        [self closeDatabase];
    }
}

/*  是否存在当前ID的好友  */
- (BOOL)existFriend:(NSString*)frinedID
{
    if ([self createOrOpenUserDB])
    {
        NSString *nowUserID = [[FDSUserManager sharedManager]getNowUser].m_userID;
        NSString *selectSQL = [NSString stringWithFormat:@"select * from userFriends where userID = '%@' and friendID = '%@'",nowUserID,frinedID];
        sqlite3_stmt *stmt;
        if(sqlite3_prepare_v2(fdsInfoDB, [selectSQL UTF8String], -1, &stmt, nil) == SQLITE_OK)
        {
            while(sqlite3_step(stmt) == SQLITE_ROW)
            {
                sqlite3_finalize(stmt);
                [self closeDatabase];
                return YES;
            }
            sqlite3_finalize(stmt);
        }
        [self closeDatabase];
    }
    return NO;
}

/*  删除某个好友  */
- (void)deleteUserFriend:(FDSUser*)friendInfo
{
    if ([self createOrOpenUserDB])
    {
        NSString *nowUserID = [[FDSUserManager sharedManager]getNowUser].m_userID;
        NSString *sql = [NSString stringWithFormat:@"DELETE  FROM  userFriends where userID = '%@' and friendID = '%@'",nowUserID,friendInfo.m_friendID];
        [self execSql:sql];
        [self closeDatabase];
    }
}

/*  删除某个好友  通过ID*/
- (void)deleteFriend:(int)friendID
{
    if ([self createOrOpenUserDB])
    {
        NSString *sql = [NSString stringWithFormat:@"DELETE  FROM  userFriends where id = '%d'",friendID];
        [self execSql:sql];
        [self closeDatabase];
    }
}

/* 更新某个好友信息到本地 */
- (void)updateUserFriend:(FDSUser*)friendInfo
{
    if ([self createOrOpenUserDB])
    {
        NSString *nowUserID = [[FDSUserManager sharedManager]getNowUser].m_userID;//,,,,,
        NSString *updateSQL = [NSString stringWithFormat:@"update userFriends set name = '%@',icon = '%@',remarkName = '%@',company = '%@',job = '%@',golfage = '%d',phoneNumber = '%@' where userID = '%@' and friendID = '%@'", friendInfo.m_name,friendInfo.m_icon,friendInfo.m_remarkName,friendInfo.m_company,friendInfo.m_job,[friendInfo.m_golfAge integerValue],friendInfo.m_phone,nowUserID,friendInfo.m_friendID];
        [self execSql:updateSQL];
        [self closeDatabase];
    }
}

/* 更新某个好友备注名到本地 */
- (void)updateRemarkName:(FDSUser*)friendInfo
{
    if ([self createOrOpenUserDB])
    {
        NSString *nowUserID = [[FDSUserManager sharedManager]getNowUser].m_userID;//,,,,,
        NSString *updateSQL = [NSString stringWithFormat:@"update userFriends set remarkName = '%@' where userID = '%@' and friendID = '%@'", friendInfo.m_remarkName,nowUserID,friendInfo.m_friendID];
        [self execSql:updateSQL];
        [self closeDatabase];
    }
}

/* 更新某个好友昵称到本地 */
- (void)updateNickName:(NSString*)friendID :(NSString*)nickeName
{
    if ([self createOrOpenUserDB])
    {
        NSString *nowUserID = [[FDSUserManager sharedManager]getNowUser].m_userID;//,,,,,
        NSString *updateSQL = [NSString stringWithFormat:@"update userFriends set name = '%@' where userID = '%@' and friendID = '%@'", nickeName,nowUserID,friendID];
        [self execSql:updateSQL];
        [self closeDatabase];
    }
}

/* 更新某个好友头像到本地 */
- (void)updateIconPath:(NSString*)friendID :(NSString*)iconPath
{
    if ([self createOrOpenUserDB])
    {
        NSString *nowUserID = [[FDSUserManager sharedManager]getNowUser].m_userID;//,,,,,
        NSString *updateSQL = [NSString stringWithFormat:@"update userFriends set icon = '%@' where userID = '%@' and friendID = '%@'", iconPath,nowUserID,friendID];
        [self execSql:updateSQL];
        [self closeDatabase];
    }
}











/*  添加一条聊天消息到DB  */
- (void)AddChatMessageToDB:(FDSChatMessage*)chatMessage
{
    if ([self createOrOpenUserDB])
    {
//        NSLog(@"插入一条聊天消息数据...");
        NSString *nowUserID = [[FDSUserManager sharedManager]getNowUser].m_userID;
        NSString *insertSQL = [NSString stringWithFormat:@"insert into chatMessages (userID,chatMessageType,roleType,groupID,senderID,receiverID,content,sendTime,imageURL,state,senderIcon) values ('%@','%d','%d','%@','%@','%@','%@','%@','%@','%d','%@')",nowUserID,chatMessage.m_messageType,chatMessage.m_roleType,chatMessage.m_groupID,chatMessage.m_senderID,chatMessage.m_recevierID,chatMessage.m_content,chatMessage.m_chatTime,chatMessage.m_imageURL,chatMessage.m_state,chatMessage.m_senderIcon];
        [self execSql:insertSQL];
        chatMessage.m_messageID = (int)sqlite3_last_insert_rowid(fdsInfoDB);
        
//        NSLog(@"FDSDBManager中消息messageID = %d",chatMessage.m_messageID);
        [self closeDatabase];
    }
}

/*  查询对应好友的聊天信息 群聊 */
- (NSMutableArray*)getChatMessageWithID:(FDSMessageCenter*)centerMessage :(NSInteger)count
{
    int index = 0;
    if ([self createOrOpenUserDB])
    {
        NSString *nowUserID = [[FDSUserManager sharedManager]getNowUser].m_userID;
        NSString *selectSQL = nil;
        if (FDSMessageCenterMessage_Type_CHAT_GROUP == centerMessage.m_messageType)
        {
            selectSQL = [NSString stringWithFormat:@"select * from chatMessages where userID = '%@' and groupID = '%@' and chatMessageType = '%d' ORDER BY sendTime desc",nowUserID,centerMessage.m_param1,CHAT_MESSAGE_TYPE_CHAT_GROUP];
        }
        else if(FDSMessageCenterMessage_Type_CHAT_PERSON == centerMessage.m_messageType)
        {
            selectSQL = [NSString stringWithFormat:@"select * from chatMessages where userID = '%@' and (senderID = '%@' or receiverID = '%@') and chatMessageType = '%d'    ORDER BY sendTime desc",nowUserID,centerMessage.m_senderID,centerMessage.m_senderID,CHAT_MESSAGE_TYPE_CHAT_PERSON];
        }
        else
        {
            [self closeDatabase];
            return nil;
        }

        sqlite3_stmt *stmt;
        FDSChatMessage * chatMessage = nil;
        NSMutableArray *chatMessageList = [[NSMutableArray alloc] initWithCapacity:0];
        if(sqlite3_prepare_v2(fdsInfoDB, [selectSQL UTF8String], -1, &stmt, nil) == SQLITE_OK)
        {
            while(sqlite3_step(stmt) == SQLITE_ROW)
            {
                chatMessage = [[FDSChatMessage alloc]init];
                chatMessage.m_messageID = sqlite3_column_int(stmt,0);
//                chatMessage.m_userID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
                chatMessage.m_messageType = sqlite3_column_int(stmt,2);
                chatMessage.m_roleType = sqlite3_column_int(stmt, 3);
                chatMessage.m_groupID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 4)];
                chatMessage.m_senderID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 5)];
                if ([chatMessage.m_senderID isEqualToString:nowUserID])
                {
                    chatMessage.m_owner = YES;
                }
                else
                {
                    chatMessage.m_owner = NO;
                }
                chatMessage.m_recevierID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 6)];
                chatMessage.m_content = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 7)];
                
                chatMessage.m_chatContent = [[NSMutableArray alloc] init];
                [[FDSPublicManage sharePublicManager] getMessageRange:chatMessage.m_content :chatMessage.m_chatContent];
                
                chatMessage.m_chatTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 8)];
                chatMessage.m_imageURL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 9)];
                chatMessage.m_state = sqlite3_column_int(stmt, 10);
                chatMessage.m_senderIcon = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 11)];

                [chatMessageList addObject:chatMessage];
                [chatMessage release];
                
                index++;
                
                if(index >= count)
                {
                    sqlite3_finalize(stmt);
                    [self closeDatabase];
                    return chatMessageList;
                }
            }
            sqlite3_finalize(stmt);
        }
        [self closeDatabase];
        return chatMessageList;
    }
    return nil;
}

/* 查询chatMessage表中未读消息数目 */
- (NSInteger)getChatMessageUnread:(FDSMessageCenter*)messageCenter
{
    /* 好友发送的消息才有可能是未读 */
    if ([self createOrOpenUserDB])
    {
        NSString *nowUserID = [[FDSUserManager sharedManager]getNowUser].m_userID;
        NSString *selectSQL = nil;
        if (FDSMessageCenterMessage_Type_CHAT_GROUP == messageCenter.m_messageType)
        {
            selectSQL = [NSString stringWithFormat:@"select count(*) from chatMessages where state = '%d' and userID = '%@' and groupID = '%@' and chatMessageType = '%d' ",FDS_MSG_STATE_UNREADED,nowUserID,messageCenter.m_param1,CHAT_MESSAGE_TYPE_CHAT_GROUP];
        }
        else if(FDSMessageCenterMessage_Type_CHAT_PERSON == messageCenter.m_messageType)
        {
            selectSQL = [NSString stringWithFormat:@"select count(*) from chatMessages where state = '%d' and userID = '%@' and senderID = '%@' and chatMessageType = '%d' ",FDS_MSG_STATE_UNREADED,nowUserID,messageCenter.m_senderID,CHAT_MESSAGE_TYPE_CHAT_PERSON];
        }
        else
        {
            [self closeDatabase];
            return 0;
        }
        
        sqlite3_stmt *stmt;
        if(sqlite3_prepare_v2(fdsInfoDB, [selectSQL UTF8String], -1, &stmt, nil) == SQLITE_OK)
        {
            while(sqlite3_step(stmt) == SQLITE_ROW)
            {
                NSInteger unReadCount = sqlite3_column_int(stmt,0);
                sqlite3_finalize(stmt);
                [self closeDatabase];
                return unReadCount;
            }
            sqlite3_finalize(stmt);
        }
        [self closeDatabase];
    }
    return 0;
}

/* 更新某一条聊天信息为已读 */
- (void)updateChatMessageDoRead:(NSInteger)chatMessageID
{
    if ([self createOrOpenUserDB])
    {
        NSLog(@"设置已读...");
        NSString *updateSQL = [NSString stringWithFormat:@"update chatMessages set state = '%d' where id = '%d'",FDS_MSG_STATE_READED,chatMessageID];
        [self execSql:updateSQL];
    }
    [self closeDatabase];
}

/* 更新与某一 好友/某群 的所有聊天信息为已读 */
- (void)updateChatRecordDoRead:(FDSMessageCenter*)messageCenter
{
    if ([self createOrOpenUserDB])
    {
//        NSLog(@"设置已读...");
        NSString *nowUserID = [[FDSUserManager sharedManager]getNowUser].m_userID;
        NSString *updateSQL = nil;
        if (FDSMessageCenterMessage_Type_CHAT_GROUP == messageCenter.m_messageType)
        {
            updateSQL = [NSString stringWithFormat:@"update chatMessages set state = '%d' where state = '%d' and groupID = '%@' and chatMessageType = '%d' and userID = '%@' ",FDS_MSG_STATE_READED,FDS_MSG_STATE_UNREADED,messageCenter.m_param1,CHAT_MESSAGE_TYPE_CHAT_GROUP,nowUserID];
        }
        else if(FDSMessageCenterMessage_Type_CHAT_PERSON == messageCenter.m_messageType)
        {
            updateSQL = [NSString stringWithFormat:@"update chatMessages set state = '%d' where state = '%d' and senderID = '%@' and chatMessageType = '%d' and userID = '%@' ",FDS_MSG_STATE_READED,FDS_MSG_STATE_UNREADED,messageCenter.m_senderID,CHAT_MESSAGE_TYPE_CHAT_PERSON,nowUserID];
        }
        else
        {
            [self closeDatabase];
            return;
        }
        [self execSql:updateSQL];
    }
    [self closeDatabase];
}

/*  删除chatMessages表中对应messageID的消息 */
- (void)deleteChatMessageFromDB:(NSInteger)chatMessageID
{
    if ([self createOrOpenUserDB])
    {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM chatMessages where id = '%d' ",chatMessageID];
        [self execSql:sql];
        [self closeDatabase];
    }
}











/* 更新一条消息到MessageCenter */
//不论添加还是更新操作messageCenter都获取到了messageCenter.m_id的值
- (void)updateMessageCenterToDB:(FDSMessageCenter*)messageCenter
{
    if ([self createOrOpenUserDB])
    {
        NSString *nowUserID = [[FDSUserManager sharedManager]getNowUser].m_userID;
        NSString *selectSQL = nil;
        if (FDSMessageCenterMessage_Type_CHAT_GROUP == messageCenter.m_messageType)
        {
            selectSQL = [NSString stringWithFormat:@"select * from messageCenter where userID = '%@' and param1 = '%@' and messageType = '%d'",nowUserID,messageCenter.m_param1,FDSMessageCenterMessage_Type_CHAT_GROUP];
        }
        else //除群聊的其他信息（包括系统添加好友信息）
        {
            selectSQL = [NSString stringWithFormat:@"select * from messageCenter where userID = '%@' and senderID = '%@' and messageType = '%d'",nowUserID,messageCenter.m_senderID,messageCenter.m_messageType];
        }
        sqlite3_stmt *stmt;
        if(sqlite3_prepare_v2(fdsInfoDB, [selectSQL UTF8String], -1, &stmt, nil) == SQLITE_OK)
        {
            if (sqlite3_step(stmt) != SQLITE_ROW)//插入之前查询有没有此条数据
            {
//                NSLog(@"插入一条数据到消息中心表...");
                NSString *insertSQL = [NSString stringWithFormat:@"insert into messageCenter (messageClass, messageType, icon, sendername, senderID, content, sendTime, state, userID, param1, param2) values ('%d','%d','%@','%@','%@','%@','%@','%d','%@','%@','%@')",messageCenter.m_messageClass,messageCenter.m_messageType, messageCenter.m_icon, messageCenter.m_senderName, messageCenter.m_senderID, messageCenter.m_content, messageCenter.m_sendTime, messageCenter.m_state, nowUserID, messageCenter.m_param1, messageCenter.m_param2];
                [self execSql:insertSQL];
                messageCenter.m_id = (int)sqlite3_last_insert_rowid(fdsInfoDB); //获取到消息ID
            }
            else //存在则更新messageCenter表
            {
//                NSLog(@"更新一条数据到消息中心表...");
                messageCenter.m_id = sqlite3_column_int(stmt,0);
                NSString *updateSQL = [NSString stringWithFormat:@"update messageCenter set senderID = '%@',sendername = '%@',content = '%@',sendTime = '%@',state = '%d',param1 = '%@' where id = '%d'",messageCenter.m_senderID,messageCenter.m_senderName, messageCenter.m_content, messageCenter.m_sendTime, messageCenter.m_state,messageCenter.m_param1, messageCenter.m_id];
                [self execSql:updateSQL];
            }
            sqlite3_finalize(stmt);  //查询之后不能忘记调用  否则将会导致之后的数据库表操作都失败
        }
        [self closeDatabase];
    }
}

/*  更新备注名到消息中心表的发送名字段  */
- (void)updateSenderName:(FDSUser*)friendInfo
{
    if ([self createOrOpenUserDB])
    {
        NSString *nowUserID = [[FDSUserManager sharedManager]getNowUser].m_userID;//,,,,,
        NSString *updateSQL = [NSString stringWithFormat:@"update messageCenter set sendername = '%@' where senderID = '%@' and userID = '%@'",friendInfo.m_remarkName,friendInfo.m_friendID,nowUserID];
        [self execSql:updateSQL];
        [self closeDatabase];
    }
}

/* 更新当前用户所有未读的系统消息为已读到MessageCenter  针对当前用户*/
- (void)updateAllSystemMessageCenterDoRead
{
    if ([self createOrOpenUserDB])
    {
        NSString *nowUserID = [[FDSUserManager sharedManager]getNowUser].m_userID;
        NSString *updateSQL = [NSString stringWithFormat:@"update messageCenter set state = '%d'  where userID = '%@' and state = '%d' and messageType != '%d' and messageType != '%d'",FDS_MSG_STATE_READED,nowUserID,FDS_MSG_STATE_UNREADED,FDSMessageCenterMessage_Type_CHAT_PERSON,FDSMessageCenterMessage_Type_CHAT_GROUP];
        [self execSql:updateSQL];
        [self closeDatabase];
    }
}

/* 更新当前用户某条系统消息为已读到MessageCenter */
- (void)updateSystemMessageCenterDoRead:(FDSMessageCenter*)messageCenter
{
    if ([self createOrOpenUserDB])
    {
        NSString *updateSQL = [NSString stringWithFormat:@"update messageCenter set state = '%d'  where id = '%d'",messageCenter.m_state,messageCenter.m_id];
        [self execSql:updateSQL];
        [self closeDatabase];
    }
}

/* 更新当前用户某条系统消息的操作状态到MessageCenter */
- (void)updateSystemMessageCenter:(FDSMessageCenter*)messageCenter
{
    if ([self createOrOpenUserDB])
    {
        NSString *updateSQL = [NSString stringWithFormat:@"update messageCenter set messageType = '%d'  where id = '%d'",messageCenter.m_messageType,messageCenter.m_id];
        [self execSql:updateSQL];
        [self closeDatabase];
    }
}


/* 获取当前用户MessageCenter表中的消息列表 按时间降序排列 */
- (NSMutableArray*)getMessageCenterNowUserFromDB
{
    if ([self createOrOpenUserDB])
    {
        BOOL isFind = NO; //针对系统消息或者添加好友信息是否查到过
        NSInteger index = 0;
        NSInteger firstIndex = 0;//查找到的第一个系统消息或者添加好友信息 缓存中的索引
        NSString *nowUserID = [[FDSUserManager sharedManager]getNowUser].m_userID;
        NSString *selectSQL = [NSString stringWithFormat:@"select * from messageCenter where userID = '%@' ORDER BY sendTime desc",nowUserID];
        sqlite3_stmt *stmt;
        FDSMessageCenter* messageCenter = nil;
        NSMutableArray *centerList = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        if(sqlite3_prepare_v2(fdsInfoDB, [selectSQL UTF8String], -1, &stmt, nil) == SQLITE_OK)
        {
            while(sqlite3_step(stmt) == SQLITE_ROW)
            {
                if (FDSMessageCenterMessage_Class_SYSTEM == sqlite3_column_int(stmt,1) ||  FDSMessageCenterMessage_Type_ADD_FRIEND_REQUEST== sqlite3_column_int(stmt,2) || FDSMessageCenterMessage_Type_ADD_FRIEND_AGREE == sqlite3_column_int(stmt,2) || FDSMessageCenterMessage_Type_ADD_FRIEND_REJECT == sqlite3_column_int(stmt,2) || FDSMessageCenterMessage_Type_ADD_FRIEND_SUC_RESULT == sqlite3_column_int(stmt,2) || FDSMessageCenterMessage_Type_ADD_FRIEND_FAIL_RESULT == sqlite3_column_int(stmt,2))
                {
                    if (isFind)
                    {
                        messageCenter = [centerList objectAtIndex:firstIndex];
                        if (FDS_MSG_STATE_UNREADED == sqlite3_column_int(stmt,8))
                        {
                            messageCenter.m_newMessageCount+=1;
                        }
                        continue; //不添加到展示列表中
                    }
                    isFind  = YES;
                    firstIndex = index;
                }
                
                messageCenter = [[FDSMessageCenter alloc]init];
                messageCenter.m_id = sqlite3_column_int(stmt,0);
                messageCenter.m_messageClass = sqlite3_column_int(stmt,1);
                messageCenter.m_messageType = sqlite3_column_int(stmt,2);
                messageCenter.m_icon = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)];
                messageCenter.m_senderName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 4)];
                messageCenter.m_senderID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 5)];
                
                messageCenter.m_content = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 6)];
                
                messageCenter.m_msgContent = [[[NSMutableArray alloc] init] autorelease];
                [[FDSPublicManage sharePublicManager] getMessageRange:messageCenter.m_content :messageCenter.m_msgContent];
                if (FDSMessageCenterMessage_Type_CHAT_GROUP == messageCenter.m_messageType)
                {
                    [messageCenter.m_msgContent insertObject:[NSString stringWithFormat:@"%@: ",messageCenter.m_senderName] atIndex:0];
                }
                messageCenter.m_sendTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 7)];
                messageCenter.m_state = sqlite3_column_int(stmt,8);
                if ((FDSMessageCenterMessage_Class_SYSTEM == sqlite3_column_int(stmt,1) ||  FDSMessageCenterMessage_Type_ADD_FRIEND_REQUEST== sqlite3_column_int(stmt,2) || FDSMessageCenterMessage_Type_ADD_FRIEND_AGREE == sqlite3_column_int(stmt,2) || FDSMessageCenterMessage_Type_ADD_FRIEND_REJECT == sqlite3_column_int(stmt,2) || FDSMessageCenterMessage_Type_ADD_FRIEND_SUC_RESULT == sqlite3_column_int(stmt,2) || FDSMessageCenterMessage_Type_ADD_FRIEND_FAIL_RESULT == sqlite3_column_int(stmt,2)) && FDS_MSG_STATE_UNREADED == messageCenter.m_state)
                {
                    messageCenter.m_newMessageCount+=1;
                }
                //[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 9)]; //userID
                messageCenter.m_param1 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 10)];
                messageCenter.m_param2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 11)];

                [centerList addObject:messageCenter];
                [messageCenter release];
                ++index;
            }
            sqlite3_finalize(stmt);
        }
        [self closeDatabase];
        return centerList;
    }
    return nil;
}

/* 查询当前用户MessageCenter 表中系统消息数据 */
- (NSMutableArray*)getSystemInfoNowUserFromDB
{
    if ([self createOrOpenUserDB])
    {
        NSString *nowUserID = [[FDSUserManager sharedManager]getNowUser].m_userID;
        NSString *selectSQL = [NSString stringWithFormat:@"select * from messageCenter where userID = '%@' and messageType != '%d' and messageType != '%d' ORDER BY sendTime desc",nowUserID,FDSMessageCenterMessage_Type_CHAT_PERSON,FDSMessageCenterMessage_Type_CHAT_GROUP];
        sqlite3_stmt *stmt;
        FDSMessageCenter* messageCenter = nil;
        NSMutableArray *centerList = [[NSMutableArray alloc] initWithCapacity:0];
        if(sqlite3_prepare_v2(fdsInfoDB, [selectSQL UTF8String], -1, &stmt, nil) == SQLITE_OK)
        {
            while(sqlite3_step(stmt) == SQLITE_ROW)
            {
                messageCenter = [[FDSMessageCenter alloc]init];
                messageCenter.m_id = sqlite3_column_int(stmt,0);
                messageCenter.m_messageClass = sqlite3_column_int(stmt,1);
                messageCenter.m_messageType = sqlite3_column_int(stmt,2);
                messageCenter.m_icon = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)];
                messageCenter.m_senderName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 4)];
                messageCenter.m_senderID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 5)];
                
                messageCenter.m_content = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 6)];
                
                messageCenter.m_msgContent = [[NSMutableArray alloc] init];
                [[FDSPublicManage sharePublicManager] getMessageRange:messageCenter.m_content :messageCenter.m_msgContent];
                
                messageCenter.m_sendTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 7)];
                messageCenter.m_state = sqlite3_column_int(stmt,8);
                messageCenter.m_param1 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 10)];
                messageCenter.m_param2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 11)];
                
                [centerList addObject:messageCenter];
                [messageCenter release];
            }
            sqlite3_finalize(stmt);
        }
        [self closeDatabase];
        return centerList;
    }
    return nil;
}

/*  删除messageCenter表中对应messageID的消息 */
- (void)deleteMessageCenterFromDB:(NSInteger)centerMessageID
{
    if ([self createOrOpenUserDB])
    {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM messageCenter where id = '%d' ",centerMessageID];
        [self execSql:sql];
        [self closeDatabase];
    }
}

/*  删除messageCenter表中对应的消息 */
- (void)deleteMessageCenter:(FDSMessageCenter*)messageCenter
{
    if ([self createOrOpenUserDB])
    {
        NSString *nowUserID = [[FDSUserManager sharedManager]getNowUser].m_userID;
        NSString *delSQL = nil;
        if (FDSMessageCenterMessage_Type_CHAT_GROUP == messageCenter.m_messageType)
        {
           delSQL = [NSString stringWithFormat:@"DELETE FROM messageCenter where userID = '%@' and param1 = '%@' and messageClass = '%d' and messageType = '%d' ",nowUserID,messageCenter.m_param1,FDSMessageCenterMessage_Class_USER,FDSMessageCenterMessage_Type_CHAT_GROUP];
        }
        else
        {
           delSQL = [NSString stringWithFormat:@"DELETE FROM messageCenter where userID = '%@' and senderID = '%@' and messageClass = '%d' and messageType = '%d' ",nowUserID,messageCenter.m_senderID,FDSMessageCenterMessage_Class_USER,messageCenter.m_messageType];
        }
        [self execSql:delSQL];
        [self closeDatabase];
    }
}


/*  删除当前用户messageCenter表中全部系统的消息 */
- (void)deleteAllSystemMessageFromDB
{
    if ([self createOrOpenUserDB])
    {
        NSString *nowUserID = [[FDSUserManager sharedManager]getNowUser].m_userID;
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM messageCenter where userID = '%@' and messageType != '%d' and messageType != '%d'",nowUserID,FDSMessageCenterMessage_Type_CHAT_PERSON,FDSMessageCenterMessage_Type_CHAT_GROUP];
        [self execSql:sql];
        [self closeDatabase];
    }
}

/*  更新发送消息者昵称字段到MessageCenter  针对当前用户*/
- (void)updateMessageCenterSendName:(NSString*)sendID :(NSString*)sendName
{
    if ([self createOrOpenUserDB])
    {
        NSString *nowUserID = [[FDSUserManager sharedManager]getNowUser].m_userID;
        NSString *updateSQL = [NSString stringWithFormat:@"update messageCenter set sendername = '%@'  where senderID = '%@' and userID = '%@'",sendName,sendID,nowUserID];
        [self execSql:updateSQL];
        [self closeDatabase];
    }
}







#pragma collectMsgInfo 表操作
/*  获取当前用户的收藏数据  */
- (NSMutableArray*)getNowUserFromCollectedDB
{
    if ([self createOrOpenUserDB])
    {
        NSString *nowUserID = [[FDSUserManager sharedManager]getNowUser].m_userID;
        NSString *selectSQL = [NSString stringWithFormat:@"select * from collectMsgInfo where userID = '%@' ORDER BY collectTime desc",nowUserID];
        sqlite3_stmt *stmt;
        FDSCollectedInfo* collectInfo = nil;
        NSMutableArray *collectedList = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        if(sqlite3_prepare_v2(fdsInfoDB, [selectSQL UTF8String], -1, &stmt, nil) == SQLITE_OK)
        {
            while(sqlite3_step(stmt) == SQLITE_ROW)
            {
                collectInfo = [[FDSCollectedInfo alloc]init];
                collectInfo.m_id = sqlite3_column_int(stmt,0);
                collectInfo.m_collectType = sqlite3_column_int(stmt,1);
                //[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];//userID
                collectInfo.m_collectTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)];
                collectInfo.m_collectTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 4)];
                collectInfo.m_collectIcon = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 5)];
                collectInfo.m_collectID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 6)];
                [collectedList addObject:collectInfo];
                [collectInfo release];
            }
            sqlite3_finalize(stmt);
        }
        [self closeDatabase];
        return collectedList;
    }
    return nil;
}

/*  增加一条收藏数据  */
- (void)addCollectedInfoToDB:(FDSCollectedInfo*)collectedInfo
{
    if ([self createOrOpenUserDB])
    {
//        NSLog(@"插入一条收藏信息数据...");
        NSString *nowUserID = [[FDSUserManager sharedManager]getNowUser].m_userID;
        NSString *insertSQL = [NSString stringWithFormat:@"insert into collectMsgInfo (collectType,userID,collectTitle,collectTime,collectIcon,collectID) values ('%d','%@','%@','%@','%@','%@')",collectedInfo.m_collectType,nowUserID,collectedInfo.m_collectTitle,collectedInfo.m_collectTime,collectedInfo.m_collectIcon,collectedInfo.m_collectID];
        [self execSql:insertSQL];
        collectedInfo.m_id = (int)sqlite3_last_insert_rowid(fdsInfoDB);
        
//        NSLog(@"FDSDBManager中消息messageID = %d",collectedInfo.m_id);
        [self closeDatabase];
    }
}

/*  删除一条收藏数据  */
- (void)deleteCollectedInfoFromDB:(NSInteger)messageID
{
    /*  messageID 唯一  */
    if ([self createOrOpenUserDB])
    {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM collectMsgInfo where id = '%d' ",messageID];
        [self execSql:sql];
        [self closeDatabase];
    }
}




@end

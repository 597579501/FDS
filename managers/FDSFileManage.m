//
//  FDSFileManage.m
//  FDS
//
//  Created by zhuozhong on 14-2-11.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//
#import <sqlite3.h>
#import "FDSFileManage.h"
#import "FDSPathManager.h"

static FDSFileManage *shareFileManager = nil;

@implementation FDSFileManage

+(id)shareFileManager
{
    if (shareFileManager == nil)
    {
        shareFileManager = [[super allocWithZone:NULL] init];
    }
    return shareFileManager;
}

- (BOOL)creatUserFolder
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *systemPath = [[FDSPathManager sharePathManager]getSystemPath];
    NSError *error = nil;
    if (![fileManager fileExistsAtPath:systemPath])
    {
        [fileManager createDirectoryAtPath:systemPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error)
        {
//            NSLog(@"Create System Folder has Error -------%@",error);
            return NO;
        }
        else
        {
//            NSLog(@"Create System Folder is OK...");
        }
    }
    
    NSString *userFoldPath = [[FDSPathManager sharePathManager] getUserFoldPath];
    if (![fileManager fileExistsAtPath:userFoldPath])
    {
        [fileManager createDirectoryAtPath:userFoldPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error)
        {
//            NSLog(@"Create userFoldPath Folder has Error -------%@",error);
            return NO;
        }
        else
        {
//            NSLog(@"Create userFoldPath Folder is OK...");
        }
    }
    
    NSString *chatImagePath = [[FDSPathManager sharePathManager] getchatImagePath];
    if (![fileManager fileExistsAtPath:chatImagePath])
    {
        [fileManager createDirectoryAtPath:chatImagePath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error)
        {
//            NSLog(@"Create chatImagePath Folder has Error -------%@",error);
            return NO;
        }
        else
        {
//            NSLog(@"Create chatImagePath Folder is OK...");
        }
    }

    return YES;
}

- (BOOL)creatUserInfoDataBase
{
    if ([self creatUserFolder])
    {
        sqlite3 *userInfoDB;
        NSString *dbPath = [[FDSPathManager sharePathManager] getUserDatabasePath];
        if (![[NSFileManager defaultManager] fileExistsAtPath:dbPath])  //存在则不创建（每次都执行较耗时）
        {
            if (sqlite3_open([dbPath UTF8String], &userInfoDB) == SQLITE_OK)
            {
                NSLog(@"打开或创建系统数据库OK...");
                /* 创建消息中心 表 */
                NSString *messageCenterSQL = @"CREATE TABLE IF NOT EXISTS  messageCenter (id integer primary key autoincrement, messageClass integer ,messageType integer,icon varchar(200),sendername varchar(200),senderID varchar(40),content varchar(400),sendTime varchar(20),state integer,userID varchar(20),param1 varchar(100),param2 varchar(40))";
                char *errorMsg;
                if (sqlite3_exec(userInfoDB, [messageCenterSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK)
                {
//                    NSLog(@"创建消息中心表错误: %s", errorMsg);
                }
                else
                {
//                    NSLog(@"创建消息中心表OK...");
                }
                
                /* 创建用户好友列表 表 */
                NSString *userFriendsSQL = @"CREATE TABLE IF NOT EXISTS  userFriends (id integer primary key autoincrement, userID varchar(20) , friendID varchar(20),name varchar(200),icon varchar(200),remarkName varchar(40),company varchar(400),job varchar(100),golfage integer,phoneNumber varchar(20))";
                if (sqlite3_exec(userInfoDB, [userFriendsSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK)
                {
//                    NSLog(@"创建好友列表 表错误: %s", errorMsg);
                }
                else
                {
//                    NSLog(@"创建好友列表 表OK...");
                }

                /* 创建用户群 表 */
                NSString *userGroupsSQL = @"CREATE TABLE IF NOT EXISTS  userGroups (id integer primary key autoincrement, userID varchar(20) ,groupType integer,name varchar(200),icon varchar(200),groupID varchar(40),brief varchar(400))";
                if (sqlite3_exec(userInfoDB, [userGroupsSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK)
                {
//                    NSLog(@"创建用户群表错误: %s", errorMsg);
                }
                else
                {
//                    NSLog(@"创建用户群表OK...");
                }

                /* 创建聊天消息 表 */
                NSString *chatMessagesSQL = @"CREATE TABLE IF NOT EXISTS  chatMessages (id integer primary key autoincrement, userID varchar(20) ,chatMessageType integer,roleType integer,groupID varchar(40),senderID varchar(40),receiverID varchar(40),content varchar(400),sendTime varchar(20),imageURL varchar(200),state integer,senderIcon varchar(200))";
                if (sqlite3_exec(userInfoDB, [chatMessagesSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK)
                {
//                    NSLog(@"创建聊天消息表错误: %s", errorMsg);
                }
                else
                {
//                    NSLog(@"创建聊天消息表OK...");
                }
                
                /* 创建添加好友确认信息 表 */
                NSString *addFriendCheckMessageSQL = @"CREATE TABLE IF NOT EXISTS  addFriendCheckMessage (id integer primary key autoincrement, userID varchar(20),senderType integer,senderName varchar(100),senderID varchar(40),messageType integer,state integer,result integer,accessword varchar(200))";
                if (sqlite3_exec(userInfoDB, [addFriendCheckMessageSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK)
                {
//                    NSLog(@"创建添加好友确认信息表错误: %s", errorMsg);
                }
                else
                {
//                    NSLog(@"创建添加好友确认信息表OK...");
                }

                /* 创建收藏帖子 收藏企业 表 */
                NSString *collectInfoSQL = @"CREATE TABLE IF NOT EXISTS  collectMsgInfo (id integer primary key autoincrement,collectType integer, userID varchar(20),collectTitle varchar(100),collectTime varchar(20),collectIcon varchar(150),collectID varchar(20))";
                if (sqlite3_exec(userInfoDB, [collectInfoSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK)
                {
//                    NSLog(@"创建收藏表错误: %s", errorMsg);
                }
                else
                {
//                    NSLog(@"创建收藏表OK...");
                }

                sqlite3_close(userInfoDB);
            }
            else
            {
//                NSLog(@"打开或创建系统数据库Fail...");
                sqlite3_close(userInfoDB);
                return NO;
            }
        }
        return YES;
    }
    return NO;
}

@end

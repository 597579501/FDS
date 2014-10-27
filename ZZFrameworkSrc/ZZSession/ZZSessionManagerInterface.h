//
//  ZZSessionManager_P.h
//  ZZFramework
//
//  Created by zhuozhongkeji on 13-10-17.
//  Copyright (c) 2013年 zhuozhongkeji. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 the net state ...
 */
/*
 1. 收到消息
 2. 连接状态
 
 */
enum ZZSessionNetState
{
    ZZSessionNetState_NONE,
    ZZSessionNetState_2G,
    ZZSessionNetState_WIFI,
    ZZSessionNetState_MAX
};
enum ZZSessionManagerState
{
    ZZSessionManagerState_NONE,
    ZZSessionManagerState_GETSEVERS,
    ZZSessionManagerState_CONNECTED,
    ZZSessionManagerState_CONNECT_FAIL,
    ZZSessionManagerState_CONNECT_MISS,
    ZZSessionManagerState_NET_FAIL,
    ZZSessionManagerState_NET_OK,
    ZZSessionManagerState_MAX
};
@protocol ZZSessionManagerInterface <NSObject>
@optional
-(void)sessionManagerStateNotice :(enum ZZSessionManagerState)sessionManagerState;
-(void)parseMessageData:(NSDictionary*)data;
@end

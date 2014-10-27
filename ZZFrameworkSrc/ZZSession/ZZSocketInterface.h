//
//  ZZSocket_P.h
//  ZZFramework
//
//  Created by zhuozhongkeji on 13-10-17.
//  Copyright (c) 2013年 zhuozhongkeji. All rights reserved.
//

#import <Foundation/Foundation.h>
/*  状态  */
enum ZZSocketState{
    ZZSocketState_NONE,
    ZZSocketState_CONNECTING,
    ZZSocketState_CONNECTED,//连接成功
    ZZSocketState_CONNECT_FAIL,//连接失败
    ZZSocketState_CREATE_CLOSE_FAIL,//创建失败
    ZZSocketState_CLOSE_BY_CLIENT,//客户端关闭
    ZZSocketState_CLOSE_BY_SERVER,//服务器关闭
    ZZSocketState_MAX
};
@protocol ZZSocketInterface <NSObject>
@optional
-(void)socketStateNotice :(enum ZZSocketState) socketState;
-(void)socketRecvMessage:(NSData *)data;
@end

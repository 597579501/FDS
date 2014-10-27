//
//  ZZSocketManager.h
//  ZZFramework
//
//  Created by zhuozhongkeji on 13-10-17.
//  Copyright (c) 2013年 zhuozhongkeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZInclude.h"
#import "ZZSocketInterface.h"

#import <sys/socket.h>
#import <stdio.h>
#import <stdlib.h>
#import <unistd.h>
#import <arpa/inet.h>
#import <sys/types.h>
#import <netdb.h>
#import <netinet/in.h>


@interface ZZSocketManager : NSObject<ZZSocketInterface>
{
    enum ZZSocketState m_socketState;
    CFSocketRef m_socket;/*  socket referce */
    NSMutableArray *messageQueue;
  
   // NSMutableSet observerArray;/*  关注网络状态，和socket状态的  */
   
}
@property (nonatomic,retain) NSMutableArray *observerArray;
@property (nonatomic,assign) BOOL recvThreadRun;
@property (nonatomic,assign) BOOL sendThreadRun;
@property (nonatomic,assign) BOOL disconnectByPhone;


+(ZZSocketManager*)sharedSocketManager;
-(void)registerObserver:(id<ZZSocketInterface>)observer;
-(void)unRegisterObserver:(id<ZZSocketInterface>)observer;

-(void)connectServer : (NSString*)serverIP : (int)serverPort;
-(void)closeSocket:(BOOL)closeByClient;

-(enum ZZSocketState)getSocketStatus;
-(void)NoticeSocketStateToDelegate :(enum ZZSocketState)socketState;
-(void)sendMessage:(NSData *)data;
-(void)readStream;
-(void)connectFinished:(BOOL)success;

@end

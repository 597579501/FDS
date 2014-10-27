//
//  ZZSessionManager.m
//  ZZFramework
//
//  Created by zhuozhongkeji on 13-10-17.
//  Copyright (c) 2013年 zhuozhongkeji. All rights reserved.

#import "ZZSessionManager.h"

@implementation ZZSessionManager
static ZZSessionManager *sessionManager = nil;
+(id)sharedSessionManager{
    if (sessionManager == nil) {
        sessionManager = [[super allocWithZone:NULL] init];
        [sessionManager managerInit];
    }
    return sessionManager;
}
-(void)managerInit
{
    sessionManagerState = ZZSessionManagerState_NONE;
    observerArray = [[NSMutableArray alloc]initWithCapacity:0];
   // [observerArray retain];
    messageObservers = [[NSMutableDictionary alloc]initWithCapacity:0];
    [messageObservers retain];
    socketManager = [[ZZSocketManager alloc]init];
    [socketManager registerObserver:self];
    netState = [self getNetState];
    [self registerNetStateManager];
}

/**###----net Manager------###*/
-(void)registerNetStateManager
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    reachability = [[Reachability reachabilityWithHostName:@"www.baidu.com"] retain];
    [reachability startNotifier];
}
-(void)reachabilityChanged:(NSNotification *)note{
    Reachability * curReach = [note object];
 //   NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    NetworkStatus tem = [curReach currentReachabilityStatus];
    if(m_netStatus != tem)
    {
        m_netStatus = tem;
    if (m_netStatus == NotReachable) {
        netState = ZZSessionNetState_NONE;
          sessionManagerState = ZZSessionManagerState_NET_FAIL;
        dispatch_async(dispatch_get_main_queue(),^{
            [self NoticeStateToDelegate:ZZSessionManagerState_NET_FAIL];
        });

//          [self NoticeStateToDelegate:ZZSessionManagerState_NET_FAIL];
        [self distroySessionConnect ];
            }
    else{
        netState = ZZSessionNetState_WIFI;
        sessionManagerState = ZZSessionManagerState_NET_OK;
        dispatch_async(dispatch_get_main_queue(),^{
            [self NoticeStateToDelegate:ZZSessionManagerState_NET_OK];
        });
//        [self NoticeStateToDelegate:ZZSessionManagerState_NET_OK];
        [self createSessionConnect];
    }
    }
    
    
}
/*   这个外部调用很少*/
-(NetworkStatus)getNetState
{
    //    if[self getSocketStatus]
    return m_netStatus;
    Reachability * curReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status_now = [curReach currentReachabilityStatus];
    return status_now;
}
-(void)NoticeStateToDelegate :(enum ZZSessionManagerState)sessionState
{
    for(id<ZZSessionManagerInterface>observer in observerArray)
    {
        if([observer respondsToSelector:@selector(sessionManagerStateNotice:)])
        {
               [observer sessionManagerStateNotice:sessionState];
        }
    }
}
-(void)sendMessage:(NSDictionary*)message

{
    if(socketManager == nil || [socketManager getSocketStatus] != ZZSocketState_CONNECTED)
        return;
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:message options:NSJSONWritingPrettyPrinted error:&error];
   
    if (!error) {
        NSLog(@"Process JSON data is sucessed...");
        
    }else{
        NSLog(@"Process JSON data has error...");
   
    }
//    if(socketManager == nil || sessionManagerState != ZZSessionManagerState_CONNECTED)
//    {
//        NSLog(@"连接失败，请稍后再试");
//        return;
//    }
    if (data ) {
          [socketManager sendMessage:data];
    }
    else{
        return;
    }
}
-(void)socketStateNotice:(enum ZZSocketState)socketManagerType
{
    switch (socketManagerType) {
    
        case ZZSocketState_CREATE_CLOSE_FAIL:
            break;
        case  ZZSocketState_CONNECT_FAIL:
            sessionManagerState = ZZSessionManagerState_NONE;
             [self NoticeStateToDelegate:sessionManagerState];
           // [socketManager closeSocket:YES];
            [self distroySessionConnect];
            break;
        case ZZSocketState_CONNECTED:
            sessionManagerState = ZZSessionManagerState_CONNECTED;
             [self NoticeStateToDelegate:sessionManagerState];
            break;
        case ZZSocketState_CLOSE_BY_SERVER:
            sessionManagerState = ZZSessionManagerState_CONNECT_MISS;
            [self distroySessionConnect];
             [self NoticeStateToDelegate:sessionManagerState];
            //[socketManager closeSocket:NO];
            break;
        default:
            break;
    }
//    dispatch_async(dispatch_get_main_queue(),^{
    
//    });

  
}

- (enum ZZSessionManagerState)getSessionState
{
    return sessionManagerState;
}

- (enum ZZSessionNetState)getSessionNetState
{
    return netState;
}

-(void)createSessionConnect
{
    if(socketManager != nil && [socketManager getSocketStatus] == ZZSocketState_NONE)
    {
        [socketManager connectServer:SERVER_IP : SERVER_PORT ];
    }
}
-(void)distroySessionConnect
{
     if(socketManager != nil && [socketManager getSocketStatus] != ZZSocketState_NONE)
     {
         [socketManager closeSocket:YES];
     }

}
-(void)socketRecvMessage:(NSData *)data
{
    NSError *error = nil;
    if (data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        if (!error) {
//            NSLog(@"JSON Data has Decoded...");
            NSString *key = [dic objectForKey:@"messageClass"];
            if(key)
            {
                ZZMessageManager *messageManager = [messageObservers objectForKey:key];
                if(messageManager && [messageManager respondsToSelector:@selector(parseMessageData:)])
                {
                    [messageManager parseMessageData:dic];
                }
            }
        }
        else{
            
            NSLog(@"##############Json数据解析出错！！！###################");
        }
        
    }
}
-(void)registerObserver:(id<ZZSessionManagerInterface>)observer
{
   if(![observerArray containsObject:observer])
   {
       [observerArray addObject:observer];
   }
}
-(void)unRegisterObserver:(id<ZZSessionManagerInterface>)observer
{
    if([observerArray containsObject:observer])
    {
        [observerArray removeObject:observer];
    }
}


-(void)registerMessageObserver:(id<ZZSessionManagerInterface>)observer :(NSString*)messageClass
{
     if([messageObservers objectForKey:messageClass] == nil)
     {
         [messageObservers setObject:observer forKey:messageClass];
     }
}
-(void)unRegisterMessageObserver:(NSString*)messageClass
{
    if([messageObservers objectForKey:messageClass] != nil)
    {
        [messageObservers removeObjectForKey:messageClass];
    }
}
@end

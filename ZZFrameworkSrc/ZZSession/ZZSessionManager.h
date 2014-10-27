//
//  ZZSessionManager.h
//  ZZFramework
//
//  Created by zhuozhongkeji on 13-10-17.
//  Copyright (c) 2013年 zhuozhongkeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZSocketManager.h"
#import "ZZMessageManager.h"
#import "ZZSessionManagerInterface.h"
#import "Reachability.h"
/*
 每一个消息都附带一个messageClass
 
 */

@interface ZZSessionManager : NSObject<ZZSocketInterface>
{
    NSMutableDictionary *messageObservers;
    NSMutableArray *observerArray;
    enum ZZSessionManagerState sessionManagerState;
    
    Reachability *reachability;
    NetworkStatus m_netStatus;
    enum ZZSessionNetState netState;// net state
    
    ZZSocketManager *socketManager; // socket manager.
}
+(id)sharedSessionManager;
-(void)sendMessage:(NSDictionary*)message;
-(void)registerObserver:(id<ZZSessionManagerInterface>)observer;
-(void)unRegisterObserver:(id<ZZSessionManagerInterface>)observer;

-(void)registerMessageObserver:(id<ZZSessionManagerInterface>)observer :(NSString*)messageClass;
-(void)unRegisterMessageObserver:(NSString*)messageClass;
- (enum ZZSessionManagerState)getSessionState;
-(enum ZZSessionNetState)getSessionNetState;
-(void)createSessionConnect;
-(void)distroySessionConnect;
@end

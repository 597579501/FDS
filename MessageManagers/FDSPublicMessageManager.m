//
//  FDSPublicMessageManager.m
//  FDS
//
//  Created by zhuozhong on 13-12-3.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "FDSPublicMessageManager.h"
#import "FDSUserManager.h"
@implementation FDSPublicMessageManager
#define FDSPublicMessageClass @"systemMessageManager"

static FDSPublicMessageManager *instance = nil;
+(FDSPublicMessageManager*)sharedManager
{
    if(nil == instance)
    {
        instance = [FDSPublicMessageManager alloc ];
        [instance initManager];
    }
    return instance;
}

-(void)initManager
{
    self.observerArray = [[NSMutableArray alloc]initWithCapacity:0];
    [self registerMessageManager:self :FDSPublicMessageClass];
    [[ZZSessionManager sharedSessionManager] registerObserver:self];
    // [self r:self :@"userCenter"];
    
}

-(void)registerObserver:(id<FDSPublicMessageInterface>)observer
{
    if ([self.observerArray containsObject:observer] == NO)
    {
        // [observer retain];
        [self.observerArray addObject:observer];
    }
}

-(void)unRegisterObserver:(id<FDSPublicMessageInterface>)observer
{
    if ([self.observerArray containsObject:observer]) {
        [self.observerArray removeObject:observer];
    }
}
- (void)sendMessage:(NSMutableDictionary *)message
{
    [message setObject:FDSPublicMessageClass forKey:@"messageClass"];
    [super sendMessage:message];
}
/*  请求离线消息  */
-(void)getOffLineMessages
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getOffLineMessages" forKey:@"messageType"];
    NSString *userID = [[FDSUserManager sharedManager] getNowUser].m_userID;
    if (userID && userID.length>0)
    {
        [dic setObject:userID forKey:@"userID"];
    }
    else
    {
        [dic setObject:@"" forKey:@"userID"];
    }

    //designer.m_userID = [data objectForKey:@"userID"];
    [self sendMessage:dic];
}
-(void)sendOnLineMessage
{
    /*    发表评论，回复(都不支持图片)     */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"onLinePoint" forKey:@"messageType"];
    
    [self sendMessage:dic];
}

- (void)updateStatus:(NSTimer*)timer
{
	[self sendOnLineMessage];
}

-(void)startOnLine
{
    if(m_timer == nil)
    {
        m_timer = [NSTimer timerWithTimeInterval:60 target:self selector:@selector(updateStatus:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:m_timer forMode:NSRunLoopCommonModes];
    }
}

-(void)stopOnLine
{
    if(nil != m_timer)
    {
        [m_timer invalidate];
        m_timer = nil;
    }

}
-(void)sessionManagerStateNotice :(enum ZZSessionManagerState)sessionManagerState
{
    switch (sessionManagerState) {
        case ZZSessionManagerState_CONNECTED:
        {
            [self startOnLine];
            break;
        }
        case ZZSessionManagerState_CONNECT_FAIL:
        {
            [self stopOnLine];
            break;
        }
        default:
            break;
    }
}
@end

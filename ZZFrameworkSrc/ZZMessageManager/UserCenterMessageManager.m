//
//  UserCenterMessageManager.m
//  ZZFramework
//
//  Created by zhuozhongkeji on 13-10-17.
//  Copyright (c) 2013年 zhuozhongkeji. All rights reserved.
//

#import "UserCenterMessageManager.h"

@implementation UserCenterMessageManager 
static UserCenterMessageManager *instance = nil;
+(UserCenterMessageManager*)sharedManager
{
   if(nil == instance)
   {
       instance = [UserCenterMessageManager alloc ];
       [instance initManager];
   }
    return instance;
}

-(void)initManager
{
    
}

-(void)sessionManagerStateNotice:(enum ZZSessionManagerState)sessionManagerState
{
    

}

-(void)parseMessageData:(NSDictionary *)data
{
    NSLog(@"user get Login message!");
}

-(void)sendMessage:(NSMutableDictionary *)message
{
    [message setObject:@"userCenter" forKey:@"messageClass"];
    [super sendMessage:message];
}

-(void)registerObserver:(id<UserCenterMessageInterface>)observer
{
}

-(void)unRegisterObserver:(id<UserCenterMessageInterface>)observer
{
    
}

@end

//
//  UserCenterMessageManager.h
//  ZZFramework
//
//  Created by zhuozhongkeji on 13-10-17.
//  Copyright (c) 2013年 zhuozhongkeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZSessionManager.h"
#import "UserCenterMessageInterface.h"

@interface UserCenterMessageManager : ZZMessageManager

+(UserCenterMessageManager*)sharedManager;

-(void)registerObserver:(id<UserCenterMessageInterface>)observer;
-(void)unRegisterObserver:(id<UserCenterMessageInterface>)observer;

@end

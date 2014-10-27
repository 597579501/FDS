//
//  UserManager.h
//  FDS
//
//  Created by zhuozhong on 14-1-22.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDSUser.h"
#import "FDSUserCenterMessageManager.h"
#import "ZZSessionManagerInterface.h"
@interface FDSUserManager : NSObject<FDSUserCenterMessageInterface,ZZSessionManagerInterface,ZZSocketInterface>
{
    FDSUser *m_user;
    enum USERSTATE m_userState;
}

+(FDSUserManager*)sharedManager;
- (enum USERSTATE)getNowUserState;
- (void)setNowUserState:(enum USERSTATE)userState;
- (FDSUser*)getNowUser;
- (void)modifyNowUser:(FDSUser*)userInfo;
- (void)setNowUserWithStyle:(enum MODIFY_PROFILE)modifyType withContext:(NSString*)context;

@end

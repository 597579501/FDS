//
//  UserManager.m
//  FDS
//
//  Created by zhuozhong on 14-1-22.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSUserManager.h"
#import "ZZUserDefaults.h"
#import "FDSUserCenterMessageManager.h"
#import "ZZSessionManager.h"
#import "FDSDBManager.h"
#import "FDSPublicMessageManager.h"

@implementation FDSUserManager
static FDSUserManager* manager = nil;

+ (FDSUserManager*)sharedManager
{
    if(nil == manager)
    {
       // m_user = nil;
        manager = [[FDSUserManager alloc]init];
        [manager managerInit];
    }
    return manager;
}

- (int)autoCheck
{
    int result = 0;
    /* get User ID ,count , password */
    NSString *userCount = [ZZUserDefaults getUserDefault:USER_COUNT];
    NSString *userPassword = [ZZUserDefaults getUserDefault:USER_PASSWORD];
    NSString *userLogout = [ZZUserDefaults getUserDefault:ISLOGOUT];
    if(userCount != nil && userPassword != nil)
    {
        m_user.m_account = userCount;
        m_user.m_password = userPassword;
        if(userLogout == nil ||  [userLogout isEqualToString:@"yes"])  //注销后不做自动登录
        {
            m_userState = USERSTATE_HAVE_ACCOUNT_NO_LOGIN_LOGINOUT;
            result = 0;
        }
        else
        {
            //有账号需自动登录  初始化为没网络（网路一旦连上需自动登录）若自动登录失败即可获知失败原因
            m_userState = USERSTATE_NONE;
            result = 1;
        }
    }
    else
    {
        m_userState = USERSTATE_NO_ACCOUNT;
    }
    return result;
}

- (void)managerInit
{
    m_userState = USERSTATE_NONE;

       m_user = [[FDSUser alloc]init];
    
    [self autoCheck];
    
    [[ZZSessionManager sharedSessionManager] registerObserver:self];
    [[FDSUserCenterMessageManager sharedManager] registerObserver:self];
}

- (enum USERSTATE)getNowUserState
{
    return m_userState;
}

- (void)setNowUserState:(enum USERSTATE)userState
{
    m_userState = userState;
}

- (FDSUser*)getNowUser
{
    return m_user;
}

- (void)modifyNowUser:(FDSUser*)userInfo
{
    [m_user copy:userInfo];
}


- (void)setNowUserWithStyle:(enum MODIFY_PROFILE)modifyType withContext:(NSString*)context
{
    switch (modifyType) {
        case MODIFY_PROFILE_NAME:
        {
            m_user.m_name = context;
        }
            break;
        case MODIFY_PROFILE_ICON:
        {
            m_user.m_icon = context;
        }
            break;
        case MODIFY_PROFILE_SEX:
        {
            m_user.m_sex = context;
        }
            break;
        case MODIFY_PROFILE_COMPANY:
        {
            m_user.m_company = context;
        }
            break;
        case MODIFY_PROFILE_JOB:
        {
            m_user.m_job = context;
        }
            break;
        case MODIFY_PROFILE_PHONE:
        {
            m_user.m_phone = context;
        }
            break;
        case MODIFY_PROFILE_TEL:
        {
            m_user.m_tel = context;
        }
            break;
        case MODIFY_PROFILE_GOLFAGE:
        {
            m_user.m_golfAge = context;
        }
            break;
        case MODIFY_PROFILE_BRIEF:
        {
            m_user.m_brief = context;
        }
            break;
        case MODIFY_PROFILE_HANDICAP:
        {
            m_user.m_handicap = context;
        }
            break;
        case MODIFY_PROFILE_EMAIL:
        {
            m_user.m_email = context;
        }
            break;
            
        default:
            break;
    }
}


- (void)sessionManagerStateNotice:(enum ZZSessionManagerState)sessionManagerState
{
    switch (sessionManagerState) {
        case ZZSessionManagerState_CONNECTED:
        {
            if([self autoCheck] == 1)
            {
                 /*  login */
                [[FDSUserCenterMessageManager sharedManager] userLogin:m_user.m_account :m_user.m_password];
            }
            break;
        }
        case ZZSessionManagerState_CONNECT_FAIL:
        {
            m_userState = USERSTATE_HAVE_ACCOUNT_NO_LOGIN_NOTNET;
            break;
        }
        default:
            break;
    }
}

- (void)userLoginCB:(NSString *)result :(NSString *)reason :(FDSUser *)user
{
    if([result isEqualToString:@"OK"])
    {
        m_userState = USERSTATE_LOGIN;
        [m_user copy:user];
        [[FDSPublicMessageManager sharedManager] getOffLineMessages];
        if ([[FDSDBManager sharedManager]getUserFriendsWithUserID].count <= 0)
        {
            /* 拉取好友列表 */
            [[FDSUserCenterMessageManager sharedManager] getUserFriends:user.m_userID];
        }
    }
    else if ([reason isEqualToString:@"FAIL"])
    {
        m_userState = USERSTATE_LOGIN_FAILED;
    }
}

- (void)getUserFriendsCB:(NSMutableArray *)friendList
{
    /* 拉取好友列表回调 */
    if (friendList.count > 0)
    {
        [[FDSDBManager sharedManager]AddFriendListToLocal:friendList];
//        [[FDSDBManager sharedManager]refreshAllFriends:friendList];
    }
}

@end

//
//  FDSUser.m
//  FDS
//
//  Created by Naval on 13-12-17.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "FDSUser.h"

@implementation FDSUser
-(void)dealloc
{
    self.m_name = nil;
    self.m_account = nil;
    self.m_userID = nil;
    self.m_friendID = nil;
    self.m_password = nil;
    self.m_phone = nil;
    self.m_icon = nil;
    self.m_sex = nil;
    self.m_job = nil;
    self.m_company = nil;
    self.m_handicap = nil;
    self.m_tel = nil;
    self.m_email = nil;
    self.m_brief = nil;
    self.m_golfAge = nil;
    self.m_remarkName = nil;
    self.m_joinedCompanyCount = nil;
    self.m_joinedBarCount = nil;
    self.m_friendType = nil;
    self.m_displayName = nil;
    [super dealloc];
}

- (void)copy:(FDSUser*)user
{
   if(user == nil)
       return;
    /* 针对切换账号内容更新  账号秘密字段服务器不返回 需判空*/
//    if (user.m_name && 0 < user.m_name.length)
//    {
        self.m_name = user.m_name;
//    }
    if (user.m_account && 0 < user.m_account.length)
    {
        self.m_account = user.m_account;
    }
    if (user.m_userID && 0 < user.m_userID.length)
    {
        self.m_userID = user.m_userID;
    }
    if (user.m_password && 0 < user.m_password.length)
    {
        self.m_password = user.m_password;
    }
    self.m_friendID = user.m_friendID;
//    if (user.m_phone && 0 < user.m_phone.length)
//    {
        self.m_phone = user.m_phone;
//    }
//    if (user.m_icon && 0 < user.m_icon.length)
//    {
        self.m_icon = user.m_icon;
//    }
//    if (user.m_sex && 0 < user.m_sex.length)
//    {
        self.m_sex = user.m_sex;
//    }
//    if (user.m_job && 0 < user.m_job.length)
//    {
        self.m_job = user.m_job;
//    }
//    if (user.m_company && 0 < user.m_company.length)
//    {
        self.m_company = user.m_company;
//    }
//    if (user.m_handicap && 0 < user.m_handicap.length)
//    {
        self.m_handicap = user.m_handicap;
//    }
//    if (user.m_tel && 0 < user.m_tel.length)
//    {
        self.m_tel = user.m_tel;
//    }
//    if (user.m_email && 0 < user.m_email.length)
//    {
        self.m_email = user.m_email;
//    }
//    if (user.m_brief && 0 < user.m_brief.length)
//    {
        self.m_brief = user.m_brief;
//    }
//    if (user.m_golfAge && 0 < user.m_golfAge.length)
//    {
        self.m_golfAge = user.m_golfAge;
//    }
        self.m_messageID = user.m_messageID;
    
    self.m_remarkName = user.m_remarkName;
    self.m_joinedCompanyCount = user.m_joinedCompanyCount;
    self.m_joinedBarCount = user.m_joinedBarCount;
    self.m_friendType = user.m_friendType;
    self.m_displayName = user.m_displayName;
}

@end

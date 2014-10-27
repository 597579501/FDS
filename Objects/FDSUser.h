//
//  FDSUser.h
//  FDS
//
//  Created by Naval on 13-12-17.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>
enum USERSTATE{
    USERSTATE_NONE,
    USERSTATE_NO_ACCOUNT,
    USERSTATE_HAVE_ACCOUNT_NO_LOGIN_LOGINOUT,// 因为注销而没有登录
    USERSTATE_HAVE_ACCOUNT_NO_LOGIN_NOTNET,//因为没有网络而没有登录
    USERSTATE_LOGIN,
    USERSTATE_LOGIN_FAILED, //登录失败
    USERSTATE_MAX
};
@interface FDSUser : NSObject
@property(nonatomic,retain)NSString *m_name;
@property(nonatomic,retain)NSString *m_account;
@property(nonatomic,retain)NSString *m_userID;
@property(nonatomic,retain)NSString *m_friendID;
@property(nonatomic,retain)NSString *m_password;
@property(nonatomic,retain)NSString *m_phone;
@property(nonatomic,retain)NSString *m_icon;
@property(nonatomic,retain)NSString *m_sex;
@property(nonatomic,retain)NSString *m_job;
@property(nonatomic,retain)NSString *m_company;
@property(nonatomic,retain)NSString *m_handicap;
@property(nonatomic,retain)NSString *m_tel;
@property(nonatomic,retain)NSString *m_email;
@property(nonatomic,retain)NSString *m_brief;
@property(nonatomic,retain)NSString *m_golfAge;
@property(nonatomic,assign)NSInteger m_messageID;


@property (nonatomic,assign) NSInteger m_sectionNumber;


@property(nonatomic,retain)NSString *m_remarkName;
@property(nonatomic,retain)NSString *m_joinedCompanyCount;
@property(nonatomic,retain)NSString *m_joinedBarCount;
@property(nonatomic,retain)NSString *m_friendType; //”no”,”friend”,
@property(nonatomic,retain)NSString *m_displayName;

-(void)copy:(FDSUser*)user;

@end

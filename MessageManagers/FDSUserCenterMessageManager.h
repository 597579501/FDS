//
//  FDSUserCenterMessageManager.h
//  FDS
//
//  Created by zhuozhong on 13-12-3.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "ZZMessageManager.h"
#import "FDSUserCenterMessageInterface.h"
#import "ZZSessionManager.h"

enum MODIFY_PROFILE
{
    MODIFY_PROFILE_NONE,
    MODIFY_PROFILE_NAME,
    MODIFY_PROFILE_ICON,
    MODIFY_PROFILE_SEX,
    MODIFY_PROFILE_COMPANY,
    MODIFY_PROFILE_JOB,
    MODIFY_PROFILE_PHONE,
    MODIFY_PROFILE_TEL,
    MODIFY_PROFILE_GOLFAGE,
    MODIFY_PROFILE_BRIEF,
    MODIFY_PROFILE_HANDICAP,
    MODIFY_PROFILE_EMAIL,
    MODIFY_PROFILE_MAX
};

@interface FDSUserCenterMessageManager : ZZMessageManager

+ (FDSUserCenterMessageManager*)sharedManager;
- (void)registerObserver:(id<FDSUserCenterMessageInterface>)observer;
- (void)unRegisterObserver:(id<FDSUserCenterMessageInterface>)observer;

//********用户注册***********
- (void)userRegisterRequest:(NSString*)phoneNumber :(NSString*)sessionID;
- (void)userRegister:(NSString*)phoneNumber :(NSString*)password :(NSString*)authCode :(NSString*)sessionID;

//********用户登陆***********
- (void)userLogin:(NSString*)userAccount :(NSString*)passsword;

//********修改个人名片***********
- (void)modifyUserCard:(NSString*)userID :(NSString*)modifyText :(enum MODIFY_PROFILE)modifyStyle;

//********用户注销***********
- (void)userLogout:(NSString*)userID;

//********得到个人的好友列表***********
- (void)getUserFriends:(NSString*)userID;

//********发送即时聊天***********
- (void)sendIM:(FDSChatMessage*)chatMessage;

//***************发送添加好友请求****************
- (void)addFriend:(NSString*)friendID :(NSString*)queryInfo;

//***************回复加好友请求****************
- (void)addFriendRequestReply:(NSString*)friendID :(NSString*)result;

//***************查找好友请求****************
- (void)searchFriends:(NSString*)KeyWord;

//***************获取好友的个人名片****************
- (void)getUserCard:(NSString*)friendID;

//***************删除好友****************
- (void)subFriend:(NSString*)friendID;

//***************修改好友备注名****************
- (void)modifyFriendsRemarkName:(NSString*)friendID :(NSString*)remarkName;

//***************得到用户企业列表****************
- (void)getJoinedCompanyList;

//***************得到个人动态****************
- (void)getUserRecord:(NSString*)friendID :(NSString*)recordID :(NSString*)getWay :(NSInteger)count;

//***************发表个人动态****************
- (void)sendUserRecord:(NSString*)content :(NSMutableArray*)images;

//***************发表评论，回复(都不支持图片)****************
- (void)sendRecordCommentRevert:(NSString*)recordID :(NSString*)content :(NSString*)type :(NSString*)revertedID;

//***************删除动态，评论，回复****************
- (void)deleteRecordCommentRevert:(NSString*)commentObjectID :(NSString*)type :(NSString*)objectID;

//***************意见反馈****************
- (void)feedback:(NSString*)content :(NSString*)contactWay;

//***************修改密码****************
- (void)modifyPassword:(NSString*)sessionID;

- (void)modifyPassword:(NSString*)sessionID :(NSString*)phoneNum;

- (void)modifyNewPassword:(NSString*)sessionID :(NSString*)authCode :(NSString*)newPassword;
- (void)modifyNewPassword:(NSString*)sessionID :(NSString*)authCode :(NSString*)newPassword :(NSString*)phoneNum;


//***************得到群成员****************
- (void)getGroupMembers:(NSString*)groupID :(NSString*)groupType;

//***************删除群成员****************
- (void)deleteGroupMember:(NSString*)deletedorID :(NSString*)groupID :(NSString*)groupType;


//***************验证用户为平台用户****************
- (void)checkUsersMembersByPhone:(NSMutableArray*)userList;

//***************获取推送设置****************
- (void)getPushSetting;

//***************修改推送设置****************
- (void)setPushSetting:(NSString*)ONOFF :(NSInteger)setType;

//***************检查版本更新****************
- (void)checkVersion;

@end

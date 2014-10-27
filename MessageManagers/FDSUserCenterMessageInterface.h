//
//  FDSUserCenterMessageInterface.h
//  FDS
//
//  Created by zhuozhong on 13-12-3.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FDSMessageCenter;
@class FDSChatMessage;
@class FDSUser;

@protocol FDSUserCenterMessageInterface <NSObject>

@optional
- (void)userRegisterRequestCB:(NSString*)result :(NSString*)authCode :(NSString*)timeout;//注册获取验证码
- (void)userRegisterCB:(NSString*)result;  //发送验证码注册
- (void)userLoginCB:(NSString *)result :(NSString *)reason :(FDSUser *)user;  //登录
- (void)modifyUserCardCB:(NSString*)result; //修改个人名片
- (void)userLogoutCB:(NSString*)result; //用户注销

- (void)getUserFriendsCB:(NSMutableArray*)friendList;//个人的好友列表

- (void)sendIMCB:(NSString*)result :(NSString*)messageID;//即时聊天

- (void)getIMCB:(FDSChatMessage*)chatMessage :(FDSMessageCenter*)messageCenter; //push 收消息

/* push消息 收到对方的添加好友请求 */
- (void)addFriendRequestCB:(FDSMessageCenter*)centerMessage :(FDSUser*)friendInfo;

/* push消息 发出添加好友请求后收到的回复 */
- (void)addFriendReplyCB:(FDSUser*)friendInfo :(FDSMessageCenter*)messageCenter;

/* 查找好友 */
- (void)searchFriendsCB:(NSMutableArray*)friendList;

/*  获取好友的个人名片 */
- (void)getUserCardCB:(FDSUser*)contactInfo :(NSString*)result;

/*    主动删除好友 */
- (void)subFriendCB:(NSString*)result :(FDSUser*)friendInfo;

/*  push消息  被好友对方删除  */
- (void)subedFriend:(FDSUser*)friendInfo;

/*    修改好友备注名   */
- (void)modifyFriendsRemarkNameCB:(NSString*)result;

/*   得到用户企业列表  */
- (void)getJoinedCompanyListCB:(NSMutableArray*)companyList;

/*    得到个人动态       */
- (void)getUserRecordCB:(NSMutableArray*)recordList;

/*    发表个人动态      */
- (void)sendUserRecordCB:(NSString*)result :(NSString*)recordID;

/*    发表评论，回复(都不支持图片)     */
- (void)sendRecordCommentRevertCB:(NSString*)result :(NSString*)commentID;

/*    删除动态，评论，回复     */
- (void)deleteRecordCommentRevertCB:(NSString*)result;

/*   意见反馈     */
-(void)feedbackCB:(NSString*)result;

//***************修改密码****************
- (void)modifyPasswordCB:(NSString*)result :(NSString*)authCode :(NSString*)timeout :(NSString*)sessionID;

- (void)modifyNewPasswordCB :(NSString*)result :(NSString*)reason;

/*    得到群成员     */
- (void)getGroupMembersCB:(NSString*)groupName :(NSString*)groupIcon :(NSString*)relation :(NSMutableArray*)friendList;

/*   删除群成员   */
- (void)deleteGroupMemberCB:(NSString*)result;

/*    验证用户为平台用户     */
- (void)checkUsersMembersByPhoneCB:(NSMutableArray*)resultList;

/*    好友修改名称 修改头像消息推送     */
- (void)cardInfoModifyCB:(NSString*)cardType :(NSString*)modifyName :(NSString*)modifyIcon :(NSString*)userID;

/*      获取推送设置       */
- (void)getPushSettingCB:(NSString*)result :(NSString*)restMode :(NSString*)systemPushMessage :(NSString*)friendPushMessage;

/*        修改推送设置        */
- (void)setPushSettingCB:(NSString*)result;

/*        检查版本更新        */
- (void)checkVersionCB:(NSString*)version :(NSString*)downloadURL;

@end

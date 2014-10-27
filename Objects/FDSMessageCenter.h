//
//  FDSMessageCenter.h
//  FDS
//
//  Created by zhuozhong on 14-2-12.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDSChatMessage.h"
/* message class , 这个功能上保留，但底层程序已经对该属性进行了处理     */
enum FDSMessageCenterMessage_Class
{
    FDSMessageCenterMessage_Class_NONE,
    FDSMessageCenterMessage_Class_USER, // 个人消息
    FDSMessageCenterMessage_Class_SYSTEM, // 系统消息
    FDSMessageCenterMessage_Class_MAX
};

/* message type */
enum FDSMessageCenterMessage_Type
{
    FDSMessageCenterMessage_Type_NONE,
    FDSMessageCenterMessage_Type_CHAT_PERSON, // 个人聊天
    FDSMessageCenterMessage_Type_CHAT_GROUP,// 群组聊天
    FDSMessageCenterMessage_Type_ADD_FRIEND_REQUEST, // 添加好友申请 (对方加自己)
    FDSMessageCenterMessage_Type_ADD_FRIEND_AGREE,// 已经同意添加 (对方加自己)
    FDSMessageCenterMessage_Type_ADD_FRIEND_REJECT,// 已经拒绝添加 (对方加自己)
    FDSMessageCenterMessage_Type_ADD_FRIEND_SUC_RESULT, // 添加好友成功结果 (自己加对方)
    FDSMessageCenterMessage_Type_ADD_FRIEND_FAIL_RESULT, // 添加好友失败结果(自己加对方)
    FDSMessageCenterMessage_Type_MAX
};

@interface FDSMessageCenter : NSObject

@property(nonatomic,assign)enum FDSMessageCenterMessage_Class       m_messageClass;
@property(nonatomic,assign)enum FDSMessageCenterMessage_Type        m_messageType;
@property(nonatomic,assign)enum FDS_MSG_READ_STATE                  m_state;
@property(nonatomic,assign)NSInteger                 m_newMessageCount;// 如果为0则没有新消息
@property(nonatomic,assign)NSInteger                 m_id;

@property(nonatomic,retain)NSMutableArray            *m_msgContent;
@property(nonatomic,retain)NSString                  *m_content;

@property(nonatomic,retain)NSString                  *m_icon;
@property(nonatomic,retain)NSString                  *m_senderID;
@property(nonatomic,retain)NSString                  *m_senderName;
@property(nonatomic,retain)NSString                  *m_sendTime;// 发送时间
@property(nonatomic,retain)NSString                  *m_param1;/* 保留参数1：在消息列表中这个用来表示群聊天的时候，表示企业ID */
@property(nonatomic,retain)NSString                  *m_param2;/* 保留参数2：在消息列表中这个用来表示群聊天的时候，表示企业Name */

- (void)copyMessage:(FDSChatMessage*)chatMessage;

@end

//
//  FDSMessage.h
//  FDS
//
//  Created by zhuozhong on 14-2-12.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

enum MSG_SEND_STATE  //发送状态
{
    MSG_STATE_NONE,
    MSG_STATE_SENDING,
    MSG_STATE_SEND_SUCCESS,
    MSG_STATE_SEND_FAILED,
    MSG_STATE_SEND_TIMEOUT,
    MSG_STATE_MAX
};

enum CHAT_MESSAGE_TYPE
{
    CHAT_MESSAGE_TYPE_NONE,
    CHAT_MESSAGE_TYPE_CHAT_PERSON, /* 个人聊天消息 */
    CHAT_MESSAGE_TYPE_CHAT_GROUP, /* 群聊天消息 */
    CHAT_MESSAGE_TYPE_MAX
};

enum CHAT_MESSAGE_SHOW_TIME
{
    CHAT_MESSAGE_SHOW_NONE,
    CHAT_MESSAGE_SHOW_TIP,
    CHAT_MESSAGE_SHOW_NO_TIP,
    CHAT_MESSAGE_SHOW_NO_MAX
};

enum FDS_Role_Type
{
    FDS_Role_Type_NONE,
    FDS_Role_Type_User, // 个人
    FDS_Role_Type_Group_Company, // 公司
    FDS_Role_Type_Group_Bar, // 贴吧
    FDS_Role_Type_Group_Team, // 球队
    FDS_Role_Type_MAX
};

enum FDS_MSG_READ_STATE
{
    FDS_MSG_STATE_NONE,
    FDS_MSG_STATE_UNREADED, //未读
    FDS_MSG_STATE_READED, //已读
    FDS_MSG_STATE_MAX
};

@interface FDSChatMessage : NSObject
@property(nonatomic,assign)enum CHAT_MESSAGE_SHOW_TIME   m_showtime;//是否显示时间
@property(nonatomic,assign)BOOL                      m_owner; //是否为自己发送的消息
@property(nonatomic,assign)enum MSG_SEND_STATE       m_send_state; //发送状态
@property(nonatomic,assign)enum CHAT_MESSAGE_TYPE    m_messageType;//消息类型
@property(nonatomic,assign)enum FDS_Role_Type        m_roleType;//角色类型
@property(nonatomic,assign)enum FDS_MSG_READ_STATE   m_state;//消息已读/未读状态
@property(nonatomic,assign)NSInteger                 m_messageID;  /* 消息记录ID */

@property(nonatomic,retain)NSMutableArray            *m_chatContent; //聊天消息内容
@property(nonatomic,retain)NSString                  *m_content;
@property(nonatomic,retain)NSString                  *m_chatTime; //聊天时间
@property(nonatomic,retain)NSString                  *m_groupID; //群组ID
@property(nonatomic,retain)NSString                  *m_imageURL; /* 如果是图片，这个保存图片的URL */
@property(nonatomic,retain)NSString                  *m_senderID;
@property(nonatomic,retain)NSString                  *m_senderName;
@property(nonatomic,retain)NSString                  *m_senderIcon;
@property(nonatomic,retain)NSString                  *m_recevierID;// 接受
@property(nonatomic,retain)NSString                  *m_groupName;// 群的名称：（公司名称）
@property(nonatomic,retain)NSString                  *m_groupIcon;// 群的icon
@property(nonatomic,retain)NSString                  *m_tmpImg;//临时存取本地发送得图片路径

@end

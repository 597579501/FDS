//
//  FDSMessageCenter.m
//  FDS
//
//  Created by zhuozhong on 14-2-12.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSMessageCenter.h"

@implementation FDSMessageCenter

- (void)dealloc
{
    self.m_msgContent = nil;           //聊天消息内容
    self.m_content = nil;
    self.m_icon = nil;              //聊天时间
    self.m_senderID = nil;               //群组ID
    self.m_senderName = nil;              /* 如果是图片，这个保存图片的URL */
    self.m_sendTime = nil;
    self.m_param1 = nil;
    self.m_param2 = nil;
    
    [super dealloc];
}

- (void)copyMessage:(FDSChatMessage*)chatMessage
{
    if (nil == chatMessage)
    {
        return;
    }
    if (chatMessage.m_chatContent)
    {
        _m_msgContent = [[NSMutableArray alloc] initWithArray:chatMessage.m_chatContent];
    }
    if (chatMessage.m_content)
    {
        self.m_content = chatMessage.m_content;
    }
    if (chatMessage.m_senderID)
    {
        self.m_senderID = chatMessage.m_senderID;
    }
    if (chatMessage.m_senderName)
    {
        self.m_senderName = chatMessage.m_senderName;
    }
    if (chatMessage.m_chatTime)
    {
        self.m_sendTime = chatMessage.m_chatTime;
    }
    self.m_state = chatMessage.m_state;
    
    if(CHAT_MESSAGE_TYPE_CHAT_PERSON == chatMessage.m_messageType)
    {
        self.m_messageType = FDSMessageCenterMessage_Type_CHAT_PERSON;
        if (chatMessage.m_senderIcon)
        {
            self.m_icon = chatMessage.m_senderIcon;
        }
    }
    else if(CHAT_MESSAGE_TYPE_CHAT_GROUP == chatMessage.m_messageType)
    {
        self.m_messageType = FDSMessageCenterMessage_Type_CHAT_GROUP;
        if (chatMessage.m_groupIcon)
        {
            self.m_icon = chatMessage.m_groupIcon;
        }
        self.m_param1 = chatMessage.m_groupID;
        self.m_param2 = chatMessage.m_groupName;
        [self.m_msgContent insertObject:[NSString stringWithFormat:@"%@ :",self.m_senderName] atIndex:0];
    }
}

@end

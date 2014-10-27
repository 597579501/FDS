//
//  FDSMessage.m
//  FDS
//
//  Created by zhuozhong on 14-2-12.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSChatMessage.h"
#import "Constants.h"

@implementation FDSChatMessage

- (void)dealloc
{
    self.m_chatContent = nil;           //聊天消息内容
    self.m_content = nil;
    self.m_chatTime = nil;              //聊天时间
    self.m_groupID = nil;               //群组ID
    self.m_imageURL = nil;              /* 如果是图片，这个保存图片的URL */
    self.m_senderID = nil;
    self.m_senderName = nil;
    self.m_senderIcon = nil;
    self.m_recevierID = nil;
    self.m_groupName = nil;
    self.m_groupIcon = nil;
    self.m_tmpImg = nil;
    
    [super dealloc];
}


@end

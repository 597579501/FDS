//
//  FDSComment.m
//  FDS
//
//  Created by zhuozhong on 14-2-24.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSComment.h"

@implementation FDSComment

- (void)dealloc
{
    self.m_commentID = nil;
    self.m_content = nil;
    self.m_senderID = nil;
    self.m_senderIcon = nil;
    self.m_senderName = nil;
    self.m_sendTime = nil;
    self.m_images = nil;
    self.m_revertsList = nil;
    
    [super dealloc];
}

@end

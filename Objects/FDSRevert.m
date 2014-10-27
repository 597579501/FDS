//
//  FDSRevert.m
//  FDS
//
//  Created by zhuozhong on 14-2-24.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSRevert.h"

@implementation FDSRevert

- (void)dealloc
{
    self.m_revertID = nil;
    self.m_senderID = nil;
    self.m_senderName = nil;
    self.m_senderIcon = nil;
    self.m_sendTime = nil;
    self.m_content = nil;
    self.m_reveredName = nil;
    
    [super dealloc];
}

@end

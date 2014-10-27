//
//  FDSBarPostInfo.m
//  FDS
//
//  Created by zhuozhong on 14-2-28.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSBarPostInfo.h"

@implementation FDSBarPostInfo

- (void)dealloc
{
    self.m_postType = nil;
    self.m_title = nil;
    self.m_contentType = nil;//”html”则content为html代码，”text”;
    self.m_content = nil;
    self.m_postID = nil;
    self.m_senderName = nil;
    self.m_senderID = nil;
    self.m_senderIcon = nil;
    self.m_sendTime = nil;
    self.m_commentNumber = nil;
    
    self.m_images = nil;

    self.m_url = nil;
    
    self.m_barPostList = nil;
    
    [super dealloc];
}
@end

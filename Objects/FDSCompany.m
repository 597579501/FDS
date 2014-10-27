//
//  FDSCompany.m
//  FDS
//
//  Created by zhuozhongkeji on 14-1-11.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSCompany.h"

@implementation FDSCompany

-(void)dealloc
{
    self.m_comName = nil;
    self.m_comIcon = nil;
    self.m_comState = nil;
    self.m_comId = nil;
    
    self.m_chatRoom = nil;
    self.m_customerServerID = nil;
    self.m_companyNameZH = nil;
    self.m_companyNamePin = nil;
    self.m_companyImage = nil;
    self.m_companyIcon = nil;
    self.m_briefInfo = nil;
    self.m_relation = nil;
    self.m_calls = nil;
    self.m_email = nil;
    self.m_fax = nil;
    self.m_website = nil;
    self.m_address = nil;
    self.m_longitude = nil;
    self.m_latitude = nil;
    self.m_commentCount = nil;

    [self.m_modulesArr removeAllObjects];
    self.m_modulesArr = nil;
    [self.m_barsArr removeAllObjects];
    self.m_barsArr = nil;
    
    self.m_sharedLink = nil;
    self.m_memberNumber = nil;
    [super dealloc];
}

@end

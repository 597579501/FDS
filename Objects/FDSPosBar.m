//
//  FDSPosBar.m
//  FDS
//
//  Created by zhuozhong on 14-2-28.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSPosBar.h"

@implementation FDSPosBar

- (void)dealloc
{
    self.m_barTypeName = nil;
    self.m_barTypeID = nil;
    self.m_barTypeIcon = nil;
    
    self.m_barName = nil;
    self.m_barID = nil;
    self.m_barIcon = nil;
    self.m_joinedNumber = nil;
    self.m_postNumber = nil;
    self.m_introduce = nil;

    self.m_relation = nil;
    self.m_companyID = nil;
    
    [super dealloc];
}

@end

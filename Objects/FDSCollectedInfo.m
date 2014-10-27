//
//  FDSCollectedInfo.m
//  FDS
//
//  Created by saibaqiao on 14-3-6.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSCollectedInfo.h"

@implementation FDSCollectedInfo

- (void)dealloc
{
    self.m_collectTitle = nil;
    self.m_collectTime = nil;
    self.m_collectIcon = nil;
    self.m_collectID = nil;
    
    
    [self.m_collectList removeAllObjects];
    self.m_collectList = nil;
    self.m_typeIcon = nil;
    self.m_typeTitle = nil;
    
    [super dealloc];
}


@end

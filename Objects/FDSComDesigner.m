//
//  FDSComDesigner.m
//  FDS
//
//  Created by zhuozhongkeji on 14-1-20.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSComDesigner.h"

@implementation FDSComDesigner

- (void)dealloc
{
    self.m_name = nil;                 //设计师name
    self.m_designerID = nil;           //设计师ID
    self.m_successfulcaseID = nil;     //设计师ID
    self.m_icon = nil;                 //设计师icon
    self.m_job = nil;                  //设计师job
    self.m_userID = nil;               //设计师userID
    self.m_comsex = nil;               //设计师sex
    self.m_companyName = nil;          //设计师companyName
    self.m_introduce = nil;            //设计师introduce
    self.m_sharedLink = nil;
    self.designList = nil;
    self.m_phone = nil;
    [super dealloc];
}


@end

//
//  FDSComSucCase.m
//  FDS
//
//  Created by zhuozhongkeji on 14-1-20.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSComSucCase.h"

@implementation FDSComSucCase

- (void)dealloc
{
    self.m_title = nil;       //案例title
    self.m_introduce = nil;  //案例introduce
    self.m_successfulcaseID = nil;      //公司案例ID

    [self.m_imagePathArr removeAllObjects]; //公司案例图片URL列表
    self.m_imagePathArr = nil;
    self.m_sharedLink = nil;
    
    [super dealloc];
}

@end

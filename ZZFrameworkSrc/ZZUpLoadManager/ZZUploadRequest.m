//
//  ZZUploadRequest.m
//  ZZFrameWork
//
//  Created by zhuozhong on 13-12-3.
//  Copyright (c) 2013年 naval. All rights reserved.
//

#import "ZZUploadRequest.h"

@implementation ZZUploadRequest

-(void)dealloc
{
    self.m_filePath = nil;
    self.m_fileName = nil;
    self.m_uploadSessionID = nil;
    self.m_storeWay = nil;
    self.m_fileDatas = nil;
    self.m_fileType = nil;
    self.m_stateCheckHTTPRequest = nil;
    self.m_asiFormDataRequest = nil;
    self.param1 = nil;
    [super dealloc];
}

@end

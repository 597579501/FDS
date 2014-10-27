//
//  FDSMessagesNavViewController.h
//  FDS
//
//  Created by zhuozhong on 13-12-3.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "FDSNavViewController.h"
#import "FDSMessagesCenterViewController.h"

@interface FDSMessagesNavViewController : FDSNavViewController
{
    FDSMessagesCenterViewController   *rootViewController;
}

@end

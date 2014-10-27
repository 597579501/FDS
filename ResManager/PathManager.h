//
//  PathManager.h
//  FDS
//
//  Created by Naval on 13-12-17.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZSessionManagerInterface.h"
#import "FDSPublicMessageInterface.h"
#import "FDSUserCenterMessageInterface.h"
#define SERVER_USER_ICON @"/userIcon"

@interface PathManager : NSObject<FDSPublicMessageInterface,FDSUserCenterMessageInterface>
+(PathManager*)sharedManager;
@property(nonatomic,retain)NSString *m_userIconServer;
@end

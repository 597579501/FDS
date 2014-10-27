//
//  PathManager.m
//  FDS
//
//  Created by Naval on 13-12-17.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "PathManager.h"
#import "FDSUserCenterMessageManager.h"
#import "FDSPublicMessageManager.h"
@implementation PathManager
static PathManager* pathManager = nil;
+(PathManager*)sharedManager
{
    if (nil == pathManager)
    {
        pathManager = [[PathManager alloc]init];
        [pathManager managerInit];
    }
    return pathManager;
}
-(void)managerInit
{
    [[FDSUserCenterMessageManager sharedManager] registerObserver:self];
    [[FDSPublicMessageManager sharedManager] registerObserver:self];
}
-(void)userLoginCB:(FDSUser *)user
{

}
-(void)serverPathResCB:(FDSServerPathRes *)serverPathRes
{

}

@end

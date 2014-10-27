//
//  PathManager.h
//  FDS
//
//  Created by zhuozhong on 14-1-22.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDSPathManager : NSObject
{
    NSString *userIconServerPath;
}

+ (FDSPathManager *)sharePathManager;

- (NSString*)getServerUserIcon;

- (NSString*)getMessageImagePath;

- (NSString *)getSystemPath;

- (NSString*)getUserFoldPath;  //可能改成userid动态文件名

- (NSString*)getUserDatabasePath;

- (NSString *)getchatImagePath;

@end

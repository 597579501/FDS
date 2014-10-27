//
//  PathManager.m
//  FDS
//
//  Created by zhuozhong on 14-1-22.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSPathManager.h"

#define kUserDataBase @"fds.sqlite"

static FDSPathManager *pathManager = nil;

@implementation FDSPathManager

+ (FDSPathManager *)sharePathManager
{
    if (pathManager == nil)
    {
        pathManager = [[super allocWithZone:NULL] init];
        [pathManager managerInit];
    }
    return pathManager;
}

-(void)managerInit
{
     userIconServerPath = @"/userIcon/";
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"_expression_cn"ofType:@"plist"]] forKey:@"FaceMap"];
}

- (NSString*)getServerUserIcon
{
    return  userIconServerPath;
}

- (NSString*)getMessageImagePath
{
    return @"/messageImage/";
}


- (NSString *)getSystemPath
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fdsPath = [documentPath stringByAppendingPathComponent:@"FDS"];
    return fdsPath;
}

- (NSString*)getUserFoldPath  //可能改成userid动态文件名
{
    NSString *systemPath = [self getSystemPath];
    NSString *userFolderPath = [systemPath stringByAppendingPathComponent:@"userDatabase"];//possible change userid
    return userFolderPath;
}

- (NSString*)getUserDatabasePath
{
    NSString *userFolderPath = [self getUserFoldPath];
    NSString *userDatabasePath = [userFolderPath stringByAppendingPathComponent:kUserDataBase];
    return userDatabasePath;
}

- (NSString *)getchatImagePath
{
    NSString *systemPath = [self getSystemPath];
    NSString *chatImagePath = [systemPath stringByAppendingPathComponent:@"chatImage"];
    return chatImagePath;
}

- (void)dealloc
{
    [super dealloc];
}

@end

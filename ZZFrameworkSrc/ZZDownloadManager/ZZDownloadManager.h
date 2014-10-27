//
//  ZZDownloadManager.h
//  FDS
//
//  Created by Naval on 13-12-17.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"
#import "ZZDownloadInterface.h"
@interface ZZDownloadManager : NSObject<ASIHTTPRequestDelegate>
@property (nonatomic,retain) NSMutableArray *observers;
//@property (nonatomic,retain) NSMutableArray *uploadRequests;
+(ZZDownloadManager * )sharedManager;
-(enum SYSTEM_STATE)startDownloadRequest : (NSURL*)url :(NSString*)storePath;

-(void)registerObserver:(id<ZZDownloadInterface>)observer;
-(void)unRegisterObserver:(id<ZZDownloadInterface>)observer;
@end

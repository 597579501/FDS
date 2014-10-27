//
//  ZZUploadManager.h
//  ZZFrameWork
//
//  Created by zhuozhong on 13-12-3.
//  Copyright (c) 2013年 naval. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZUploadInterface.h"
#import "ZZSessionManagerInterface.h"
#define UPLOAD_NUMBER_SUPPORT_MAX 10
@interface ZZUploadManager : NSObject<ASIHTTPRequestDelegate,ZZSessionManagerInterface>
{
    NSString *uploadServerURL;
    NSString *LookUploadStateServerURL;
}
+(ZZUploadManager * )sharedUploadManager;
@property (nonatomic,retain) NSMutableArray *observers;
@property (nonatomic,retain) NSMutableArray *uploadRequests;
-(NSArray*)getNowUploadRequests;

-(void)registerObserver:(id<ZZUploadInterface>)observer;
-(void)unRegisterObserver:(id<ZZUploadInterface>)observer;


/*  begin a uploadSession /userIcon/*/
-(enum ZZUploadState)beginUploadRequest:(NSString*)filePath :(NSString*)fileName :(NSString*)uploadSessionID :(NSString*)storeWay :(NSData*)fileDatas :(NSString*)fileType;
@end

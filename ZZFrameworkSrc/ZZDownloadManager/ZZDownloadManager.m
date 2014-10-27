//
//  ZZDownloadManager.m
//  FDS
//
//  Created by Naval on 13-12-17.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "ZZDownloadManager.h"
#import "ASIHTTPRequest.h"
@implementation ZZDownloadManager
static ZZDownloadManager *manager = nil;
+(ZZDownloadManager * )sharedManager
{
   if(nil == manager)
   {
       manager = [[ZZDownloadManager alloc] init];
       [manager managerInit];
   }
    return manager;
}
-(void)managerInit
{
    if (self.observers == nil)
    {
        self.observers = [[[NSMutableArray alloc] init] autorelease];
       
    }

}
-(void)registerObserver:(id<ZZDownloadInterface>)observer
{
    if ([self.observers containsObject:observer] == NO)
    {
        // [observer retain];
        [self.observers addObject:observer];
    }
}
-(void)unRegisterObserver:(id<ZZDownloadInterface>)observer
{
    if ([self.observers containsObject:observer]) {
        [self.observers removeObject:observer];
    }
}
-(void)downloadManagerStateNotice :(ZZDownloadRequest*)downloadRequest
{
    for(id<ZZDownloadInterface> upLoadInterface in self.observers)
    {
        if([upLoadInterface respondsToSelector:@selector(uploadStateNotice:)])
        {
            [upLoadInterface downStateNotice:downloadRequest];
        }
    }
}

-(void)downloadPackageDone:(ASIHTTPRequest *)request{
    
     NSLog(@"responseString is %@",[request responseString]);
    
//    NSData *data = [request responseData];
//    if (data) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            
//            if ([self.downloadCallBackDelegate respondsToSelector:@selector(downloadCallBackWithData:WithFriend:WithStatus:)]){
//                
//                //获取文件名
//                NSString *url = [[request originalURL] absoluteString];
//                NSArray *tempStringArray = [NSArray arrayWithArray:[url componentsSeparatedByString:@"/"]];
//                NSString *lastString = [tempStringArray objectAtIndex:[tempStringArray count]-1];
//                //lastString = [[lastString componentsSeparatedByString:@"."] objectAtIndex:0];
//                
//                [self.downloadCallBackDelegate downloadCallBackWithData:data WithFriend:lastString WithStatus:YES];
//                
//            }
//            
//            else if([self.downloadCallBackDelegate respondsToSelector:@selector(downloadCallBackWithData:WithStatus:)]){
//                
//                [self.downloadCallBackDelegate downloadCallBackWithData:[request responseData] WithStatus:YES];
//                
//            }
//            
//        });
//        
//    }
    
}

-(void)downloadPackageFail:(ASIHTTPRequest *)request
{
//    int i = 0;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        if([self.downloadCallBackDelegate respondsToSelector:@selector(downloadCallBackWithData:WithStatus:)]){
//            
//            [self.downloadCallBackDelegate downloadCallBackWithData:nil WithStatus:NO];
//            
//        }
//    });
    
}
-(enum SYSTEM_STATE)startDownloadRequest : (NSURL*)url :(NSString*)storePath
{
    enum SYSTEM_STATE state = SYSTEM_STATE_NONE;
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDownloadDestinationPath:storePath];
    [request setDidFinishSelector:@selector(downloadPackageDone:)];
    [request setDidFailSelector:@selector(downloadPackageFail:)];
    [request startAsynchronous];
    return state;
}
@end

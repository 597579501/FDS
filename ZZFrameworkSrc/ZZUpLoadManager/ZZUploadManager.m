//
//  ZZUploadManager.m
//  ZZFrameWork
//
//  Created by zhuozhong on 13-12-3.
//  Copyright (c) 2013年 naval. All rights reserved.
//

#import "ZZUploadManager.h"
#import "ZZSessionManager.h"
@implementation ZZUploadManager

static ZZUploadManager *uploadManager = nil;
+(ZZUploadManager * )sharedUploadManager
{
    if(nil == uploadManager)
    {
        uploadManager = [[ZZUploadManager alloc]init];
        [uploadManager managerInit];
        
    }
    return uploadManager;
}

-(void)managerInit
{
    if (self.observers == nil)
    {
        self.observers = [[[NSMutableArray alloc] init] autorelease];
    }
    
    if (self.uploadRequests == nil)
    {
        self.uploadRequests = [[[NSMutableArray alloc]init] autorelease];
    }
    uploadServerURL = [[NSString stringWithFormat:@"http://112.124.108.71/ZZFileServer/FileUploadPage.jsp"] retain];
//    uploadServerURL = [[NSString stringWithFormat:@"http://192.168.1.117:8080/fileserver/FileUploadPage.jsp"] retain];
    
    LookUploadStateServerURL = [[NSString stringWithFormat:@"http://112.124.108.71/ZZFileServer/LookFileUploadPage.jsp"] retain];
    /* get for some info... */
    [[ZZSessionManager sharedSessionManager]registerMessageObserver:self :@"uploadManager"];
}

-(void)registerObserver:(id<ZZUploadInterface>)observer
{
    if ([self.observers containsObject:observer] == NO)
    {
        // [observer retain];
        [self.observers addObject:observer];
    }
}
-(void)unRegisterObserver:(id<ZZUploadInterface>)observer
{
    if ([self.observers containsObject:observer]) {
        [self.observers removeObject:observer];
    }
}

-(NSArray*)getNowUploadRequests
{
    return self.uploadRequests;
}
/*  begin a uploadSession */
-(enum ZZUploadState)beginUploadRequest:(NSString*)filePath :(NSString*)fileName :(NSString*)uploadSessionID :(NSString*)storeWay :(NSData*)fileDatas :(NSString*)fileType
{
    enum ZZUploadState uploadState = ZZUploadState_NONE;
    ZZUploadRequest * uploadRequest = [[ZZUploadRequest alloc]init];
    uploadRequest.m_filePath = filePath;
    uploadRequest.m_fileName = fileName;
    uploadRequest.m_uploadSessionID = uploadSessionID;
    uploadRequest.m_storeWay = storeWay;
    uploadRequest.m_fileDatas = fileDatas;
    uploadRequest.m_fileType = fileType;
    uploadRequest.m_fileSize =[fileDatas length];
    
    [self.uploadRequests addObject:uploadRequest];
    uploadRequest.m_uploadState = ZZUploadState_UPLOAD_BEGIN;
    [self uploadManagerStateNotice:uploadRequest];
    [self startUploadRequst:uploadRequest];
    return uploadState;

}
-(ZZUploadRequest*)getUploadRequestByASIHTTPRequest:(ASIHTTPRequest*)asiHTTPRequest
{
    for(ZZUploadRequest *uploadRequest in self.uploadRequests)
    {
         if(uploadRequest.m_asiFormDataRequest ==asiHTTPRequest)
             return uploadRequest;
    }
    return nil;
}
-(ZZUploadRequest*)getUploadRequestByHTTPRequest:(ASIHTTPRequest*)httpRequest
{
    for(ZZUploadRequest *uploadRequest in self.uploadRequests)
    {
        if(uploadRequest.m_stateCheckHTTPRequest ==httpRequest)
            return uploadRequest;
    }
    return nil;
}
-(void)startUploadRequst:(ZZUploadRequest*)uploadRequest
{
    NSString *filePath = uploadRequest.m_filePath;
    NSString *fileName = uploadRequest.m_fileName;
    NSString *uploadSessionID = uploadRequest.m_uploadSessionID;
    NSString *storeWay = uploadRequest.m_storeWay;
    NSString *urlString = [[NSString stringWithFormat:@"%@?filePath=%@&fileName=%@&UploadSessionID=%@&storeWay=%@",uploadServerURL,filePath,fileName,uploadSessionID,storeWay] retain];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];//image/jepg
    
    uploadRequest.m_asiFormDataRequest = request;
//    UIImage *image = [UIImage imageNamed:@"coderbutton.png"];
//    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    [request setData:uploadRequest.m_fileDatas withFileName:uploadRequest.m_fileType andContentType:@"image/jepg" forKey:@"file"];
    [request setDelegate:self];
    [request startAsynchronous];
    uploadRequest.m_uploadState = ZZUploadState_UPLOADING;
    [self uploadManagerStateNotice:uploadRequest];
    [self uploadStateCheck:uploadRequest];
}
-(void)uploadManagerStateNotice :(ZZUploadRequest*)uploadRequest
{
    for(id<ZZUploadInterface> upLoadInterface in self.observers)
    {
        if([upLoadInterface respondsToSelector:@selector(uploadStateNotice:)])
        {
           [upLoadInterface uploadStateNotice:uploadRequest];
        }
    }
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error = nil;
    NSLog(@"Response is %@",[request responseString]);
    NSString *resultString = [request responseString];
    resultString = [resultString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[resultString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    if (!error) {
        NSLog(@"JSON Data has Decoded...");
       
        ZZUploadRequest *uploadRequest = [self getUploadRequestByASIHTTPRequest:request];
        if(uploadRequest != nil)
        {
             NSString *result = [dic objectForKey:@"result"];
            if([result compare:@"success"] == 0)
             {
                /*  ok */
                uploadRequest.m_uploadState = ZZUploadState_UPLOAD_OK;
                uploadRequest.m_filePath = [dic objectForKey:@"fileURL"];
             }
            else
             {
             /*  fail */
                uploadRequest.m_uploadState = ZZUploadState_UPLOAD_FAIL;
              }
            [self uploadManagerStateNotice:uploadRequest];
            [self removeUploadrequest:uploadRequest];
        }
        else/*state check */
        {
            ZZUploadRequest *uploadRequest1 = [self getUploadRequestByHTTPRequest:request];
            if(uploadRequest1 == nil)
                return;
            NSString *result = [dic objectForKey:@"result"];
            NSString *bytesRead = [dic objectForKey:@"bytesRead"];
            if([result compare:@"sucess"] == 0)
            {
                uploadRequest1.m_uploadedSize = [bytesRead intValue];
                [self uploadManagerStateNotice:uploadRequest1];
                NSLog(@"get the state check, fileSize is  :%d,and upload Size is :%d",uploadRequest1.m_fileSize,uploadRequest1.m_uploadedSize);
                if(uploadRequest1.m_uploadState == ZZUploadState_UPLOADING && (uploadRequest1.m_uploadedSize < uploadRequest1.m_fileSize))
                {
                    [self uploadStateCheck:uploadRequest1];
                }
            }
            else
            {
                if(uploadRequest1.m_uploadState == ZZUploadState_UPLOADING)
                {
                     [self uploadStateCheck:uploadRequest1];
                }
            // fail
            }
            
            
        }
        
    }
    else{
        
        NSLog(@"##############Json数据解析出错！！！###################");
    }

}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    ZZUploadRequest *uploadRequest = [self getUploadRequestByASIHTTPRequest:request];
    uploadRequest.m_uploadState = ZZUploadState_UPLOAD_FAIL;
    [self uploadManagerStateNotice:uploadRequest];
    [self removeUploadrequest:uploadRequest];
}
-(void)removeUploadrequest:(ZZUploadRequest*)uploadRequest
{
    [self.uploadRequests removeObject:uploadRequest];
}

/* state check */
-(void)uploadStateCheck:(ZZUploadRequest*)uploadRequest
{
    NSString *urlString = [NSString stringWithFormat:@"%@?UploadSessionID=%@",LookUploadStateServerURL,uploadRequest.m_uploadSessionID];
    NSURL *url = [NSURL URLWithString:urlString];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
    uploadRequest.m_stateCheckHTTPRequest =request;
}

-(void)sessionManagerStateNotice:(enum ZZSessionManagerState)sessionManagerState
{
    if(sessionManagerState == ZZSessionManagerState_GETSEVERS)
    {
        
    }
}

@end

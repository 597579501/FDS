//
//  ZZUploadRequest.h
//  ZZFrameWork
//
//  Created by zhuozhong on 13-12-3.
//  Copyright (c) 2013年 naval. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
enum ZZUploadState{
    ZZUploadState_NONE,
    ZZUploadState_FAIL_OVER_MAX,//wait state ,because the upload number is over
    ZZUploadState_UPLOAD_BEGIN,
    ZZUploadState_UPLOADING,
    ZZUploadState_UPLOAD_OK,
    ZZUploadState_UPLOAD_FAIL,
    ZZUploadState_MAX,
    
};
@interface ZZUploadRequest : NSObject
@property(nonatomic,assign)int m_fileSize;
@property(nonatomic,assign)int m_uploadedSize;
@property(nonatomic)enum ZZUploadState m_uploadState;
@property(nonatomic,retain)NSString *m_filePath;
@property(nonatomic,retain)NSString *m_fileName;
@property(nonatomic,retain)NSString *m_uploadSessionID;
@property(nonatomic,retain)NSString *m_storeWay;
@property(nonatomic,retain)NSData *m_fileDatas;
@property(nonatomic,retain)NSString *m_fileType;
@property(nonatomic,retain)ASIFormDataRequest *m_asiFormDataRequest;
@property(nonatomic,retain)ASIHTTPRequest *m_stateCheckHTTPRequest;
@property(nonatomic,retain)NSString *param1;// return param1;
@end

//
//  ZZDownloadRequest.h
//  FDS
//
//  Created by Naval on 13-12-17.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>
enum ZZDownloadState{
    ZZDownloadState_NONE,
    ZZDownloadState_FAIL_OVER_MAX,//wait state ,because the upload number is over
    ZZDownloadState_DOWNLOAD_BEGIN,
    ZZDownloadState_DOWNLOADING,
    ZZDownloadState_DOWNLOAD_OK,
    ZZDownloadState_DOWNLOAD_FAIL,
    ZZDownloadState_MAX,
    
};
@interface ZZDownloadRequest : NSObject

@end

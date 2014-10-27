//
//  ZZDownloadInterface.h
//  FDS
//
//  Created by Naval on 13-12-17.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#ifndef FDS_ZZDownloadInterface_h
#define FDS_ZZDownloadInterface_h

#import <Foundation/Foundation.h>
#import "ZZDownloadRequest.h"

@protocol ZZDownloadInterface <NSObject>
@optional
-(void)downStateNotice:(ZZDownloadRequest*)uploadRequest;
@end




#endif

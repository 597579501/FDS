//
//  ZZUploadInterface.h
//  ZZFrameWork
//
//  Created by zhuozhong on 13-12-3.
//  Copyright (c) 2013年 naval. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZUploadRequest.h"

@protocol ZZUploadInterface <NSObject>
@optional
-(void)uploadStateNotice:(ZZUploadRequest*)uploadRequest;
@end

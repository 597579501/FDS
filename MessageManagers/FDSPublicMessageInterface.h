//
//  FDSPublicMessageInterface.h
//  FDS
//
//  Created by zhuozhong on 13-12-3.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDSServerPathRes.h"
@protocol FDSPublicMessageInterface <NSObject>
@optional
-(void)serverPathResCB : (FDSServerPathRes*)serverPathRes;
@end

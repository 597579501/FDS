//
//  FDSFileManage.h
//  FDS
//
//  Created by zhuozhong on 14-2-11.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDSFileManage : NSObject

+ (id)shareFileManager;

- (BOOL)creatUserFolder;

- (BOOL)creatUserInfoDataBase;

@end

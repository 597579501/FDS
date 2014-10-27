//
//  ZZSharedManager.h
//  FDS
//
//  Created by zhuozhong on 14-3-24.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZSharedManager : NSObject

+ (ZZSharedManager *)shareManager;

+ (void)setSharedParam:(UIViewController *)viewControl :(NSString*)title :(NSString*)URL :(NSString*)icon :(NSString*)content;

@end

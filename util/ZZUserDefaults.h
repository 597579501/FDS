//
//  ZZUserDefaults.h
//  FDS
//
//  Created by zhuozhong on 14-1-22.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZUserDefaults : NSObject
+(NSString*)getUserDefault:(NSString*)key;
+(void)setUserDefault:(NSString*)key : (NSString*)value;
@end

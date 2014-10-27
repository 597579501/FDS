//
//  ZZUserDefaults.m
//  FDS
//
//  Created by zhuozhong on 14-1-22.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "ZZUserDefaults.h"

@implementation ZZUserDefaults
+(NSString*)getUserDefault:(NSString*)key{
    if(nil == key)
        return nil;
    NSUserDefaults *defalult = [NSUserDefaults standardUserDefaults];
    NSString *result = nil;
    result = [defalult objectForKey:key];
    return result;

}
+(void)setUserDefault:(NSString*)key : (NSString*)value
{
    NSUserDefaults *defalult = [NSUserDefaults standardUserDefaults];
    [defalult setValue:value forKey:key];
    [defalult synchronize];
}
@end

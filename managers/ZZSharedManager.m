//
//  ZZSharedManager.m
//  FDS
//
//  Created by zhuozhong on 14-3-24.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "ZZSharedManager.h"
#import "UMSocial.h"

@implementation ZZSharedManager

static ZZSharedManager* manager = nil;

+ (ZZSharedManager *)shareManager
{
    if(nil == manager)
    {
        manager = [[ZZSharedManager alloc]init];
        [manager managerInit];
    }
    return manager;
}


- (void)managerInit
{
    [UMSocialData setAppKey:@"532be5fb56240b2cdf0a2c8d"];  //52bb9f7256240be11509ed41
    
    //打开Qzone的SSO开关
    [UMSocialConfig setSupportQzoneSSO:YES importClasses:@[[QQApiInterface class],[TencentOAuth class]]];
    
    //打开新浪微博的SSO开关
    [UMSocialConfig setSupportSinaSSO:YES];
}

+ (void)setSharedParam:(UIViewController *)viewControl :(NSString*)title :(NSString*)URL :(NSString*)icon :(NSString*)content
{
    if (content.length > 200 )
    {
        content = [content substringToIndex:200];
    }
    if (title.length > 100)
    {
        title = [title substringToIndex:100];
    }

    [UMSocialData defaultData].extConfig.title = title;
    
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:icon];
    
    //设置微信AppId，url地址传nil，将默认使用友盟的网址
    [UMSocialConfig setWXAppId:@"wx66e842747f7d9596" url:URL];
    
    //打开Qzone的SSO开关
//    [UMSocialConfig setSupportQzoneSSO:YES importClasses:@[[QQApiInterface class],[TencentOAuth class]]];

    //设置手机QQ的AppId，url传nil，将使用友盟的网址
    [UMSocialConfig setQQAppId:@"101044554" url:URL importClasses:@[[QQApiInterface class],[TencentOAuth class]]];

    [UMSocialSnsService presentSnsIconSheetView:viewControl
                                         appKey:@"532be5fb56240b2cdf0a2c8d"
                                      shareText:[NSString stringWithFormat:@"%@",content]
                                     shareImage:nil
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToDouban,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToEmail,UMShareToSms,nil]
                                       delegate:nil];
    
}


@end

//
//  ZZMessageManager.m
//  ZZFramework
//
//  Created by zhuozhongkeji on 13-10-17.
//  Copyright (c) 2013年 zhuozhongkeji. All rights reserved.
//

#import "ZZMessageManager.h"
#import "ZZSessionManager.h"
#import "SVProgressHUD.h"
#import "UIToastAlert.h"

@implementation ZZMessageManager
-(void)registerMessageManager:(ZZMessageManager*)messageManager :(NSString*)messageClass
{
     [[ZZSessionManager sharedSessionManager] registerMessageObserver :messageManager : messageClass];
}

-(void)sendMessage:(NSDictionary*)message
{
    enum ZZSessionManagerState state = [[ZZSessionManager sharedSessionManager]getSessionState];
    if (ZZSessionManagerState_NONE == state || ZZSessionManagerState_NET_FAIL == state || ZZSessionManagerState_CONNECT_FAIL == state ||
        ZZSessionManagerState_CONNECT_MISS == state) //网络不可用
    {
        if ([SVProgressHUD isActivty])
        {
            [SVProgressHUD popActivity];
            NSString *str = nil;
            if (ZZSessionManagerState_NET_FAIL == state)
            {
                str = [NSString stringWithFormat:@"网络不可用 请检查网络！"];
            }
            else
            {
                str = [NSString stringWithFormat:@"服务器连接失败！"];
            }
            UIToastAlert *toast = [UIToastAlert shortToastForMessage:str atPosition:UIToastAlertPositionBottom];
            toast._tintColor = [UIColor grayColor];
            [toast show:[UIApplication sharedApplication].keyWindow.rootViewController.view];
        }
    }
    else
    {
        [[ZZSessionManager sharedSessionManager] sendMessage:message];
    }
}


@end

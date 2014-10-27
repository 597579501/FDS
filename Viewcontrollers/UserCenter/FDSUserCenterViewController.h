//
//  FDSUserCenterViewController.h
//  FDS
//
//  Created by zhuozhongkeji on 14-1-8.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnLoginView.h"
#import "FDSUserCenterMessageManager.h"
#import "ZZSessionManager.h"

@interface FDSUserCenterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,LoginBtnDelegate,FDSUserCenterMessageInterface,ZZSessionManagerInterface,ZZSocketInterface>
{
    UIView              *networkView; //网络是否可用提示
}

@property(nonatomic,strong) UITableView     *profileTable;

@property(nonatomic,retain) UnLoginView     *unLoginview;

@end

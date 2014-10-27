//
//  FDSSettingViewController.h
//  FDS
//
//  Created by zhuozhongkeji on 14-1-8.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSUserCenterMessageManager.h"

@interface FDSSettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,FDSUserCenterMessageInterface>
{
    
}

@property(nonatomic,strong) UITableView     *setTable;

@property(nonatomic,retain) NSString        *updateURL;

@end

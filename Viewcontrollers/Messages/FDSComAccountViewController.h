//
//  FDSComAccountViewController.h
//  FDS
//
//  Created by zhuozhong on 14-3-13.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSUserCenterMessageManager.h"

@interface FDSComAccountViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,FDSUserCenterMessageInterface>

@property(nonatomic,retain) UITableView      *companyTable;

@property(nonatomic,retain)NSMutableArray    *companyInfoList;

@end

//
//  FDSEditSexViewController.h
//  FDS
//
//  Created by zhuozhongkeji on 14-1-23.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSUserCenterMessageManager.h"
#import "FDSEditProfileViewController.h"

@interface FDSEditSexViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,FDSUserCenterMessageInterface>

@property(nonatomic,strong)UITableView   *tableview;

@property(nonatomic,strong)NSString   *modifyContent;
@property(nonatomic,assign)id<ProfileRefreshDelegate>delegate;

@end

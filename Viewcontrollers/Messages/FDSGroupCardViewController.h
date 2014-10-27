//
//  FDSGroupCardViewController.h
//  FDS
//
//  Created by zhuozhong on 14-3-13.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSUserCenterMessageManager.h"

@interface FDSGroupCardViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,FDSUserCenterMessageInterface>

@property(nonatomic,strong)UITableView     *groupTable;

@property(nonatomic,retain)NSMutableArray  *resultList;

@property(nonatomic,retain)NSString        *groupID;
@property(nonatomic,retain)NSString        *groupType;

@property(nonatomic,retain)NSString        *groupName;
@property(nonatomic,retain)NSString        *groupIcon;
@property(nonatomic,retain)NSString        *relation;

@end

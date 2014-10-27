//
//  FDSSystemMessageViewController.h
//  FDS
//
//  Created by zhuozhong on 14-2-19.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgCenterTableViewCell.h"
#import "FDSUserCenterMessageManager.h"


@interface FDSSystemMessageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,OperFriendDelegate,FDSUserCenterMessageInterface>
{
    NSMutableArray  *systemList;
}

@property(nonatomic,retain)UITableView     *systemTable;

@property(nonatomic,assign)BOOL     isUpdateDB;


@end

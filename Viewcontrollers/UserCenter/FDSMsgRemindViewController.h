//
//  FDSMsgRemindViewController.h
//  FDS
//
//  Created by zhuozhongkeji on 14-1-9.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileTableViewCell.h"
#import "FDSUserCenterMessageManager.h"

@interface FDSMsgRemindViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MsgSetingListenDelegate,FDSUserCenterMessageInterface>
{
    NSArray    *titleArr;
    NSInteger  selectIndex;
}
@property(nonatomic,strong) UITableView     *msgSetingTable;

@property(nonatomic,retain) NSString        *resetMode; //免打扰
@property(nonatomic,retain) NSString        *systemPushMessage;//系统通知
@property(nonatomic,retain) NSString        *friendPushMessage;//好友信息通知

@end

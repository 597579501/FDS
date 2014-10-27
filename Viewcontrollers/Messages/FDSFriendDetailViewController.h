//
//  FDSFriendDetailViewController.h
//  FDS
//
//  Created by zhuozhong on 14-2-19.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSUser.h"
#import "FDSUserCenterMessageManager.h"

@interface FDSFriendDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,FDSUserCenterMessageInterface>
{
    NSArray    *titleArr;
}

@property(nonatomic,strong) UITableView     *friendInfoTable;

@property(nonatomic,retain) FDSUser         *friendInfo;

@end

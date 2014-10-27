//
//  FDSThirdAccManagerViewController.h
//  FDS
//
//  Created by zhuozhongkeji on 14-1-10.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileTableViewCell.h"

@interface FDSThirdAccManagerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UnBindListenDelegate>
{
    NSMutableArray    *snsInfoArr;
}
@property(nonatomic,strong) UITableView     *accountManageTable;

@end

//
//  FDSCollectListViewController.h
//  FDS
//
//  Created by zhuozhong on 14-3-7.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSPublicManage.h"

@interface FDSCollectListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
}
@property(nonatomic,retain) UITableView                      *collectedTable;

@property(nonatomic,retain) FDSCollectedInfo                 *collectInfo;

@end

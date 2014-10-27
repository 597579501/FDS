//
//  FDSRecordListViewController.h
//  FDS
//
//  Created by zhuozhongkeji on 13-12-23.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSCompanyMessageManager.h"

@interface FDSRecordListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,FDSCompanyMessageInterface>
{
}

@property(nonatomic,strong) UITableView     *tableDataView;
@property(nonatomic,strong) NSString        *titStr;
@property(nonatomic,strong) NSMutableArray  *pageDataArr;
@property(nonatomic,retain) NSString        *firstTypeID;

@end

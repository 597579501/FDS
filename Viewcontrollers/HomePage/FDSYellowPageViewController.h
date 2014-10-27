//
//  FDSYellowPageViewController.h
//  FDS
//
//  Created by zhuozhongkeji on 13-12-23.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendCell.h"
#import "RecoreListCell.h"
#import "FDSCompanyMessageManager.h"

@interface FDSYellowPageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ScrollClickInterface,FDSCompanyMessageInterface>
{
    NSMutableArray  *_pageDataArr;
}

@property(nonatomic,strong) UITableView     *tableDataView;

@property(nonatomic,retain) NSMutableArray  *companyList;

@end

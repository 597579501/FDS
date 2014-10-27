//
//  FDSComListViewController.h
//  FDS
//
//  Created by zhuozhongkeji on 13-12-23.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSCompanyMessageManager.h"

@interface FDSComListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,FDSCompanyMessageInterface>
{
}

@property(nonatomic,retain) UITableView   *tableDataView;
@property(nonatomic,retain) NSString      *titStr;
@property(nonatomic,retain) NSString      *typeId; //有可能是ID 也可能是搜索Key
@property(nonatomic,retain) NSMutableArray   *pageDataArr;

@property(nonatomic,retain)NSString      *showType;//按分类还是关键词

@end

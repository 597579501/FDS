//
//  FDSSeachResultViewController.h
//  FDS
//
//  Created by zhuozhong on 14-2-17.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDSSeachResultViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView     *resultTable;

@property(nonatomic,retain)NSMutableArray  *resultList;

@end

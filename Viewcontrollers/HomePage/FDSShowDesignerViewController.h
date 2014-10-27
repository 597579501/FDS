//
//  FDSShowDesignerViewController.h
//  FDS
//
//  Created by zhuozhongkeji on 14-1-6.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSCompanyMessageManager.h"

@interface FDSShowDesignerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,FDSCompanyMessageInterface>

@property(nonatomic,strong)UITableView     *designerTable;

@property(nonatomic,retain)NSMutableArray  *designerList;
@property(nonatomic,strong)NSString        *com_ID;
@property(nonatomic,assign)BOOL            isSearch;
@end

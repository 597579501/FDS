//
//  FDSShowSchemeViewController.h
//  FDS
//
//  Created by zhuozhongkeji on 14-1-6.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchemeTableViewCell.h"
#import "FDSCompanyMessageManager.h"

@interface FDSShowSchemeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SchemeDetailDelegate,FDSCompanyMessageInterface>

@property(nonatomic,strong) UITableView       *schemeTable;

@property(nonatomic,strong) NSString          *com_ID;

@property(nonatomic,strong) NSMutableArray    *sucfulList;

@property(nonatomic,assign) BOOL              isSearch;

@end

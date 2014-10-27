//
//  FDSShowProductViewController.h
//  FDS
//
//  Created by zhuozhongkeji on 13-12-27.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuScrollView.h"
#import "FDSCompanyMessageManager.h"

@interface FDSShowProductViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MenuBtnDelegate,FDSCompanyMessageInterface>
{
}
@property(nonatomic,strong) MenuScrollView    *menuScroll;
@property(nonatomic,strong) UITableView       *contentTable;

@property(nonatomic,strong) NSString          *com_ID;
@property(nonatomic,strong) NSMutableArray    *titleArr;

@property(nonatomic,assign) BOOL isSearch;  //是否搜索

@end

//
//  FDSAdressBookViewController.h
//  FDS
//
//  Created by zhuozhong on 14-2-11.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSUserCenterMessageManager.h"

@interface FDSAdressBookViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,FDSUserCenterMessageInterface>
{
    UISearchBar *searchBar;
}

@property(nonatomic,retain)UITableView    *contactTableView;

@property(nonatomic,retain)NSMutableArray *contactsArr;
@property(nonatomic,retain)NSMutableArray *contentList; //展示内容数据
@property (nonatomic,retain) NSMutableArray *filteredListContent; //搜索结果数据


@property (nonatomic,retain) UISearchDisplayController *mySearchDisplayController;

@end

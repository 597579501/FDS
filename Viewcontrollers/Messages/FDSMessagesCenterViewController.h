//
//  FDSMessagesCenterViewController.h
//  FDS
//
//  Created by zhuozhong on 14-1-26.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnLoginView.h"
#import "FDSUserCenterMessageManager.h"
#import "ZZSessionManager.h"

@interface FDSMessagesCenterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,LoginBtnDelegate,FDSUserCenterMessageInterface,ZZSessionManagerInterface,ZZSocketInterface>
{
    UIView              *networkView; //网络是否可用提示
    
    UISearchBar         *searchBar;
}

@property(nonatomic,retain) UnLoginView     *unLoginview;

@property(nonatomic,retain) UITableView   *msgTable;

@property(nonatomic,retain)NSMutableArray *centerMesageList;

@property (nonatomic,retain) NSMutableArray *filteredListContent; //搜索结果数据

@property (nonatomic,retain) UISearchDisplayController *mySearchDisplayController;

@end

//
//  FDSBarTypeViewController.h
//  FDS
//
//  Created by zhuozhong on 14-2-28.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSBarMessageManager.h"
#import "PullingRefreshTableView.h"

@interface FDSBarTypeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,FDSBarMessageInterface,PullingRefreshTableViewDelegate>
{
    BOOL   isRefresh;
    BOOL   isLoadMore;
    NSInteger   selectIndex;
    
    PullingRefreshTableView         *posBarTable;
}
@property(nonatomic,assign) BOOL              isSearch;//是否是贴吧搜索进去
@property(nonatomic,retain) NSMutableArray    *posBarList;

@property(nonatomic,retain) FDSPosBar         *posBarInfo;
@property(nonatomic,retain) NSString          *keyWord; //贴吧搜索关键词

@end

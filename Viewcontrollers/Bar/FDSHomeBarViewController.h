//
//  FDSHomeBarViewController.h
//  FDS
//
//  Created by zhuozhong on 14-2-27.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHADScrollView.h"
#import "FDSBarMessageManager.h"
#import "ZZSessionManager.h"

@interface FDSHomeBarViewController : UIViewController<UITextFieldDelegate,XHADScrollViewDatasource,XHADScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,FDSBarMessageInterface,ZZSessionManagerInterface,ZZSocketInterface,ZZSocketInterface>
{
    XHADScrollView      *xhaScroll;
    UITableView         *posBarTable;
    UIView              *networkView; //网络是否可用提示
    UIView              *seachView;
}

@property(nonatomic,retain) UITextField     *searchText;

@property(nonatomic,retain)NSMutableArray   *posBarList;

@property(nonatomic,retain)NSMutableArray   *hotPosBarList;

@end

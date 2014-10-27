//
//  FDSDesignerDetailViewController.h
//  FDS
//
//  Created by zhuozhongkeji on 14-1-7.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuDropView.h"
#import "FDSCompanyMessageManager.h"
#import "ButtomMenuView.h"

@interface FDSDesignerDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,OperSNSBtnDelegate,FDSCompanyMessageInterface>
{
    NSArray    *titleArr;
}
@property(nonatomic,strong) ButtomMenuView  *menuButtomView;
@property(nonatomic,strong) UITableView     *designerTable;

@property(nonatomic,strong) NSString        *designerID;
@property(nonatomic,retain) FDSComDesigner  *designerInfo;

@property(nonatomic,retain)NSMutableArray   *collectTypeData;

@end

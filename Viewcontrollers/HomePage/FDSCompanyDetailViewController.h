//
//  FDSCompanyDetailViewController.h
//  FDS
//
//  Created by zhuozhongkeji on 13-12-20.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+BarExtension.h"
#import "MSTouchLabel.h"
#import "SummaryTableViewCell.h"
#import "MoreTableViewCell.h"
#import "MenuDropView.h"
#import "FDSCompanyMessageManager.h"
#import "EGOImageView.h"


@interface FDSCompanyDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MSTouchLabelDelegate,MoreTableViewCellHideInterface,MoreTableCellClickInterface,MenuDropBtnDelegate,FDSCompanyMessageInterface>
{
    UITableView      *_pageTable;
    EGOImageView     *_companyBgImg;
    MenuDropView     *_transView;
}

@property(nonatomic,strong)NSString      *companyID;

@property(nonatomic,strong)NSString      *comName; //企业名

@property(nonatomic,retain)FDSCompany    *companyInfo;

@property(nonatomic,retain)NSMutableArray   *collectTypeData;

@end

//
//  FDSSchemeDetailViewController.h
//  FDS
//
//  Created by zhuozhongkeji on 14-1-6.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHADScrollView.h"
#import "FDSComSucCase.h"
#import "ButtomMenuView.h"
#import "FDSCompanyMessageManager.h"

@interface FDSSchemeDetailViewController : UIViewController<XHADScrollViewDatasource,XHADScrollViewDelegate,OperSNSBtnDelegate,FDSCompanyMessageInterface>
{
    XHADScrollView      *xhaScroll;
    UITextView          *schemeContentText;
}

@property(nonatomic,strong)FDSComSucCase   *comSucCaseInfo;

@property(nonatomic,strong) ButtomMenuView  *menuButtomView;

@property(nonatomic,retain)NSMutableArray   *collectTypeData;

@end

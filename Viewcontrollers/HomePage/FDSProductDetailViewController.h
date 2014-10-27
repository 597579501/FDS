//
//  FDSProductDetailViewController.h
//  FDS
//
//  Created by zhuozhongkeji on 13-12-27.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSCompanyMessageManager.h"
#import "ButtomMenuView.h"
#import "XHADScrollView.h"

@interface FDSProductDetailViewController : UIViewController<OperSNSBtnDelegate,FDSCompanyMessageInterface,XHADScrollViewDatasource,XHADScrollViewDelegate>

@property(nonatomic,strong) ButtomMenuView  *menuButtomView;
@property(nonatomic,retain) XHADScrollView  *xhaScroll;

@property(nonatomic,retain) UILabel       *nameLab;
@property(nonatomic,retain) UILabel       *storeNumLab;
@property(nonatomic,retain) UILabel       *postageLab; //包邮
@property(nonatomic,retain) UILabel       *priceLab;

@property(nonatomic,retain) UITextView    *briefInfoText;

@property(nonatomic,retain) NSString     *companyID;
@property(nonatomic,retain) NSString     *productID;

@property(nonatomic,strong)FDSComProduct *productInfo;

@property(nonatomic,strong)NSMutableArray   *collectTypeData;

@end

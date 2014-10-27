//
//  FDSCompanyMessageInterface.h
//  FDS
//
//  Created by zhuozhong on 13-12-3.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDSCompany.h"
#import "FDSComProduct.h"
#import "FDSComSucCase.h"
#import "FDSComDesigner.h"

@protocol FDSCompanyMessageInterface <NSObject>
@optional

/*  根据企业一级分类得到二级分类  */
- (void)getCompanySencondTypeByFirstTypeCB:(NSMutableArray*)recordList;

- (void)getSystemRecommendCompanysCB:(NSMutableArray*)compnyList;
- (void)getCompanyListCB:(NSMutableArray*)result;
- (void)getCompanyInfoCB:(NSString*)result withCompanyInfo:(FDSCompany*)companyInfo;
- (void)getCompanyProductTypesCB:(NSMutableArray*)result;
- (void)getCompanyProductListCB:(NSMutableArray*)productInfoArr withCondition:(NSString*)condition;
- (void)getCompanyProductInfoCB:(FDSComProduct*)productInfo;
- (void)getCompanySuccessfulcaselistCB:(NSMutableArray*)successfulcaselist;
/*   得到案例详情   */
- (void)getSuccessfulcaseInfoCB:(FDSComSucCase*)sucCaseDetail;
- (void)getCompanyDesignersCB:(NSMutableArray*)designerslist;
- (void)getDesignerInfoCB:(FDSComDesigner*)designers;
- (void)getCompanyCommentListCB:(NSMutableArray*)commentList;
- (void)companyCommentCB:(NSString*)result :(NSString*)commentID;
- (void)getCompanyCommentRevertListCB:(NSMutableArray*)revertList;
- (void)deleteCompanyCommentRevertCB:(NSString*)result;
- (void)joinGroupCB:(NSString*)result :(NSString*)reason;
- (void)quitGroupCB:(NSString*)result;

/*  得到系统搜索热词  */
- (void)getSystemHotWordsCB:(NSMutableArray*)words;

/*   获取首页的推荐  */
- (void)getHomePageRecommendedsCB:(NSMutableArray*)recommandList;

@end

//
//  FDSCompanyMessageManager.h
//  FDS
//
//  Created by zhuozhong on 13-12-3.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "ZZMessageManager.h"
#import "ZZSessionManager.h"
#import "FDSCompanyMessageInterface.h"
#import "FDSComment.h"


@interface FDSCompanyMessageManager : ZZMessageManager
{
    
}

+ (FDSCompanyMessageManager*)sharedManager;
- (void)registerObserver:(id<FDSCompanyMessageInterface>)observer;
- (void)unRegisterObserver:(id<FDSCompanyMessageInterface>)observer;

/*  根据企业一级分类得到二级分类  */
- (void)getCompanySencondTypeByFirstType :(NSString*)firstTypeID;

//********得到推荐企业***********
- (void)getSystemRecommendCompanys;

//********获取企业列表接口***********
- (void)getCompanyList:(NSString*)getWay :(NSString*)condition;

//********获取企业详细接口***********
- (void)getCompanyInfo:(NSString*)comId;

//********获取公司的产品分类接口***********
- (void)getCompanyProductTypes:(NSString*)userId withComId:(NSString*)comId;

//********获取公司的产品列表***********
- (void)getCompanyProductList:(NSString*)userId withComId:(NSString*)comId withWay:(NSString*)way withCondition:(NSString*)condition;

//********得到产品详情***********
- (void)getCompanyProductInfo:(NSString*)userId withComId:(NSString*)comId withProductId:(NSString*)productID;

//********得到公司案例列表***********
//way:”all”:表示得到所有的，condition就传companyID  而key则表示来按照关键字来进行搜索。
- (void)getCompanySuccessfulcaselist:(NSString*)way withCondition:(NSString*)condition;

/*   得到案例详情   */
- (void)getSuccessfulcaseInfo:(NSString*)successfulcaseID;

//********得到公司设计师***********
//way:”all”:表示得到所有的，condition就传companyID  而key则表示来按照关键字来进行搜索。
- (void)getCompanyDesigners:(NSString*)way withCondition:(NSString*)condition;

//******** 得到设计师信息***********
- (void)getDesignerInfo:(NSString*)designerID;

/*      包括企业，产品，案例，设计师的评论获取    */
- (void)getCompanyCommentList:(NSString*)commentObjectID :(NSString*)commentObjectType :(NSString*)commentID :(NSString*)getWay :(NSInteger)count;

/*  发表企业评论，回复  */
- (void)companyComment:(NSString*)commentObjectType :(NSString*)commentContentType :(NSString*)commentObjectID :(NSString*)commentID :(NSString*)content :(NSMutableArray*)images;

/*   得到评论的回复列表  */
- (void)getCompanyCommentRevertList:(NSString*)commentID :(NSString*)revertID :(NSString*)getWay :(NSInteger)count;

/*   删除企业评论，回复  */
- (void)deleteCompanyCommentRevert:(NSString*)commentObjectID :(NSString*)type :(NSString*)objectID;

/*  加入群  */
- (void)joinGroup:(NSString*)groupType :(NSString*)groupID;

/*  退出群  */
- (void)quitGroup:(NSString*)groupType :(NSString*)groupID;

/*  得到系统搜索热词  */
- (void)getSystemHotWords:(NSString*)type;

/*  获取首页的推荐  */
- (void)getHomePageRecommendeds;

@end

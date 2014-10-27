//
//  FDSCompanyMessageManager.m
//  FDS
//
//  Created by zhuozhong on 13-12-3.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "FDSCompanyMessageManager.h"
#import "FDSRevert.h"
#import "FDSUserManager.h"
#import "FDSPosBar.h"
#import "FDSBarPostInfo.h"

#define FDSCompanyMessageClass @"companyMessageManager"

@implementation FDSCompanyMessageManager
static FDSCompanyMessageManager *instance = nil;

+ (FDSCompanyMessageManager*)sharedManager
{
    if(nil == instance)
    {
        instance = [FDSCompanyMessageManager alloc];
        [instance initManager];
    }
    return instance;
}

- (void)initManager
{
    self.observerArray = [[NSMutableArray alloc]initWithCapacity:0];
    [self registerMessageManager:self :FDSCompanyMessageClass];
    [[ZZSessionManager sharedSessionManager] registerObserver:self];
}

- (void)parseMessageData:(NSDictionary *)data
{
    NSString* messageType = [data objectForKey:@"messageType"];
    //得到推荐企业列表
    if([messageType isEqualToString:@"getSystemRecommendCompanysReply"] == YES)
    {
        NSMutableArray *companyList = [[NSMutableArray alloc] init];
        NSArray *tmpArr = [data objectForKey:@"companys"];
        for (int i=0; i < tmpArr.count; i++)
        {
            NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
            FDSCompany *company = [[FDSCompany alloc] init];
            company.m_comName = [tmpDic objectForKey:@"companyName"];
            company.m_comIcon = [tmpDic objectForKey:@"companyIcon"];
            company.m_comId = [tmpDic objectForKey:@"companyID"];
            [companyList addObject:company];
            [company release];
        }
        for(id<FDSCompanyMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(getSystemRecommendCompanysCB:)])
                [interface getSystemRecommendCompanysCB:companyList];
        }
        [companyList release];
    }
    else if([messageType isEqualToString:@"getCompanySencondTypeByFirstTypeReply"] == YES)
    {
        /*  根据企业一级分类得到二级分类  */
        NSMutableArray *typeList = [[NSMutableArray alloc] init];
        NSArray *tmpArr = [data objectForKey:@"types"];
        for (int i=0; i < tmpArr.count; i++)
        {
            NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
            FDSCompany *company = [[FDSCompany alloc] init];
            company.m_comName = [tmpDic objectForKey:@"typeName"];
            company.m_comIcon = [tmpDic objectForKey:@"typeIcon"];
            company.m_comId = [tmpDic objectForKey:@"typeID"];
            [typeList addObject:company];
            [company release];
        }
        for(id<FDSCompanyMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(getCompanySencondTypeByFirstTypeCB:)])
                [interface getCompanySencondTypeByFirstTypeCB:typeList];
        }
        [typeList release];
    }
    else if([messageType isEqualToString:@"getCompanyListReply"] == YES)
    {
        //获取公司列表
        NSMutableArray *companyList = [[NSMutableArray alloc] init];
        NSArray *tmpArr = [data objectForKey:@"companys"];
        for (int i=0; i < tmpArr.count; i++)
        {
            NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
            FDSCompany *company = [[FDSCompany alloc] init];
            company.m_comName = [tmpDic objectForKey:@"name"];
            company.m_comIcon = [tmpDic objectForKey:@"icon"];
            company.m_comState = [tmpDic objectForKey:@"state"];
            company.m_comId = [tmpDic objectForKey:@"companyID"];
            [companyList addObject:company];
            [company release];
        }
        for(id<FDSCompanyMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(getCompanyListCB:)])
                [interface getCompanyListCB:companyList];
        }
        [companyList release];
    }
    //获得企业的主页信息
    else if([messageType isEqualToString:@"getCompanyInfoReply"] == YES)
    {
        NSString *result = [data objectForKey:@"result"];
        FDSCompany *company = nil;
        if ([result isEqualToString:@"OK"])//”FAIL”,如果企业的权限不够，或者过来有效期，而返回FAIL。
        {
            company = [[FDSCompany alloc] init];
            company.m_comId = [data objectForKey:@"companyID"];
            company.m_customerServerID = [data objectForKey:@"customerServerID"];
            company.m_chatRoom = [data objectForKey:@"chatRoom"];
            company.m_companyNameZH = [data objectForKey:@"companyNameZH"];
            company.m_companyNamePin = [data objectForKey:@"companyNamePin"];
            company.m_companyImage = [data objectForKey:@"companyImage"];
            company.m_companyIcon = [data objectForKey:@"companyIcon"];
            company.m_briefInfo = [data objectForKey:@"briefInfo"];
            company.m_relation = [data objectForKey:@"relation"];
            company.m_calls = [data objectForKey:@"calls"];
            company.m_email = [data objectForKey:@"email"];
            company.m_fax = [data objectForKey:@"fax"];
            company.m_website = [data objectForKey:@"website"];
            company.m_address = [data objectForKey:@"address"];
            company.m_longitude = [data objectForKey:@"longitude"];
            company.m_latitude = [data objectForKey:@"latitude"];
            company.m_commentCount = [data objectForKey:@"commentCount"];
            company.m_sharedLink = [data objectForKey:@"sharedLink"];
            /* 默认都有下面几个 */
            company.m_products = YES;
            company.m_successfulcase = YES;
            company.m_designers = YES;

//            NSArray *tmpArr = [data objectForKey:@"modules"];
//            NSDictionary *tmpDic = nil;
//            company.m_modulesArr = [[[NSMutableArray alloc] init] autorelease];
//            for (int i=0; i < tmpArr.count; i++)
//            {
//                ModulesData module;
//                tmpDic = [tmpArr objectAtIndex:i];
//                module.m_moduleType = [tmpDic objectForKey:@"type"];
//                module.m_moduleCount = [tmpDic objectForKey:@"count"];
//                NSValue *value = [NSValue valueWithBytes:&module objCType:@encode(ModulesData)];
//                [company.m_modulesArr addObject:value];
//                
//                if([module.m_moduleType isEqualToString:@"products"]) //产品展示
//                {
//                    company.m_products = YES;
//                }
//                else if([module.m_moduleType isEqualToString:@"designers"])//成功案例
//                {
//                    company.m_successfulcase = YES;
//                }
//                else if([module.m_moduleType isEqualToString:@"successfulcase"])//设计师展示
//                {
//                    company.m_designers = YES;
//                }
//                else if([module.m_moduleType isEqualToString:@"news"])//新闻及活动
//                {
//                    company.m_news = YES;
//                }
//            }
            
            NSArray *tmpArr = [data objectForKey:@"bars"];
            company.m_barsArr = [[[NSMutableArray alloc] init] autorelease];
            for (int i=0; i < tmpArr.count; i++)
            {
                FDSPosBar *barInfo = [[FDSPosBar alloc] init];
                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                barInfo.m_barID = [tmpDic objectForKey:@"barID"];
                barInfo.m_barName = [tmpDic objectForKey:@"barName"];
                barInfo.m_barIcon = [tmpDic objectForKey:@"barIcon"];

                [company.m_barsArr addObject:barInfo];
                [barInfo release];
                
                company.m_composbar = YES;//存在企业吧
            }
        }
        for(id<FDSCompanyMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(getCompanyInfoCB:withCompanyInfo:)])
                [interface getCompanyInfoCB:result withCompanyInfo:company];
        }
        [company release];
    }
    //获取产品分类接口
    else if([messageType isEqualToString:@"getCompanyProductTypesReply"] == YES)
    {
        NSMutableArray *productList = [[NSMutableArray alloc] init];
        NSArray *tmpArr = [data objectForKey:@"companyTypes"];
        for (int i=0; i < tmpArr.count; i++)
        {
            NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
            FDSComProduct *product = [[FDSComProduct alloc] init];
            product.m_protypeID = [tmpDic objectForKey:@"typeID"];
            product.m_protypeName = [tmpDic objectForKey:@"typeName"];
            [productList addObject:product];
            [product release];
        }
        for(id<FDSCompanyMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(getCompanyProductTypesCB:)])
                [interface getCompanyProductTypesCB:productList];
        }
        [productList release];
    }
    //获取公司的产品列表
    else if([messageType isEqualToString:@"getCompanyProductListReply"] == YES)
    {
        NSMutableArray *productList = [[NSMutableArray alloc] init];
        NSArray *tmpArr = [data objectForKey:@"products"];
        NSString *condition = [data objectForKey:@"condition"];

        for (int i=0; i < tmpArr.count; i++)
        {
            NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
            FDSComProduct *product = [[FDSComProduct alloc] init];
            
            product.m_proName = [tmpDic objectForKey:@"name"];
            product.m_proIcon = [tmpDic objectForKey:@"icon"];
            product.m_productID = [tmpDic objectForKey:@"productID"];
            product.m_storeNumber = [tmpDic objectForKey:@"storeNumber"];
            product.m_briefInfo = [tmpDic objectForKey:@"briefInfo"];
            product.m_price = [tmpDic objectForKey:@"price"];
            product.m_browserNumber = [tmpDic objectForKey:@"browserNumber"];

            [productList addObject:product];
            [product release];
        }
        for(id<FDSCompanyMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(getCompanyProductListCB:withCondition:)])
                [interface getCompanyProductListCB:productList withCondition:condition];
        }
        [productList release];
    }
    //获得产品详情
    else if([messageType isEqualToString:@"getCompanyProductInfoReply"] == YES)
    {
        FDSComProduct *product = [[FDSComProduct alloc] init];
        
        product.m_proName = [data objectForKey:@"name"];
        product.m_price = [data objectForKey:@"price"];
        product.m_storeNumber = [data objectForKey:@"storeNumber"];
        product.m_saleNumber = [data objectForKey:@"saleNumber"];
        product.m_briefInfo = [data objectForKey:@"briefInfo"];  //简介
        product.m_sharedLink = [data objectForKey:@"sharedLink"];
        product.m_browserNumber = [data objectForKey:@"browserNumber"];
        product.m_postage = [data objectForKey:@"postage"];

        NSArray *tmpArr = [data objectForKey:@"images"];
        product.m_imagePathArr = [[[NSMutableArray alloc] init] autorelease];
        for (int i=0; i<tmpArr.count; i++)
        {
            [product.m_imagePathArr addObject:[tmpArr[i] objectForKey:@"imagePath"]];
        }
        for(id<FDSCompanyMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(getCompanyProductInfoCB:)])
                [interface getCompanyProductInfoCB:product];
        }
        [product release];
    }
    //获得公司案例列表
    else if([messageType isEqualToString:@"getCompanySuccessfulcaselistReply"] == YES)
    {
        NSMutableArray *comSucCaseList = [[NSMutableArray alloc] init];
        NSArray *tmpArr = [data objectForKey:@"successfulcases"];
        for (int i=0; i < tmpArr.count; i++)
        {
            NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
            FDSComSucCase *comsucCase = [[FDSComSucCase alloc] init];
            
            comsucCase.m_title = [tmpDic objectForKey:@"title"];
            comsucCase.m_introduce = [tmpDic objectForKey:@"introduce"];
            comsucCase.m_successfulcaseID = [tmpDic objectForKey:@"successfulcaseID"];
            
            comsucCase.m_imagePathArr = [[[NSMutableArray alloc]init] autorelease];
            NSArray *secArr = [tmpDic objectForKey:@"images"];
            for (int i=0; i<secArr.count; i++)
            {
                [comsucCase.m_imagePathArr addObject:[secArr[i] objectForKey:@"URL"]];
            }
            [comSucCaseList addObject:comsucCase];
            [comsucCase release];
        }
        for(id<FDSCompanyMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(getCompanySuccessfulcaselistCB:)])
                [interface getCompanySuccessfulcaselistCB:comSucCaseList];
        }
        [comSucCaseList release];
    }
    else if([messageType isEqualToString:@"getSuccessfulcaseInfoReply"] == YES)
    {
        /*   得到案例详情   */
        FDSComSucCase *sucInfo = [[FDSComSucCase alloc] init];
        sucInfo.m_title = [data objectForKey:@"title"];
        sucInfo.m_introduce = [data objectForKey:@"introduce"];
        sucInfo.m_browserNumber = [data objectForKey:@"browserNumber"];
        sucInfo.m_sharedLink = [data objectForKey:@"sharedLink"];
        sucInfo.m_imagePathArr = [[[NSMutableArray alloc]init] autorelease];
        NSArray *secArr = [data objectForKey:@"images"];
        for (int i=0; i<secArr.count; i++)
        {
            [sucInfo.m_imagePathArr addObject:[secArr[i] objectForKey:@"URL"]];
        }

        for(id<FDSCompanyMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(getSuccessfulcaseInfoCB:)])
                [interface getSuccessfulcaseInfoCB:sucInfo];
        }
        [sucInfo release];
    }
    else if([messageType isEqualToString:@"getCompanyDesignersReply"] == YES)
    {
        NSMutableArray *designersList = [[NSMutableArray alloc] init];
        NSArray *tmpArr = [data objectForKey:@"designers"];
        for (int i=0; i < tmpArr.count; i++)
        {
            NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
            FDSComDesigner *designer = [[FDSComDesigner alloc] init];
            
            designer.m_name = [tmpDic objectForKey:@"name"];
            designer.m_designerID = [tmpDic objectForKey:@"designerID"];
            designer.m_icon = [tmpDic objectForKey:@"icon"];
            designer.m_job = [tmpDic objectForKey:@"job"];
            if ([@"YES" isEqualToString:[tmpDic objectForKey:@"isPlatUser"]])
            {
                designer.m_isPlatUser = YES;
            }
            else
            {
                designer.m_isPlatUser = NO;
            }
            designer.m_userID = [tmpDic objectForKey:@"userID"];
            
            [designersList addObject:designer];
            [designer release];
        }

        for(id<FDSCompanyMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(getCompanyDesignersCB:)])
                [interface getCompanyDesignersCB:designersList];
        }
        [designersList release];
    }
    else if([messageType isEqualToString:@"getDesignerInfoReply"] == YES)
    {
        FDSComDesigner *designer = [[FDSComDesigner alloc] init];
        
        designer.m_name = [data objectForKey:@"name"];
        designer.m_icon = [data objectForKey:@"icon"];
        designer.m_comsex = [data objectForKey:@"sex"];
        if ([@"YES" isEqualToString:[data objectForKey:@"isPlatUser"]])
        {
            designer.m_isPlatUser = YES;
        }
        else
        {
            designer.m_isPlatUser = NO;
        }
        designer.m_userID = [data objectForKey:@"userID"];
        designer.m_companyName = [data objectForKey:@"companyName"];
        designer.m_job = [data objectForKey:@"job"];
        designer.m_introduce = [data objectForKey:@"introduce"];  //简介
        designer.m_sharedLink = [data objectForKey:@"sharedLink"];

        for(id<FDSCompanyMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(getDesignerInfoCB:)])
                [interface getDesignerInfoCB:designer];
        }
        [designer release];
    }
    else if([messageType isEqualToString:@"getCompanyCommentListReply"] == YES)
    {
        NSMutableArray *commentList = [[NSMutableArray alloc] init];
        FDSComment *comment = nil;
        NSArray *tmpArr = [data objectForKey:@"comments"];
        for (int i=0; i<tmpArr.count; i++)
        {
            NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
            comment = [[FDSComment alloc] init];
            comment.m_commentID = [tmpDic objectForKey:@"commentID"];
            
            comment.m_content = [tmpDic objectForKey:@"content"];
            comment.m_senderID = [tmpDic objectForKey:@"senderID"];
            comment.m_senderIcon = [tmpDic objectForKey:@"senderIcon"];
            comment.m_senderName = [tmpDic objectForKey:@"senderName"];
            comment.m_sendTime = [tmpDic objectForKey:@"sendTime"];
            
            comment.m_images = [[[NSMutableArray alloc] init] autorelease];
            NSArray *urlArr = [tmpDic objectForKey:@"images"];
            for (int j=0; j<urlArr.count; j++)
            {
                NSDictionary *urlDic = [urlArr objectAtIndex:j];
                [comment.m_images addObject:[urlDic objectForKey:@"URL"]];
            }
            
            comment.m_revertCount = [[tmpDic objectForKey:@"revertCount"] integerValue];
            
            comment.m_revertsList = [[[NSMutableArray alloc] init] autorelease];
            NSArray *revertsArr = [tmpDic objectForKey:@"reverts"];
            FDSRevert *revert = nil;
            for (int ii=0; ii<revertsArr.count; ii++)
            {
                NSDictionary *revertDic = [revertsArr objectAtIndex:ii];
                revert = [[FDSRevert alloc] init];
                
                revert.m_revertID = [revertDic objectForKey:@"revertID"];
                revert.m_senderID = [revertDic objectForKey:@"senderID"];
                revert.m_senderName = [revertDic objectForKey:@"senderName"];
                revert.m_senderIcon = [revertDic objectForKey:@"senderIcon"];
                revert.m_sendTime = [revertDic objectForKey:@"sendTime"];
                revert.m_content = [revertDic objectForKey:@"content"];
                [comment.m_revertsList addObject:revert];
                [revert release];
                if (ii > 0)  //主列表最多只显示两条数据
                {
                    break;
                }
            }
            
            [commentList addObject:comment];
            [comment release];
        }
        
        for (id<FDSCompanyMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(getCompanyCommentListCB:)])
                [interface getCompanyCommentListCB:commentList];
        }
        [commentList release];
    }
    else if([messageType isEqualToString:@"companyCommentReply"] == YES)
    {
        NSString *result = [data objectForKey:@"result"];
        NSString *commentID = [data objectForKey:@"commentID"];
        for(id<FDSCompanyMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(companyCommentCB::)])
                [interface companyCommentCB:result :commentID];
        }
    }
    else if([messageType isEqualToString:@"getCompanyCommentRevertListReply"] == YES)
    {
        NSMutableArray *revertList = [[NSMutableArray alloc] init];
        FDSRevert *revert = nil;
        NSArray *tmpArr = [data objectForKey:@"reverts"];
        for (int i=0; i<tmpArr.count; i++)
        {
            NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
            revert = [[FDSRevert alloc] init];
            revert.m_revertID = [tmpDic objectForKey:@"revertID"];
            revert.m_senderID = [tmpDic objectForKey:@"senderID"];
            revert.m_senderName = [tmpDic objectForKey:@"senderName"];
            revert.m_senderIcon = [tmpDic objectForKey:@"senderIcon"];
            revert.m_sendTime = [tmpDic objectForKey:@"sendTime"];
            revert.m_content = [tmpDic objectForKey:@"content"];
            
            [revertList addObject:revert];
            [revert release];
        }
        for(id<FDSCompanyMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(getCompanyCommentRevertListCB:)])
                [interface getCompanyCommentRevertListCB:revertList];
        }
        [revertList release];
    }
    else if([messageType isEqualToString:@"deleteCompanyCommentRevertReply"] == YES)
    {
        NSString *result = [data objectForKey:@"result"];
        for(id<FDSCompanyMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(deleteCompanyCommentRevertCB:)])
                [interface deleteCompanyCommentRevertCB:result];
        }
    }
    else if([messageType isEqualToString:@"joinGroupReply"] == YES)
    {
        NSString *result = [data objectForKey:@"result"];
        NSString *reason = [data objectForKey:@"reason"];
        for(id<FDSCompanyMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(joinGroupCB::)])
                [interface joinGroupCB:result :reason];
        }
    }
    else if([messageType isEqualToString:@"quitGroupReply"] == YES)
    {
        NSString *result = [data objectForKey:@"result"];
        for(id<FDSCompanyMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(quitGroupCB:)])
                [interface quitGroupCB:result];
        }
    }
    else if([messageType isEqualToString:@"getSystemHotWordsReply"] == YES)
    {
        NSMutableArray *words = [NSMutableArray arrayWithCapacity:1];
        NSArray *tmpArr = [data objectForKey:@"words"];
        for (int i=0; i<tmpArr.count; i++)
        {
            NSDictionary *dic = [tmpArr objectAtIndex:i];
            [words addObject:[dic objectForKey:@"word"]];
        }
        for(id<FDSCompanyMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(getSystemHotWordsCB:)])
                [interface getSystemHotWordsCB:words];
        }
    }
    else if([messageType isEqualToString:@"getHomePageRecommendedsReply"] == YES)
    {
        /*   获取首页的推荐  */
        NSMutableArray *recommandList = [NSMutableArray arrayWithCapacity:1];
        NSArray *tmpArr = [data objectForKey:@"recommends"];
        FDSBarPostInfo *postInfo = nil;
        for (int i=0; i<tmpArr.count; i++)
        {
            postInfo = [[FDSBarPostInfo alloc] init];
            NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
            
            postInfo.m_postID = [tmpDic objectForKey:@"contentID"];
            postInfo.m_title = [tmpDic objectForKey:@"title"];
            postInfo.m_senderName = [tmpDic objectForKey:@"organizationName"];
            postInfo.m_postType = [tmpDic objectForKey:@"contentType"];//”post”,”product”,”designer”
            postInfo.m_images = [[[NSMutableArray alloc] init]autorelease];
            [postInfo.m_images addObject:[tmpDic objectForKey:@"image"]];
            
            [recommandList addObject:postInfo];
            [postInfo release];
        }
        for(id<FDSCompanyMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(getHomePageRecommendedsCB:)])
                [interface getHomePageRecommendedsCB:recommandList];
        }
    }
}

- (void)sendMessage:(NSMutableDictionary *)message
{
    [message setObject:FDSCompanyMessageClass forKey:@"messageClass"];
    [super sendMessage:message];
}

- (void)registerObserver:(id<FDSCompanyMessageInterface>)observer
{
    if ([self.observerArray containsObject:observer] == NO)
    {
        // [observer retain];
        [self.observerArray addObject:observer];
    }
}

- (void)unRegisterObserver:(id<FDSCompanyMessageInterface>)observer
{
    if ([self.observerArray containsObject:observer]) {
        [self.observerArray removeObject:observer];
    }
}

/*  根据企业一级分类得到二级分类  */
- (void)getCompanySencondTypeByFirstType :(NSString*)firstTypeID
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getCompanySencondTypeByFirstType" forKey:@"messageType"];
    [dic setObject:firstTypeID forKey:@"firstTypeID"];

    [self sendMessage:dic];
}

//********得到推荐企业***********
- (void)getSystemRecommendCompanys
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getSystemRecommendCompanys" forKey:@"messageType"];
    [self sendMessage:dic];
}

//********获取企业列表接口***********
- (void)getCompanyList:(NSString*)getWay :(NSString*)condition
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getCompanyList" forKey:@"messageType"];
    [dic setObject:getWay forKey:@"getWay"];
    [dic setObject:condition forKey:@"condition"];
    [self sendMessage:dic];
}

//********获取企业详细接口***********
- (void)getCompanyInfo:(NSString*)comId
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getCompanyInfo" forKey:@"messageType"];
    [dic setObject:comId forKey:@"companyID"];
    NSString *userID = [[FDSUserManager sharedManager] getNowUser].m_userID;
    if (userID && userID.length>0)
    {
        [dic setObject:userID forKey:@"userID"];
    }
    else
    {
        [dic setObject:@"" forKey:@"userID"];
    }
    [self sendMessage:dic];
}

//********获取产品分类接口***********
- (void)getCompanyProductTypes:(NSString*)userId withComId:(NSString*)comId
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getCompanyProductTypes" forKey:@"messageType"];
    [dic setObject:comId forKey:@"companyID"];
    [dic setObject:userId forKey:@"userID"];
    [self sendMessage:dic];
}

//********获取公司的产品列表***********
- (void)getCompanyProductList:(NSString*)userId withComId:(NSString*)comId withWay:(NSString*)way withCondition:(NSString*)condition
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getCompanyProductList" forKey:@"messageType"];
    [dic setObject:comId forKey:@"companyID"];
    [dic setObject:userId forKey:@"userID"];
    [dic setObject:way forKey:@"getWay"];
    [dic setObject:condition forKey:@"condition"];
    [self sendMessage:dic];
}

//********得到产品详情***********
- (void)getCompanyProductInfo:(NSString*)userId withComId:(NSString*)comId withProductId:(NSString*)productID
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getCompanyProductInfo" forKey:@"messageType"];
    [dic setObject:comId forKey:@"companyID"];
    [dic setObject:userId forKey:@"userID"];
    [dic setObject:productID forKey:@"productID"];
    [self sendMessage:dic];
}

//********得到公司案例列表***********
//way:”all”:表示得到所有的，condition就传companyID  而key则表示来按照关键字来进行搜索。
- (void)getCompanySuccessfulcaselist:(NSString*)way withCondition:(NSString*)condition
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getCompanySuccessfulcaselist" forKey:@"messageType"];
    [dic setObject:way forKey:@"getWay"];
    [dic setObject:condition forKey:@"condition"];
    [self sendMessage:dic];
}

- (void)getSuccessfulcaseInfo:(NSString*)successfulcaseID
{
    /*   得到案例详情   */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getSuccessfulcaseInfo" forKey:@"messageType"];
    [dic setObject:successfulcaseID forKey:@"successfulcaseID"];
    [self sendMessage:dic];
}

//********得到公司设计师***********
//way:”all”:表示得到所有的，condition就传companyID  而key则表示来按照关键字来进行搜索。
- (void)getCompanyDesigners:(NSString*)way withCondition:(NSString*)condition
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getCompanyDesigners" forKey:@"messageType"];
    [dic setObject:way forKey:@"getWay"];
    [dic setObject:condition forKey:@"condition"];
    [self sendMessage:dic];
}

//******** 得到设计师信息***********
- (void)getDesignerInfo:(NSString*)designerID
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getDesignerInfo" forKey:@"messageType"];
    [dic setObject:designerID forKey:@"designerID"];
    [self sendMessage:dic];
}

/*      包括企业，产品，案例，设计师的评论获取    */
- (void)getCompanyCommentList:(NSString*)commentObjectID :(NSString*)commentObjectType :(NSString*)commentID :(NSString*)getWay :(NSInteger)count
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getCompanyCommentList" forKey:@"messageType"];
    [dic setObject:@"" forKey:@"userID"];
    [dic setObject:commentObjectType forKey:@"commentObjectType"];
    [dic setObject:commentObjectID forKey:@"commentObjectID"];
    [dic setObject:commentID forKey:@"commentID"];
    [dic setObject:getWay forKey:@"getWay"];
    [dic setObject:[NSString stringWithFormat:@"%d",count] forKey:@"count"];

    [self sendMessage:dic];
}


/*  发表企业评论，回复  */
- (void)companyComment:(NSString*)commentObjectType :(NSString*)commentContentType :(NSString*)commentObjectID :(NSString*)commentID :(NSString*)content :(NSMutableArray*)images
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"companyComment" forKey:@"messageType"];
    [dic setObject:commentObjectType forKey:@"commentObjectType"];
    [dic setObject:commentContentType forKey:@"commentContentType"];
    [dic setObject:commentObjectID forKey:@"commentObjectID"];
    [dic setObject:commentID forKey:@"commentID"];
    
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    [dic setObject:content forKey:@"content"];
    if (images && images.count > 0)
    {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:5];
        for (int i=0; i<images.count; i++)
        {
            NSDictionary *dic = [NSDictionary dictionaryWithObject:[images objectAtIndex:i] forKey:@"URL"];
            [arr addObject:dic];
        }
        [dic setObject:arr forKey:@"images"];
    }

    [self sendMessage:dic];
}

/*   得到评论的回复列表  */
- (void)getCompanyCommentRevertList:(NSString*)commentID :(NSString*)revertID :(NSString*)getWay :(NSInteger)count
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getCompanyCommentRevertList" forKey:@"messageType"];
    [dic setObject:commentID forKey:@"commentID"];
    [dic setObject:revertID forKey:@"revertID"];
    [dic setObject:getWay forKey:@"getWay"];
    [dic setObject:[NSString stringWithFormat:@"%d",count] forKey:@"count"];//客户端本次希望获得的评论条数
    
    [self sendMessage:dic];
}

/*   删除企业评论，回复  */
- (void)deleteCompanyCommentRevert:(NSString*)commentObjectID :(NSString*)type :(NSString*)objectID
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"deleteCompanyCommentRevert" forKey:@"messageType"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    [dic setObject:commentObjectID forKey:@"commentObjectID"];
    [dic setObject:type forKey:@"type"];
    [dic setObject:objectID forKey:@"id"];
    
    [self sendMessage:dic];
}

/*  加入群  */
- (void)joinGroup:(NSString*)groupType :(NSString*)groupID
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"joinGroup" forKey:@"messageType"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    [dic setObject:groupType forKey:@"groupType"];
    [dic setObject:groupID forKey:@"groupID"];
    
    [self sendMessage:dic];
}

/*  退出群  */
- (void)quitGroup:(NSString*)groupType :(NSString*)groupID
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"quitGroup" forKey:@"messageType"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    [dic setObject:groupType forKey:@"groupType"];
    [dic setObject:groupID forKey:@"groupID"];
    
    [self sendMessage:dic];
}

/*  得到系统搜索热词  */
- (void)getSystemHotWords:(NSString*)type
{
    /*  type为“company” ”product”,”designer”,”sucessfullcase */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getSystemHotWords" forKey:@"messageType"];
    [dic setObject:type forKey:@"type"];
    
    [self sendMessage:dic];
}

/*   获取首页的推荐  */
- (void)getHomePageRecommendeds
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getHomePageRecommendeds" forKey:@"messageType"];
    
    [self sendMessage:dic];
}

@end

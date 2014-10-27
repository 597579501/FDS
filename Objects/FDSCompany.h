//
//  FDSCompany.h
//  FDS
//
//  Created by zhuozhongkeji on 14-1-11.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct{
    NSString   *m_moduleType; //type:products,successfulcase,designers,news
    NSString   *m_moduleCount;
}ModulesData;

typedef struct{
    NSString   *m_barID;
    NSString   *m_barName;
    NSString   *m_barIcon;
}BarsData;

@interface FDSCompany : NSObject

@property(nonatomic,retain) NSString  *m_comName;
@property(nonatomic,retain) NSString  *m_comIcon;
@property(nonatomic,retain) NSString  *m_comState;
@property(nonatomic,retain) NSString  *m_comId;

@property(nonatomic,retain) NSString  *m_chatRoom;//”YES”表示存在，”NO”表示不存在。
@property(nonatomic,retain) NSString  *m_customerServerID;//在线客服，为空则没有
@property(nonatomic,retain) NSString  *m_companyNameZH;
@property(nonatomic,retain) NSString  *m_companyNamePin;//企业名称拼音
@property(nonatomic,retain) NSString  *m_companyImage;  //企业的形象图
@property(nonatomic,retain) NSString  *m_companyIcon;   //企业的logo
@property(nonatomic,retain) NSString  *m_briefInfo;     //企业的简介
//个人和企业之间的关系 ”nouser”表示没有登录，”no”:表示没有加入;”member”,”admin”,”superadmin”,”salesman”;
@property(nonatomic,retain) NSString  *m_relation;

@property(nonatomic,retain) NSString  *m_calls;
@property(nonatomic,retain) NSString  *m_email;
@property(nonatomic,retain) NSString  *m_fax;
@property(nonatomic,retain) NSString  *m_website;
@property(nonatomic,retain) NSString  *m_address;
@property(nonatomic,retain) NSString  *m_longitude; //经度 纬度
@property(nonatomic,retain) NSString  *m_latitude;
@property(nonatomic,retain) NSString  *m_commentCount;

@property(nonatomic,retain) NSMutableArray   *m_modulesArr;  //更多内容
@property(nonatomic,retain) NSMutableArray   *m_barsArr;     //更多贴吧

@property(nonatomic,assign) BOOL   m_products;           //是否有产品展示
@property(nonatomic,assign) BOOL   m_successfulcase;     //是否有成功案例
@property(nonatomic,assign) BOOL   m_designers;          //是否有设计师展示
@property(nonatomic,assign) BOOL   m_news;               //是否有新闻及活动

@property(nonatomic,assign) BOOL   m_composbar;         //是否有企业吧
@property(nonatomic,assign) BOOL   m_innerbar;          //是否有内部人员吧

@property(nonatomic,retain) NSString  *m_sharedLink;     //企业的分享

@property(nonatomic,retain) NSString  *m_memberNumber; //成员数目

@end

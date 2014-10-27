//
//  FDSComDesigner.h
//  FDS
//
//  Created by zhuozhongkeji on 14-1-20.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDSComDesigner : NSObject

@property(nonatomic,retain) NSString         *m_name;                 //设计师name
@property(nonatomic,retain) NSString         *m_designerID;           //设计师ID
@property(nonatomic,retain) NSString         *m_successfulcaseID;     //设计师ID
@property(nonatomic,retain) NSString         *m_icon;                 //设计师icon
@property(nonatomic,retain) NSString         *m_job;                  //设计师job
@property(nonatomic,assign) BOOL             m_isPlatUser;           //设计师isPlatUser ”YES”,”NO”
@property(nonatomic,retain) NSString         *m_userID;               //设计师userID
@property(nonatomic,retain) NSString         *m_comsex;               //设计师sex
@property(nonatomic,retain) NSString         *m_companyName;          //设计师companyName
@property(nonatomic,retain) NSString         *m_introduce;            //设计师introduce
@property(nonatomic,retain) NSString         *m_sharedLink;            //设计师introduce

@property(nonatomic,retain) NSMutableArray   *designList;
@property(nonatomic,assign) NSInteger        m_index;
@property(nonatomic,retain) NSString         *m_phone;            //设计师phone


@end
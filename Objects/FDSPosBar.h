//
//  FDSPosBar.h
//  FDS
//
//  Created by zhuozhong on 14-2-28.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDSPosBar : NSObject

@property(nonatomic,retain)NSString    *m_barTypeName;
@property(nonatomic,retain)NSString    *m_barTypeID;
@property(nonatomic,retain)NSString    *m_barTypeIcon;

@property(nonatomic,retain)NSString    *m_barName;
@property(nonatomic,retain)NSString    *m_barID;
@property(nonatomic,retain)NSString    *m_barIcon;
@property(nonatomic,retain)NSString    *m_joinedNumber;
@property(nonatomic,retain)NSString    *m_postNumber;
@property(nonatomic,retain)NSString    *m_introduce;

@property(nonatomic,retain)NSString    *m_relation;  //”no”,”member”,”salesman”,”superadmin”,”admin”
@property(nonatomic,retain)NSString    *m_companyID; //如果是企业吧，companyID将为公司ID，不是则为空

@end

//
//  FDSComSucCase.h
//  FDS
//
//  Created by zhuozhongkeji on 14-1-20.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDSComSucCase : NSObject

@property(nonatomic,retain) NSString  *m_title;               //案例title
@property(nonatomic,retain) NSString  *m_introduce;           //案例introduce
@property(nonatomic,retain) NSString  *m_successfulcaseID;    //公司案例ID
@property(nonatomic,retain) NSMutableArray   *m_imagePathArr; //公司案例图片URL列表
@property(nonatomic,retain) NSString  *m_sharedLink;          //案例分享链接
@property(nonatomic,retain) NSString  *m_browserNumber;       //案例浏览次数

@end

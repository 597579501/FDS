//
//  FDSCollectedInfo.h
//  FDS
//
//  Created by saibaqiao on 14-3-6.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

/*  收藏类型  */
enum FDS_COLLECTED_MESSAGE_TYPE
{
    FDS_COLLECTED_MESSAGE_NONE,
    FDS_COLLECTED_MESSAGE_POSTBAR, // 帖子收藏
    FDS_COLLECTED_MESSAGE_COMPANY, // 企业收藏
    FDS_COLLECTED_MESSAGE_SUCCASE, // 案例收藏
    FDS_COLLECTED_MESSAGE_PRODUCT, // 产品收藏
    FDS_COLLECTED_MESSAGE_DESIGNER,// 设计师收藏
    FDS_COLLECTED_MESSAGE_MAX
};

@interface FDSCollectedInfo : NSObject

@property(nonatomic,assign)NSInteger                            m_id;
@property(nonatomic,assign)enum FDS_COLLECTED_MESSAGE_TYPE      m_collectType;

@property(nonatomic,retain)NSString                             *m_collectTitle;
@property(nonatomic,retain)NSString                             *m_collectTime;
@property(nonatomic,retain)NSString                             *m_collectIcon;
@property(nonatomic,retain)NSString                             *m_collectID;

@property(nonatomic,retain)NSMutableArray                       *m_collectList;
@property(nonatomic,retain)NSString                             *m_typeTitle;
@property(nonatomic,retain)NSString                             *m_typeIcon;  //type Icon

@end

//
//  FDSRevert.h
//  FDS
//
//  Created by zhuozhong on 14-2-24.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDSRevert : NSObject

@property(nonatomic,retain)NSString          *m_revertID;
@property(nonatomic,retain)NSString          *m_senderID;
@property(nonatomic,retain)NSString          *m_senderName;
@property(nonatomic,retain)NSString          *m_senderIcon;
@property(nonatomic,retain)NSString          *m_sendTime;
@property(nonatomic,retain)NSString          *m_content;
@property(nonatomic,retain)NSString          *m_reveredName;

@end

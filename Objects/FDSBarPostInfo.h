//
//  FDSBarPostInfo.h
//  FDS
//
//  Created by zhuozhong on 14-2-28.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDSBarPostInfo : NSObject

@property(nonatomic,assign)BOOL              m_isCollect; //帖子是否收藏
@property(nonatomic,retain)NSString          *m_postType;
@property(nonatomic,retain)NSString          *m_title;
@property(nonatomic,retain)NSString          *m_contentType;//”html”则content为html代码，”text”;
@property(nonatomic,retain)NSString          *m_content;
@property(nonatomic,retain)NSString          *m_postID;
@property(nonatomic,retain)NSString          *m_senderName;
@property(nonatomic,retain)NSString          *m_senderID;
@property(nonatomic,retain)NSString          *m_senderIcon;
@property(nonatomic,retain)NSString          *m_sendTime;
@property(nonatomic,retain)NSString          *m_commentNumber;
@property(nonatomic,retain)NSMutableArray    *m_images;

@property(nonatomic,retain)NSString          *m_url; //用于分享帖子的URL

@property(nonatomic,assign)BOOL              m_sucPostList;  //是否成功获取过对应的贴吧列表
@property(nonatomic,assign)BOOL              m_showMoreData; //是否还能显示更多数据
@property(nonatomic,retain)NSMutableArray    *m_barPostList; //对应类型数据列表

@end

//
//  ArticleData.h
//  MacelInternet
//
//  Created by zhuozhongkeji on 13-12-30.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, KArticleDataType)//article样式类型
{
    ArticleEliteDyn = 0,       //精华
    ArticleHotDyn = 1,         //热门
    ArticleNewDyn = 2,         //最新
    ArticleFriendDyn = 3,      //好友
    ArticleMyDyn = 4,          //我的动态
    ArticleMyCollect = 5,      //我的收藏
};


@interface ArticleData : NSObject

@property(nonatomic,retain)NSString*       article_id;          //帖子_ID
@property(nonatomic,assign)NSInteger       article_type;        //帖子类型	精华、热门、最新、好友动态、我的动态、我的收藏
@property(nonatomic,retain)NSString*       sender_id;           //发帖人的ID
@property(nonatomic,retain)NSString*       account_id;          //当前帐户id
@property(nonatomic,retain)NSString*       sender_name;         //发帖人的名称
@property(nonatomic,retain)NSString*       sender_headurl;      //发帖人的头像地址
@property(nonatomic,retain)NSString*       article_content;     //帖子的内容
@property(nonatomic,retain)NSString*       allImgJson;
@property(nonatomic,retain)NSMutableArray* articleImgs;         //帖子图片
@property(nonatomic,retain)NSMutableArray* articleThumbnails;   //帖子图片Url
@property(nonatomic,assign)CGFloat          thumb_W;            //一张图片的宽
@property(nonatomic,assign)CGFloat          thumb_H;            //高
@property(nonatomic,retain)NSString*       article_time;        //发帖的时间
@property(nonatomic,retain)NSString*       article_praiseNum;	//帖子的赞
@property(nonatomic,retain)NSString*       article_commentNum;	//帖子的评论数
@property(nonatomic,assign)BOOL            isMePraised;         //是否赞过（自己）
@property(nonatomic,assign)BOOL            isMeCollect;         //是否收藏(自己)

@end

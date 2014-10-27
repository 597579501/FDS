//
//  FDSBarMessageManager.h
//  FDS
//
//  Created by zhuozhong on 13-12-3.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "ZZMessageManager.h"
#import "FDSBarMessageInterface.h"
#import "FDSPosBar.h"
#import "FDSBarPostInfo.h"
#import "ZZSessionManager.h"

@interface FDSBarMessageManager : ZZMessageManager

+ (FDSBarMessageManager*)sharedManager;

- (void)registerObserver:(id<FDSBarMessageInterface>)observer;
- (void)unRegisterObserver:(id<FDSBarMessageInterface>)observer;

/*  得到贴吧的一级分类  */
- (void)getBarFirstType;

/*  根据贴吧分类得到贴吧列表  */
- (void)getBarByBarTypeID:(NSString*)barTypeID :(NSString*)getWay :(NSString*)barID :(NSInteger)count;

/*  得到一个贴吧信息  */
- (void)getBarInfo:(NSString*)barID;

/*  得到一个贴吧的帖子列表  */
- (void)getBarPostList:(NSString*)barID :(NSString*)getWay :(NSString*)postID :(NSInteger)count :(NSString*)postType;

/*  得到一个帖子  */
- (void)getPost:(NSString*)postID;

/*  得到一个帖子的评论  */
- (void)getPostComment:(NSString*)postID :(NSString*)getWay :(NSString*)commentID :(NSInteger)count;

/*  发表帖子  */
- (void)sendPost:(NSString*)barID :(NSString*)title :(NSString*)content :(NSMutableArray*)images :(NSString*)postType;

/*  发表帖子评论、回复  */
- (void)sendPostComment:(NSString*)commentContentType :(NSString*)postID :(NSString*)commentID :(NSString*)content :(NSMutableArray*)images;

/* 得到帖子评论的回复 */
- (void)getPostCommentRevert:(NSString*)commentID :(NSString*)getWay :(NSString*)revertID :(NSInteger)count;

/* 得到最热帖子 */
- (void)getHotPost;

/* 删除帖子，评论，回复 */
- (void)deletePostCommentRevert:(NSString*)commentObjectID :(NSString*)type :(NSString*)objectID;

/*  得到贴吧(现在仅仅用于贴吧搜索)  */
- (void)getBars:(NSString*)key :(NSString*)keyword :(NSString*)getWay :(NSString*)barID :(NSInteger)count;

@end

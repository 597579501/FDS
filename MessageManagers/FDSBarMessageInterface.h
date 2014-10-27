//
//  FDSBarMessageInterface.h
//  FDS
//
//  Created by zhuozhong on 13-12-3.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDSPosBar.h"
#import "FDSBarPostInfo.h"

@protocol FDSBarMessageInterface <NSObject>

@optional

- (void)getBarFirstTypeCB:(NSMutableArray*)posBarList;
- (void)getBarByBarTypeIDCB:(NSMutableArray*)posBarArr;
- (void)getBarInfoCB:(FDSPosBar*)posBarInfo;
- (void)getBarPostListCB:(NSMutableArray*)barPostList :(NSString*)postType;
- (void)getPostCB:(FDSBarPostInfo*)posBarInfo;

/*  得到一个帖子的评论  */
- (void)getPostCommentCB:(NSMutableArray*)commentList;

/*  发表帖子  */
- (void)sendPostCB:(NSString*)result :(NSString*)postID;

/*  发表帖子评论、回复  */
- (void)sendPostCommentCB:(NSString*)result :(NSString*)commentID;

/* 得到帖子评论的回复 */
- (void)getPostCommentRevertCB:(NSMutableArray*)postCommentRevertList;

/* 得到最热帖子 */
- (void)getHotPostCB:(NSMutableArray*)posBarArr;

/* 删除帖子，评论，回复 */
- (void)deletePostCommentRevertCB:(NSString*)result;

/*  得到贴吧(现在仅仅用于贴吧搜索)  */
- (void)getBarsCB:(NSMutableArray*)barsList;


@end

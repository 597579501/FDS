//
//  ArticleData.m
//  MacelInternet
//
//  Created by zhuozhongkeji on 13-12-30.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "ArticleData.h"
//#import "NSDictionaryAdditions.h"
//#import "NSObject+SBJSON.h"
//#import "AppUtils.h"
//#import "ModelManager.h"

@implementation ArticleData

- (id)init//:(NSDictionary*)dic
{    
    if(self = [super init])
    {
        _articleImgs = [[NSMutableArray alloc] initWithCapacity:0];
        _articleThumbnails = [[NSMutableArray alloc] initWithCapacity:0];
//        [_articleThumbnails addObject:[UIImage imageNamed:@"headphoto_s"]];
//        [_articleThumbnails addObject:[UIImage imageNamed:@"headphoto_s"]];
//        [_articleThumbnails addObject:[UIImage imageNamed:@"headphoto_s"]];
//        [_articleThumbnails addObject:[UIImage imageNamed:@"headphoto_s"]];
//        [_articleThumbnails addObject:[UIImage imageNamed:@"headphoto_s"]];
//        [_articleThumbnails addObject:[UIImage imageNamed:@"headphoto_s"]];
    }
    return self;
}

- (void)dealloc
{
    self.article_time = nil;        //发帖的时间
    self.article_praiseNum = nil;	//帖子的赞
    self.article_commentNum = nil;	//帖子的评论数

    self.article_id = nil;          //帖子_ID
    self.sender_id = nil;           //发帖人的ID
    self.account_id = nil;          //当前帐户id
    self.sender_name = nil;         //发帖人的名称
    self.sender_headurl = nil;      //发帖人的头像地址
    self.article_content = nil;     //帖子的内容
    self.allImgJson = nil;

    [_articleImgs release];
    [_articleThumbnails release];
    [super dealloc];
}

@end

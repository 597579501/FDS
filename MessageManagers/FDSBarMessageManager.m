//
//  FDSBarMessageManager.m
//  FDS
//
//  Created by zhuozhong on 13-12-3.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "FDSBarMessageManager.h"
#import "FDSUserManager.h"
#import "FDSComment.h"
#import "FDSRevert.h"
#import "FDSPublicManage.h"

#define FDSBarMessageClass  @"postbarMessageManager"


@implementation FDSBarMessageManager

static FDSBarMessageManager *instance = nil;

+ (FDSBarMessageManager*)sharedManager
{
    if(nil == instance)
    {
        instance = [FDSBarMessageManager alloc ];
        [instance initManager];
    }
    return instance;
}

- (void)initManager
{
    self.observerArray = [[[NSMutableArray alloc]initWithCapacity:0] autorelease];
    [self registerMessageManager:self :FDSBarMessageClass];
    [[ZZSessionManager sharedSessionManager] registerObserver:self];
}

- (void)registerObserver:(id<FDSBarMessageInterface>)observer
{
    if ([self.observerArray containsObject:observer] == NO)
    {
        // [observer retain];
        [self.observerArray addObject:observer];
    }
}

- (void)unRegisterObserver:(id<FDSBarMessageInterface>)observer
{
    if ([self.observerArray containsObject:observer])
    {
        [self.observerArray removeObject:observer];
    }
}


- (void)sendMessage:(NSMutableDictionary *)message
{
    [message setObject:FDSBarMessageClass forKey:@"messageClass"];
    [super sendMessage:message];
}

- (void)parseMessageData:(NSDictionary *)data
{
    NSString* messageType = [data objectForKey:@"messageType"];
    if ([messageType isEqualToString:@"getBarFirstTypeReply"] == YES)
    {
        /* 得到贴吧的一级分类 */
        NSMutableArray *posBarList = [[NSMutableArray alloc] init];
        FDSPosBar *bar = nil;
        NSArray *array = [data objectForKey:@"barFirstTypes"];
        for (int i=0; i<array.count; i++)
        {
            NSDictionary *tmpDic = [array objectAtIndex:i];
            bar = [[FDSPosBar alloc] init];
            bar.m_barTypeName = [tmpDic objectForKey:@"barTypeName"];
            bar.m_barTypeID = [tmpDic objectForKey:@"barTypeID"];
            bar.m_barTypeIcon = [tmpDic objectForKey:@"barTypeIcon"];
            
            [posBarList addObject:bar];
            [bar release];
        }
        for(id<FDSBarMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(getBarFirstTypeCB:)])
                [interface getBarFirstTypeCB:posBarList];
        }
        [posBarList release];
    }
    else if ([messageType isEqualToString:@"getBarByBarTypeIDReply"] == YES)
    {
        /*  根据贴吧分类得到贴吧列表  */
        NSMutableArray *posBarList = [[NSMutableArray alloc] init];
        FDSPosBar *bar = nil;
        NSArray *array = [data objectForKey:@"bars"];
        for (int i=0; i<array.count; i++)
        {
            NSDictionary *tmpDic = [array objectAtIndex:i];
            bar = [[FDSPosBar alloc] init];
            bar.m_barName = [tmpDic objectForKey:@"barName"];
            bar.m_barID = [tmpDic objectForKey:@"barID"];
            bar.m_barIcon = [tmpDic objectForKey:@"barIcon"];
            bar.m_joinedNumber = [tmpDic objectForKey:@"joinedNumber"];
            bar.m_postNumber = [tmpDic objectForKey:@"postNumber"];
            bar.m_introduce = [tmpDic objectForKey:@"introduce"];
            bar.m_companyID = [tmpDic objectForKey:@"companyID"];
            
            [posBarList addObject:bar];
            [bar release];
        }
        for(id<FDSBarMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(getBarByBarTypeIDCB:)])
                [interface getBarByBarTypeIDCB:posBarList];
        }
        [posBarList release];
    }
    else if ([messageType isEqualToString:@"getBarInfoReply"] == YES)
    {
        /*  得到一个贴吧信息  */
        FDSPosBar *posBar = [[FDSPosBar alloc]init];
        posBar.m_barName = [data objectForKey:@"barName"];
        posBar.m_barIcon = [data objectForKey:@"barIcon"];
        posBar.m_joinedNumber = [data objectForKey:@"joinedNumber"];
        posBar.m_postNumber = [data objectForKey:@"postNumber"];
        posBar.m_introduce = [data objectForKey:@"introduce"];
        posBar.m_relation = [data objectForKey:@"relation"];
        posBar.m_companyID = [data objectForKey:@"companyID"];//如果是企业吧，companyID将为公司ID，不是则为空
        for(id<FDSBarMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(getBarInfoCB:)])
                [interface getBarInfoCB:posBar];
        }
        [posBar release];
    }
    else if ([messageType isEqualToString:@"getBarPostListReply"] == YES)
    {
        /*  得到一个贴吧的帖子列表  */
        NSMutableArray *barPostList = [[NSMutableArray alloc] init];
        NSString *postType = [data objectForKey:@"postType"];
        NSArray *tmpArr = [data objectForKey:@"posts"];
        FDSBarPostInfo *barPost = nil;
        for (int i=0; i<tmpArr.count; i++)
        {
            NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
            barPost = [[FDSBarPostInfo alloc] init];
            barPost.m_title = [tmpDic objectForKey:@"title"];
            barPost.m_contentType = [tmpDic objectForKey:@"contentType"];
            barPost.m_content = [tmpDic objectForKey:@"content"];
            barPost.m_postID = [tmpDic objectForKey:@"postID"];
            barPost.m_senderName = [tmpDic objectForKey:@"senderName"];
            barPost.m_senderID = [tmpDic objectForKey:@"senderID"];
            barPost.m_senderIcon = [tmpDic objectForKey:@"senderIcon"];
            barPost.m_sendTime = [tmpDic objectForKey:@"sendTime"];
            barPost.m_commentNumber = [tmpDic objectForKey:@"commentNumber"];
            
            NSMutableArray *collectTypeData = [[FDSPublicManage sharePublicManager]getCollectedDataWithType:FDS_COLLECTED_MESSAGE_POSTBAR];
            if (collectTypeData && collectTypeData.count > 0)
            {
                BOOL isExist = NO;
                FDSCollectedInfo *tempCollect = nil;
                for (int ii=0; ii<collectTypeData.count; ii++)
                {
                    tempCollect = [collectTypeData objectAtIndex:ii];
                    
                    if ([barPost.m_postID isEqualToString:tempCollect.m_collectID])
                    {
                        isExist = YES;
                        break;
                    }
                }
                if (isExist)
                {
                    barPost.m_isCollect = YES;
                }
                else
                {
                    barPost.m_isCollect = NO;
                }
            }
            else
            {
                barPost.m_isCollect = NO;
            }
            
            barPost.m_images = [[[NSMutableArray alloc] init]autorelease];
            NSArray *urlArr = [tmpDic objectForKey:@"images"];
            for (int j=0; j<urlArr.count; j++)
            {
                NSDictionary *dic2 = [urlArr objectAtIndex:j];
                [barPost.m_images addObject:[dic2 objectForKey:@"URL"]];
            }
            [barPostList addObject:barPost];
            [barPost release];
        }
        for(id<FDSBarMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(getBarPostListCB::)])
                [interface getBarPostListCB:barPostList:postType];
        }
        [barPostList release];
    }
    else if ([messageType isEqualToString:@"getPostReply"] == YES)
    {
        /*  得到一个帖子  */
        FDSBarPostInfo *barInfo = [[FDSBarPostInfo alloc] init];
        barInfo.m_title = [data objectForKey:@"title"];
        barInfo.m_contentType = [data objectForKey:@"contentType"];
        barInfo.m_content = [data objectForKey:@"content"];
        barInfo.m_url = [data objectForKey:@"URL"];
        barInfo.m_senderName = [data objectForKey:@"senderName"];
        barInfo.m_senderIcon = [data objectForKey:@"senderIcon"];
        barInfo.m_senderID = [data objectForKey:@"senderID"];
        barInfo.m_sendTime = [data objectForKey:@"sendTime"];
        barInfo.m_commentNumber = [data objectForKey:@"commentNumber"];
        barInfo.m_images = [[[NSMutableArray alloc] init]autorelease];
        NSArray *urlArr = [data objectForKey:@"images"];
        for (int j=0; j<urlArr.count; j++)
        {
            NSDictionary *dic2 = [urlArr objectAtIndex:j];
            [barInfo.m_images addObject:[dic2 objectForKey:@"URL"]];
        }
        
        for(id<FDSBarMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(getPostCB:)])
                [interface getPostCB:barInfo];
        }
        [barInfo release];
    }
    else if ([messageType isEqualToString:@"getPostCommentReply"] == YES)
    {
        /*  得到一个帖子的评论  */
        NSMutableArray *posbarCommentList = [[NSMutableArray alloc] init];
        NSArray *tmpArr = [data objectForKey:@"comments"];
        FDSComment *commentInfo = nil;
        for (int i=0; i<tmpArr.count; i++)
        {
            commentInfo = [[FDSComment alloc] init];
            NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
            commentInfo.m_commentID = [tmpDic objectForKey:@"commentID"];
            
            commentInfo.m_content = [tmpDic objectForKey:@"content"];
            commentInfo.m_senderID = [tmpDic objectForKey:@"senderID"];
            commentInfo.m_senderIcon = [tmpDic objectForKey:@"senderIcon"];
            commentInfo.m_senderName = [tmpDic objectForKey:@"senderName"];
            commentInfo.m_sendTime = [tmpDic objectForKey:@"sendTime"];
            
            commentInfo.m_images = [[[NSMutableArray alloc] init]autorelease];
            NSArray *urlArr = [tmpDic objectForKey:@"images"];
            for (int j=0; j<urlArr.count; j++)
            {
                NSDictionary *urlDic = [urlArr objectAtIndex:j];
                [commentInfo.m_images addObject:[urlDic objectForKey:@"URL"]];
            }
            
            commentInfo.m_revertCount = [[tmpDic objectForKey:@"revertCount"] integerValue];
            
            commentInfo.m_revertsList = [[[NSMutableArray alloc] init] autorelease];
            NSArray *revertsArr = [tmpDic objectForKey:@"reverts"];
            FDSRevert *revert = nil;
            for (int ii=0; ii<revertsArr.count; ii++)
            {
                NSDictionary *revertDic = [revertsArr objectAtIndex:ii];
                revert = [[FDSRevert alloc] init];
                
                revert.m_revertID = [revertDic objectForKey:@"revertID"];
                revert.m_senderID = [revertDic objectForKey:@"senderID"];
                revert.m_senderName = [revertDic objectForKey:@"senderName"];
                revert.m_senderIcon = [revertDic objectForKey:@"senderIcon"];
                revert.m_sendTime = [revertDic objectForKey:@"sendTime"];
                revert.m_content = [revertDic objectForKey:@"content"];
                [commentInfo.m_revertsList addObject:revert];
                [revert release];
                if (ii > 0)  //主列表最多只显示两条数据
                {
                    break;
                }
            }

            [posbarCommentList addObject:commentInfo];
            [commentInfo release];
        }
        for(id<FDSBarMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(getPostCommentCB:)])
                [interface getPostCommentCB:posbarCommentList];
        }
        [posbarCommentList release];
    }
    else if ([messageType isEqualToString:@"sendPostReply"] == YES)
    {
        /*  发表帖子  */
        NSString *result = [data objectForKey:@"result"];
        NSString *postID = [data objectForKey:@"postID"];
        for(id<FDSBarMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(sendPostCB::)])
                [interface sendPostCB:result :postID];
        }
    }
    else if ([messageType isEqualToString:@"sendPostCommentReply"] == YES)
    {
        /*  发表帖子评论、回复  */
        NSString *result = [data objectForKey:@"result"];
        NSString *commentID = [data objectForKey:@"commentID"];
        for(id<FDSBarMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(sendPostCommentCB::)])
                [interface sendPostCommentCB:result :commentID];
        }
    }
    else if ([messageType isEqualToString:@"getPostCommentRevertReply"] == YES)
    {
        /* 得到帖子评论的回复 */
        NSMutableArray *revertList = [[NSMutableArray alloc] init];
        FDSRevert *revert = nil;
        NSArray *tmpArr = [data objectForKey:@"reverts"];
        for (int i=0; i<tmpArr.count; i++)
        {
            NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
            revert = [[FDSRevert alloc] init];
            revert.m_revertID = [tmpDic objectForKey:@"revertID"];
            revert.m_senderID = [tmpDic objectForKey:@"senderID"];
            revert.m_senderName = [tmpDic objectForKey:@"senderName"];
            revert.m_senderIcon = [tmpDic objectForKey:@"senderIcon"];
            revert.m_sendTime = [tmpDic objectForKey:@"sendTime"];
            revert.m_content = [tmpDic objectForKey:@"content"];
            
            [revertList addObject:revert];
            [revert release];
        }
        for(id<FDSBarMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(getCompanyCommentRevertListCB:)])
                [interface getPostCommentRevertCB:revertList];
        }
        [revertList release];
    }
    else if ([messageType isEqualToString:@"getHotPostReply"] == YES)
    {
        /* 得到最热帖子 */
        NSMutableArray *hotPostList = [[NSMutableArray alloc] init];
        NSArray *tmpArr = [data objectForKey:@"posts"];
        FDSBarPostInfo *postInfo = nil;
        for (int i=0; i<tmpArr.count; i++)
        {
            postInfo = [[FDSBarPostInfo alloc] init];
            NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
            postInfo.m_postID = [tmpDic objectForKey:@"postID"];
            postInfo.m_title = [tmpDic objectForKey:@"postTitle"];
            postInfo.m_images = [[[NSMutableArray alloc] init]autorelease];
            [postInfo.m_images addObject:[tmpDic objectForKey:@"image"]];

            [hotPostList addObject:postInfo];
            [postInfo release];
        }
        
        for(id<FDSBarMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(getHotPostCB:)])
                [interface getHotPostCB:hotPostList];
        }
        [hotPostList release];
    }
    else if ([messageType isEqualToString:@"deletePostCommentRevertReply"] == YES)
    {
        /* 删除帖子，评论，回复 */
        NSString *result = [data objectForKey:@"result"];
        for(id<FDSBarMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(deletePostCommentRevertCB:)])
                [interface deletePostCommentRevertCB:result];
        }
    }
    else if ([messageType isEqualToString:@"getBarsReply"] == YES)
    {
        /*  得到贴吧(现在仅仅用于贴吧搜索)  */
        NSMutableArray *posBarList = [[NSMutableArray alloc] init];
        FDSPosBar *bar = nil;
        NSArray *array = [data objectForKey:@"bars"];
        for (int i=0; i<array.count; i++)
        {
            NSDictionary *tmpDic = [array objectAtIndex:i];
            bar = [[FDSPosBar alloc] init];
            bar.m_barName = [tmpDic objectForKey:@"barName"];
            bar.m_barID = [tmpDic objectForKey:@"barID"];
            bar.m_barIcon = [tmpDic objectForKey:@"barIcon"];
            bar.m_joinedNumber = [tmpDic objectForKey:@"joinedNumber"];
            bar.m_postNumber = [tmpDic objectForKey:@"postNumber"];
            bar.m_introduce = [tmpDic objectForKey:@"introduce"];
            bar.m_companyID = [tmpDic objectForKey:@"companyID"];

            [posBarList addObject:bar];
            [bar release];
        }
        for(id<FDSBarMessageInterface> interface in self.observerArray)
        {
            if([interface respondsToSelector:@selector(getBarsCB:)])
                [interface getBarsCB:posBarList];
        }
        [posBarList release];
    }
    
}




/*  得到贴吧的一级分类  */
- (void)getBarFirstType
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getBarFirstType" forKey:@"messageType"];
    [self sendMessage:dic];
}

/*  根据贴吧分类得到贴吧列表  */
- (void)getBarByBarTypeID:(NSString*)barTypeID :(NSString*)getWay :(NSString*)barID :(NSInteger)count
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getBarByBarTypeID" forKey:@"messageType"];
    [dic setObject:barTypeID forKey:@"barTypeID"];
    [dic setObject:getWay forKey:@"getWay"];
    [dic setObject:barID forKey:@"barID"];
    [dic setObject:[NSString stringWithFormat:@"%d",count] forKey:@"count"];
    [self sendMessage:dic];
}

/*  得到一个贴吧信息  */
- (void)getBarInfo:(NSString*)barID
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getBarInfo" forKey:@"messageType"];
    [dic setObject:barID forKey:@"barID"];
    NSString *userID = [[FDSUserManager sharedManager] getNowUser].m_userID;
    if (userID && userID.length>0)
    {
        [dic setObject:userID forKey:@"userID"];
    }
    else
    {
        [dic setObject:@"" forKey:@"userID"];
    }
    [self sendMessage:dic];
}

/*  得到一个贴吧的帖子列表  */
- (void)getBarPostList:(NSString*)barID :(NSString*)getWay :(NSString*)postID :(NSInteger)count :(NSString*)postType
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getBarPostList" forKey:@"messageType"];
    [dic setObject:barID forKey:@"barID"];
    [dic setObject:getWay forKey:@"getWay"];
    if (postID)
    {
        [dic setObject:postID forKey:@"postID"];
    }
    else
    {
        [dic setObject:@"-1" forKey:@"postID"];
    }
    [dic setObject:[NSString stringWithFormat:@"%d",count] forKey:@"count"];
    [dic setObject:postType forKey:@"postType"]; //”all”, //”news” 0：公司新闻；interviwe 1：人物专访；event 2：活动；3：topic话题；hr 4：招聘
    [self sendMessage:dic];
}

/*  得到一个帖子  */
- (void)getPost:(NSString*)postID
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getPost" forKey:@"messageType"];
    [dic setObject:postID forKey:@"postID"];
    [self sendMessage:dic];
}

/*  得到一个帖子的评论  */
- (void)getPostComment:(NSString*)postID :(NSString*)getWay :(NSString*)commentID :(NSInteger)count
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getPostComment" forKey:@"messageType"];
    [dic setObject:postID forKey:@"postID"];
    [dic setObject:getWay forKey:@"getWay"];
    [dic setObject:commentID forKey:@"commentID"];
    [dic setObject:[NSString stringWithFormat:@"%d",count] forKey:@"count"];

    [self sendMessage:dic];
}

/*  发表帖子  */
- (void)sendPost:(NSString*)barID :(NSString*)title :(NSString*)content :(NSMutableArray*)images :(NSString*)postType
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"sendPost" forKey:@"messageType"];
    [dic setObject:barID forKey:@"barID"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    [dic setObject:title forKey:@"title"];
    [dic setObject:content forKey:@"content"];
    if (images && images.count > 0)
    {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:5];
        for (int i=0; i<images.count; i++)
        {
            NSDictionary *dic = [NSDictionary dictionaryWithObject:[images objectAtIndex:i] forKey:@"URL"];
            [arr addObject:dic];
        }
        [dic setObject:arr forKey:@"images"];
    }
    [dic setObject:postType forKey:@"postType"];

    [self sendMessage:dic];
}

/*  发表帖子评论、回复  */
- (void)sendPostComment:(NSString*)commentContentType :(NSString*)postID :(NSString*)commentID :(NSString*)content :(NSMutableArray*)images
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"sendPostComment" forKey:@"messageType"];
    [dic setObject:commentContentType forKey:@"commentContentType"];//”comment”,// “reply”
    [dic setObject:postID forKey:@"postID"];
    [dic setObject:commentID forKey:@"commentID"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    [dic setObject:content forKey:@"content"];
    if (images && images.count > 0)
    {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:5];
        for (int i=0; i<images.count; i++)
        {
            NSDictionary *dic = [NSDictionary dictionaryWithObject:[images objectAtIndex:i] forKey:@"URL"];
            [arr addObject:dic];
        }
        [dic setObject:arr forKey:@"images"];
    }

    [self sendMessage:dic];
}

/* 得到帖子评论的回复 */
- (void)getPostCommentRevert:(NSString*)commentID :(NSString*)getWay :(NSString*)revertID :(NSInteger)count
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getPostCommentRevert" forKey:@"messageType"];
    [dic setObject:commentID forKey:@"commentID"];
    [dic setObject:getWay forKey:@"getWay"];
    [dic setObject:revertID forKey:@"revertID"];
    [dic setObject:[NSString stringWithFormat:@"%d",count] forKey:@"count"];
    
    [self sendMessage:dic];
}

/* 得到最热帖子 */
- (void)getHotPost
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getHotPost" forKey:@"messageType"];

    [self sendMessage:dic];
}

/* 删除帖子，评论，回复 */
- (void)deletePostCommentRevert:(NSString*)commentObjectID :(NSString*)type :(NSString*)objectID
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"deletePostCommentRevert" forKey:@"messageType"];
    [dic setObject:[[FDSUserManager sharedManager] getNowUser].m_userID forKey:@"userID"];
    [dic setObject:commentObjectID forKey:@"commentObjectID"];
    [dic setObject:type forKey:@"type"];
    [dic setObject:objectID forKey:@"id"];

    [self sendMessage:dic];
}

/*  得到贴吧(现在仅仅用于贴吧搜索)  */
- (void)getBars:(NSString*)key :(NSString*)keyword :(NSString*)getWay :(NSString*)barID :(NSInteger)count
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"getBars" forKey:@"messageType"];
    [dic setObject:key forKey:@"key"];// keyword  typeID
    [dic setObject:keyword forKey:@"keyword"];
    [dic setObject:getWay forKey:@"getWay"]; //只有before
    [dic setObject:barID forKey:@"barID"];
    [dic setObject:[NSString stringWithFormat:@"%d",count] forKey:@"count"];
    
    [self sendMessage:dic];
}


@end

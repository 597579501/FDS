//
//  SpaceDynamicListCell.h
//  FDS
//
//  Created by zhuozhong on 14-3-10.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
#import "CommentView.h"
#import "FDSComment.h"

@protocol SpaceFeedBtnDelegate <NSObject>

@optional

- (void)didClickReplyBtn:(NSInteger)currentTag;
- (void)didClickDeleteComment:(NSInteger)currentTag;

- (void)didSelectCommentHead:(NSInteger)currentIndex;
- (void)didSelectReplyBtn:(NSInteger)currentIndex :(NSInteger)replyIndex;
- (void)didClickDeleteRecert:(NSInteger)currentIndex :(NSInteger)replyIndex;

@end

@interface SpaceDynamicListCell : UITableViewCell
{
    CGFloat             cell_H;     //cell最终高度
    CGFloat             off_x;      //起始横坐标变化
    
    FDSComment          *commentInfo;
}

@property(assign,nonatomic) id<SpaceFeedBtnDelegate>   delegate;
@property(assign,nonatomic) NSInteger                  indexTag;

@property(retain,nonatomic) UIImageView       *commentCellImg;        //cell背景
@property(retain,nonatomic) EGOImageButton    *commentHeadImg;        //评论人头像
@property(retain,nonatomic) UILabel           *commentNameLab;        //发布动态人name

@property(nonatomic,strong) UIButton          *delBtn;     //删除
@property(nonatomic,strong) UIImageView       *delImg;

@property(nonatomic,strong) UIButton          *replyBtn;   //回复
@property(nonatomic,strong) UIImageView       *replyImg;
@property(nonatomic,strong) UILabel           *replyLab;

@property(retain,nonatomic) UILabel           *commentTimeLab;        //发布动态时间
@property(retain,nonatomic) CommentView       *commentContentView;     //发布动态内容
@property(retain,nonatomic) UIView            *commentImgViews;       //发布动态图片
@property(retain,nonatomic) UIView            *commentReplyViews;     //动态的回复列表

- (void)loadCellData:(FDSComment*)commentData;


@end

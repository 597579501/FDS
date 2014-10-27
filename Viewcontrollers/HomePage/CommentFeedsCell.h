//
//  CommentFeedsCell.h
//  FDS
//
//  Created by zhuozhongkeji on 13-12-30.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
#import "FDSComment.h"
#import "CommentView.h"

@protocol CommentFeedBtnDelegate <NSObject>

@optional

- (void)didClickReplyBtn:(NSInteger)currentTag;
- (void)didClickDeleteBtn:(NSInteger)currentTag;

- (void)didSelectCommentHead:(NSInteger)currentIndex;
- (void)didSelectContentImg:(NSInteger)currentIndex :(NSInteger)imgIndex;
- (void)didSelectReplyHead:(NSInteger)currentIndex :(NSInteger)replyIndex;
@end

@interface CommentFeedsCell : UITableViewCell
{
    CGFloat             cell_H;     //cell最终高度
    CGFloat             off_x;      //起始横坐标变化
    FDSComment          *commentInfo;
}

@property(assign,nonatomic) id<CommentFeedBtnDelegate> delegate;
@property(assign,nonatomic) NSInteger                  indexTag;

@property(retain,nonatomic) UIImageView       *commentCellImg;        //cell背景
@property(retain,nonatomic) EGOImageButton    *commentHeadImg;        //评论人头像
@property(retain,nonatomic) UILabel           *commentNameLab;        //发布评论人name

@property(nonatomic,strong) UIButton          *delBtn;   //删除
@property(nonatomic,strong) UIImageView       *delImg;

@property(nonatomic,strong) UIButton          *replyBtn;   //回复
@property(nonatomic,strong) UIImageView       *replyImg;
@property(nonatomic,strong) UILabel           *replyLab;

@property(retain,nonatomic) UILabel           *commentTimeLab;        //发布评论时间
@property(retain,nonatomic) CommentView       *commentContentView;     //发布评论内容
@property(retain,nonatomic) UIView            *commentImgViews;       //发布评论图片
@property(retain,nonatomic) UIView            *commentReplyViews;     //评论的回复列表
@property(retain,nonatomic) UIView            *commentLineView;       //分隔线
@property(retain,nonatomic) UIButton          *commentMoreRelyBtn;   //查看更多回复

- (void)loadCellData:(FDSComment*)commentData;

- (CGFloat)getCurrentCellHeight;

@end

//
//  BarPostListCell.h
//  FDS
//
//  Created by zhuozhong on 14-3-4.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
#import "CommentView.h"
#import "FDSBarPostInfo.h"

@protocol BarPostCellDelegate <NSObject>

@optional
- (void)didHeadImgWithTag:(NSInteger)currentTag;
- (void)didCollectWithTag:(NSInteger)currentTag;
- (void)didClickDeleteBtn:(NSInteger)currentTag;
@end

@interface BarPostListCell : UITableViewCell
{
    CGFloat             cell_H;     //cell最终高度
    CGFloat             off_x;      //起始横坐标变化
    
    FDSBarPostInfo      *barInfo;
}

@property(nonatomic,assign)id<BarPostCellDelegate> delegate;
@property(nonatomic,assign)NSInteger        currentIndex;

@property(nonatomic,retain)UIImageView      *postCellImg;
@property(nonatomic,retain)UILabel          *publishTimeLab;
@property(nonatomic,retain)UILabel          *titleLab;

@property(nonatomic,strong) UIButton          *delBtn;   //删除
@property(nonatomic,strong) UIImageView       *delImg;

@property(nonatomic,retain)UIView           *imgViews;
@property(nonatomic,retain)CommentView      *postContentView;
@property(nonatomic,retain)UIView           *postLineView;

@property(nonatomic,retain)EGOImageButton   *headImg;
@property(nonatomic,retain)UILabel          *nameLab;
@property(nonatomic,assign)UIButton         *collectBtn;
@property(nonatomic,retain)UIImageView      *commentImg;
@property(nonatomic,retain)UILabel          *commentNumLab;


- (void)loadPostCellData:(FDSBarPostInfo*)dataInfo;

-(CGFloat)getCurrentCellHeight:(FDSBarPostInfo*)dataInfo;

@end

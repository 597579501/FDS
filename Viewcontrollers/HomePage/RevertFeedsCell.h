//
//  RevertFeedsCell.h
//  FDS
//
//  Created by zhuozhong on 14-2-26.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
#include "CommentView.h"
#import "FDSRevert.h"

@protocol RevertDelDelegate <NSObject>

@optional

-(void)deleteRevertWithIndex:(NSInteger)currentIndex;

- (void)didSelectRevertImgWithIndex:(NSInteger)currentTag;

@end

@interface RevertFeedsCell : UITableViewCell
{
    CGFloat   CELL_H;
}

@property(nonatomic,strong) UIButton          *delBtn;   //删除
@property(nonatomic,strong) UIImageView       *delImg;

@property(nonatomic,retain)EGOImageButton    *revertHeadImg;
@property(nonatomic,retain)UILabel           *revertNameLab;
@property(nonatomic,retain)UILabel           *revertTimeLab;
@property(nonatomic,retain)CommentView       *revertContenView;

@property(nonatomic,assign)NSInteger             indexRow;
@property(nonatomic,assign)id<RevertDelDelegate> delegate;

- (void)loadRevertCellData:(FDSRevert*)revert;

- (CGFloat)getCurrentCellHeight;

@end

//
//  SNSTableViewCell.h
//  FDS
//
//  Created by zhuozhongkeji on 14-1-15.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface SNSTableViewCell : UITableViewCell
{
    CGFloat             cell_H;     //cell最终高度
    CGFloat             off_x;      //起始横坐标变化
}

@property(nonatomic,strong)UIImageView      *cellBgView;
@property(nonatomic,strong)EGOImageView     *headPhotoImg;
@property(nonatomic,strong)UILabel          *nameTextLab;
@property(nonatomic,strong)UILabel          *timeTextLab; //操作时间
@property(nonatomic,strong)UILabel          *contentTextLab;
@property(nonatomic,strong)UIView           *contentImgs; //图片动态
@property(nonatomic,strong)UIView           *operItemsView; //操作选择项

//@property(nonatomic,strong)UIButton         *permissionsBtn;//权限
//@property(nonatomic,strong)UIImageView      *permissionsImg;
//@property(nonatomic,strong)UILabel          *permissionsLab;
//
//@property(nonatomic,strong)UIButton         *shareBtn;//分享
//@property(nonatomic,strong)UIImageView      *shareImg;
//@property(nonatomic,strong)UILabel          *shareLab;
//
//@property(nonatomic,strong)UIButton         *deleteBtn;//删除
//@property(nonatomic,strong)UIImageView      *deleteImg;
//@property(nonatomic,strong)UILabel          *deleteLab;

@end

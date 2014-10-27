//
//  DynamicCell.h
//  MacelInternet
//
//  Created by zhuozhongkeji on 13-12-30.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleData.h"
#import "EGOImageView.h"
//#import "ImgsLoading.h"

typedef NS_ENUM(NSInteger, UIElementType)//页面样式类型
{
    UIStyleHeadPhoto = 0,       //头像
    UIStyleNickName,
    UIStyleCollect,         //收藏
    UIStyleReport,         //举报
    UIStylePraise,         //赞
    UIStyleComment,         //评论
    UIStyleDelete,          //删除
    UIStyleReply,
    UIStyleOther,
};

typedef NS_ENUM(NSInteger, UISelfDefCellType)//cell样式类型
{
    UISelfDefCellStyle  = 0,        //cell样式0 默认样式
    UISelfDefCellStyle1 = 1,        //cell样式1 带收藏按钮带头像
    UISelfDefCellStyle2 = 2,        //cell样式2 我的动态类型
    UISelfDefCellStyle3 = 3,        //cell样式2 带收藏按钮无头像
};

@protocol DynamicCellDelegate <NSObject>

- (void)CellTapped:(UIElementType)type currTag:(NSInteger)tagIndex;

@end

@interface DynamicCell : UITableViewCell
{
    EGOImageView*       headPhoto;
    UILabel*            nickName;
    UILabel*            dynamicText;    //文本动态
    UIView*             dynamicImgs;    //图片动态
    UILabel*            dynamicTime;    //发布动态的时间
    
    UIView*             collectView;    //收藏
    UIImageView*        collectImgV;
    
    UIView*             commentView;    //评论
    UILabel*            commentLb;
    UIImageView*        commentImgV;

    UIView*             praiseView;     //赞
    UILabel*            praiseLb;
    UIImageView*        praiseImgV;

    UIView*             deleteView;     //删除
    UIImageView*        deleteImgV;     //删除
    
    UIView*             reportView;     //举报
    UILabel*            reportLb;
    
    UILabel*            replyLab;     //回复
    
    CGFloat             cell_H;     //cell最终高度
    ArticleData*        cellData;   //cell填充数据
    NSMutableArray*     imgViews;
    
    CGFloat             off_x;      //起始横坐标变化
}

@property(nonatomic, assign)NSInteger           indexTag;
@property(nonatomic,assign)id<DynamicCellDelegate> cellDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style Delegate:(id)delegate reuseIdentifier:(NSString *)reuseIdentifier;
- (void)LoadCellData:(ArticleData*)cellDataObj CellType:(UISelfDefCellType)cellType;

- (void)resetCellData;
- (void)collectInit;
- (void)commentAndPraiseInit;

- (CGFloat)GetCurrentCellHeight;
@end

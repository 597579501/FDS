//
//  FDSPosBarInfoViewController.h
//  FDS
//
//  Created by zhuozhong on 14-3-3.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "MenuScrollView.h"
#import "PullingRefreshTableView.h"
#import "FDSBarMessageManager.h"
#import "FDSCompanyMessageManager.h"
#import "BarPostListCell.h"
#import "FDSSendPostViewController.h"
#import "EGOImageView.h"

enum BAR_POST_TYPE
{
    BAR_POST_TYPE_NONE,
    BAR_POST_TYPE_COMPANY,
    BAR_POST_TYPE_OTHER,
    BAR_POST_TYPE_MAX
};

@interface FDSPosBarInfoViewController : UIViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,MenuBtnDelegate,FDSBarMessageInterface,BarPostCellDelegate,FDSCompanyMessageInterface,PostBarRefreshDelegate>
{
    BOOL   isRefresh;
    BOOL   isLoadMore;
    NSInteger              selectIndex;
    NSMutableArray         *titleArr;
    
    NSInteger              deleteIndex;
    
    NSMutableDictionary    *sizeList; //存取cell高度
    
    BOOL                   isSendPost;//是否发帖
    BOOL                   sendRefresh;//发帖刷新
}
@property(nonatomic,retain) EGOImageView             *companyLogoImg;
@property(nonatomic,retain) UILabel                  *companyNameLab;
@property(nonatomic,retain)UILabel                   *followedNumLab;//关注该帖子人数
@property(nonatomic,retain)UILabel                   *posbarNumLab;//帖子数

@property(nonatomic,assign)UIButton                  *followBtn;  //进行关注
@property(nonatomic,retain)UILabel                   *followLab;
@property(nonatomic,retain)UIImageView               *followImg;

@property(nonatomic,retain) MenuScrollView           *menuScroll;
@property(nonatomic,retain) PullingRefreshTableView  *postTable;

@property(nonatomic,retain) FDSPosBar                *lastPageBar; //列表页面传入的帖子详情

@property(nonatomic,assign) enum BAR_POST_TYPE       bar_type;  //贴吧类型

@end

//
//  FDSBarCommentViewController.h
//  FDS
//
//  Created by zhuozhong on 14-3-5.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSBarPostInfo.h"
#import "PullingRefreshTableView.h"
#import "FaceBoard.h"
#import "UIPlaceHolderTextView.h"
#import "FDSBarMessageManager.h"
#import "CommentFeedsCell.h"
#import "FDSRevertListViewController.h"
#import "FDSSendCommentViewController.h"

@interface FDSBarCommentViewController : UIViewController<UIWebViewDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,FaceBoardDelegate,FDSBarMessageInterface,CommentFeedBtnDelegate,NotifiCommentDelegate,SucSendCommentDelegate>
{
    UIView    *imgViews;
    FaceBoard *faceBoard;  //表情view
    
    UIView *toolBar;
    
    UIPlaceHolderTextView *textView;
    
    UIButton *keyboardButton;
    UIButton *photoBtn;
    UIButton *sendButton;
    
    BOOL isFirstShowKeyboard;
    
    BOOL isKeyboardShowing;
    
    BOOL isSystemBoardShow;
    
    CGFloat keyboardHeight;
    
    BOOL   isRefresh;
    
    BOOL   loadMore; //是否显示加载更多
    
    NSInteger   deleteIndex; //指定删除cell索引
    BOOL        isChange;//某条评论的回复是否改变
    NSInteger   currentRow;// 需tableview刷新的索引行
    CGFloat     cell_H;
    
    BOOL        sucPublish;
}
@property(nonatomic,assign)UIButton                         *collectBtn;
@property(nonatomic,retain)UIImageView                      *commentImg;
@property(nonatomic,retain)UIView                           *lastLineView;
@property(nonatomic,retain)UILabel                          *commentNumLab;//评论数

@property(nonatomic,retain)PullingRefreshTableView          *commentTabView;

@property(nonatomic,retain)NSMutableArray       *commentDataArray;
@property(nonatomic,retain)FDSBarPostInfo       *barPostInfo;
@property(nonatomic,retain)NSString             *publishContent;//发布评论内容

@property(nonatomic,assign)BOOL                 isTotop; //是否置顶

@end

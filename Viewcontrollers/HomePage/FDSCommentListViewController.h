//
//  FDSCommentListViewController.h
//  FDS
//
//  Created by zhuozhongkeji on 13-12-30.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentFeedsCell.h"
#import "FDSCompanyMessageManager.h"
#import "PullingRefreshTableView.h"
#import "FaceBoard.h"
#import "UIPlaceHolderTextView.h"
#import "FDSRevertListViewController.h"
#import "FDSSendCommentViewController.h"

@interface FDSCommentListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CommentFeedBtnDelegate,FDSCompanyMessageInterface,PullingRefreshTableViewDelegate,FaceBoardDelegate,UITextViewDelegate,NotifiCommentDelegate,UIAlertViewDelegate,SucSendCommentDelegate>
{
    BOOL   isRefresh;
    
    BOOL   loadMore; //是否显示加载更多
    
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
    
    BOOL        isChange;//某条评论的回复是否改变
    NSInteger   currentRow;// 需tableview刷新的索引行
    
    NSInteger   deleteIndex; //指定删除cell索引
    
    BOOL         sucPublish; //是否成功发布
}
@property(nonatomic,retain)PullingRefreshTableView     *commentTabView;

@property(nonatomic,retain)NSMutableArray  *commentDataArray;
@property(nonatomic,retain)NSString        *commentObjectID;
@property(nonatomic,retain)NSString       *commentObjectType;//”company”,”product”,”designer”,”successfulcase”


@property(nonatomic,retain)FDSCompany      *companyInfo;  //传指针修改评论总条数

@property(nonatomic,retain)NSString        *publishContent;//发布内容

@end

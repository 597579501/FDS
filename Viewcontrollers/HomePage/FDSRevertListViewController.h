//
//  FDSRevertListViewController.h
//  FDS
//
//  Created by zhuozhong on 14-2-26.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
#import "FDSComment.h"
#import "FDSCompanyMessageManager.h"
#import "FaceBoard.h"
#import "UIPlaceHolderTextView.h"
#import "RevertFeedsCell.h"
#import "FDSBarMessageManager.h"

enum COMMENT_REVERT_SHOW_TYPE
{
    COMMENT_REVERT_SHOW_NONE,
    COMMENT_REVERT_SHOW_DYNAMIC,
    COMMENT_REVERT_SHOW_POSTBAR,
    COMMENT_REVERT_SHOW_MAX
};

@protocol NotifiCommentDelegate <NSObject>

- (void)didChangeReplyValue:(NSInteger)currentIndex;

@end
@interface FDSRevertListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,FDSCompanyMessageInterface,FDSBarMessageInterface,FaceBoardDelegate,UITextViewDelegate,RevertDelDelegate,UIAlertViewDelegate>
{
    BOOL   isRefresh;
    BOOL   isLoadMore;
    
    FaceBoard *faceBoard;  //表情view
    
    UIView *toolBar;
    
    UIPlaceHolderTextView *textView;
    
    UIButton *keyboardButton;
    UIButton *sendButton;
    
    BOOL isFirstShowKeyboard;
    
    BOOL isKeyboardShowing;
    
    BOOL isSystemBoardShow;
    
    CGFloat keyboardHeight;
    
    BOOL   ischageReply;  //回复是否发生变化
    
    NSInteger   deleteIndex;
    
    UIView *commentImgViews;
}

@property(nonatomic,assign) id<NotifiCommentDelegate>  delegate;

@property(nonatomic,retain) PullingRefreshTableView    *revertTableView;
@property(nonatomic,retain) NSMutableArray             *revertDataArray;

@property(nonatomic,retain) FDSComment                 *commentInfo;
@property(nonatomic,assign) NSInteger                  indexTag; //指定评论索引

@property(nonatomic,retain)NSString                    *publishContent;//发布内容

@property(nonatomic,assign)enum COMMENT_REVERT_SHOW_TYPE revertType;
@end

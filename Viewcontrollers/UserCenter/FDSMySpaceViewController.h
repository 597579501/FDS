//
//  FDSMySpaceViewController.h
//  FDS
//
//  Created by zhuozhongkeji on 14-1-14.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpaceDynamicListCell.h"
#import "PullingRefreshTableView.h"
#import "FDSUserCenterMessageManager.h"
#import "FaceBoard.h"
#import "UIPlaceHolderTextView.h"
#import "FDSRevert.h"
#import "FDSSendCommentViewController.h"

@interface FDSMySpaceViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,PullingRefreshTableViewDelegate,FDSUserCenterMessageInterface,SpaceFeedBtnDelegate,UITextViewDelegate,FaceBoardDelegate,SucSendCommentDelegate>
{
    NSMutableDictionary    *sizeList; //存取cell高度
    CommentView            *recordContentView;
    
    BOOL   loadMore; //是否显示加载更多
    BOOL   isRefresh;
    
    FaceBoard *faceBoard;  //表情view
    
    UIView *toolBar;
    
    UIPlaceHolderTextView *textView;
    
    UIButton *keyboardButton;
    UIButton *sendButton;
    
    BOOL isFirstShowKeyboard;
    
    BOOL isKeyboardShowing;
    
    BOOL isSystemBoardShow;
    
    CGFloat keyboardHeight;
    
    BOOL  isComment;  //YES评论 NO回复
    FDSComment   *selectDynamic; //选中评论回复的动态
    FDSRevert    *selectReply; //选中的回复
    
    NSInteger    deleteIndex; //删除操作
    NSInteger    replyDelIndex;
    
    BOOL         sucPublish; //是否成功发布
}

@property(nonatomic,retain) PullingRefreshTableView     *spaceManageTable;

@property(nonatomic,retain) NSMutableArray              *dynamicDataArray;

@property(nonatomic,assign) BOOL                        isMeInfo;  //是否是自己动态

@property(nonatomic,retain)NSString                     *publishContent;//发布内容

@property(nonatomic,retain)NSString                     *friendID; //用于获取好友动态
@end

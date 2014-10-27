//
//  FDSChatViewController.h
//  FDS
//
//  Created by zhuozhongkeji on 14-1-3.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceBoard.h"
#import "MessageListCell.h"
#import "TPKeyboardAvoidingTableView.h"
#import "UIPlaceHolderTextView.h"
#import "FDSUser.h"
#import "FDSUserCenterMessageManager.h"
#import "ZZUploadManager.h"
#import "PullingRefreshTableView.h"


@interface FDSChatViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PullingRefreshTableViewDelegate,FaceBoardDelegate,FDSUserCenterMessageInterface,MessageListDelegate,ZZUploadInterface>
{
    BOOL isLineReturn;

    CGFloat upX;
    
    CGFloat upY;

    FDSChatMessage *sendmesssgaeImg; //发送图片存储
    
    NSInteger nowReadCount;  //当前页面显示聊天条数
    
    BOOL isFirstShowKeyboard;
    
    BOOL isKeyboardShowing;
    
    BOOL isSystemBoardShow;
    
    CGFloat keyboardHeight;
    
    NSMutableDictionary *sizeList;
    
    FaceBoard *faceBoard;  //表情view

    PullingRefreshTableView *messageListView;
    
    UIView *toolBar;
    
    UIPlaceHolderTextView *textView;
    
    UIButton *keyboardButton;
    UIButton *photoBtn;
    UIButton *sendButton;
    
    BOOL needReload;//是否滚动
    BOOL needUpdateDB; //是否更新chatMessages 和 centerMessage
    
    NSDate  *lastShowDate;  //上次显示得时间
}

@property(nonatomic,retain) NSMutableArray   *messageList; //页面展示数据

@property(nonatomic,retain) FDSMessageCenter *centerMessage;

@end

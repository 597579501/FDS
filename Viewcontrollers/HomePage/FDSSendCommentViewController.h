//
//  FDSSendCommentViewController.h
//  FDS
//
//  Created by saibaqiao on 14-3-16.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

@protocol SucSendCommentDelegate <NSObject>

@optional
- (void)handleSucRefresh;

@end

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"
#import "MSKeyboardScrollView.h"
#import "FDSBarMessageManager.h"
#import "MenuAddImageView.h"
#import "ZZUploadManager.h"
#import "FDSCompanyMessageManager.h"
#import "FDSUserCenterMessageManager.h"

enum SEND_NEW_MESSAGE_TYPE
{
    SEND_NEW_MESSAGE_TYPE_NONE,
    SEND_NEW_MESSAGE_TYPE_COMMENT,//普通评论
    SEND_NEW_MESSAGE_TYPE_BAR,// 贴吧评论
    SEND_NEW_MESSAGE_TYPE_DYNAMIC,//动态
    SEND_NEW_MESSAGE_TYPE_MAX
};

@interface FDSSendCommentViewController : UIViewController<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,FDSBarMessageInterface,FDSCompanyMessageInterface,FDSUserCenterMessageInterface,MenuAddBtnDelegate,ZZUploadInterface>
{
    UIPlaceHolderTextView *contextTextView;
    MSKeyboardScrollView  *scrollView;
    
    MenuAddImageView      *addMenuView;
    
    NSInteger             uploadCount;
    NSMutableArray        *imagesURL;
    UILabel               *numLab;
}

@property(nonatomic,assign) id<SucSendCommentDelegate> delegate;
@property(nonatomic,assign) enum SEND_NEW_MESSAGE_TYPE send_type;  //贴吧类型

@property(nonatomic,retain) NSString                   *commentObjectType;//普通评论需要type
@property(nonatomic,retain) NSString                   *objectID;
@property(nonatomic,retain) NSMutableArray             *recordList; //列表信息

@property(nonatomic,retain) NSString                   *publishContent; //发布内容

@end

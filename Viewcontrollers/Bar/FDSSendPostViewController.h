//
//  FDSSendPostViewController.h
//  FDS
//
//  Created by zhuozhong on 14-3-14.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

@protocol PostBarRefreshDelegate <NSObject>

@optional
- (void)didSucRefresh;

@end

#import <UIKit/UIKit.h>
#import "FDSPosBarInfoViewController.h"
#import "MenuButtonView.h"
#import "UIPlaceHolderTextView.h"
#import "MSKeyboardScrollView.h"
#import "FDSBarMessageManager.h"
#import "MenuAddImageView.h"
#import "ZZUploadManager.h"


@interface FDSSendPostViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,FDSBarMessageInterface,MenuAddBtnDelegate,ZZUploadInterface>
{
    MenuButtonView        *buttonView;
    UITextField           *titleText;
    UIPlaceHolderTextView *contextTextView;
    MSKeyboardScrollView  *scrollView;
    UILabel               *numLab;

    MenuAddImageView      *addMenuView;
    
    NSInteger             uploadCount;
    NSMutableArray        *imagesURL;
}

@property(nonatomic,assign) enum BAR_POST_TYPE       bar_type;  //贴吧类型
@property(nonatomic,retain) NSString                 *barID;
@property(nonatomic,retain) FDSBarPostInfo           *barInfo;

@property(nonatomic,retain) NSString                 *publishTitle;
@property(nonatomic,retain) NSString                 *publishContent;
@property(nonatomic,retain) NSString                 *publishType;

@property(nonatomic,assign) id<PostBarRefreshDelegate> delegate;

@end

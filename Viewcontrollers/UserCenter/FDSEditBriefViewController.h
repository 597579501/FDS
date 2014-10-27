//
//  FDSEditBriefViewController.h
//  FDS
//
//  Created by zhuozhongkeji on 14-1-23.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"
#import "FDSUserCenterMessageManager.h"
#import "MSKeyboardScrollView.h"
#import "FDSEditProfileViewController.h"

@interface FDSEditBriefViewController : UIViewController<UITextViewDelegate,FDSUserCenterMessageInterface>

@property(nonatomic,strong)MSKeyboardScrollView    *scrollView;
@property(nonatomic,strong)UIPlaceHolderTextView   *dataField;
@property(nonatomic,strong)UILabel                 *numLab;
@property(nonatomic,assign)id<ProfileRefreshDelegate> delegate;

@property(nonatomic,strong)NSString   *modifyContent;

@end

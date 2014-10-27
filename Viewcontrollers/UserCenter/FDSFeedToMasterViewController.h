//
//  FDSFeedToMasterViewController.h
//  FDS
//
//  Created by zhuozhongkeji on 14-1-10.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"
#import "MSKeyboardScrollView.h"
#import "FDSUserCenterMessageManager.h"

@interface FDSFeedToMasterViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,FDSUserCenterMessageInterface>
{
    UILabel               *numLab;
}
@property(nonatomic,strong) UIPlaceHolderTextView  *sugTextView;
@property(nonatomic,strong) UITextField            *emailTextField;
@property(nonatomic,strong) MSKeyboardScrollView   *scrollView;

@end

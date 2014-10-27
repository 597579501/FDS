//
//  FDSRegisterViewController.h
//  FDS
//
//  Created by zhuozhongkeji on 14-1-21.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSKeyboardScrollView.h"
#import "FDSUserCenterMessageManager.h"


@interface FDSRegisterViewController : UIViewController<UITextFieldDelegate,FDSUserCenterMessageInterface>

@property(nonatomic,retain) MSKeyboardScrollView     *scrollView;
@property(nonatomic,retain) UITextField              *phoneText;
@property(nonatomic,retain) UITextField              *pwdText;

@property(nonatomic,retain) NSString*     account;
@property(nonatomic,retain) NSString*     password;
@property(nonatomic,retain) NSString      *sessionID;

@end

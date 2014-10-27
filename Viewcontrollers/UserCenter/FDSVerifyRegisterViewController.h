//
//  FDSVerifyRegisterViewController.h
//  FDS
//
//  Created by zhuozhongkeji on 14-1-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSKeyboardScrollView.h"
#import "FDSUserCenterMessageManager.h"
#import "TimerLabel.h"

@interface FDSVerifyRegisterViewController : UIViewController<UITextFieldDelegate,TimerLabelDelegate,FDSUserCenterMessageInterface>
{
    BOOL    isValidauthCode;  //验证码是否过期
}

@property(nonatomic,retain)MSKeyboardScrollView    *scrollView;
@property(nonatomic,retain)UITextField             *authCodeText;
@property(nonatomic,retain)TimerLabel              *timeLab;


@property(nonatomic,retain)NSString     *phoneNumber;
@property(nonatomic,retain)NSString     *password;
@property(nonatomic,retain)NSString     *authCode;
@property(nonatomic,retain)NSString     *timeout;

@property(nonatomic,assign)BOOL         isRegister;
@property(nonatomic,assign)BOOL         isForget;


@property(nonatomic,retain)NSString     *sessionID;

@end

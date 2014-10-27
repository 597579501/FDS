//
//  FDSChangePwdViewController.h
//  FDS
//
//  Created by zhuozhongkeji on 14-1-9.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSUserCenterMessageManager.h"

@interface FDSChangePwdViewController : UIViewController<UITextFieldDelegate,FDSUserCenterMessageInterface>

//@property(nonatomic,retain)UITextField   *oldPwd;
@property(nonatomic,retain)UITextField   *newPwd;
@property(nonatomic,retain)UITextField   *repeatNewPwd;

@property(nonatomic,retain)NSString      *phoneNum; //手机号

@property(nonatomic,retain)NSString      *newPassword; //新密码
@property(nonatomic,retain)NSString      *sessionID; 

@end

//
//  FDSForgetPwdViewController.h
//  FDS
//
//  Created by zhuozhong on 14-4-8.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDSForgetPwdViewController : UIViewController<UITextFieldDelegate>


@property(nonatomic,retain) UITextField              *phoneText;

@property(nonatomic,retain) NSString                 *phoneNum;

@end

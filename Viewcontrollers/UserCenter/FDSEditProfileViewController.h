//
//  FDSEditProfileViewController.h
//  FDS
//
//  Created by zhuozhongkeji on 14-1-22.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSUserCenterMessageManager.h"
#import "MSKeyboardScrollView.h"

@protocol ProfileRefreshDelegate <NSObject>

@optional
- (void)didRefreshCurrPage;

@end

@interface FDSEditProfileViewController : UIViewController<UITextFieldDelegate,FDSUserCenterMessageInterface>
{
}
@property(nonatomic,strong)MSKeyboardScrollView  *scrollView;
@property(nonatomic,strong)UITextField           *dataField;

@property(nonatomic,strong)NSString              *titleStr;
@property(nonatomic,strong)NSString              *contentStr;
@property(nonatomic,strong)NSString              *modifyContent;
@property(nonatomic,assign)id<ProfileRefreshDelegate> delegate;
@property(nonatomic,assign)enum MODIFY_PROFILE   modifyStyle;
@end

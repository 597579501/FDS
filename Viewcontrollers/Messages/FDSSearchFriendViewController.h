//
//  FDSSearchFriendViewController.h
//  FDS
//
//  Created by zhuozhong on 14-2-17.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSUserCenterMessageManager.h"
#import "MSKeyboardScrollView.h"

enum ADD_FRIEND_STYLE
{
    ADD_FRIEND_STYLE_NONE,
    ADD_FRIEND_STYLE_CONTACT,
    ADD_FRIEND_STYLE_COMPANY,
    MODIFY_FRIEND_REMARK_NAME,
    ADD_FRIEND_STYLE_MAX
};

@interface FDSSearchFriendViewController : UIViewController<UITextFieldDelegate,FDSUserCenterMessageInterface>
{
}

@property(nonatomic,strong)MSKeyboardScrollView  *scrollView;
@property(nonatomic,strong)UITextField           *dataField;

@property(nonatomic,assign)enum ADD_FRIEND_STYLE      addStyle;

@property(nonatomic,retain)FDSUser   *friendInfo;

@property(nonatomic,retain) NSString*     modifyText;

@end

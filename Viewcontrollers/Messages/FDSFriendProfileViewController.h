//
//  FDSFriendProfileViewController.h
//  FDS
//
//  Created by zhuozhong on 14-2-18.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSUser.h"
#import "FDSUserCenterMessageManager.h"
#import "EGOImageView.h"

@interface FDSFriendProfileViewController : UIViewController<UIAlertViewDelegate,UIActionSheetDelegate,FDSUserCenterMessageInterface>
{
}
@property(nonatomic,retain)FDSUser   *friendInfo;

@property(nonatomic,assign)BOOL isExist ;//本地是否存在当前联系人

@property(nonatomic,retain)UILabel        *nameLab;
@property(nonatomic,retain)UIImageView    *sexImg;
@property(nonatomic,retain)EGOImageView   *headImg;
@property(nonatomic,retain)UILabel        *companyLab;
@property(nonatomic,retain)UILabel        *jobLab;
@property(nonatomic,retain)UIScrollView   *pageScroll;

@property(nonatomic,assign)BOOL           refreshNavbar;

@end

//
//  FDSMeProfileViewController.h
//  FDS
//
//  Created by zhuozhongkeji on 14-1-13.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSEditProfileViewController.h"
#import "ZZUploadManager.h"

@interface FDSMeProfileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ProfileRefreshDelegate,ZZUploadInterface,FDSUserCenterMessageInterface>
{
    NSArray    *titleArr;
    BOOL       isRefresh;
}
@property(nonatomic,strong) UITableView     *meInfoTable;

@property(nonatomic,retain)NSString   *modifyContent;

@end

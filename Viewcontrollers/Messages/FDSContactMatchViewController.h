//
//  FDSContactMatchViewController.h
//  FDS
//
//  Created by zhuozhong on 14-3-19.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "FDSUserCenterMessageManager.h"
#import "MsgCenterTableViewCell.h"

@interface FDSContactMatchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate,FDSUserCenterMessageInterface,ContactDetailDelegate>
{
    UITableView       *contactTableView;
    NSMutableArray    *addressBookList;
    
    NSArray           *allContactList;
}

@end

//
//  FDSSearchViewController.h
//  FDS
//
//  Created by zhuozhongkeji on 13-12-24.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSCompanyMessageManager.h"
#import "DropDownView.h"

@interface FDSSearchViewController : UIViewController<UITextFieldDelegate,FDSCompanyMessageInterface,DropDownViewDelegate>
{
    UITextField         *searchText;
    DropDownView        *menuDropView;
    UILabel             *showLab;
    
    UIImageView         *imageView; //三角的背景
    
    UIView              *bgView;
}

@property(nonatomic,retain) NSString   *typeStr;

@property(nonatomic,retain) NSMutableArray   *wordsList;

@end

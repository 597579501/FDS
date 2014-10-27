//
//  FDSHomePageViewController.h
//  FDS
//
//  Created by zhuozhong on 13-12-3.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHADScrollView.h"
#import "ZZSessionManager.h"
#import "FDSCompanyMessageManager.h"

@interface FDSHomePageViewController : UIViewController<XHADScrollViewDatasource,XHADScrollViewDelegate,FDSCompanyMessageInterface,ZZSessionManagerInterface,ZZSocketInterface>
{
    UIScrollView *_ScrollView;
    UIScrollView *_ScrollView1;
    
    XHADScrollView      *xhaScroll;
    
    UIView              *networkView; //网络是否可用提示
}

@property(nonatomic,retain) NSMutableArray      *homeData;

@end

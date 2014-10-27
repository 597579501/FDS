//
//  FDSGuideViewController.h
//  FDS
//
//  Created by zhuozhong on 14-3-12.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDSGuideViewController : UIViewController<UIScrollViewDelegate>
{
	UIScrollView					*scrollview;
    NSInteger                       pageIndex;
}

@property(nonatomic,assign)  BOOL isFirstLunch; //是否首次从首页切入

@end

//
//  FDSMyFavoritesViewController.h
//  FDS
//
//  Created by zhuozhongkeji on 14-1-13.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDSMyFavoritesViewController : UIViewController

@property(nonatomic,strong) UIScrollView     *pageScroll;
@property(nonatomic,strong) UIImageView      *bgView;
@property(nonatomic,retain) NSMutableArray   *collectTotalArr;

@end

//
//  UnLoginView.h
//  FDS
//
//  Created by zhuozhongkeji on 14-1-21.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginBtnDelegate <NSObject>
- (void)didselectLogin;
@end

@interface UnLoginView : UIView

@property(nonatomic,assign)id<LoginBtnDelegate>   delegate;

@end

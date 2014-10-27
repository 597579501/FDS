//
//  ButtomMenuView.h
//  FDS
//
//  Created by zhuozhongkeji on 14-1-17.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OperSNSBtnDelegate <NSObject>
- (void)didSNSWithTag:(NSInteger)currTag;
@end

@interface ButtomMenuView : UIView
{
    NSArray   *_operDataArr;
}
@property(nonatomic,assign)id<OperSNSBtnDelegate> delegate;
- (id)initWithFrame:(CGRect)frame withDataArr:(NSArray*)arr;

@end

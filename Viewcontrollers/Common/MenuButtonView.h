//
//  MenuButtonView.h
//  FDS
//
//  Created by zhuozhong on 14-3-14.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SingleButtonDelegate <NSObject>

- (void)didSelectedBtnWithTag:(NSInteger)currentTag;

@end

@interface MenuButtonView : UIView
{
    UIView       *indicatorImage;
    UILabel      *titleLab;
    
    UIScrollView *scrollView;
}

@property(nonatomic,assign)NSInteger      selectIndex; //选中button
@property(nonatomic,assign)NSInteger      spaceWidth;//间隔空隙

@property(nonatomic,assign)id<SingleButtonDelegate> delegate;


- (id)initWithFrame:(CGRect)frame :(NSArray*)typeArr :(NSInteger)spaceWidth;

@end

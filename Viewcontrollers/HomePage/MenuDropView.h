//
//  MenuDropView.h
//  FDS
//
//  Created by zhuozhongkeji on 13-12-27.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuDropBtnDelegate <NSObject>
- (void)handleButtonWithTag:(NSInteger)currTag :(NSString*)title;
@end


@interface MenuDropView : UIView

@property (retain, nonatomic) NSArray       *menu_titles;
@property (retain, nonatomic) UIScrollView  *scrollView;
@property (assign,nonatomic) id<MenuDropBtnDelegate> delegate;

-(id)initWithFrame:(CGRect)frame withTitles:(NSArray *)arr;

@end

//
//  MenuScrollView.h
//  SP2P
//
//  Created by xuym on 13-8-1.
//  Copyright (c) 2013年 sls001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuBtnDelegate <NSObject>
- (void)didSelectedButtonWithTag:(NSInteger)currTag;
@end

@interface MenuScrollView : UIView<UIScrollViewDelegate>
{
}
@property (retain, nonatomic) UIScrollView  *scrollView;
@property (retain, nonatomic) UIView        *indicatorImage;

@property (retain, nonatomic) NSArray       *menu_titles;

@property (assign, nonatomic) BOOL          hiddenimage;
@property (assign, nonatomic) NSInteger     selectIndex;
@property (assign, nonatomic) id<MenuBtnDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withTitles:(NSArray *)arr;
- (id)initWithFrame:(CGRect)frame withTitles:(NSArray *)arr WithBOOL:(BOOL)ishidden;
- (void)changeMenuState:(NSInteger)index;

@end

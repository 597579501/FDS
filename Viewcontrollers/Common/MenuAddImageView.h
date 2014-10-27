//
//  MenuAddImageView.h
//  FDS
//
//  Created by saibaqiao on 14-3-15.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuAddBtnDelegate <NSObject>

@optional
- (void)didSelectImagePicker;

- (void)notifyPageLayout:(NSInteger)moveHeight;

@end

@interface MenuAddImageView : UIView
{
    UIScrollView   *scrollView;
    UIButton       *addButton;
    NSInteger      spaceWidth;
}

@property(nonatomic,retain) NSMutableArray   *imageList;
@property(nonatomic,assign) id<MenuAddBtnDelegate> delegate;

- (id)initWithFrame:(CGRect)frame :(NSInteger)space;

@property(nonatomic,assign)NSInteger   totalNum;  //允许图片最大总数

/*  添加一张图片 */
- (void)handleImageAdd:(UIImage*)image :(NSData*)imageData;

@end

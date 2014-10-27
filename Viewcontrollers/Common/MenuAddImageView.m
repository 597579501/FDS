//
//  MenuAddImageView.m
//  FDS
//
//  Created by saibaqiao on 14-3-15.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "MenuAddImageView.h"
#import "Constants.h"
#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@implementation MenuAddImageView

- (id)initWithFrame:(CGRect)frame :(NSInteger)space
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageList = [[NSMutableArray alloc] init];
        spaceWidth = space;
        [self menuAddViewInit];
    }
    return self;
}

- (void)menuAddViewInit
{
    self.backgroundColor = COLOR(225, 227, 226, 1);
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kMSScreenWith, self.frame.size.height)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor clearColor];
    
    float width = 58;
    addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setFrame:CGRectMake(spaceWidth, 5, width, width)];
    [addButton addTarget:self action:@selector(btnAddImagePressed) forControlEvents:UIControlEventTouchUpInside];
    [addButton setBackgroundImage:[UIImage imageNamed:@"send_image_add"] forState:UIControlStateNormal];
    [scrollView addSubview:addButton];
    
    [self addSubview:scrollView];
    [scrollView release];
}

/*  点击添加 */
- (void)btnAddImagePressed
{
    if ([self.delegate  respondsToSelector:@selector(didSelectImagePicker)])
    {
        [self.delegate didSelectImagePicker];
    }
}

/*  添加一张图片 */
- (void)handleImageAdd:(UIImage*)image :(NSData*)imageData
{
    NSInteger btncount = [_imageList count];
    
    NSInteger num = (btncount+1)/5;
    
    NSInteger row = (btncount+1)%5;
    if(0 == row)
    {
        CGRect rect = self.frame;
        rect.size = CGSizeMake(kMSScreenWith, 68+(58+5)*num);
        self.frame = rect;
        
        rect = scrollView.frame;
        rect.size = CGSizeMake(kMSScreenWith, 68+(58+5)*num);
        scrollView.frame = rect;
        
        addButton.frame = CGRectMake(5, 68+63*(num-1), 58, 58);
        
        if ([self.delegate respondsToSelector:@selector(notifyPageLayout:)])
        {
            /*  delegate to vc */
            [self.delegate notifyPageLayout:58+5];
        }
    }
    else if(_totalNum - 1 <= btncount)
    {
        addButton.hidden = YES;
    }
    else
    {
        CGRect rect = addButton.frame;
        rect.origin.x += spaceWidth+58;
        addButton.frame = rect;
    }
    
//    UIImageView *imageBtn = nil;
//    if (btncount <= 4)
//    {
       UIImageView *imageBtn = [[UIImageView alloc] initWithFrame:CGRectMake((spaceWidth+58)*(btncount-(btncount/5)*5)+spaceWidth, 5+63*(btncount/5), 58, 58)];
//    }
//    else
//    {
//        imageBtn = [[UIImageView alloc] initWithFrame:CGRectMake((spaceWidth+58)*(btncount-5)+spaceWidth, 68, 58, 58)];
//    }
    imageBtn.userInteractionEnabled = YES;
    imageBtn.tag = btncount;
    imageBtn.image = image;
    [scrollView addSubview:imageBtn];
    [imageBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
    [imageBtn release];

    [_imageList addObject:imageData];
}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    int count = [_imageList count];
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.srcImageView = scrollView.subviews[i+1]; // 来源于哪个UIImageView
        photo.image = ((UIImageView*)scrollView.subviews[i+1]).image;
        [photos addObject:photo];
        [photo release];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    [browser release];
}

- (void)dealloc
{
    [self.imageList removeAllObjects];
    self.imageList = nil;
    
    [super dealloc];
}

@end

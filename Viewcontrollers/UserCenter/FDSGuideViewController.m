//
//  FDSGuideViewController.m
//  FDS
//
//  Created by zhuozhong on 14-3-12.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSGuideViewController.h"
#import "Constants.h"
#import "AppDelegate.h"

@interface FDSGuideViewController ()

@end

@implementation FDSGuideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isFirstLunch  = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.navigationController.navigationBarHidden = YES;
    if(IOS_7)
    {
        [self.navigationController.navigationBar setTranslucent:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBarHidden = NO;
    if(IOS_7)
    {
        [self.navigationController.navigationBar setTranslucent:YES];
    }
}

- (void)dealloc
{
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kMSScreenWith, kMSGUIDESCREENHEIGHT)];
    for (int i = 0; i < 4; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * 320, 0, kMSScreenWith, kMSGUIDESCREENHEIGHT)];
        if(DEVICE_IS_IPHONE5)
        {
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"0%d_guide", i + 1]];
        }
        else
        {
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"0%d_guide_small", i + 1]];
        }
        [scrollview addSubview:imageView];
        [imageView release];
    }
    [scrollview setContentSize:CGSizeMake(kMSScreenWith * 4, kMSGUIDESCREENHEIGHT)];

    scrollview.pagingEnabled = YES;
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.bounces = NO;
    scrollview.delegate = self;
    [self.view addSubview:scrollview];
    [scrollview release];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGes:)];
    tap.cancelsTouchesInView=NO;
    [scrollview addGestureRecognizer:tap];
    [tap release];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    pageIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

- (void)handleGes:(UIGestureRecognizer *)guestureRecognizer
{
    if (3 == pageIndex)
    {
        if (_isFirstLunch)
        {
            AppDelegate * delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [delegate.window addSubview:delegate.tabBarController.view];
            delegate.window.rootViewController= delegate.tabBarController;
            [delegate.tabBarController release];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


@end

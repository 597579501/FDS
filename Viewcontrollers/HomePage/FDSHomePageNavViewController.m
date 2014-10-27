//
//  FDSHomePageNavViewController.m
//  FDS
//
//  Created by zhuozhong on 13-12-3.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "FDSHomePageNavViewController.h"

@interface FDSHomePageNavViewController ()

@end

@implementation FDSHomePageNavViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (!rootViewController)
        {
            rootViewController = [[FDSHomePageViewController alloc] init];
        }
        [self pushViewController:rootViewController animated:NO];
        return self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)dealloc
{
    [rootViewController release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

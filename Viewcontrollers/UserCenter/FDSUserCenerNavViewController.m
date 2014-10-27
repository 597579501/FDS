//
//  FDSUserCenerNavViewController.m
//  FDS
//
//  Created by zhuozhong on 13-12-3.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "FDSUserCenerNavViewController.h"

@interface FDSUserCenerNavViewController ()

@end

@implementation FDSUserCenerNavViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        rootViewController = [[FDSUserCenterViewController alloc] init];
        [self pushViewController:rootViewController animated:NO];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [rootViewController release];
    [super dealloc];
}

@end

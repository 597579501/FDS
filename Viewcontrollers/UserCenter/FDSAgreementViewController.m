//
//  FDSAgreementViewController.m
//  FDS
//
//  Created by zhuozhong on 14-4-9.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSAgreementViewController.h"
#import "UIViewController+BarExtension.h"
#import "Constants.h"

@interface FDSAgreementViewController ()

@end

@implementation FDSAgreementViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self homeNavbarWithTitle:@"注册协议" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    NSString *txtPath = [[NSBundle mainBundle] pathForResource:@"register" ofType:@"txt"];
    //    将txt到string对象中，编码类型为NSUTF8StringEncoding
    NSString *string = [[NSString  alloc] initWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:nil];

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith, kMSTableViewHeight-44)];
    scrollView.backgroundColor = COLOR(234, 234, 234, 1);
    [self.view addSubview:scrollView];
    [scrollView release];
    
    UITextView *text = [[UITextView alloc]initWithFrame:CGRectMake(5, 0, 310, kMSTableViewHeight-44)];
    text.backgroundColor = [UIColor clearColor];
    text.editable = NO;
    text.text = string;
    text.textColor = COLOR(69, 69, 69, 1);
    text.font = [UIFont systemFontOfSize:14];
    [scrollView addSubview:text];
    [text release];
    
    [string release];
	// Do any additional setup after loading the view.
}





@end

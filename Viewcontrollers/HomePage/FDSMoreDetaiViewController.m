//
//  FDSMoreDetaiViewController.m
//  FDS
//
//  Created by zhuozhongkeji on 13-12-24.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "FDSMoreDetaiViewController.h"
#import "UIViewController+BarExtension.h"
#import "Constants.h"
#import "EGOImageView.h"

@interface FDSMoreDetaiViewController ()

@end

@implementation FDSMoreDetaiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.companyInfo = nil;
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
    self.companyInfo = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = COLOR(234, 234, 234, 1);
    
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self homeNavbarWithTitle:@"公司简介" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    
    EGOImageView *companyLogoImg = [[EGOImageView alloc] initWithFrame:CGRectMake(10, kMSNaviHight+20, 60, 60)];
    companyLogoImg.layer.borderWidth = 1;
    companyLogoImg.layer.cornerRadius = 4.0;
    companyLogoImg.layer.masksToBounds=YES;
    companyLogoImg.layer.borderColor = [[UIColor colorWithRed:242.0f/255 green:242.0f/255 blue:242.0f/255 alpha:1.0f] CGColor];
    [companyLogoImg initWithPlaceholderImage:[UIImage imageNamed:@"send_image_default"]];
    companyLogoImg.imageURL = [NSURL URLWithString:_companyInfo.m_companyIcon];
    companyLogoImg.userInteractionEnabled = YES;
    [self.view addSubview:companyLogoImg];
    [companyLogoImg release];

    UILabel *companyNameLab = [[UILabel alloc] initWithFrame:CGRectMake(70+10, kMSNaviHight+20, 235, 60)];
    companyNameLab.backgroundColor = [UIColor clearColor];
    companyNameLab.textColor = [UIColor blackColor];
    companyNameLab.numberOfLines = 2;
    companyNameLab.font = [UIFont systemFontOfSize:17.0f];
    companyNameLab.text = _companyInfo.m_companyNameZH;
    [self.view addSubview:companyNameLab];
    [companyNameLab release];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, kMSNaviHight+90, kMSScreenWith-10,kMSTableViewHeight-44-110)];
    bgView.image = [[UIImage imageNamed:@"round_white_cellbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
    [bgView release];
    
    UITextView *textview = [[UITextView alloc] initWithFrame:CGRectMake(5, 1, kMSScreenWith-20, kMSTableViewHeight-44-112)];
    textview.editable = NO;
    textview.textColor = COLOR(31, 31, 31, 1);
    textview.font = [UIFont systemFontOfSize:14];
    textview.text = _companyInfo.m_briefInfo;
    [bgView addSubview:textview];
    [textview release];
    // Do any additional setup after loading the view.
}

@end

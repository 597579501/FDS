//
//  FDSSearchViewController.m
//  FDS
//
//  Created by zhuozhongkeji on 13-12-24.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "FDSSearchViewController.h"
#import "UIViewController+BarExtension.h"
#import "FDSPublicManage.h"
#import "FDSComListViewController.h"
#import "FDSShowProductViewController.h"
#import "FDSShowSchemeViewController.h"
#import "FDSShowDesignerViewController.h"

@interface FDSSearchViewController ()

@end

@implementation FDSSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.typeStr = @"company";
        self.wordsList = nil;
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
    self.typeStr = nil;
    [self.wordsList removeAllObjects];
    self.wordsList = nil;

    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[FDSCompanyMessageManager sharedManager]registerObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[FDSCompanyMessageManager sharedManager]unRegisterObserver:self];
    
    if ([searchText isFirstResponder])
    {
        [searchText resignFirstResponder];
    }
    [menuDropView hide];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self homeNavbarWithTitle:@"黄页" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    /*搜索框*/
    UIImageView *searchImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith, 50)];
    searchImgView.userInteractionEnabled = YES;
    searchImgView.image = [UIImage imageNamed:@"yellow_searview_bg"];
    [self.view addSubview:searchImgView];
    [searchImgView release];
    
    UIImageView *bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 190, 40)];
    bgImg.image = [[UIImage imageNamed:@"yellow_search_rect"]resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    bgImg.userInteractionEnabled = YES;
    [searchImgView addSubview:bgImg];
    [bgImg release];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 5, 30, 30)];
    iconView.image = [UIImage imageNamed:@"search_msg_bg"];
    [bgImg addSubview:iconView];
    [iconView release];
    
    searchText = [[UITextField alloc] initWithFrame:CGRectMake(32, 5+KFDSTextOffset, 190-32, 30)];
    searchText.delegate = self;
    searchText.borderStyle = UITextBorderStyleNone;
    searchText.font = [UIFont systemFontOfSize:16.0f];
    searchText.textColor = kMSTextColor;
    searchText.placeholder = @"请输入关键字";
    searchText.returnKeyType = UIReturnKeySearch;
    searchText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [bgImg addSubview:searchText];
    [searchText release];
    /*搜索框*/

    /* 企业下拉 */
    UIImageView *showTextImg = [[UIImageView alloc] initWithFrame:CGRectMake(210, 5, 55, 40)];
    showTextImg.image = [UIImage imageNamed: @"search_left_bg"] ;
    showTextImg.userInteractionEnabled = YES;
    [searchImgView addSubview:showTextImg];
    [showTextImg release];

    showLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 55, 30)];
    showLab.backgroundColor= [UIColor clearColor];
    showLab.text = @"企业";
    showLab.textAlignment = NSTextAlignmentCenter;
    [showLab setFont:[UIFont systemFontOfSize:14.0]];
    showLab.textColor = [UIColor blackColor];
    [showTextImg addSubview:showLab];
    [showLab release];

    UIButton *dropBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dropBtn setFrame:CGRectMake(265, 5, 45, 40)];
    [dropBtn setBackgroundImage:[UIImage imageNamed:@"show_drop_normal_bg"] forState:UIControlStateNormal];
    [dropBtn setBackgroundImage:[UIImage imageNamed:@"show_drop_hl_bg"] forState:UIControlStateHighlighted];
    [dropBtn addTarget:self action:@selector(btnPressedItem) forControlEvents:UIControlEventTouchUpInside];
    [searchImgView addSubview:dropBtn];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 15, 15)];
    imageView.image = [UIImage imageNamed:@"search_drop_hidden"];
    [dropBtn addSubview:imageView];
    [imageView release];
    /* 企业下拉 */
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kMSNaviHight+50, kMSScreenWith, kMSTableViewHeight-44-kMSNaviHight-50)];
    bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgView];
    [bgView release];
    
    menuDropView = [[DropDownView alloc] initWithFrame:CGRectMake(200, kMSNaviHight+45, 120, 176) Items:[NSArray arrayWithObjects:@"企业",@"产品",@"案例",@"设计师", nil]];
    menuDropView.delegate = self;
    [self.view addSubview:menuDropView];
    [menuDropView hide];
    [menuDropView release];

//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGes:)];
//    tap.cancelsTouchesInView=NO;
//    [bgView addGestureRecognizer:tap];
//    [tap release];

    [[FDSCompanyMessageManager sharedManager]getSystemHotWords:self.typeStr];
	// Do any additional setup after loading the view.
}

- (void)handleGes:(UIGestureRecognizer *)guestureRecognizer
{
    [menuDropView hide];
    if ([searchText isFirstResponder])
    {
        [searchText resignFirstResponder];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [menuDropView hide];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *text = [searchText.text stringByTrimmingCharactersInSet:whitespace];
    if (text && 0 >= text.length)
    {
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"搜索内容不能为空"];
        return YES;
    }
    searchText.text = nil;
    if ([self.typeStr isEqualToString:@"company"])
    {
        /*  企业列表  */
        FDSComListViewController *fdsCpage = [[FDSComListViewController alloc]init];
        fdsCpage.titStr = @"公司列表";
        fdsCpage.typeId = text;
        fdsCpage.showType = @"key";
        [self.navigationController pushViewController:fdsCpage animated:YES];
        [fdsCpage release];
    }
    else if ([self.typeStr isEqualToString:@"product"])
    {
        /*  产品列表  */
        FDSShowProductViewController *showVC = [[FDSShowProductViewController alloc]init];
        showVC.com_ID = text;
        showVC.isSearch = YES;
        [self.navigationController pushViewController:showVC animated:YES];
        [showVC release];
    }
    else if ([self.typeStr isEqualToString:@"sucessfullcase"])
    {
        /*  案例列表  */
        FDSShowSchemeViewController *showVC = [[FDSShowSchemeViewController alloc]init];
        showVC.com_ID = text;
        showVC.isSearch = YES;
        [self.navigationController pushViewController:showVC animated:YES];
        [showVC release];
    }
    else if ([self.typeStr isEqualToString:@"designer"])
    {
        /*  设计师列表  */
        FDSShowDesignerViewController *showVC = [[FDSShowDesignerViewController alloc]init];
        showVC.com_ID = text;
        showVC.isSearch = YES;
        [self.navigationController pushViewController:showVC animated:YES];
        [showVC release];
    }

    return YES;
}

- (void)btnPressedItem
{
    if (menuDropView.hidden)
    {
        imageView.image = [UIImage imageNamed:@"search_drop_show"];
        if ([searchText isFirstResponder])
        {
            [searchText resignFirstResponder];
        }
        [menuDropView show];
    }
    else
    {
        imageView.image = [UIImage imageNamed:@"search_drop_hidden"];
        [menuDropView hide];
    }
}

#pragma -mark DropDownViewDelegate method
- (void)dropItemDidSelectedText:(NSString *)text AtIndex:(NSInteger)index
{
    imageView.image = [UIImage imageNamed:@"search_drop_hidden"];
    if (index != menuDropView.selectIndex) //点击相同不发送
    {
        showLab.text = text;
        if ([text isEqualToString:@"企业"])
        {
            self.typeStr = @"company";
        }
        else if ([text isEqualToString:@"产品"])
        {
            self.typeStr = @"product";
        }
        else if ([text isEqualToString:@"案例"])
        {
            self.typeStr = @"sucessfullcase";
        }
        else if ([text isEqualToString:@"设计师"])
        {
            self.typeStr = @"designer";
        }
        [[FDSCompanyMessageManager sharedManager]getSystemHotWords:self.typeStr];
    }
}

/*  得到系统热词 */
- (void)getSystemHotWordsCB:(NSMutableArray *)words
{
    self.wordsList = words;
    
    [self handleHotWordMove];
}

- (void)handleHotWordMove
{
    [UIView beginAnimations:@"ShowHideView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(showHideDidStop:finished:context:)];
    [UIView setAnimationDelay:1.0];
    // Commit the changes and perform the animation.
    
//    for (UIView* tmpView in bgView.subviews)
//    {
//        [tmpView removeFromSuperview];
//    }
//    bgView.alpha = 0.0;

    [UIView commitAnimations];
}


- (void)showHideDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [UIView beginAnimations:@"ShowHideView2" context:nil];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    [UIView setAnimationDuration:1.0];
    
    for (UIView* tmpView in bgView.subviews)
    {
        [tmpView removeFromSuperview];
    }
    bgView.alpha = 0.0;

    for (int i=0; i<self.wordsList.count; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        float width = (5*i+arc4random()%5*50)%(int)(320-40);
        float height = (50*i+arc4random()%10)%(int)(bgView.frame.size.height-50);
        btn.frame = CGRectMake(width,height, 80, 50);
        [btn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [btn setTitle:[self.wordsList objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:(CGFloat)random()/(CGFloat)RAND_MAX green:(CGFloat)random()/(CGFloat)RAND_MAX blue:(CGFloat)random()/(CGFloat)RAND_MAX alpha:1.0f] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnPressedKey:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
    }

    bgView.alpha = 1.0;
    
    [UIView commitAnimations];
}

- (void)btnPressedKey:(id)sender
{
    if ([self.typeStr isEqualToString:@"company"])
    {
        /*  企业列表  */
        FDSComListViewController *fdsCpage = [[FDSComListViewController alloc]init];
        fdsCpage.titStr = @"公司列表";
        fdsCpage.typeId = [self.wordsList objectAtIndex:[sender tag]];
        fdsCpage.showType = @"key";
        [self.navigationController pushViewController:fdsCpage animated:YES];
        [fdsCpage release];
    }
    else if ([self.typeStr isEqualToString:@"product"])
    {
        /*  产品列表  */
        FDSShowProductViewController *showVC = [[FDSShowProductViewController alloc]init];
        showVC.com_ID = [self.wordsList objectAtIndex:[sender tag]];
        showVC.isSearch = YES;
        [self.navigationController pushViewController:showVC animated:YES];
        [showVC release];
    }
    else if ([self.typeStr isEqualToString:@"sucessfullcase"])
    {
        /*  案例列表  */
        FDSShowSchemeViewController *showVC = [[FDSShowSchemeViewController alloc]init];
        showVC.com_ID = [self.wordsList objectAtIndex:[sender tag]];
        showVC.isSearch = YES;
        [self.navigationController pushViewController:showVC animated:YES];
        [showVC release];
    }
    else if ([self.typeStr isEqualToString:@"designer"])
    {
        /*  设计师列表  */
        FDSShowDesignerViewController *showVC = [[FDSShowDesignerViewController alloc]init];
        showVC.com_ID = [self.wordsList objectAtIndex:[sender tag]];
        showVC.isSearch = YES;
        [self.navigationController pushViewController:showVC animated:YES];
        [showVC release];
    }
}


@end

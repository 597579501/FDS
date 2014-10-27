//
//  FDSShowSchemeViewController.m
//  FDS
//
//  Created by zhuozhongkeji on 14-1-6.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSShowSchemeViewController.h"
#import "UIViewController+BarExtension.h"
#import "Constants.h"
#import "FDSSchemeDetailViewController.h"
#import "SVProgressHUD.h"

@interface FDSShowSchemeViewController ()

@end

@implementation FDSShowSchemeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.sucfulList = nil;
        _isSearch = NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[FDSCompanyMessageManager sharedManager] registerObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[FDSCompanyMessageManager sharedManager] unRegisterObserver:self];
}

- (void)dealloc
{
    [_sucfulList removeAllObjects];
    self.sucfulList = nil;
    [_com_ID release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self homeNavbarWithTitle:@"案例展示" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];//@"search_navbar_bg"];
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _schemeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith,kMSTableViewHeight-44) style:UITableViewStylePlain];
    _schemeTable.delegate = self;
    _schemeTable.dataSource = self;
    _schemeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_schemeTable];
    [_schemeTable release];
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_back"]];
    if ([_schemeTable respondsToSelector:@selector(setBackgroundView:)])
    {
        [_schemeTable setBackgroundView:backImg];
    }
    [backImg release];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    if (_isSearch)
    {
        /*  搜索 */
        [[FDSCompanyMessageManager sharedManager] getCompanySuccessfulcaselist:@"key" withCondition:_com_ID];
    }
    else
    {
        [[FDSCompanyMessageManager sharedManager] getCompanySuccessfulcaselist:@"all" withCondition:_com_ID];
    }
    // Do any additional setup after loading the view.
}

#pragma mark - FDSCompanyMessageInterface Method
- (void)getCompanySuccessfulcaselistCB:(NSMutableArray*)successfulcaselist
{
    [SVProgressHUD popActivity];
    self.sucfulList = successfulcaselist;
    [_schemeTable reloadData];
}


#pragma mark - UITableViewDelegate UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_sucfulList)
    {
        return [_sucfulList count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_sucfulList.count-1 == indexPath.row)
    {
        return 171.f+10.f;
    }
    return 171.f+5.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath row];
    static NSString *CellIdentifier = @"SchemeTableViewCell";
    SchemeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[SchemeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    //config the cell
    cell.delegate = self;
    cell.currentIndex = indexPath.row;
    
    FDSComSucCase *sucCase = [_sucfulList objectAtIndex:index];
    cell.schemeLogoImg.placeholderImage = [UIImage imageNamed:@"loading_logo_bg"];
    if (0 < sucCase.m_imagePathArr.count)
    {
//        cell.schemeLogoImg.imageURL = [NSURL URLWithString:[sucCase.m_imagePathArr objectAtIndex:0]];
        NSString *imageUrl = [sucCase.m_imagePathArr objectAtIndex:0];
        if (imageUrl && [imageUrl length]>0)
        {
            NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@",imageUrl];
            if (urlStr.length >= 4)
            {
                [urlStr insertString:@"_middle" atIndex:urlStr.length-4];
            }
            cell.schemeLogoImg.imageURL = [NSURL URLWithString:urlStr];/* 待解决问题  大图片存储处理 */
        }
        else
        {
            cell.schemeLogoImg.image = [UIImage imageNamed:@"loading_logo_bg"];
        }

    }
    cell.schemeNameLab.text = sucCase.m_title;
    return cell;
}

#pragma mark - SchemeDetailDelegate Method
- (void)handleDetailWithIndex:(NSInteger)currIndex
{
    FDSSchemeDetailViewController *fdsVC = [[FDSSchemeDetailViewController alloc]init];
    fdsVC.comSucCaseInfo = [_sucfulList objectAtIndex:currIndex];
    [self.navigationController pushViewController:fdsVC animated:YES];
    [fdsVC release];
}


@end

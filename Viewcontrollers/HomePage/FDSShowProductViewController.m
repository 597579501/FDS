//
//  FDSShowProductViewController.m
//  FDS
//
//  Created by zhuozhongkeji on 13-12-27.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "FDSShowProductViewController.h"
#import "UIViewController+BarExtension.h"
#import "FDSProductDetailViewController.h"
#import "ProductTableViewCell.h"
#import "SVProgressHUD.h"

@interface FDSShowProductViewController ()
{
}
@end

@implementation FDSShowProductViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.titleArr = nil;
        _isSearch = NO;
    }
    return self;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_com_ID release];
    [_titleArr removeAllObjects];
    self.titleArr = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self homeNavbarWithTitle:@"产品展示" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];//@"search_navbar_bg"];

    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    if (_isSearch)
    {
        /* 搜索 */
        NSMutableArray *result = [[NSMutableArray alloc] init];
        self.titleArr = result;
        [result release];
        
        FDSComProduct *product = [FDSComProduct alloc];
        product.m_protypeName = @"全部";
        product.m_protypeID = self.com_ID;
        [_titleArr insertObject:product atIndex:0];
        [product release];
        [self loadAllSubView];
        
        //对userID判断登录与否  首次进入默认拉取全部产品列表（typeID为－1）
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        /* 搜索公司ID为空  com_ID为搜索关键字 */
        [[FDSCompanyMessageManager sharedManager] getCompanyProductList:@"" withComId:@"" withWay:@"key" withCondition:self.com_ID];
    }
    else
    {
        /* 公司详情进入 */
        [[FDSCompanyMessageManager sharedManager] getCompanyProductTypes:@"" withComId:self.com_ID];//对userID判断登录与否
    }
	// Do any additional setup after loading the view.
}

- (void)loadAllSubView
{
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (int i=0; i<_titleArr.count; i++)
    {
        FDSComProduct *product = [_titleArr objectAtIndex:i];
        [tempArr addObject:product.m_protypeName];
    }
    _menuScroll = [[MenuScrollView alloc]initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith, 34) withTitles:tempArr WithBOOL:YES];
    _menuScroll.delegate = self;
    [self.view addSubview:_menuScroll];
    [_menuScroll release];
    [tempArr removeAllObjects];
    [tempArr release];
    
    _contentTable = [[UITableView alloc]initWithFrame:CGRectMake(0, kMSNaviHight+34, kMSScreenWith,kMSTableViewHeight-78) style:UITableViewStylePlain];
    _contentTable.showsVerticalScrollIndicator = NO;
    _contentTable.delegate = self;
    _contentTable.dataSource = self;
    _contentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_contentTable];
    [_contentTable release];
    
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_back"]];
    if ([_contentTable respondsToSelector:@selector(setBackgroundView:)])
    {
        [_contentTable setBackgroundView:backImg];
    }
    [backImg release];
}

#pragma mark FDSCompanyMessageInterface method
- (void)getCompanyProductTypesCB:(NSMutableArray*)result
{
    [SVProgressHUD popActivity];
    self.titleArr = result;
    FDSComProduct *product = [FDSComProduct alloc];
    product.m_protypeName = @"全部";
    product.m_protypeID = @"-1";
    [_titleArr insertObject:product atIndex:0];
    [product release];
    
    [self loadAllSubView];
    //对userID判断登录与否  首次进入默认拉取全部产品列表（typeID为－1）
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [[FDSCompanyMessageManager sharedManager] getCompanyProductList:@"" withComId:self.com_ID withWay:@"type" withCondition:@"-1"];
}

- (void)getCompanyProductListCB:(NSMutableArray*)productInfoArr withCondition:(NSString *)condition
{
    [SVProgressHUD popActivity];
    for (int i=0; i<_titleArr.count; i++)
    {
        FDSComProduct* product = [_titleArr objectAtIndex:i];
        if ([condition isEqualToString:product.m_protypeID])
        {
            product.m_modulesArr = productInfoArr;
            product.suc_productList = YES;
            break;
        }
    }
    [_contentTable reloadData];
}

#pragma mark MenuBtnDelegate
- (void)didSelectedButtonWithTag:(NSInteger)currTag
{
    if (5 <= [_titleArr count])
    {
        if (currTag == [_titleArr count]-1)
        {
            [_menuScroll.scrollView setContentOffset:CGPointMake((currTag-2)*kMSScreenWith/3, _menuScroll.scrollView.contentOffset.y) animated:YES];
        }
        else if(currTag >= 2)
        {
            [_menuScroll.scrollView setContentOffset:CGPointMake((currTag-1)*kMSScreenWith/3, _menuScroll.scrollView.contentOffset.y) animated:YES];
        }
        else
        {
            [_menuScroll.scrollView setContentOffset:CGPointMake(0, _menuScroll.scrollView.contentOffset.y) animated:YES] ;
        }
    }
    //对userID判断登录与否  选择对应typeID
    FDSComProduct *productInfo = [_titleArr objectAtIndex:currTag];
    if (!productInfo.suc_productList)//未获取过
    {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        [[FDSCompanyMessageManager sharedManager] getCompanyProductList:@"" withComId:self.com_ID withWay:@"type" withCondition:productInfo.m_protypeID];
    }
    else
    {
        [_contentTable reloadData];
    }
}

#pragma mark - UITableViewDelegate UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FDSComProduct *productInfo = [_titleArr objectAtIndex:_menuScroll.selectIndex];
    return [productInfo.m_modulesArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath row];
    static NSString *CellIdentifier = @"Cell";
    ProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[ProductTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_cell_bg"]] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    //config the cell
    FDSComProduct *productInfo = [_titleArr objectAtIndex:_menuScroll.selectIndex];

    FDSComProduct *product = [productInfo.m_modulesArr objectAtIndex:index];
    [cell.productImg initWithPlaceholderImage:[UIImage imageNamed:@"send_image_default"]];
    if (product.m_proIcon && product.m_proIcon.length >= 4)
    {
        NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@",product.m_proIcon];
        if (urlStr.length >= 4)
        {
            [urlStr insertString:@"_middle" atIndex:urlStr.length-4];
        }
        cell.productImg.imageURL = [NSURL URLWithString:urlStr];
    }
    cell.productName.text = product.m_proName;
    cell.productPrice.text = [NSString stringWithFormat:@"%.2f",[product.m_price floatValue]];
    cell.productStyle.text = [NSString stringWithFormat:@"浏览量: %@",product.m_browserNumber];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath row];
    FDSProductDetailViewController *fdsVC = [[FDSProductDetailViewController alloc]init];
    FDSComProduct *productInfo = [_titleArr objectAtIndex:_menuScroll.selectIndex];
    FDSComProduct *product = [productInfo.m_modulesArr objectAtIndex:index];
    fdsVC.productID = product.m_productID;
    fdsVC.companyID = self.com_ID;
    [self.navigationController pushViewController:fdsVC animated:YES];
    [fdsVC release];
}

@end

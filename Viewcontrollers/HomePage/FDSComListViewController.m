//
//  FDSComListViewController.m
//  FDS
//
//  Created by zhuozhongkeji on 13-12-23.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "FDSComListViewController.h"
#import "FDSCompanyDetailViewController.h"
#import "UIViewController+BarExtension.h"
#import "RecoreListCell.h"
#import "SVProgressHUD.h"

@interface FDSComListViewController ()

@end

@implementation FDSComListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.pageDataArr = nil;
        
        self.typeId = nil;
        self.titStr = nil;
        self.showType = nil;
    }
    return self;
}

- (void)dealloc
{
    self.typeId = nil;
    self.titStr = nil;
    self.showType = nil;
    
    [_pageDataArr removeAllObjects];
    self.pageDataArr = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self homeNavbarWithTitle:_titStr andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    [self tableviewInit];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [[FDSCompanyMessageManager sharedManager] getCompanyList:_showType :_typeId];
	// Do any additional setup after loading the view.
}

- (void)tableviewInit
{
    _tableDataView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith,kMSTableViewHeight-44) style:UITableViewStylePlain];
    _tableDataView.showsVerticalScrollIndicator = NO;
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _tableDataView.delegate = self;
    _tableDataView.dataSource = self;
    _tableDataView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableDataView];
    [_tableDataView release];
}

#pragma mark - FDSCompanyMessageInterface Method
-(void)getCompanyListCB:(NSMutableArray*)result
{
    [SVProgressHUD popActivity];
    self.pageDataArr = result;
    [_tableDataView reloadData];
}

#pragma mark - UITableViewDelegate UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 >= _pageDataArr.count)
    {
        return 0;
    }
    return [_pageDataArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath row];
    static NSString *CellIdentifier = @"Cell";
    RecoreListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[RecoreListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier addLine:NO] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_cell_bg"]] autorelease];
    }
    //config the cell
    FDSCompany *showCompany = [_pageDataArr objectAtIndex:index];
    cell.imgView.frame = CGRectMake(10, 10, 30, 30);
    cell.contentLab.frame = CGRectMake(50, 5, 250, 40);

    [cell.imgView initWithPlaceholderImage:[UIImage imageNamed:@"send_image_default"]]; 
    [cell.imgView setImageURL:[NSURL URLWithString:showCompany.m_comIcon]] ;
    cell.contentLab.text = showCompany.m_comName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath row];
    FDSCompanyDetailViewController *fdsDpage = [[FDSCompanyDetailViewController alloc]init];
    FDSCompany *showCompany = [_pageDataArr objectAtIndex:index];
    fdsDpage.companyID = showCompany.m_comId;
    fdsDpage.comName = showCompany.m_comName;

    [self.navigationController pushViewController:fdsDpage animated:YES];
    [fdsDpage release];
}

@end

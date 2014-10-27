//
//  FDSRecordListViewController.m
//  FDS
//
//  Created by zhuozhongkeji on 13-12-23.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "FDSRecordListViewController.h"
#import "RecoreListCell.h"
#import "UIViewController+BarExtension.h"
#import "FDSComListViewController.h"
#import "SVProgressHUD.h"

@interface FDSRecordListViewController ()

@end

@implementation FDSRecordListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.firstTypeID = nil;
        self.pageDataArr = nil;
        self.titStr = nil;
    }
    return self;
}

- (void)dealloc
{
    self.firstTypeID = nil;
    self.titStr = nil;

    [self.pageDataArr removeAllObjects];
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
    self.view.backgroundColor = COLOR(234, 234, 234, 1);

    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self homeNavbarWithTitle:_titStr andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [[FDSCompanyMessageManager sharedManager]getCompanySencondTypeByFirstType:self.firstTypeID];
	// Do any additional setup after loading the view.
}

- (void)getCompanySencondTypeByFirstTypeCB:(NSMutableArray *)recordList
{
    [SVProgressHUD popActivity];
    self.pageDataArr = recordList;
    [self tableviewInit];
}

- (void)tableviewInit
{
    _tableDataView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith,kMSTableViewHeight-44) style:UITableViewStylePlain];
    _tableDataView.showsVerticalScrollIndicator = NO;
    _tableDataView.delegate = self;
    _tableDataView.dataSource = self;
    _tableDataView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableDataView];
    [_tableDataView release];
}

#pragma mark - UITableViewDelegate UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    FDSCompany *typeInfo = [_pageDataArr objectAtIndex:index];
    cell.imgView.frame = CGRectMake(10, 10, 30, 30);
    cell.contentLab.frame = CGRectMake(50, 5, 250, 40);
    [cell.imgView initWithPlaceholderImage:[UIImage imageNamed:@"send_image_default"]];
    cell.imgView.imageURL = [NSURL URLWithString:typeInfo.m_comIcon];
    cell.contentLab.text = typeInfo.m_comName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath row];
    FDSComListViewController *fdsCpage = [[FDSComListViewController alloc]init];
    FDSCompany *typeInfo = [_pageDataArr objectAtIndex:index];
    fdsCpage.titStr = typeInfo.m_comName;
    fdsCpage.typeId = typeInfo.m_comId;
    fdsCpage.showType = @"type";
    [self.navigationController pushViewController:fdsCpage animated:YES];
    [fdsCpage release];
}

@end

//
//  FDSYellowPageViewController.m
//  FDS
//
//  Created by zhuozhongkeji on 13-12-23.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "FDSYellowPageViewController.h"
#import "UIViewController+BarExtension.h"
#import "FDSRecordListViewController.h"
#import "FDSCompanyDetailViewController.h"
#import "SVProgressHUD.h"
#import "FDSSearchViewController.h"

@interface FDSYellowPageViewController ()
{
    UITableViewCell    *_titleCell;
    RecommendCell      *_recommendCell;
}
@end

@implementation FDSYellowPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSString *pliststr = [[NSBundle mainBundle] pathForResource:@"FDSDataManage" ofType:@"plist"];
        NSDictionary *fileDic = [NSDictionary dictionaryWithContentsOfFile:pliststr];
        _pageDataArr = [[NSMutableArray alloc]initWithArray:[fileDic objectForKey:@"enterpriseManage"]];
        self.companyList = nil;
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
    [[FDSCompanyMessageManager sharedManager]registerObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[FDSCompanyMessageManager sharedManager]unRegisterObserver:self];
}

- (void)dealloc
{
    [_companyList removeAllObjects];
    self.companyList = nil;
    [_tableDataView release];
    [_titleCell release];
    [_recommendCell release];
    [_pageDataArr release];
    [super dealloc];
}

- (void)handleRightEvent
{
    FDSSearchViewController *searchVC = [[FDSSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
    [searchVC release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self homeNavbarWithTitle:@"黄页" andLeftButtonName:@"btn_caculate" andRightButtonName:@"search_navbar_bg"];
    [self tableviewInit];
    [self AllStyleCellInit];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [[FDSCompanyMessageManager sharedManager] getSystemRecommendCompanys];
	// Do any additional setup after loading the view.
}

- (void)recommandCellInit
{
    //**********_recommendCell*******
    _recommendCell = [[RecommendCell alloc]initScrollView:self.companyList reuseIdentifier:@"bottomCell_Y"] ;
    _recommendCell.scrollDelegate = self;
    
    _recommendCell.backgroundColor = [UIColor clearColor];
    _recommendCell.selectionStyle=UITableViewCellSelectionStyleNone;
    _recommendCell.moreLab.text = @"推荐企业";
}

- (void)tableviewInit
{
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _tableDataView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith,kMSTableViewHeight-44) style:UITableViewStylePlain];
    _tableDataView.showsVerticalScrollIndicator = NO;
    _tableDataView.delegate = self;
    _tableDataView.dataSource = self;
    _tableDataView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableDataView];
}


- (void)AllStyleCellInit
{
    //**********_titleCell*******
    _titleCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleCell_Y"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 18, 18)];
    imgView.image =[UIImage imageNamed:@"yellow_head_bg"];
    [_titleCell.contentView addSubview:imgView];
    [imgView release];
    
    UILabel *tmpLab = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 260, 30)];
    tmpLab.backgroundColor = [UIColor clearColor];
    tmpLab.text = [NSString stringWithFormat:@"全部分类"];
    tmpLab.textColor = kMSTextColor;
    tmpLab.font=[UIFont boldSystemFontOfSize:16];
    [_titleCell.contentView addSubview:tmpLab];
    [tmpLab release];
}

#pragma mark - FDSCompanyMessageInterface Method
- (void)getSystemRecommendCompanysCB:(NSMutableArray*)compnyList
{
    [SVProgressHUD popActivity];
    self.companyList = compnyList;
    [self recommandCellInit];

    [_tableDataView reloadData];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_pageDataArr count]+1 inSection:0];
//    [_tableDataView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - ScrollClickInterface Methods
- (void)handleScrollClick:(NSInteger)withCurrtag
{
//    NSLog(@"%d",withCurrtag);
    FDSCompany *showCompany = [_companyList objectAtIndex:withCurrtag];
    if (showCompany.m_comId && showCompany.m_comId.length >0 )
    {
        FDSCompanyDetailViewController *fdsDetail = [[FDSCompanyDetailViewController alloc]init];
        fdsDetail.companyID = showCompany.m_comId;
        fdsDetail.comName = showCompany.m_comName;
        [self.navigationController pushViewController:fdsDetail animated:YES];
        [fdsDetail release];
    }
    else
    {
        NSLog(@"未有此企业");
    }
}

#pragma mark - UITableViewDelegate UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.companyList)
    {
        return [_pageDataArr count]+2;
    }
    else
    {
        return [_pageDataArr count]+1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_pageDataArr count]+1 == indexPath.row)
    {
        return 261.0f;
    }
    else if(0 == indexPath.row)
    {
        return 40.0f;
    }
    else
    {
        return  50.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath row];
    //config the cell
    if (0 == index)
    {
        _titleCell.backgroundColor = [UIColor clearColor];
        _titleCell.selectionStyle=UITableViewCellSelectionStyleNone;
        _titleCell.contentView.backgroundColor = COLOR(229, 229, 229, 1);
        return _titleCell;
    }
    else if(7 == index)
    {
        return _recommendCell;
    }
    else
    {
        static NSString *CellIdentifier = @"RecoreListCell_Y";
        RecoreListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[[RecoreListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier addLine:YES] autorelease];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        if (index > 0 && index < 7)
        {
            NSDictionary *tmpDic = [_pageDataArr objectAtIndex:index-1];
            cell.imgView.image = [UIImage imageNamed:[tmpDic objectForKey:@"enterPriseIcon"]];
            cell.contentLab.text = [NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"enterPriseName"]];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath row];
    if (0 != index && [_pageDataArr count]+1 != index)
    {
        FDSRecordListViewController *fdsRpage = [[FDSRecordListViewController alloc]init];
        NSDictionary *tmpDic = [_pageDataArr objectAtIndex:index-1];
        fdsRpage.titStr = [NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"enterPriseName"]];
        fdsRpage.firstTypeID = [tmpDic objectForKey:@"enterPriseId"];
        [self.navigationController pushViewController:fdsRpage animated:YES];
        [fdsRpage release];
    }
}


@end

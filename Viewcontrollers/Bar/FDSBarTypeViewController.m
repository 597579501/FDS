//
//  FDSBarTypeViewController.m
//  FDS
//
//  Created by zhuozhong on 14-2-28.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSBarTypeViewController.h"
#import "UIViewController+BarExtension.h"
#import "PosBarListCell.h"
#import "SVProgressHUD.h"
#import "FDSBusinessCardViewController.h"
#import "FDSPosBarInfoViewController.h"

@interface FDSBarTypeViewController ()

@end

@implementation FDSBarTypeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.posBarList = nil;
        self.posBarInfo = nil;
        self.keyWord = nil;
        isRefresh = NO;
        _isSearch = NO;
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
    [self.posBarList removeAllObjects];
    self.posBarList = nil;
    self.posBarInfo = nil;
    self.keyWord = nil;

    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[FDSBarMessageManager sharedManager]registerObserver:self];
    
    if(self.posBarList && self.posBarList.count > selectIndex)
    {
        NSIndexPath *refreshPath = [NSIndexPath indexPathForRow:selectIndex inSection:0];
        [posBarTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:refreshPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[FDSBarMessageManager sharedManager]unRegisterObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    if (self.isSearch)
    {
        [self homeNavbarWithTitle:@"贴吧搜索" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    }
    else
    {
        [self homeNavbarWithTitle:self.posBarInfo.m_barTypeName andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    }

    posBarTable = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith,kMSTableViewHeight-44) style:UITableViewStylePlain];
    posBarTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    posBarTable.delegate = self;
    posBarTable.dataSource = self;
    posBarTable.pullingDelegate = self;
    [self.view addSubview:posBarTable];
    [posBarTable release];
    posBarTable.backgroundColor = COLOR(234, 234, 234, 1);
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    if (_isSearch)
    {
        [[FDSBarMessageManager sharedManager] getBars:@"keyword" :self.keyWord :@"before" :@"-1" :10];
    }
    else
    {
        [[FDSBarMessageManager sharedManager]getBarByBarTypeID:_posBarInfo.m_barTypeID :@"before" :@"-1" :10];
    }
	// Do any additional setup after loading the view.
}

#pragma mark - UITableViewDelegate UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_posBarList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PosBarSECListCell";
    PosBarListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[PosBarListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    //config the cell
    FDSPosBar *bar = [_posBarList objectAtIndex:[indexPath row]];
    [cell.logoImg initWithPlaceholderImage:[UIImage imageNamed:@"posbar_common_load"]];
    cell.logoImg.imageURL = [NSURL URLWithString:bar.m_barIcon];
    cell.nameLab.text = bar.m_barName;
    cell.followedLab.text = @"关注:";
    cell.posbarLab.text = @"帖子:";
    cell.followedNumLab.text = bar.m_joinedNumber;
    cell.posbarNumLab.text = bar.m_postNumber;
    cell.posBarBriefLab.text = bar.m_introduce;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    FDSBusinessCardViewController *bcVC = [[FDSBusinessCardViewController alloc] init];
//    
//    bcVC.posBarInfo = [_posBarList objectAtIndex:indexPath.row];
//    
//    selectIndex = indexPath.row;
//    [self.navigationController pushViewController:bcVC animated:YES];
//    [bcVC release];
    
    FDSPosBarInfoViewController *barVC = [[FDSPosBarInfoViewController alloc] init];
    selectIndex = indexPath.row;
    barVC.lastPageBar = [_posBarList objectAtIndex:indexPath.row];
    
    if (barVC.lastPageBar.m_companyID && barVC.lastPageBar.m_companyID.length > 0)
    {
        barVC.bar_type = BAR_POST_TYPE_COMPANY;
    }
    else
    {
        barVC.bar_type = BAR_POST_TYPE_OTHER;
    }
    [self.navigationController pushViewController:barVC animated:YES];
    [barVC release];
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    isRefresh  = YES;
    isLoadMore = NO;
    /* 拉取最新的10条回复 */
    if (_isSearch)
    {
        [[FDSBarMessageManager sharedManager] getBars:@"keyword" :self.keyWord :@"before" :@"-1" :10];
    }
    else
    {
        [[FDSBarMessageManager sharedManager]getBarByBarTypeID:_posBarInfo.m_barTypeID :@"before" :@"-1" :10];
    }
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    isRefresh  = YES;
    isLoadMore = YES;
    if (self.posBarList.count > 0)
    {
        FDSPosBar *posBar = [self.posBarList objectAtIndex:self.posBarList.count-1];
        if (_isSearch)
        {
            [[FDSBarMessageManager sharedManager] getBars:@"keyword" :self.keyWord :@"before" :posBar.m_barID :10];
        }
        else
        {
            [[FDSBarMessageManager sharedManager]getBarByBarTypeID:_posBarInfo.m_barTypeID :@"before" :posBar.m_barID :10];
        }
    }
    else
    {
        [posBarTable tableViewDidFinishedLoading];
        posBarTable.reachedTheEnd = YES; //到达底部后即不会有上提操作
    }
}

- (NSDate *)pullingTableViewRefreshingFinishedDate
{
    NSDate *date = [NSDate date];
    return date;
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [posBarTable tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [posBarTable tableViewDidEndDragging:scrollView];
}

- (void)commonHandleGetData:(NSMutableArray*)posBarArr
{
    if (isRefresh)
    {
        [posBarTable tableViewDidFinishedLoading];
        if (!isLoadMore)  //刷新拉取最新10条  拉取更多则不需删除
        {
            [_posBarList removeAllObjects];
        }
    }
    else
    {
        [SVProgressHUD popActivity];
    }
    if (!self.posBarList)
    {
        self.posBarList = posBarArr;
    }
    else
    {
        [self.posBarList addObjectsFromArray:posBarArr];
    }
    
    if (posBarArr.count >= 10)/* 如果拉取到足够条数 就显示加载更多*/
    {
        posBarTable.reachedTheEnd = NO;
    }
    else
    {
        posBarTable.reachedTheEnd = YES; //到达底部后即不会有上提操作
    }
    
    [posBarTable reloadData];
    
    if ([_posBarList count] > 0)
    {
        if (isLoadMore)
        {
            [posBarTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_posBarList count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
        else
        {
            [posBarTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}

#pragma mark - FDSBarMessageInterface Method
- (void)getBarByBarTypeIDCB:(NSMutableArray *)posBarArr
{
    [self commonHandleGetData:posBarArr];
}

- (void)getBarsCB:(NSMutableArray *)barsList
{
    [self commonHandleGetData:barsList];
}

@end

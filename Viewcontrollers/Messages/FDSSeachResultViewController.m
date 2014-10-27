//
//  FDSSeachResultViewController.m
//  FDS
//
//  Created by zhuozhong on 14-2-17.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSSeachResultViewController.h"
#import "UIViewController+BarExtension.h"
#import "AddressBookTableViewCell.h"
#import "FDSFriendProfileViewController.h"

@interface FDSSeachResultViewController ()

@end

@implementation FDSSeachResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.resultList = nil;
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
    [self.resultList removeAllObjects];
    self.resultList = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self homeNavbarWithTitle:@"搜索结果" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _resultTable = [[UITableView alloc]initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith,kMSTableViewHeight-44) style:UITableViewStylePlain];
    _resultTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _resultTable.delegate = self;
    _resultTable.dataSource = self;
    [self.view addSubview:_resultTable];
    [_resultTable release];
    
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_back"]];
    if ([_resultTable respondsToSelector:@selector(setBackgroundView:)])
    {
        [_resultTable setBackgroundView:backImg];
    }
    [backImg release];
	// Do any additional setup after loading the view.
}

#pragma mark - UITableViewDelegate UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_resultList)
    {
        return [_resultList count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchResultTableViewCell";
    SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[SearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    //config the cell
    NSInteger index = [indexPath row];
    [cell loadCellWithData:[self.resultList objectAtIndex:index]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath row];
    FDSFriendProfileViewController *fpVC = [[FDSFriendProfileViewController alloc]init];
    fpVC.friendInfo = [self.resultList objectAtIndex:index];
    [self.navigationController pushViewController:fpVC animated:YES];
    [fpVC release];
}

@end

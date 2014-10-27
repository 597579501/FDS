//
//  FDSShowDesignerViewController.m
//  FDS
//
//  Created by zhuozhongkeji on 14-1-6.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSShowDesignerViewController.h"
#import "UIViewController+BarExtension.h"
#import "SchemeTableViewCell.h"
#import "FDSDesignerDetailViewController.h"
#import "SVProgressHUD.h"

@interface FDSShowDesignerViewController ()

@end

@implementation FDSShowDesignerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.designerList = nil;
        self.com_ID = nil;
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
    [_designerList removeAllObjects];
    self.designerList = nil;
    self.com_ID = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self homeNavbarWithTitle:@"设计师展示" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _designerTable = [[UITableView alloc]initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith,kMSTableViewHeight-44) style:UITableViewStylePlain];
    _designerTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _designerTable.delegate = self;
    _designerTable.dataSource = self;
    [self.view addSubview:_designerTable];
    [_designerTable release];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    if (_isSearch)
    {
        [[FDSCompanyMessageManager sharedManager]getCompanyDesigners:@"key" withCondition:self.com_ID];
    }
    else
    {
        [[FDSCompanyMessageManager sharedManager]getCompanyDesigners:@"all" withCondition:self.com_ID];
    }
	// Do any additional setup after loading the view.
}

#pragma mark FDSCompanyMessageInterface method
- (void)getCompanyDesignersCB:(NSMutableArray*)designerslist
{
    [SVProgressHUD popActivity];
    self.designerList = designerslist;
    [_designerTable reloadData];
}

#pragma mark - UITableViewDelegate UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_designerList)
    {
        return [_designerList count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DesignTableViewCell";
    DesignerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[DesignerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_cell_bg"]] autorelease];
    }
    //config the cell
    NSInteger index = [indexPath row];
    FDSComDesigner *designer = [_designerList objectAtIndex:index];
    cell.designerImg.placeholderImage = [UIImage imageNamed:@"send_image_default"];
    cell.designerImg.imageURL = [NSURL URLWithString:designer.m_icon];
    cell.designerNameLab.text = designer.m_name;
    cell.professionLab.text = designer.m_job;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath row];
    FDSDesignerDetailViewController *fdsVC = [[FDSDesignerDetailViewController alloc]init];
    FDSComDesigner *designer = [_designerList objectAtIndex:index];
    fdsVC.designerID = designer.m_designerID;
    [self.navigationController pushViewController:fdsVC animated:YES];
    [fdsVC release];
}

@end

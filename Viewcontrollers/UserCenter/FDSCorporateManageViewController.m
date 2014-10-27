//
//  FDSCorporateManageViewController.m
//  FDS
//
//  Created by zhuozhongkeji on 14-1-13.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSCorporateManageViewController.h"
#import "UIViewController+BarExtension.h"
#import "Constants.h"
#import "ProfileTableViewCell.h"
#import "SVProgressHUD.h"
#import "FDSCompany.h"
#import "FDSCompanyDetailViewController.h"

@implementation CompanyDetail

- (void)dealloc
{
    [self.companyList removeAllObjects];
    self.companyList = nil;
    
    self.companyTitle = nil;
    [super dealloc];
}

@end



@interface FDSCorporateManageViewController ()

@end

@implementation FDSCorporateManageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        companyInfoList = [[NSMutableArray alloc] init];
        
        CompanyDetail *meInfo = [[CompanyDetail alloc] init];
        meInfo.companyList = [NSMutableArray arrayWithCapacity:1];
        meInfo.companyType = KCOMPANY_TYPE_ME_OWNED;
        meInfo.companyTitle = @"我的企业";
        [companyInfoList addObject:meInfo];
        [meInfo release];
        
        CompanyDetail *joinedInfo = [[CompanyDetail alloc] init];
        joinedInfo.companyList = [NSMutableArray arrayWithCapacity:1];
        joinedInfo.companyType = KCOMPANY_TYPE_ME_OWNED;
        joinedInfo.companyTitle = @"加入企业";
        [companyInfoList addObject:joinedInfo];
        [joinedInfo release];
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
    [[FDSUserCenterMessageManager sharedManager] registerObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[FDSUserCenterMessageManager sharedManager] unRegisterObserver:self];
}

-(void)dealloc
{
    [companyInfoList release];

    [super dealloc];
}

- (void)companyTableInit
{
    _companyTable = [[UITableView alloc]initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith,kMSTableViewHeight-44) style:UITableViewStyleGrouped];
    _companyTable.delegate = self;
    _companyTable.dataSource = self;
    [self.view addSubview:_companyTable];
    [_companyTable release];
    
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_back"]];
    if ([_companyTable respondsToSelector:@selector(setBackgroundView:)])
    {
        [_companyTable setBackgroundView:backImg];
    }
    [backImg release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = COLOR(234, 234, 234, 1);

    [self homeNavbarWithTitle:@"我的企业" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [[FDSUserCenterMessageManager sharedManager] getJoinedCompanyList];
	// Do any additional setup after loading the view.
}


#pragma mark - FDSUserCenterMessageInterface Methods
- (void)getJoinedCompanyListCB:(NSMutableArray *)companyList
{
    [SVProgressHUD popActivity];
    FDSCompany *company = nil;
    for (int i=0; i<companyList.count; i++)
    {
        company = [companyList objectAtIndex:i];
        if ([company.m_relation isEqualToString:@"admin"])
        {
            CompanyDetail *meInfo = [companyInfoList objectAtIndex:0];
            [meInfo.companyList addObject:company];
        }
        else
        {
            CompanyDetail *joinedInfo = [companyInfoList objectAtIndex:1];
            [joinedInfo.companyList addObject:company];
        }
    }
    
    [self companyTableInit];
}


#pragma mark - UITableViewDelegate UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return companyInfoList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CompanyDetail *companyInfo = [companyInfoList objectAtIndex:section];
    return [companyInfo.companyList count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* myView = [[[UIView alloc] init] autorelease];
    myView.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 200, 22)];
    titleLabel.textColor = kMSTextColor;
    titleLabel.font =[UIFont systemFontOfSize:16];
    titleLabel.backgroundColor = [UIColor clearColor];
    
    CompanyDetail *companyInfo = [companyInfoList objectAtIndex:section];
    titleLabel.text = companyInfo.companyTitle;
    
    [myView addSubview:titleLabel];
    [titleLabel release];
    return myView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"companyTableViewCell";
    ProfileTableViewCell *profileCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (profileCell == nil)
    {
        profileCell = [[[ProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier cellIndefy:YES] autorelease];
        
        profileCell.logoImg.layer.borderWidth = 1;
        profileCell.logoImg.layer.cornerRadius = 4.0;
        profileCell.logoImg.layer.masksToBounds=YES;
        profileCell.logoImg.layer.borderColor = [[UIColor colorWithRed:242.0f/255 green:242.0f/255 blue:242.0f/255 alpha:1.0f] CGColor];
    }
    
    CompanyDetail *companyInfo = [companyInfoList objectAtIndex:indexPath.section];
    FDSCompany *company = [companyInfo.companyList objectAtIndex:indexPath.row];
    profileCell.logoImg.placeholderImage = [UIImage imageNamed:@"send_image_default"];
    profileCell.logoImg.imageURL = [NSURL URLWithString:company.m_companyIcon];
    
    profileCell.titleTextLab.text = company.m_companyNameZH;
    return profileCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompanyDetail *companyInfo = [companyInfoList objectAtIndex:indexPath.section];
    FDSCompany *company = [companyInfo.companyList objectAtIndex:indexPath.row];
    
    FDSCompanyDetailViewController *fdsDpage = [[FDSCompanyDetailViewController alloc]init];
    fdsDpage.companyID = company.m_comId;
    fdsDpage.comName = company.m_companyNameZH;

    [self.navigationController pushViewController:fdsDpage animated:YES];
    [fdsDpage release];
}

@end

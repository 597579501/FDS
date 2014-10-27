//
//  FDSDesignerDetailViewController.m
//  FDS
//
//  Created by zhuozhongkeji on 14-1-7.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSDesignerDetailViewController.h"
#import "UIViewController+BarExtension.h"
#import "SchemeTableViewCell.h"
#import "UMSocial.h"
#import "SVProgressHUD.h"
#import "FDSCommentListViewController.h"
#import "FDSPublicManage.h"
#import "FDSDBManager.h"
#import "FDSFriendProfileViewController.h"
#import "ZZSharedManager.h"

@interface FDSDesignerDetailViewController ()

@end

@implementation FDSDesignerDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.designerID = nil;
        self.designerInfo = nil;
        titleArr = [[NSArray alloc]initWithObjects:@"",@"基本信息",@"个人简介", nil];
        
        self.collectTypeData = nil;
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
    self.collectTypeData = nil;

    self.designerInfo = nil;
    self.designerID = nil;
    [titleArr release];
    [super dealloc];
}

- (void)buttomViewInit
{
    //底部操作栏
    NSMutableDictionary *collectDic = [NSMutableDictionary dictionaryWithCapacity:3];
    [collectDic setObject:[UIImage imageNamed:@"show_connect_bg"] forKey:@"Default"];
    [collectDic setObject:[NSString stringWithFormat:@"收藏"] forKey:@"title"];
    
    NSMutableDictionary *shareDic = [NSMutableDictionary dictionaryWithCapacity:3];
    [shareDic setObject:[UIImage imageNamed:@"show_share_bg"] forKey:@"Default"];
    [shareDic setObject:[NSString stringWithFormat:@"分享"] forKey:@"title"];
    
    NSMutableDictionary *imDic = [NSMutableDictionary dictionaryWithCapacity:3];
    [imDic setObject:[UIImage imageNamed:@"show_comment_bg"] forKey:@"Default"];
    [imDic setObject:[NSString stringWithFormat:@"评论"] forKey:@"title"];
    
    NSArray *dicArr = [NSArray arrayWithObjects:collectDic,shareDic,imDic, nil];
    _menuButtomView = [[ButtomMenuView alloc] initWithFrame:CGRectMake(0, kMSNaviHight+kMSTableViewHeight-44-50, kMSScreenWith, 50) withDataArr:dicArr];
    _menuButtomView.delegate = self;
    [self.view addSubview:_menuButtomView];
    [_menuButtomView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self homeNavbarWithTitle:@"设计师详情" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _designerTable = [[UITableView alloc]initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith,kMSTableViewHeight-44-50) style:UITableViewStylePlain];
    _designerTable.delegate = self;
    _designerTable.dataSource = self;
    _designerTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_designerTable];
    [_designerTable release];
    
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_back"]];
    if ([_designerTable respondsToSelector:@selector(setBackgroundView:)])
    {
        [_designerTable setBackgroundView:backImg];
    }
    [backImg release];
    
    [self buttomViewInit];
    
    if (self.designerID)
    {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        [[FDSCompanyMessageManager sharedManager]getDesignerInfo:self.designerID];
    }

	// Do any additional setup after loading the view.
}

#pragma mark FDSCompanyMessageInterface method
- (void)getDesignerInfoCB:(FDSComDesigner*)designers
{
    [SVProgressHUD popActivity];
    self.designerInfo = designers;
    [_designerTable reloadData];
}

#pragma mark - OperSNSBtnDelegate Method
- (void)didSNSWithTag:(NSInteger)currTag
{
    switch (currTag)
    {
        case 0://设计师收藏
        {
            self.collectTypeData = [[FDSPublicManage sharePublicManager]getCollectedDataWithType:FDS_COLLECTED_MESSAGE_DESIGNER];
            if (self.collectTypeData)
            {
                BOOL isExist = NO;
                FDSCollectedInfo *tempCollect = nil;
                for (int i=0; i<self.collectTypeData.count; i++)
                {
                    tempCollect = [self.collectTypeData objectAtIndex:i];
                    
                    if ([_designerID isEqualToString:tempCollect.m_collectID])
                    {
                        isExist = YES;
                        break;
                    }
                }
                if (isExist)
                {
                    [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"你已经收藏过"];
                }
                else
                {
                    FDSCollectedInfo *newCompanyInfo = [[FDSCollectedInfo alloc] init];
                    newCompanyInfo.m_collectType = FDS_COLLECTED_MESSAGE_DESIGNER;
                    newCompanyInfo.m_collectID = _designerID;
                    newCompanyInfo.m_collectTitle = _designerInfo.m_name;
                    newCompanyInfo.m_collectIcon = _designerInfo.m_icon;
                    newCompanyInfo.m_collectTime = [[FDSPublicManage sharePublicManager] getNowDate];
                    
                    [[FDSDBManager sharedManager] addCollectedInfoToDB:newCompanyInfo]; //add to DB
                    
                    [self.collectTypeData insertObject:newCompanyInfo atIndex:0];//add to cache
                    [newCompanyInfo release];
                    
                    [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"收藏成功"];
                }
            }
            else
            {
                [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"对不起 你没有登录 无法收藏"];
            }
        }
            break;
        case 1: //设计师分享
        {
            [ZZSharedManager setSharedParam:self :_designerInfo.m_name :_designerInfo.m_sharedLink :_designerInfo.m_icon :_designerInfo.m_introduce];
        }
            break;
        case 2://设计师评论
        {
            FDSCommentListViewController *commentListVC = [[FDSCommentListViewController alloc]init];
            commentListVC.commentObjectID = _designerID;
            commentListVC.commentObjectType = @"designer";//”company”,”product”,”designer”,”successfulcase”
            [self.navigationController pushViewController:commentListVC animated:YES];
            [commentListVC release];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* myView = [[[UIView alloc] init] autorelease];
    myView.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 200, 22)];
    titleLabel.textColor = kMSTextColor;
    titleLabel.font =[UIFont systemFontOfSize:16];
    titleLabel.backgroundColor = [UIColor clearColor];
    
    if (section >= 0 && section < [titleArr count])
    {
        titleLabel.text = [NSString stringWithFormat:@"%@",[titleArr objectAtIndex:section]];
    }
    else
    {
        titleLabel.text = @"Unknow";
    }
    [myView addSubview:titleLabel];
    [titleLabel release];
    return myView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section)
    {
        return 0.0f;
    }
    else
    {
        return 35.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section || 1 == indexPath.section)
    {
        return 110.0f;
    }
    else if (2 == indexPath.section)
    {
        return 130.0f;
    }
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {
        CommonHeaderTableViewCell *headCell = [[[CommonHeaderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommonHeaderTableViewCell" isAppend:YES isPlat:YES] autorelease];
        [headCell loadCellFrame:_designerInfo.m_name withDetail:@"平台用户"];
        if (_designerInfo.m_isPlatUser)
        {
            headCell.detailImg.image = [UIImage imageNamed:@"profile_platy_bg"];
        }
        else
        {
            headCell.detailImg.image = [UIImage imageNamed:@"profile_platn_bg"];
        }
        [headCell loadImgView:_designerInfo.m_icon];
        if (_designerInfo.m_comsex)  //需文档说明该字段
        {
            headCell.sexImg.image = [UIImage imageNamed:@"profile_sexm_bg"];
        }
        else
        {
            headCell.sexImg.image = [UIImage imageNamed:@"profile_sexw_bg"];
        }
        return headCell;
    }
    else if(1 == indexPath.section)
    {
        UITableViewCell *detailCell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DesignerDetailTableViewCell"] autorelease];
        UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 100)];
        bgImg.userInteractionEnabled = YES;
        bgImg.image = [[UIImage imageNamed:@"round_white_cellbg"]resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
        [detailCell.contentView addSubview:bgImg];
        [bgImg release];
        
        UILabel *detailKeyLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 40)];
        detailKeyLab.backgroundColor = [UIColor clearColor];
        detailKeyLab.textColor = kMSTextColor;
        detailKeyLab.text = @"公司名称";
        detailKeyLab.font=[UIFont systemFontOfSize:15];
        [bgImg addSubview:detailKeyLab];
        [detailKeyLab release];
        
        UILabel *detailValueLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, 180, 40)];
        detailValueLab.backgroundColor = [UIColor clearColor];
        detailValueLab.textColor = kMSTextColor;
        detailValueLab.text = _designerInfo.m_companyName;
        detailValueLab.font=[UIFont systemFontOfSize:14];
        [bgImg addSubview:detailValueLab];
        [detailValueLab release];

        UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(1, 49, 298, 1)];
        tmpView.backgroundColor = COLOR(202, 202, 202, 1);
        [bgImg addSubview:tmpView];
        [tmpView release];

        detailKeyLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 55, 80, 40)];
        detailKeyLab.backgroundColor = [UIColor clearColor];
        detailKeyLab.textColor = kMSTextColor;
        detailKeyLab.text = @"职业";
        detailKeyLab.font=[UIFont systemFontOfSize:15];
        [bgImg addSubview:detailKeyLab];
        [detailKeyLab release];
        
        detailValueLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 55, 180, 40)];
        detailValueLab.backgroundColor = [UIColor clearColor];
        detailValueLab.textColor = kMSTextColor;
        detailValueLab.text = _designerInfo.m_job;
        detailValueLab.font=[UIFont systemFontOfSize:14];
        [bgImg addSubview:detailValueLab];
        [detailValueLab release];
        
        detailCell.backgroundColor = [UIColor clearColor];
        detailCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return detailCell;
    }
    else if(2 == indexPath.section)
    {
        UITableViewCell *instrCell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"instrCell"] autorelease];
        UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 120.0)];
        bgImg.userInteractionEnabled = YES;
        bgImg.image = [[UIImage imageNamed:@"round_white_cellbg"]resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
        [instrCell.contentView addSubview:bgImg];
        [bgImg release];
        
        UITextView *textview = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, 280, 100)];
        textview.editable = NO;
        textview.textColor = COLOR(31, 31, 31, 1);
        textview.font = [UIFont systemFontOfSize:14];
        textview.text = _designerInfo.m_introduce;
        [bgImg addSubview:textview];
        [textview release];
        
        instrCell.backgroundColor = [UIColor clearColor];
        instrCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return instrCell;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*  平台用户可以进入个人资料  */
    if (0 == indexPath.section && _designerInfo.m_isPlatUser)
    {
        FDSFriendProfileViewController *fpVC = [[FDSFriendProfileViewController alloc]init];
        FDSUser *userInfo = [[FDSUser alloc] init];
        userInfo.m_friendID = _designerInfo.m_userID;
        userInfo.m_name = _designerInfo.m_name;
        userInfo.m_icon = _designerInfo.m_icon;
        fpVC.friendInfo = userInfo;
        [userInfo release];
        [self.navigationController pushViewController:fpVC animated:YES];
        [fpVC release];
    }
}


@end

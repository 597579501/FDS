//
//  FDSSchemeDetailViewController.m
//  FDS
//
//  Created by zhuozhongkeji on 14-1-6.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSSchemeDetailViewController.h"
#import "UIViewController+BarExtension.h"
#import "Constants.h"
#import "EGOImageView.h"
#import "FDSCommentListViewController.h"
#import "UMSocial.h"
#import "FDSPublicManage.h"
#import "FDSDBManager.h"
#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "SVProgressHUD.h"
#import "ZZSharedManager.h"

@interface FDSSchemeDetailViewController ()

@end

@implementation FDSSchemeDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.comSucCaseInfo = nil;
        
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

    self.comSucCaseInfo = nil;
    [xhaScroll setAutoScrollEnable:NO];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self homeNavbarWithTitle:@"案例详情" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:234.0/255 green:234.0/255 blue:234.0/255 alpha:1.0f];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, kMSNaviHight+10, 320, 40)];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor grayColor];
    titleLab.text = _comSucCaseInfo.m_title;
    titleLab.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:titleLab];
    [titleLab release];
    
    UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, kMSNaviHight+50, 310, 300)];
    bgImg.image = [[UIImage imageNamed:@"round_white_cellbg"]resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    bgImg.userInteractionEnabled = YES;
    bgImg.layer.borderWidth = 1;
    bgImg.layer.cornerRadius = 6.0;
    bgImg.layer.masksToBounds=YES;
    bgImg.layer.borderColor =[COLOR(188, 188, 188, 1) CGColor];

    xhaScroll = [[XHADScrollView alloc]initWithFrame:CGRectMake(0, 0, 310, 140) isVisiable:YES frame:CGRectMake(0, 120, 310, 20) circle:YES start:0];
    xhaScroll.datasource = self;
    xhaScroll.delegate = self;
    xhaScroll.autoScrollEnable = YES;
    xhaScroll.pageControl.backgroundColor = [UIColor colorWithRed:192.0/255 green:192.0/255 blue:192.0/255 alpha:1.0f];
    [bgImg addSubview:xhaScroll];
    [xhaScroll release];
    
    //text
    schemeContentText = [[UITextView alloc]initWithFrame:CGRectMake(0, 140, 310, 160)];
    schemeContentText.editable = NO;
    schemeContentText.text = _comSucCaseInfo.m_introduce;
    schemeContentText.textColor = kMSTextColor;
    schemeContentText.font = [UIFont systemFontOfSize:14];
    [bgImg addSubview:schemeContentText];
    [schemeContentText release];
    
    [self.view addSubview:bgImg];
    [bgImg release];
    
    
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
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [[FDSCompanyMessageManager sharedManager]getSuccessfulcaseInfo:_comSucCaseInfo.m_successfulcaseID];
	// Do any additional setup after loading the view.
}

- (void)getSuccessfulcaseInfoCB:(FDSComSucCase *)sucCaseDetail
{
    [SVProgressHUD popActivity];
    self.comSucCaseInfo.m_title = sucCaseDetail.m_title;
    self.comSucCaseInfo.m_introduce = sucCaseDetail.m_introduce;
    self.comSucCaseInfo.m_browserNumber = sucCaseDetail.m_browserNumber;
    self.comSucCaseInfo.m_sharedLink = sucCaseDetail.m_sharedLink;
    
    [xhaScroll reloadData];
}

#pragma mark - OperSNSBtnDelegate Method
- (void)didSNSWithTag:(NSInteger)currTag
{
    switch (currTag)
    {
        case 0://案例收藏
        {
            self.collectTypeData = [[FDSPublicManage sharePublicManager]getCollectedDataWithType:FDS_COLLECTED_MESSAGE_SUCCASE];
            if (self.collectTypeData)
            {
                BOOL isExist = NO;
                FDSCollectedInfo *tempCollect = nil;
                for (int i=0; i<self.collectTypeData.count; i++)
                {
                    tempCollect = [self.collectTypeData objectAtIndex:i];
                    
                    if ([_comSucCaseInfo.m_successfulcaseID isEqualToString:tempCollect.m_collectID])
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
                    newCompanyInfo.m_collectType = FDS_COLLECTED_MESSAGE_SUCCASE;
                    newCompanyInfo.m_collectID = _comSucCaseInfo.m_successfulcaseID;
                    newCompanyInfo.m_collectTitle = _comSucCaseInfo.m_title;
                    if (_comSucCaseInfo.m_imagePathArr.count > 0)
                    {
                        newCompanyInfo.m_collectIcon = [_comSucCaseInfo.m_imagePathArr objectAtIndex:0];
                    }
                    else
                    {
                        newCompanyInfo.m_collectIcon = @"";
                    }
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
        case 1: //案例分享
        {            
            [ZZSharedManager setSharedParam:self :[NSString stringWithFormat:@"%@",_comSucCaseInfo.m_title] :_comSucCaseInfo.m_sharedLink :(_comSucCaseInfo.m_imagePathArr.count>0)?[_comSucCaseInfo.m_imagePathArr objectAtIndex:0]:nil :_comSucCaseInfo.m_introduce];
        }
            break;
        case 2://案例评论
        {
            FDSCommentListViewController *commentListVC = [[FDSCommentListViewController alloc]init];
            commentListVC.commentObjectID = _comSucCaseInfo.m_successfulcaseID;
            commentListVC.commentObjectType = @"successfulcase";//”company”,”product”,”designer”,”successfulcase”
            [self.navigationController pushViewController:commentListVC animated:YES];
            [commentListVC release];
        }
            break;
        default:
            break;
    }
}

#pragma mark - XHADScrollViewDatasource,XHADScrollViewDelegate Methods
- (NSInteger)numberOfPages
{
    if (0 < _comSucCaseInfo.m_imagePathArr.count)
    {
        return [_comSucCaseInfo.m_imagePathArr count];
    }
    else
    {
        return 1;
    }
}

- (UIView *)pageAtIndex:(NSInteger)index
{
    UIImageView *tmpImg = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 310, 140)] autorelease];
    if (0 < [_comSucCaseInfo.m_imagePathArr count])
    {
        tmpImg.tag = index;
        UIImage *placeholder = [UIImage imageNamed:@"loading_logo_bg"];
        
        NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@",[_comSucCaseInfo.m_imagePathArr objectAtIndex:index]];
        if (urlStr.length >= 4)
        {
            [urlStr insertString:@"_middle" atIndex:urlStr.length-4];
        }

        [tmpImg setImageURLStr:urlStr placeholder:placeholder];
    }
    else
    {
        tmpImg.image = [UIImage imageNamed:@"loading_logo_bg"];
    }
    return tmpImg;
}

- (void)didClickPage:(XHADScrollView *)csView atIndex:(NSInteger)index
{
    int count = _comSucCaseInfo.m_imagePathArr.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:_comSucCaseInfo.m_imagePathArr[i]]; // 图片路径
        [photos addObject:photo];
        [photo release];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = index; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    [browser release];
}

- (void)switchPageDone:(XHADScrollView *)csView atIndex:(NSInteger)index :(UIView*)pageView
{
    
}

@end

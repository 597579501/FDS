//
//  FDSPosBarInfoViewController.m
//  FDS
//
//  Created by zhuozhong on 14-3-3.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSPosBarInfoViewController.h"
#import "UIViewController+BarExtension.h"
#import "SVProgressHUD.h"
#import "Constants.h"
#import "FDSBarPostInfo.h"
#import "FDSUserManager.h"
#import "FDSFriendProfileViewController.h"
#import "FDSCompanyDetailViewController.h"
#import "FDSLoginViewController.h"
#import "FDSBarCommentViewController.h"
#import "FDSPublicManage.h"
#import "FDSDBManager.h"

@interface FDSPosBarInfoViewController ()
{
    CommentView *postContentView;
    
    UITableViewCell  *topviewCell;
}
@end

@implementation FDSPosBarInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        isRefresh = NO;
        sendRefresh = NO;

        // Custom initialization
        self.lastPageBar = nil;
        
        if ( !sizeList )
        {
            sizeList = [[NSMutableDictionary alloc] init];
        }
    }
    return self;
}

- (void)titleDataInit
{
    titleArr = [[NSMutableArray alloc] init];
    
    FDSBarPostInfo *barTitle = [[FDSBarPostInfo alloc] init];
    barTitle.m_title = @"全部";
    barTitle.m_postType = @"all";
    barTitle.m_sucPostList = NO;
    barTitle.m_barPostList = nil;
    [titleArr addObject:barTitle];
    [barTitle release];
    
    if (BAR_POST_TYPE_COMPANY == self.bar_type)
    {
        barTitle = [[FDSBarPostInfo alloc] init];
        barTitle.m_title = @"公司新闻";
        barTitle.m_postType = @"news";
        barTitle.m_sucPostList = NO;
        barTitle.m_barPostList = nil;
        [titleArr addObject:barTitle];
        [barTitle release];
        
        barTitle = [[FDSBarPostInfo alloc] init];
        barTitle.m_title = @"人物专访";
        barTitle.m_postType = @"interviwe";
        barTitle.m_sucPostList = NO;
        barTitle.m_barPostList = nil;
        [titleArr addObject:barTitle];
        [barTitle release];
        
        barTitle = [[FDSBarPostInfo alloc] init];
        barTitle.m_title = @"活动";
        barTitle.m_postType = @"event";
        barTitle.m_sucPostList = NO;
        barTitle.m_barPostList = nil;
        [titleArr addObject:barTitle];
        [barTitle release];
        
        barTitle = [[FDSBarPostInfo alloc] init];
        barTitle.m_title = @"话题";
        barTitle.m_postType = @"topic";
        barTitle.m_sucPostList = NO;
        barTitle.m_barPostList = nil;
        [titleArr addObject:barTitle];
        [barTitle release];
        
        barTitle = [[FDSBarPostInfo alloc] init];
        barTitle.m_title = @"招聘";
        barTitle.m_postType = @"hr";
        barTitle.m_sucPostList = NO;
        barTitle.m_barPostList = nil;
        [titleArr addObject:barTitle];
        [barTitle release];
    }
    postContentView = [[CommentView alloc]initWithFrame:CGRectZero];
    postContentView.fontSize = 14.0f;
    postContentView.maxlength = 310;
    postContentView.facialSizeWidth = 18;
    postContentView.facialSizeHeight = 18;
    postContentView.textlineHeight = 20;  //用于计算cell高度
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [postContentView  release];
    [topviewCell release];
    [titleArr removeAllObjects];
    [titleArr release];
    
    [sizeList removeAllObjects];
    [sizeList release];

    self.lastPageBar = nil;
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[FDSBarMessageManager sharedManager]registerObserver:self];
    [[FDSCompanyMessageManager sharedManager] registerObserver:self];
    
    FDSBarPostInfo *barInfo = nil;
    if (BAR_POST_TYPE_COMPANY == self.bar_type)
    {
        barInfo = [titleArr objectAtIndex:_menuScroll.selectIndex];
    }
    else
    {
        barInfo = [titleArr objectAtIndex:0];
    }
    if (isSendPost) //从发帖页面返回
    {
        if (sendRefresh) //成功发帖才刷新
        {
            if (BAR_POST_TYPE_COMPANY == self.bar_type)
            {
                _menuScroll.selectIndex = 0;
            }
            self.lastPageBar.m_postNumber = [NSString stringWithFormat:@"%d",[self.lastPageBar.m_postNumber integerValue]+1];
            _posbarNumLab.text = self.lastPageBar.m_postNumber;
            
            [sizeList removeAllObjects];
            [_postTable reloadData];  //刷新显示最新帖子数据
        }
    }
    else
    {
        if(barInfo.m_barPostList && barInfo.m_barPostList.count >= selectIndex+1)
        {
            NSIndexPath *refreshPath = [NSIndexPath indexPathForRow:selectIndex+1 inSection:0];
            [_postTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:refreshPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    isSendPost = NO;
    sendRefresh = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[FDSBarMessageManager sharedManager]unRegisterObserver:self];
    [[FDSCompanyMessageManager sharedManager] unRegisterObserver:self];
}

/*   发布帖子  */
- (void)handleRightEvent
{
    FDSSendPostViewController *sendVC = [[FDSSendPostViewController alloc] init];
    sendVC.delegate = self;
    sendVC.bar_type = self.bar_type;
    sendVC.barID = self.lastPageBar.m_barID;
    sendVC.barInfo = [titleArr objectAtIndex:0];
    isSendPost = YES;
    [self.navigationController pushViewController:sendVC animated:YES];
    [sendVC release];
}

/* 发帖成功刷新 */
- (void)didSucRefresh
{
    sendRefresh = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = COLOR(234, 234, 234, 1);

    [self titleDataInit];
//    [self homeNavbarWithTitle:self.lastPageBar.m_barName andLeftButtonName:@"btn_caculate" andRightButtonName:@"navbar_post_new_bg"];//@"search_navbar_bg"];
    [self homeNavbarWithTitle:self.lastPageBar.m_barName andLeftButtonName:@"btn_caculate" andRightButtonName:@"发帖"];
    
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self loadTopView];
    
    [self loadAllSubView];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [[FDSBarMessageManager sharedManager]getBarInfo:self.lastPageBar.m_barID];//得到一个贴吧信息
    [[FDSBarMessageManager sharedManager]getBarPostList:self.lastPageBar.m_barID :@"before" :@"-1" :10 :@"all"];//得到一个贴吧的帖子列表
	// Do any additional setup after loading the view.
}

- (void)loadTopView
{
    topviewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"barTopCell"];
    topviewCell.backgroundColor = [UIColor clearColor];
    topviewCell.selectionStyle=UITableViewCellSelectionStyleNone;

    _companyLogoImg = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 7, 110, 110)];
    _companyLogoImg.layer.borderWidth = 1;
    _companyLogoImg.layer.cornerRadius = 4.0;
    _companyLogoImg.layer.masksToBounds=YES;
    _companyLogoImg.layer.borderColor = [[UIColor colorWithRed:242.0f/255 green:242.0f/255 blue:242.0f/255 alpha:1.0f] CGColor];
    [_companyLogoImg initWithPlaceholderImage:[UIImage imageNamed:@"posbar_common_load"]];
    _companyLogoImg.imageURL = [NSURL URLWithString:self.lastPageBar.m_barIcon];
    _companyLogoImg.userInteractionEnabled = YES;
    [topviewCell.contentView addSubview:_companyLogoImg];
    [_companyLogoImg release];
    
    _companyNameLab = [[UILabel alloc] initWithFrame:CGRectMake(120+10, 5, 235-40, 60)];
    _companyNameLab.backgroundColor = [UIColor clearColor];
    _companyNameLab.textColor = [UIColor blackColor];//COLOR(61, 61, 61, 1);
    _companyNameLab.font = [UIFont systemFontOfSize:19.0f];
    _companyNameLab.text = self.lastPageBar.m_barName;
    _companyNameLab.numberOfLines = 2;
    [topviewCell.contentView addSubview:_companyNameLab];
    [_companyNameLab release];
    
    /* 关注 帖子  */
    UILabel *followedLab = [[UILabel alloc]initWithFrame:CGRectMake(120+10, 60, 35, 20)];
    followedLab.backgroundColor = [UIColor clearColor];
    followedLab.textColor = [UIColor blackColor];
    followedLab.text = @"关注";
    followedLab.font=[UIFont systemFontOfSize:15];
    [topviewCell.contentView addSubview:followedLab];
    [followedLab release];
    
    _followedNumLab = [[UILabel alloc]initWithFrame:CGRectMake(120+10+35, 60, 45, 20)];
    _followedNumLab.backgroundColor = [UIColor clearColor];
    _followedNumLab.textColor = COLOR(233, 172, 136, 1);
    _followedNumLab.font=[UIFont systemFontOfSize:15];
    _followedNumLab.text = self.lastPageBar.m_joinedNumber;
    [topviewCell.contentView addSubview:_followedNumLab];
    [_followedNumLab release];
    
    UILabel *posbarLab = [[UILabel alloc]initWithFrame:CGRectMake(120+10+65, 60, 35, 20)];
    posbarLab.backgroundColor = [UIColor clearColor];
    posbarLab.textColor = [UIColor blackColor];
    posbarLab.text = @"帖子";
    posbarLab.font=[UIFont systemFontOfSize:15];
    [topviewCell.contentView addSubview:posbarLab];
    [posbarLab release];
    
    _posbarNumLab = [[UILabel alloc]initWithFrame:CGRectMake(120+10+100, 60, 85, 20)];
    _posbarNumLab.backgroundColor = [UIColor clearColor];
    _posbarNumLab.textColor = COLOR(233, 172, 136, 1);
    _posbarNumLab.text = self.lastPageBar.m_postNumber;
    _posbarNumLab.font=[UIFont systemFontOfSize:15];
    [topviewCell.contentView addSubview:_posbarNumLab];
    [_posbarNumLab release];
    
    _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _followBtn.frame = CGRectMake(120+10, 85, 70, 30);
    _followBtn.tag = 0x01;
    [_followBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [topviewCell.contentView addSubview:_followBtn];
    
    _followImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    [_followBtn addSubview:_followImg];
    [_followImg release];
    
    _followLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    _followLab.backgroundColor = [UIColor clearColor];
    _followLab.font = [UIFont systemFontOfSize:16.0f];
    _followLab.textAlignment = NSTextAlignmentCenter;
    [_followBtn addSubview:_followLab];
    [_followLab release];

    if ([self.lastPageBar.m_relation isEqualToString:@"no"])
    {
        _followImg.image = [UIImage imageNamed:@"system_agree_normal_bg"];
        _followLab.textColor = [UIColor whiteColor];
        _followLab.text = @"关注";
    }
    else
    {
        _followImg.image = [UIImage imageNamed:@"system_reject_normal_bg"];
        _followLab.textColor = [UIColor grayColor];
        _followLab.text = @"已关注";
    }

    if (BAR_POST_TYPE_COMPANY == self.bar_type)
    {
        UIButton *comBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        comBtn.frame = CGRectMake(120+70+20, 85, 70, 30);
        [comBtn setBackgroundImage:[UIImage imageNamed:@"com_post_normal_bg"] forState:UIControlStateNormal];
        [comBtn setBackgroundImage:[UIImage imageNamed:@"com_post_hl_bg"] forState:UIControlStateHighlighted];
        comBtn.tag = 0x02;
        [comBtn setTitle:@"企业主页" forState:UIControlStateNormal];
        [comBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [comBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [comBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [topviewCell.contentView addSubview:comBtn];
    }
    
    UIView *postLineView = [[UIView alloc] initWithFrame:CGRectMake(1, 124, 318, 1)];
    postLineView.backgroundColor = COLOR(211, 211, 211, 1);
    [topviewCell.contentView addSubview:postLineView];
    [postLineView release];
}

- (void)btnPressed:(id)sender
{
    if (0x01 == [sender tag]) //关注
    {
        if(USERSTATE_LOGIN != [[FDSUserManager sharedManager] getNowUserState]) /* 未登录成功 */
        {
            [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"你还未登录"];
//            FDSLoginViewController *loginVC = [[FDSLoginViewController alloc] init];
//            [self.navigationController pushViewController:loginVC animated:YES];
//            [loginVC release];
            return;
        }
        if ([self.lastPageBar.m_relation isEqualToString:@"no"])
        {
            //发送加入请求
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
            [[FDSCompanyMessageManager sharedManager]joinGroup:@"bar" :self.lastPageBar.m_barID];//”company”,”bar”,”team”
        }
        else
        {
            //发送取消加入请求
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
            [[FDSCompanyMessageManager sharedManager]quitGroup:@"bar" :self.lastPageBar.m_barID];//”company”,”bar”,”team”
        }
    }
    else //企业主页
    {
        if (self.lastPageBar.m_companyID && self.lastPageBar.m_companyID.length >0 )
        {
            FDSCompanyDetailViewController *fdsDetail = [[FDSCompanyDetailViewController alloc]init];
            fdsDetail.companyID = self.lastPageBar.m_companyID;
            [self.navigationController pushViewController:fdsDetail animated:YES];
            [fdsDetail release];
        }
    }
}

- (void)loadAllSubView
{
    if (BAR_POST_TYPE_COMPANY == self.bar_type)
    {
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (int i=0; i<titleArr.count; i++)
        {
            FDSBarPostInfo *titleInfo = [titleArr objectAtIndex:i];
            [tempArr addObject:titleInfo.m_title];
        }
        _menuScroll = [[MenuScrollView alloc]initWithFrame:CGRectMake(0, 125, kMSScreenWith, 34) withTitles:tempArr WithBOOL:YES];
        _menuScroll.delegate = self;
        [topviewCell.contentView addSubview:_menuScroll];
        [_menuScroll release];
        [tempArr removeAllObjects];
        [tempArr release];
        
        _postTable = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith,kMSTableViewHeight-44) style:UITableViewStylePlain];
    }
    else
    {
        _postTable = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith,kMSTableViewHeight-44) style:UITableViewStylePlain];
    }
    _postTable.delegate = self;
    _postTable.dataSource = self;
    _postTable.pullingDelegate = self;
    _postTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_postTable];
    [_postTable release];
    
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_back"]];
    if ([_postTable respondsToSelector:@selector(setBackgroundView:)])
    {
        [_postTable setBackgroundView:backImg];
    }
    [backImg release];
}

#pragma mark - FDSBarMessageInterface Methods
- (void)getBarInfoCB:(FDSPosBar *)posBarInfo
{
//    [SVProgressHUD popActivity];
    self.lastPageBar.m_relation = posBarInfo.m_relation;
    self.lastPageBar.m_joinedNumber = posBarInfo.m_joinedNumber;
    self.lastPageBar.m_postNumber = posBarInfo.m_postNumber;
    self.lastPageBar.m_companyID = posBarInfo.m_companyID;
    self.lastPageBar.m_introduce = posBarInfo.m_introduce;
    self.lastPageBar.m_barIcon = posBarInfo.m_barIcon;
    self.lastPageBar.m_barName = posBarInfo.m_barName;
    
    _companyLogoImg.imageURL = [NSURL URLWithString:self.lastPageBar.m_barIcon];
    _companyNameLab.text = self.lastPageBar.m_barName;
    _followedNumLab.text = self.lastPageBar.m_joinedNumber;
    _posbarNumLab.text = self.lastPageBar.m_postNumber;
    if ([self.lastPageBar.m_relation isEqualToString:@"no"])
    {
        _followImg.image = [UIImage imageNamed:@"system_agree_normal_bg"];
        _followLab.textColor = [UIColor whiteColor];
        _followLab.text = @"关注";
    }
    else
    {
        _followImg.image = [UIImage imageNamed:@"system_reject_normal_bg"];
        _followLab.textColor = [UIColor grayColor];
        _followLab.text = @"已关注";
    }
}

#pragma mark - FDSBarMessageInterface Methods
- (void)getBarPostListCB:(NSMutableArray *)barPostList :(NSString *)postType
{
    /* 查找对应的数据 */
    FDSBarPostInfo* barInfo = nil;
    for (int i=0; i<titleArr.count; i++)
    {
        barInfo = [titleArr objectAtIndex:i];
        if ([postType isEqualToString:barInfo.m_postType])
        {
            barInfo.m_sucPostList = YES;
            break;
        }
    }

    if (isRefresh)
    {
        [_postTable tableViewDidFinishedLoading];
        if (!isLoadMore && barInfo.m_barPostList)  //刷新拉取最新10条  拉取更多则不需删除
        {
            [barInfo.m_barPostList removeAllObjects];
        }
    }
    else
    {
        [SVProgressHUD popActivity];
    }
    NSInteger lastCount = [barInfo.m_barPostList count];
    
    if (barPostList.count > 0)
    {
        if (barInfo.m_barPostList )
        {
            [barInfo.m_barPostList addObjectsFromArray:barPostList];
        }
        else
        {
            barInfo.m_barPostList = barPostList;
        }
    }
    
    if (barPostList.count >= 10)/* 如果拉取到足够条数 就显示加载更多*/
    {
        _postTable.reachedTheEnd = NO;
        barInfo.m_showMoreData = YES; //显示可以拉取更多
    }
    else
    {
        _postTable.reachedTheEnd = YES; //到达底部后即不会有上提操作
        barInfo.m_showMoreData = NO;//显示不能拉取更多
    }
    
    [sizeList removeAllObjects]; //重新获取cell高度
    [_postTable reloadData];
    
    if (lastCount > 0)
    {
        [_postTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:lastCount inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    
    isRefresh = NO;
}

#pragma mark - FDSCompanyMessageInterface Method
- (void)joinGroupCB:(NSString *)result :(NSString *)reason
{
    [SVProgressHUD popActivity];
    if ([result isEqualToString:@"OK"])
    {
        _followImg.image = [UIImage imageNamed:@"system_reject_normal_bg"];
        _followLab.textColor = [UIColor grayColor];
        _followLab.text = @"已关注";

        NSInteger tempJoinNum = [self.lastPageBar.m_joinedNumber integerValue];
        tempJoinNum+=1;
        self.lastPageBar.m_joinedNumber = [NSString stringWithFormat:@"%d",tempJoinNum];
        self.lastPageBar.m_relation = @"member";
        
        _followedNumLab.text = self.lastPageBar.m_joinedNumber;
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"添加关注成功"];
    }
    else
    {
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"添加关注失败"];
    }
}

- (void)quitGroupCB:(NSString *)result
{
    [SVProgressHUD popActivity];
    if ([result isEqualToString:@"OK"])
    {
        _followImg.image = [UIImage imageNamed:@"system_agree_normal_bg"];
        _followLab.textColor = [UIColor whiteColor];
        _followLab.text = @"关注";

        NSInteger tempjoinCount = [self.lastPageBar.m_joinedNumber integerValue];
        tempjoinCount-=1;
        self.lastPageBar.m_joinedNumber = [NSString stringWithFormat:@"%d",tempjoinCount];
        self.lastPageBar.m_relation = @"no";
        
        _followedNumLab.text = self.lastPageBar.m_joinedNumber;
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"取消关注成功"];
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"取消关注失败"];
    }
}

#pragma mark MenuBtnDelegate Method
- (void)didSelectedButtonWithTag:(NSInteger)currTag
{
    if (5 <= [titleArr count])
    {
        if (currTag == [titleArr count]-1)
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
    FDSBarPostInfo *barInfo = [titleArr objectAtIndex:currTag];
    if (!barInfo.m_sucPostList)//未获取过
    {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        [[FDSBarMessageManager sharedManager]getBarPostList:self.lastPageBar.m_barID :@"before" :@"-1" :10 :barInfo.m_postType];//得到一个贴吧的帖子列表
    }
    else
    {
        /*  切换时要即时显示是否可以拉取更多  */
        if (barInfo.m_showMoreData && _postTable.reachedTheEnd)
        {
            _postTable.reachedTheEnd = NO;
        }
        else if(!_postTable.reachedTheEnd)
        {
            _postTable.reachedTheEnd = YES;
        }
        [sizeList removeAllObjects]; //重新获取cell高度
        [_postTable reloadData];
        NSInteger tempCount = barInfo.m_barPostList.count;
        if (tempCount > 0 && tempCount <= 10)
        {
            [_postTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}

#pragma mark - UITableViewDelegate UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FDSBarPostInfo *barInfo = nil;
    if (BAR_POST_TYPE_COMPANY == self.bar_type)
    {
        barInfo = [titleArr objectAtIndex:_menuScroll.selectIndex];
    }
    else
    {
        barInfo = [titleArr objectAtIndex:0];
    }
    return [barInfo.m_barPostList count]+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FDSBarPostInfo *barInfo = nil;
    if (BAR_POST_TYPE_COMPANY == self.bar_type)
    {
        if (0 == indexPath.row)
        {
            return 125+34.0f;
        }
        barInfo = [titleArr objectAtIndex:_menuScroll.selectIndex];
    }
    else
    {
        if (0 == indexPath.row)
        {
            return 125.0f;
        }
        barInfo = [titleArr objectAtIndex:0];
    }
    
    NSValue *sizeValue = [sizeList valueForKey:[NSString stringWithFormat:@"%d",indexPath.row-1]];
    if ( !sizeValue )
    {
        [self getContentSize:indexPath.row-1 :[barInfo.m_barPostList objectAtIndex:indexPath.row-1]];
        sizeValue = [sizeList valueForKey:[NSString stringWithFormat:@"%d",indexPath.row-1]];
    }
    CGSize size = [sizeValue CGSizeValue];
    return size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FDSBarPostInfo *barInfo = nil;
    if (BAR_POST_TYPE_COMPANY == self.bar_type)
    {
        barInfo = [titleArr objectAtIndex:_menuScroll.selectIndex];
    }
    else
    {
        barInfo = [titleArr objectAtIndex:0];
    }
    NSInteger indexRow = indexPath.row;
    if (0 == indexRow)
    {
        return topviewCell;
    }
    if (indexRow >0 && indexRow <= 3)
    {
        UITableViewCell *homeCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homeCell"] autorelease];
        
        UIImageView *topImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 16, 35, 20)];
        topImg.userInteractionEnabled = YES;
        topImg.image = [UIImage imageNamed:@"post_to_top"];
        [homeCell.contentView addSubview:topImg];
        [topImg release];

        UILabel *publishTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 230, 30)];
        publishTitleLab.backgroundColor = [UIColor clearColor];
        publishTitleLab.textColor = [UIColor blackColor];
        
        publishTitleLab.font=[UIFont systemFontOfSize:15];
        [homeCell.contentView addSubview:publishTitleLab];
        [publishTitleLab release];
        
        /*  时间戳转时间  */
        FDSBarPostInfo *tempInfo = [barInfo.m_barPostList objectAtIndex:indexRow-1];
        NSTimeInterval timeValue = [tempInfo.m_sendTime doubleValue];
        NSDate *confromTime = [NSDate dateWithTimeIntervalSince1970:timeValue/1000];
        NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"yy-MM-dd"];
        publishTitleLab.text = [NSString stringWithFormat:@"【%@】   %@",[formatter stringFromDate:confromTime],tempInfo.m_title];

        if ([tempInfo.m_senderID isEqualToString:[[FDSUserManager sharedManager] getNowUser].m_userID])
        {
            UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            delBtn.frame = CGRectMake(280, 0, 40, 50);
            delBtn.tag = indexPath.row-1;
            [delBtn addTarget:self action:@selector(didDeleteWithClick:) forControlEvents:UIControlEventTouchUpInside];
            [homeCell.contentView addSubview:delBtn];
            
            UIImageView *delImg = [[UIImageView alloc] initWithFrame:CGRectMake(8, 12, 25, 25)];
            delImg.image = [UIImage imageNamed:@"delete_comment_icon"];
            delImg.backgroundColor = [UIColor clearColor];
            [delBtn addSubview:delImg];
            [delImg release];
        }
        if (indexRow == 3) //不重用
        {
            if (barInfo.m_barPostList.count == 3)
            {
                UIView *postLineView = [[UIView alloc] initWithFrame:CGRectMake(1, 49, 318, 1)];
                postLineView.backgroundColor = COLOR(211, 211, 211, 1);
                [homeCell.contentView addSubview:postLineView];
                [postLineView release];
            }
        }
        else
        {
            UIView *postLineView = [[UIView alloc] initWithFrame:CGRectMake(1, 49, 318, 1)];
            postLineView.backgroundColor = COLOR(211, 211, 211, 1);
            [homeCell.contentView addSubview:postLineView];
            [postLineView release];
        }
        homeCell.backgroundColor = [UIColor clearColor];
        homeCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return homeCell;
    }
    
    static NSString *CellIdentifier = @"BarPostListCell";
    BarPostListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[BarPostListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    //config the cell
    cell.currentIndex = indexRow-1;
    cell.delegate = self;
    [cell loadPostCellData:[barInfo.m_barPostList objectAtIndex:indexRow-1]];
    return cell;
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    isRefresh  = YES;
    isLoadMore = NO;
    /* 拉取最新的10条回复 */

    FDSBarPostInfo *barInfo = nil;
    if (BAR_POST_TYPE_COMPANY == self.bar_type)
    {
        barInfo = [titleArr objectAtIndex:_menuScroll.selectIndex];
    }
    else
    {
        barInfo = [titleArr objectAtIndex:0];
    }
    [[FDSBarMessageManager sharedManager]getBarPostList:self.lastPageBar.m_barID :@"before" :@"-1" :10 :barInfo.m_postType];//得到一个贴吧的帖子列表
    
    [sizeList removeAllObjects]; //重新获取cell高度
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    isRefresh  = YES;
    isLoadMore = YES;
    FDSBarPostInfo *barInfo = nil;
    if (BAR_POST_TYPE_COMPANY == self.bar_type)
    {
        barInfo = [titleArr objectAtIndex:_menuScroll.selectIndex];
    }
    else
    {
        barInfo = [titleArr objectAtIndex:0];
    }
    if (barInfo.m_barPostList.count > 0)
    {
        FDSBarPostInfo *lastPost = [barInfo.m_barPostList objectAtIndex:barInfo.m_barPostList.count-1];
        [[FDSBarMessageManager sharedManager]getBarPostList:self.lastPageBar.m_barID :@"before" :lastPost.m_postID :10 :barInfo.m_postType];//拉取一个贴吧的更多帖子列表
    }
    else
    {
        [_postTable tableViewDidFinishedLoading];
        _postTable.reachedTheEnd = YES; //到达底部后即不会有上提操作
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
    [_postTable tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_postTable tableViewDidEndDragging:scrollView];
}

#pragma mark - BarPostCellDelegate Methods
- (void)didHeadImgWithTag:(NSInteger)currentTag
{
    FDSBarPostInfo *barInfo = nil;
    if (BAR_POST_TYPE_COMPANY == self.bar_type)
    {
        barInfo = [titleArr objectAtIndex:_menuScroll.selectIndex];
    }
    else
    {
        barInfo = [titleArr objectAtIndex:0];
    }
    FDSBarPostInfo *barDetail = [barInfo.m_barPostList objectAtIndex:currentTag];
    if (![barDetail.m_senderID isEqualToString:[[FDSUserManager sharedManager] getNowUser].m_userID]) //非本账号
    {
        FDSFriendProfileViewController *fpVC = [[FDSFriendProfileViewController alloc]init];
        FDSUser *userInfo = [[FDSUser alloc] init];
        userInfo.m_friendID = barDetail.m_senderID;
        userInfo.m_name = barDetail.m_senderName;
        userInfo.m_icon = barDetail.m_senderIcon;
        fpVC.friendInfo = userInfo;
        [userInfo release];
        [self.navigationController pushViewController:fpVC animated:YES];
        [fpVC release];
    }
}

- (void)didCollectWithTag:(NSInteger)currentTag
{
    FDSBarPostInfo *barInfo = nil;
    if (BAR_POST_TYPE_COMPANY == self.bar_type)
    {
        barInfo = [titleArr objectAtIndex:_menuScroll.selectIndex];
    }
    else
    {
        barInfo = [titleArr objectAtIndex:0];
    }
    FDSBarPostInfo *barDetail = [barInfo.m_barPostList objectAtIndex:currentTag];
    
    NSMutableArray *collectTypeData = [[FDSPublicManage sharePublicManager]getCollectedDataWithType:FDS_COLLECTED_MESSAGE_POSTBAR];
    if (collectTypeData)
    {
        if (barDetail.m_isCollect)
        {
            [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"你已经收藏过"];
        }
        else
        {
            FDSCollectedInfo *newCompanyInfo = [[FDSCollectedInfo alloc] init];
            newCompanyInfo.m_collectType = FDS_COLLECTED_MESSAGE_POSTBAR;
            newCompanyInfo.m_collectID = barDetail.m_postID;
            newCompanyInfo.m_collectTitle = barDetail.m_title;
            newCompanyInfo.m_collectIcon = barDetail.m_senderIcon;
            newCompanyInfo.m_collectTime = [[FDSPublicManage sharePublicManager] getNowDate];
            
            [[FDSDBManager sharedManager] addCollectedInfoToDB:newCompanyInfo]; //add to DB
            
            [collectTypeData insertObject:newCompanyInfo atIndex:0];//add to cache
            [newCompanyInfo release];
            
            barDetail.m_isCollect = YES;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentTag+1 inSection:0];
            [_postTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];  //刷新指定cell收藏状态
            
            [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"收藏成功"];
        }
    }
    else
    {
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"对不起 你没有登录 无法收藏"];
    }
}


/* 删除处理 */
- (void)didClickDeleteBtn:(NSInteger)currentTag
{
    [self handleDelBarPost:currentTag];
}

- (void)didDeleteWithClick:(id)sender
{
    [self handleDelBarPost:[sender tag]];
}

- (void)handleDelBarPost:(NSInteger)currentTag
{
    deleteIndex = currentTag;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除帖子" message:@"确定删除吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    [alert release];
}

#pragma-mark UIAlertViewDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex) //send
    {
        FDSBarPostInfo *barInfo = nil;
        if (BAR_POST_TYPE_COMPANY == self.bar_type)
        {
            barInfo = [titleArr objectAtIndex:_menuScroll.selectIndex];
        }
        else
        {
            barInfo = [titleArr objectAtIndex:0];
        }
        FDSBarPostInfo *barDetail = [barInfo.m_barPostList objectAtIndex:deleteIndex];

        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        [[FDSBarMessageManager sharedManager]deletePostCommentRevert:self.lastPageBar.m_barID :@"post" :barDetail.m_postID];
    }
}

- (void)deletePostCommentRevertCB:(NSString *)result
{
    [SVProgressHUD popActivity];
    if ([result isEqualToString:@"OK"])
    {
        /* page */
        FDSBarPostInfo *barInfo = nil;
        if (BAR_POST_TYPE_COMPANY == self.bar_type)
        {
            barInfo = [titleArr objectAtIndex:_menuScroll.selectIndex];
        }
        else
        {
            barInfo = [titleArr objectAtIndex:0];
        }

        /* 移除指定key得值  再重新获取对应高度 */
        NSMutableArray *delList = [NSMutableArray arrayWithCapacity:1];
        for (int i=0; i<barInfo.m_barPostList.count; i++)
        {
            if (i >= deleteIndex)//将排在 指定删除消息 之后得所有消息都需要调整高度
            {
                [delList addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
        [sizeList removeObjectsForKeys:delList];
        /* 移除指定key得值  再重新获取对应高度 */

        [barInfo.m_barPostList removeObjectAtIndex:deleteIndex]; //cache
        
        NSInteger count = [self.lastPageBar.m_postNumber integerValue];
        count -= 1;
        self.lastPageBar.m_postNumber = [NSString stringWithFormat:@"%d",count];
        _posbarNumLab.text = self.lastPageBar.m_postNumber;
        [_postTable reloadData];
    }
    else
    {
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"删除失败"];
    }
}

#pragma mark - UITableViewDelegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        /*  crash问题 第一行不能有点击事件  */
        return;
    }
    FDSBarPostInfo *barInfo = nil;
    if (BAR_POST_TYPE_COMPANY == self.bar_type)
    {
        barInfo = [titleArr objectAtIndex:_menuScroll.selectIndex];
    }
    else
    {
        barInfo = [titleArr objectAtIndex:0];
    }
    selectIndex = indexPath.row-1;
    FDSBarCommentViewController *barCommentVC = [[FDSBarCommentViewController alloc] init];
    barCommentVC.barPostInfo = [barInfo.m_barPostList objectAtIndex:indexPath.row-1];
    if (selectIndex <= 2)
    {
        barCommentVC.isTotop = YES;
    }
    [self.navigationController pushViewController:barCommentVC animated:YES];
    [barCommentVC release];
}

/* 避免原来每次都调用两次绘制cell来获取高度的低效率操作 */
- (void)getContentSize:(NSInteger)indexPath :(FDSBarPostInfo*)dataInfo
{
    if (indexPath <= 2)
    {
        NSValue *sizeValue = [NSValue valueWithCGSize:CGSizeMake(kMSScreenWith,50.0f)];
        [sizeList setValue:sizeValue forKey:[NSString stringWithFormat:@"%d",indexPath]];
        return ;
    }

    CGFloat cell_H = 5.0f;
    NSInteger lineNum = [[FDSPublicManage sharePublicManager] handleShowContent:dataInfo.m_title :[UIFont systemFontOfSize:17] :150];
    cell_H += 25*lineNum+15;
    if ([dataInfo.m_contentType isEqualToString:@"text"])
    {
        if (dataInfo.m_images.count > 0)
        {
            cell_H += 75+15.0f;
        }
        if (dataInfo.m_content && dataInfo.m_content.length>0)
        {
            NSString *tmpStr = nil;
            if (dataInfo.m_content.length>120)
            {
                tmpStr = [NSString stringWithFormat:@"%@",[dataInfo.m_content substringToIndex:120]];
            }
            else
            {
                tmpStr = [NSString stringWithFormat:@"%@",dataInfo.m_content];
            }

            CGFloat viewheight = [postContentView getcurrentViewHeight:tmpStr];
            cell_H += viewheight+5;
        }
    }
    else
    {
        cell_H += 5;
    }
    
    cell_H +=1;

    cell_H+=50;
    
    cell_H+=10; //间隔空隙
    
    NSValue *sizeValue = [NSValue valueWithCGSize:CGSizeMake(kMSScreenWith,cell_H)];
    [sizeList setValue:sizeValue forKey:[NSString stringWithFormat:@"%d",indexPath]];
}

@end

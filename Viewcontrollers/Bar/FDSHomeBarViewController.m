//
//  FDSHomeBarViewController.m
//  FDS
//
//  Created by zhuozhong on 14-2-27.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSHomeBarViewController.h"
#import "UIViewController+BarExtension.h"
#import "Constants.h"
#import "RecoreListCell.h"
#import "FDSBarTypeViewController.h"
#import "EGOImageButton.h"
#import "FDSPosBarInfoViewController.h"
#import "FDSBarCommentViewController.h"
#import "FDSPublicManage.h"

@interface FDSHomeBarViewController ()

@end

@implementation FDSHomeBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.posBarList = nil;
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
    [self.hotPosBarList removeAllObjects];
    self.hotPosBarList = nil;
    [xhaScroll setAutoScrollEnable:NO];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[FDSBarMessageManager sharedManager]registerObserver:self];
    [[ZZSessionManager sharedSessionManager] registerObserver:self];

    enum ZZSessionManagerState state = [[ZZSessionManager sharedSessionManager] getSessionState];
    if ( ZZSessionManagerState_NET_FAIL == state)
    {
        [self handeNewWorkShow:YES];
    }
    else
    {
        [self handeNewWorkShow:NO];
        if (!self.posBarList)
        {
            [[FDSBarMessageManager sharedManager]getBarFirstType];
        }
        if (!self.hotPosBarList)
        {
            [[FDSBarMessageManager sharedManager] getHotPost];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[FDSBarMessageManager sharedManager]unRegisterObserver:self];
    [[ZZSessionManager sharedSessionManager] unRegisterObserver:self];
    
    if ([_searchText isFirstResponder])
    {
        [_searchText resignFirstResponder];
    }
}

- (void)handleSearchBar
{
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *keyword = nil;
    if (_searchText.text)
    {
        keyword = [_searchText.text stringByTrimmingCharactersInSet:whitespace];
        if (!keyword || keyword.length <= 0)
        {
            return ;
        }
    }
    else
    {
        return ;
    }
    _searchText.text = nil;
    FDSBarTypeViewController *barTypeVC = [[FDSBarTypeViewController alloc] init];
    barTypeVC.isSearch = YES;//搜索
    barTypeVC.keyWord = keyword;
    barTypeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:barTypeVC animated:YES];
    [barTypeVC release];
}

/*  搜索功能  */
- (void)seachAction
{
    [self handleSearchBar];
}

- (void)handleGes:(UIGestureRecognizer *)guestureRecognizer
{
    if ([_searchText isFirstResponder])
    {
        [_searchText resignFirstResponder];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self homeNavbarWithTitle:@"贴吧" andLeftButtonName:nil andRightButtonName:nil];

    /*搜索框*/
    seachView = [[UIView alloc] initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith, 40)];
    seachView.backgroundColor = COLOR(229, 229, 229, 1);
    [self.view addSubview:seachView];
    [seachView release];
    
    UIImageView *bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 310, 30)];
    bgImg.image = [[UIImage imageNamed:@"round_white_cellbg"]resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    bgImg.userInteractionEnabled = YES;
    [seachView addSubview:bgImg];
    [bgImg release];
    
    _searchText = [[UITextField alloc] initWithFrame:CGRectMake(5, KFDSTextOffset, 240, 30)];
    _searchText.delegate = self;
    _searchText.borderStyle = UITextBorderStyleNone;
    _searchText.font = [UIFont systemFontOfSize:16.0f];
    _searchText.textColor = kMSTextColor;
    _searchText.placeholder = @"搜贴吧";
    _searchText.returnKeyType = UIReturnKeySearch;
//    _searchText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [bgImg addSubview:_searchText];
    [_searchText release];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.adjustsImageWhenHighlighted = NO;
    [searchBtn addTarget:self action:@selector(seachAction) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"search_msg_bg"] forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(277, 2, 25, 25);
    [bgImg addSubview:searchBtn];
    /*搜索框*/
    
    
    xhaScroll = [[XHADScrollView alloc]initWithFrame:CGRectMake(0, 0, kMSScreenWith, 130+30) isVisiable:YES frame:CGRectMake(110, 115+30, 100, 15) circle:YES start:0];
    xhaScroll.datasource = self;
    xhaScroll.delegate = self;
    xhaScroll.autoScrollEnable = YES;
    xhaScroll.backgroundColor = [UIColor lightGrayColor];
    xhaScroll.pageControl.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:xhaScroll];
//    [xhaScroll release];
    
    UIImageView *hotImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    hotImg.image = [UIImage imageNamed:@"hot_posbar_bg"];
    hotImg.userInteractionEnabled = YES;
    [xhaScroll addSubview:hotImg];
    [xhaScroll bringSubviewToFront:hotImg];
    [hotImg release];

    posBarTable = [[UITableView alloc]initWithFrame:CGRectMake(0, kMSNaviHight+40, kMSScreenWith,kMSTableViewHeight-44-40-49) style:UITableViewStylePlain];
    posBarTable.showsVerticalScrollIndicator = NO;
    posBarTable.delegate = self;
    posBarTable.dataSource = self;
    posBarTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:posBarTable];
    [posBarTable release];
    
    posBarTable.tableHeaderView = xhaScroll;
    [xhaScroll release];
	// Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGes:)];
    tap.cancelsTouchesInView=NO;
    [self.view addGestureRecognizer:tap];
    [tap release];
    
    [self netWorkViewInit];
}

- (void)netWorkViewInit
{
    /*  网络不可用提示   */
    networkView = [[UIView alloc] initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith, 40)];
    networkView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:networkView];
    [networkView release];
    
    UIImageView *networkImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 25, 25)];
    networkImg.image = [UIImage imageNamed:@"network_no_avalible"];
    [networkView addSubview:networkImg];
    [networkImg release];
    
    UILabel *promptLab = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 200, 30)];
    promptLab.backgroundColor = [UIColor clearColor];
    promptLab.textColor = [UIColor redColor];
    promptLab.text = @"当前网络不可用";
    promptLab.font=[UIFont systemFontOfSize:15];
    [networkView addSubview:promptLab];
    [promptLab release];
    
    networkView.hidden = YES;
    /*  网络不可用提示   */
}

/*  处理网络问题的显示 */
- (void)handeNewWorkShow:(BOOL)show
{
    if (show) //显示
    {
        networkView.hidden = NO;
        seachView.frame = CGRectMake(0, kMSNaviHight+40, kMSScreenWith, 40);
//        xhaScroll.frame = CGRectMake(0, kMSNaviHight+80, kMSScreenWith, 130);
//        posBarTable.frame = CGRectMake(0, kMSNaviHight+210, kMSScreenWith,kMSTableViewHeight-44-210-44);
        posBarTable.frame = CGRectMake(0, kMSNaviHight+80, kMSScreenWith,kMSTableViewHeight-44-80-49);
    }
    else
    {
        networkView.hidden = YES;
        seachView.frame = CGRectMake(0, kMSNaviHight, kMSScreenWith, 40);
//        xhaScroll.frame = CGRectMake(0, kMSNaviHight+40, kMSScreenWith, 130);
//        posBarTable.frame = CGRectMake(0, kMSNaviHight+170, kMSScreenWith,kMSTableViewHeight-44-170-44);
        posBarTable.frame = CGRectMake(0, kMSNaviHight+40, kMSScreenWith,kMSTableViewHeight-44-40-49);
    }
}

-(void)sessionManagerStateNotice:(enum ZZSessionManagerState)sessionManagerState
{
    switch(sessionManagerState)
    {
//        case ZZSessionManagerState_NONE:
        case ZZSessionManagerState_NET_FAIL:
        {
            [self handeNewWorkShow:YES];
        }
            break;
        case ZZSessionManagerState_NET_OK:
        {
            [self handeNewWorkShow:NO];
        }
            break;
        default:
            break;
    }
}

#pragma mark - FDSBarMessageInterface Methods
- (void)getBarFirstTypeCB:(NSMutableArray *)posBarList
{
    self.posBarList = posBarList;
    [posBarTable reloadData];
}

- (void)getHotPostCB:(NSMutableArray *)posBarArr
{
    self.hotPosBarList = posBarArr;
    [xhaScroll reloadData];
}

#pragma mark - UITextFieldDelegate Method
// called when 'return' key pressed. return NO to ignore.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self handleSearchBar];
    return YES;
}

#pragma mark - XHADScrollViewDatasource,XHADScrollViewDelegate Methods
- (NSInteger)numberOfPages
{
    if (self.hotPosBarList)
    {
        return [self.hotPosBarList count];
    }
    return 0;
}

- (UIView *)pageAtIndex:(NSInteger)index
{
    EGOImageButton *tmpImg = [EGOImageButton buttonWithType:UIButtonTypeCustom];
    tmpImg.adjustsImageWhenHighlighted = NO;
    tmpImg.frame = CGRectMake(0, 0, kMSScreenWith, 130+30);
    FDSBarPostInfo *postInfo = [self.hotPosBarList objectAtIndex:index];
    if (postInfo.m_images.count > 0)
    {
        NSString *tmpStr = [postInfo.m_images objectAtIndex:0];
        if (tmpStr && tmpStr.length>0)
        {
            tmpImg.useBackGroundImg = YES;
            tmpImg.placeholderImage = [UIImage imageNamed:@"loading_logo_bg"];
            NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@",tmpStr];
//            if (urlStr.length >= 4)
//            {
//                [urlStr insertString:@"_small" atIndex:urlStr.length-4];
//            }
            tmpImg.imageURL = [NSURL URLWithString:urlStr];/* 待解决问题  大图片存储处理 */
        }
        else
        {
            [tmpImg setBackgroundImage:[UIImage imageNamed:@"loading_logo_bg"] forState:UIControlStateNormal];
        }
    }
    else
    {
        [tmpImg setBackgroundImage:[UIImage imageNamed:@"loading_logo_bg"] forState:UIControlStateNormal];
    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 105+30, kMSScreenWith, 25)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.5;
    [tmpImg addSubview:bgView];
    [bgView release];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 105+30, 200, 25)];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.text = postInfo.m_title;
    titleLab.font=[UIFont systemFontOfSize:15];
    [tmpImg addSubview:titleLab];
    [titleLab release];
    
    UILabel *numLab = [[UILabel alloc]initWithFrame:CGRectMake(260, 105+30, 50, 25)];
    numLab.backgroundColor = [UIColor clearColor];
    numLab.textColor = [UIColor whiteColor];
    numLab.textAlignment = NSTextAlignmentCenter;
    numLab.text = [NSString stringWithFormat:@"%d/%d",index+1,self.hotPosBarList.count];
    numLab.font=[UIFont systemFontOfSize:15];
    [tmpImg addSubview:numLab];
    [numLab release];

    return tmpImg;
}

- (void)didClickPage:(XHADScrollView *)csView atIndex:(NSInteger)index
{
    FDSBarPostInfo *barInfo = [self.hotPosBarList objectAtIndex:index];
    
    FDSBarCommentViewController *barCommentVC = [[FDSBarCommentViewController alloc] init];
    
    FDSBarPostInfo *tempBar = [[FDSBarPostInfo alloc] init];
    
    NSMutableArray *collectTypeData = [[FDSPublicManage sharePublicManager]getCollectedDataWithType:FDS_COLLECTED_MESSAGE_POSTBAR];
    if (collectTypeData && collectTypeData.count > 0)
    {
        BOOL isExist = NO;
        FDSCollectedInfo *tempCollect = nil;
        for (int ii=0; ii<collectTypeData.count; ii++)
        {
            tempCollect = [collectTypeData objectAtIndex:ii];
            
            if ([barInfo.m_postID isEqualToString:tempCollect.m_collectID])
            {
                isExist = YES;
                break;
            }
        }
        if (isExist)
        {
            tempBar.m_isCollect = YES;
        }
        else
        {
            tempBar.m_isCollect = NO;
        }
    }
    else
    {
        tempBar.m_isCollect = NO;
    }

    tempBar.m_postID = barInfo.m_postID; //对应跳到详情页面的ID
    barCommentVC.barPostInfo = tempBar;
    [tempBar release];
    barCommentVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:barCommentVC animated:YES];
    [barCommentVC release];
}

- (void)switchPageDone:(XHADScrollView *)csView atIndex:(NSInteger)index :(UIView*)pageView
{
    
}

#pragma mark - UITableViewDelegate UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_posBarList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PosBarListCell";
    RecoreListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[RecoreListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier addLine:YES] autorelease];
        cell.imgView.frame = CGRectMake(10, 7, 35, 35);
        cell.contentLab.frame = CGRectMake(55, 5, 240, 40);
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    //config the cell
    NSInteger index = [indexPath row];

    FDSPosBar *bar = [_posBarList objectAtIndex:index];
    [cell.imgView initWithPlaceholderImage:[UIImage imageNamed:@"send_image_default"]];
    cell.imgView.imageURL = [NSURL URLWithString:bar.m_barTypeIcon];

    cell.contentLab.text = bar.m_barTypeName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FDSPosBar *bar = [_posBarList objectAtIndex:indexPath.row];
    FDSBarTypeViewController *barTypeVC = [[FDSBarTypeViewController alloc] init];
    barTypeVC.isSearch = NO;//非搜索
    barTypeVC.posBarInfo = bar;
    barTypeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:barTypeVC animated:YES];
    [barTypeVC release];
}


@end

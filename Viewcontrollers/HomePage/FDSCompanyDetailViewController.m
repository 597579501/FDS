//
//  FDSCompanyDetailViewController.m
//  FDS
//
//  Created by zhuozhongkeji on 13-12-20.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "FDSCompanyDetailViewController.h"
#import "FDSShowProductViewController.h"
#import "FDSShowSchemeViewController.h"
#import "FDSMoreDetaiViewController.h"
#import "FDSMapViewController.h"
#import "FDSCommentListViewController.h"
#import "FDSShowDesignerViewController.h"
#import "SVProgressHUD.h"
#import "FDSUserManager.h"
#import "FDSLoginViewController.h"
#import "FDSPublicManage.h"
#import "FDSDBManager.h"
#import "FDSBusinessCardViewController.h"
#import "FDSPosBarInfoViewController.h"
#import "FDSChatViewController.h"
#import "FDSMessageCenter.h"
#import "ZZSharedManager.h"

@interface FDSCompanyDetailViewController ()
{
    MoreTableViewCell *moreContentCell;
    MoreTableViewCell *postBarCell;
}
@end

@implementation FDSCompanyDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _companyInfo = nil;
        self.collectTypeData = nil;
        self.comName = nil;
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
    if (!_transView.hidden)
    {
        _transView.hidden = YES;
    }
    [[FDSCompanyMessageManager sharedManager] registerObserver:self];
    
    //only refresh row in chatTable
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    [_pageTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[FDSCompanyMessageManager sharedManager] unRegisterObserver:self];
}

-(void)dealloc
{
    self.comName = nil;

    self.collectTypeData = nil;

    self.companyInfo = nil;
    [moreContentCell release];
    [postBarCell release];
    [_transView release];
    [_pageTable release];
    [_companyID release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = COLOR(234, 234, 234, 1);

    if (self.comName)
    {
        [self homeNavbarWithTitle:self.comName andLeftButtonName:@"btn_caculate" andRightButtonName:@"bg_navbar_more"];
    }
    else
    {
        [self homeNavbarWithTitle:@"企业详情" andLeftButtonName:@"btn_caculate" andRightButtonName:@"bg_navbar_more"];
    }
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [[FDSCompanyMessageManager sharedManager] getCompanyInfo:_companyID]; //对userID判断登录与否
	// Do any additional xsetup after loading the view.
}

- (void)handleRightEvent
{
    _transView.hidden = !_transView.hidden;
}

- (void)calculate
{
    if (_transView && !_transView.hidden)
    {
        _transView.hidden = YES;
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_transView.hidden)
    {
        _transView.hidden = YES;
    }
}

#pragma mark FDSCompanyMessageInterface methods
//***获取企业信息回调*****
- (void)getCompanyInfoCB:(NSString*)result withCompanyInfo:(FDSCompany*)companyInfo
{
    [SVProgressHUD popActivity];
    if (companyInfo)
    {
        self.companyInfo = companyInfo;
        if (!self.comName)
        {
            [self homeNavbarWithTitle:self.companyInfo.m_companyNameZH andLeftButtonName:@"btn_caculate" andRightButtonName:@"bg_navbar_more"];
        }
        [self initPageControl];
        [self initMoreTableCell];
        [self initTransView];

        UIButton *currBtn = (UIButton*)[_companyBgImg viewWithTag:0x01];
        if ([_companyInfo.m_relation isEqualToString:@"no"])//”no”:表示没有加入
        {
            [currBtn setBackgroundImage:[UIImage imageNamed:@"join_detail_bg"] forState:UIControlStateNormal];
        }
        else
        {
            [currBtn setBackgroundImage:[UIImage imageNamed:@"join_detailed_bg"] forState:UIControlStateNormal];
        }
        _companyBgImg.imageURL = [NSURL URLWithString:companyInfo.m_companyImage];
//        [_pageTable reloadData];
    }
    else
    {
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"获取企业详情失败"];
    }
}

- (void)joinGroupCB:(NSString *)result :(NSString *)reason
{
    [SVProgressHUD popActivity];
    if ([result isEqualToString:@"OK"])
    {
        UIButton *currBtn = (UIButton*)[_companyBgImg viewWithTag:0x01];
        _companyInfo.m_relation = @"member";
        [currBtn setBackgroundImage:[UIImage imageNamed:@"join_detailed_bg"] forState:UIControlStateNormal];
    }
}

- (void)quitGroupCB:(NSString *)result
{
    [SVProgressHUD popActivity];
    if ([result isEqualToString:@"OK"])
    {
        UIButton *currBtn = (UIButton*)[_companyBgImg viewWithTag:0x01];
        _companyInfo.m_relation = @"no";
        [currBtn setBackgroundImage:[UIImage imageNamed:@"join_detail_bg"] forState:UIControlStateNormal];
    }
}


#pragma mark MenuDropBtnDelegate
- (void)handleButtonWithTag:(NSInteger)currTag :(NSString*)title
{
    _transView.hidden = YES;
    if (1 == currTag)
    {
        
        [ZZSharedManager setSharedParam:self :self.companyInfo.m_companyNameZH :self.companyInfo.m_sharedLink :self.companyInfo.m_companyIcon :self.companyInfo.m_briefInfo];
        return;
    }
    
    self.collectTypeData = [[FDSPublicManage sharePublicManager]getCollectedDataWithType:FDS_COLLECTED_MESSAGE_COMPANY];
    if (!self.collectTypeData)
    {
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"对不起 你没有登录 无法进行此项操作"];
        return;
    }
    
    if (0 == currTag)
    {
        BOOL isExist = NO;
        FDSCollectedInfo *tempCollect = nil;
        for (int i=0; i<self.collectTypeData.count; i++)
        {
            tempCollect = [self.collectTypeData objectAtIndex:i];
            
            if ([_companyID isEqualToString:tempCollect.m_collectID])
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
            newCompanyInfo.m_collectType = FDS_COLLECTED_MESSAGE_COMPANY;
            newCompanyInfo.m_collectID = _companyID;
            newCompanyInfo.m_collectTitle = self.companyInfo.m_companyNameZH;
            newCompanyInfo.m_collectIcon = self.companyInfo.m_companyIcon;
            newCompanyInfo.m_collectTime = [[FDSPublicManage sharePublicManager] getNowDate];
            
            [[FDSDBManager sharedManager] addCollectedInfoToDB:newCompanyInfo]; //add to DB
            
            [self.collectTypeData insertObject:newCompanyInfo atIndex:0];//add to cache
            [newCompanyInfo release];
            
            [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"收藏成功"];
        }
    }
    else if([title isEqualToString:@"会客厅"])
    {
        if ([_companyInfo.m_relation isEqualToString:@"no"])
        {
            [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"请先加入该企业"];
        }
        else
        {
            FDSChatViewController *chatVC = [[FDSChatViewController alloc] init];
            /* 针对群聊操作 */
            FDSMessageCenter *messageCenter = [[FDSMessageCenter alloc] init];
            messageCenter.m_messageClass = FDSMessageCenterMessage_Class_USER; //个人信息
            messageCenter.m_messageType = FDSMessageCenterMessage_Type_CHAT_GROUP;//群消息
            messageCenter.m_icon = self.companyInfo.m_companyIcon; //消息中心头像都显示群头像
            messageCenter.m_senderName = @"";
            messageCenter.m_senderID = @"";
            messageCenter.m_param1 = _companyID;
            messageCenter.m_param2 = _companyInfo.m_companyNameZH;
            messageCenter.m_newMessageCount = [[FDSDBManager sharedManager] getChatMessageUnread:messageCenter];
            
            chatVC.centerMessage = messageCenter;
            [messageCenter release];
            
            [self.navigationController pushViewController: chatVC animated:YES];
            [chatVC release];
        }
    }
    else if([title isEqualToString:@"在线客服"])
    {
        if ([_companyInfo.m_relation isEqualToString:@"no"])
        {
            [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"请先加入该企业"];
        }
        else
        {
            FDSChatViewController *chatVC = [[FDSChatViewController alloc] init];
            /* 针对群聊操作 */
            FDSMessageCenter *messageCenter = [[FDSMessageCenter alloc] init];
            messageCenter.m_messageClass = FDSMessageCenterMessage_Class_USER; //个人信息
            messageCenter.m_messageType = FDSMessageCenterMessage_Type_CHAT_PERSON;
            messageCenter.m_icon = @""; //消息中心头像都显示群头像
            messageCenter.m_senderName = @"在线客服";
            messageCenter.m_senderID = self.companyInfo.m_customerServerID;
            messageCenter.m_param1 = @"";
            messageCenter.m_param2 = @"";
            messageCenter.m_newMessageCount = [[FDSDBManager sharedManager] getChatMessageUnread:messageCenter];
            
            chatVC.centerMessage = messageCenter;
            [messageCenter release];
            
            [self.navigationController pushViewController: chatVC animated:YES];
            [chatVC release];
        }
    }
}

- (void)initTransView
{
    NSMutableDictionary *collectDic = [NSMutableDictionary dictionaryWithCapacity:3];
    [collectDic setObject:[UIImage imageNamed:@"com_connect_bg"] forKey:@"Default"];
    [collectDic setObject:[NSString stringWithFormat:@"收藏"] forKey:@"title"];

    NSMutableDictionary *shareDic = [NSMutableDictionary dictionaryWithCapacity:3];
    [shareDic setObject:[UIImage imageNamed:@"com_share_bg"] forKey:@"Default"];
    [shareDic setObject:[NSString stringWithFormat:@"分享"] forKey:@"title"];

    NSMutableArray *dicArr = [NSMutableArray arrayWithCapacity:3];
    [dicArr addObject:collectDic];
    [dicArr addObject:shareDic];

    if ([self.companyInfo.m_chatRoom isEqualToString:@"YES"])
    {
        NSMutableDictionary *imDic = [NSMutableDictionary dictionaryWithCapacity:3];
        [imDic setObject:[UIImage imageNamed:@"com_im_bg"] forKey:@"Default"];
        [imDic setObject:[NSString stringWithFormat:@"会客厅"] forKey:@"title"];

        [dicArr addObject:imDic];
    }
    if (self.companyInfo.m_customerServerID.length >0)
    {
        NSMutableDictionary *onSerDic = [NSMutableDictionary dictionaryWithCapacity:3];
        [onSerDic setObject:[UIImage imageNamed:@"com_online_bg"] forKey:@"Default"];
        [onSerDic setObject:[NSString stringWithFormat:@"在线客服"] forKey:@"title"];
        [dicArr addObject:onSerDic];
    }
    _transView = [[MenuDropView alloc]initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith,kMSTableViewHeight-44) withTitles:dicArr];
    _transView.hidden = YES;
    _transView.delegate = self;
    [self.view addSubview:_transView];
}

-(void)initPageControl
{
    _pageTable = [[UITableView alloc]initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith,kMSTableViewHeight-44) style:UITableViewStylePlain];
    _pageTable.showsVerticalScrollIndicator = NO;
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _pageTable.delegate = self;
    _pageTable.dataSource = self;
    _pageTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_pageTable];

    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_back"]];
    if ([_pageTable respondsToSelector:@selector(setBackgroundView:)])
    {
        [_pageTable setBackgroundView:backImg];
    }
    [backImg release];
    
    //******公司logo简介**********
    _companyBgImg = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, kMSScreenWith, 120)];
    [_companyBgImg initWithPlaceholderImage:[UIImage imageNamed:@"loading_logo_bg"]];//scroll_default_bg
    _companyBgImg.userInteractionEnabled = YES;
    
    UIButton *joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    joinBtn.tag = 0x01;
    joinBtn.adjustsImageWhenHighlighted = NO;
    joinBtn.frame = CGRectMake(250, 75, 60, 30);
    joinBtn.backgroundColor = [UIColor clearColor];
    [joinBtn setBackgroundImage:[UIImage  imageNamed:@"join_detail_bg"] forState:UIControlStateNormal];
    [joinBtn addTarget:self action:@selector(handleMoreEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [_companyBgImg addSubview:joinBtn];
    _pageTable.tableHeaderView = _companyBgImg;
    [_companyBgImg release];
    //******公司logo简介**********
}

- (void)initMoreTableCell
{
    NSMutableArray *dicArr = [NSMutableArray arrayWithCapacity:3];

    NSMutableDictionary *showProductDic = [NSMutableDictionary dictionaryWithCapacity:3];
    [showProductDic setObject:@"com_product_show" forKey:@"Default"];
    [showProductDic setObject:[NSString stringWithFormat:@"产品展示"] forKey:@"title"];
    [showProductDic setObject:@"" forKey:@"iconURL"];
    [dicArr addObject:showProductDic];
    
    NSMutableDictionary *sucCaseDic = [NSMutableDictionary dictionaryWithCapacity:3];
    [sucCaseDic setObject:@"com_succase_show" forKey:@"Default"];
    [sucCaseDic setObject:[NSString stringWithFormat:@"成功案例"] forKey:@"title"];
    [sucCaseDic setObject:@"" forKey:@"iconURL"];
    [dicArr addObject:sucCaseDic];

    NSMutableDictionary *designDic = [NSMutableDictionary dictionaryWithCapacity:3];
    [designDic setObject:@"com_designer_bg" forKey:@"Default"];
    [designDic setObject:[NSString stringWithFormat:@"设计师展示"] forKey:@"title"];
    [designDic setObject:@"" forKey:@"iconURL"];
    [dicArr addObject:designDic];

    
    if ([self.companyInfo.m_chatRoom isEqualToString:@"YES"])
    {
        NSMutableDictionary *newsDic = [NSMutableDictionary dictionaryWithCapacity:3];
        [newsDic setObject:@"com_news_bg" forKey:@"Default"];
        [newsDic setObject:[NSString stringWithFormat:@"会客厅"] forKey:@"title"];
        [newsDic setObject:@"" forKey:@"iconURL"];
        
        [dicArr addObject:newsDic];
    }


    moreContentCell = [[MoreTableViewCell alloc]initScrollView:dicArr reuseIdentifier:@"moreContentCell" :NO];
    moreContentCell.hideDelegate = self;
    moreContentCell.marked = 100;
    moreContentCell.clickDelegate = self;
    moreContentCell.moreLab.text = @"更多内容";

    NSMutableArray *moreArr = [NSMutableArray arrayWithCapacity:3];
    if (_companyInfo.m_composbar)  //存在贴吧
    {
        for (int i=0; i<_companyInfo.m_barsArr.count; i++)
        {
            FDSPosBar *barInfo = [_companyInfo.m_barsArr objectAtIndex:i];
            
            NSMutableDictionary *companyDic = [NSMutableDictionary dictionaryWithCapacity:3];
            [companyDic setObject:barInfo.m_barIcon forKey:@"iconURL"];
            [companyDic setObject:@"" forKey:@"Default"];
            [companyDic setObject:[NSString stringWithFormat:@"企业贴吧"] forKey:@"title"];
//            [companyDic setObject:barInfo.m_barName forKey:@"title"];
            [moreArr addObject:companyDic];
        }
    }
    postBarCell = [[MoreTableViewCell alloc]initScrollView:moreArr reuseIdentifier:@"postBarCell" :YES];
    postBarCell.hideDelegate = self;
    postBarCell.marked = 200;
    postBarCell.clickDelegate = self;
    postBarCell.moreLab.text = @"更多贴吧";
}

- (UITableViewCell*)initAllContentCell
{
    //****_moreInfoCell*****
    UITableViewCell *moreInfoCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"moreInfoCell"] autorelease];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 310, 200.0)];
    imgView.userInteractionEnabled = YES;
    imgView.image =[[UIImage imageNamed:@"round_white_cellbg"]resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    
    UIImageView *logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 18, 18)];
    logoImg.image =[UIImage imageNamed:@"com_phone_bg"];
    [imgView addSubview:logoImg];
    [logoImg release];

    UILabel *tmpLab = [[UILabel alloc]initWithFrame:CGRectMake(35, 10, 250, 20)];
    tmpLab.backgroundColor = [UIColor clearColor];
    if (_companyInfo)
    {
        tmpLab.text = [NSString stringWithFormat:@"电话     %@",_companyInfo.m_calls];
    }
    else
    {
        tmpLab.text = [NSString stringWithFormat:@"电话"];
    }
    tmpLab.textColor = kMSTextColor;
    tmpLab.font=[UIFont systemFontOfSize:14];
    [imgView addSubview:tmpLab];
    [tmpLab release];
    
    UIImageView *moreImg = [[UIImageView alloc] initWithFrame:CGRectMake(290, 14, 8, 12)];
    moreImg.image =[UIImage imageNamed:@"cell_more_identify_bg"];
    [imgView addSubview:moreImg];
    [moreImg release];
    
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(1, 39, 308, 1)];
    tmpView.backgroundColor = kMSLineColor;
    [imgView addSubview:tmpView];
    [tmpView release];
    
    UIButton *buttomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buttomBtn.frame = CGRectMake(0, 0, 310, 40);
    buttomBtn.tag = 0x02;
    [buttomBtn addTarget:self action:@selector(handleMoreEvent:) forControlEvents:UIControlEventTouchUpInside];
    [imgView addSubview:buttomBtn];
    
    //****
    logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40+12, 15, 15)];
    logoImg.image =[UIImage imageNamed:@"com_mail_bg"];
    [imgView addSubview:logoImg];
    [logoImg release];

    tmpLab = [[UILabel alloc]initWithFrame:CGRectMake(35, 40+10, 250, 20)];
    tmpLab.backgroundColor = [UIColor clearColor];
    if (_companyInfo)
    {
        tmpLab.text = [NSString stringWithFormat:@"邮箱     %@",_companyInfo.m_email];
    }
    else
    {
        tmpLab.text = [NSString stringWithFormat:@"邮箱"];
    }
    tmpLab.textColor = kMSTextColor;
    tmpLab.font=[UIFont systemFontOfSize:14];
    [imgView addSubview:tmpLab];
    [tmpLab release];
    
    tmpView = [[UIView alloc] initWithFrame:CGRectMake(1, 79, 308, 1)];
    tmpView.backgroundColor = kMSLineColor;
    [imgView addSubview:tmpView];
    [tmpView release];
    
    //****
    logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 80+12, 15, 15)];
    logoImg.image =[UIImage imageNamed:@"com_fax_bg"];
    [imgView addSubview:logoImg];
    [logoImg release];

    tmpLab = [[UILabel alloc]initWithFrame:CGRectMake(35, 80+10, 250, 20)];
    tmpLab.backgroundColor = [UIColor clearColor];
    if (_companyInfo)
    {
        tmpLab.text = [NSString stringWithFormat:@"传真     %@",_companyInfo.m_fax];
    }
    else
    {
        tmpLab.text = [NSString stringWithFormat:@"传真"];
    }
    tmpLab.textColor = kMSTextColor;
    tmpLab.font=[UIFont systemFontOfSize:14];
    [imgView addSubview:tmpLab];
    [tmpLab release];
    
    tmpView = [[UIView alloc] initWithFrame:CGRectMake(1, 119, 308, 1)];
    tmpView.backgroundColor = kMSLineColor;
    [imgView addSubview:tmpView];
    [tmpView release];

    //****
    logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 120+12, 15, 15)];
    logoImg.image =[UIImage imageNamed:@"com_web_bg"];
    [imgView addSubview:logoImg];
    [logoImg release];

    tmpLab = [[UILabel alloc]initWithFrame:CGRectMake(35, 120+10, 250, 20)];
    tmpLab.backgroundColor = [UIColor clearColor];
    if (_companyInfo)
    {
        tmpLab.text = [NSString stringWithFormat:@"网站    %@",_companyInfo.m_website];
    }
    else
    {
        tmpLab.text = [NSString stringWithFormat:@"网站"];
    }
    tmpLab.textColor = kMSTextColor;
    tmpLab.font=[UIFont systemFontOfSize:14];
    [imgView addSubview:tmpLab];
    [tmpLab release];
    
    tmpView = [[UIView alloc] initWithFrame:CGRectMake(1, 159, 308, 1)];
    tmpView.backgroundColor = kMSLineColor;
    [imgView addSubview:tmpView];
    [tmpView release];
    
    //****
    logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 160+11, 18, 18)];
    logoImg.image =[UIImage imageNamed:@"com_location_bg"];
    [imgView addSubview:logoImg];
    [logoImg release];

    tmpLab = [[UILabel alloc]initWithFrame:CGRectMake(35, 160+10, 255, 20)];
    tmpLab.backgroundColor = [UIColor clearColor];
    if (_companyInfo)
    {
        tmpLab.text = [NSString stringWithFormat:@"地址    %@",_companyInfo.m_address];
    }
    else
    {
        tmpLab.text = [NSString stringWithFormat:@"地址"];
    }
    tmpLab.textColor = kMSTextColor;
    tmpLab.font=[UIFont systemFontOfSize:14];
    [imgView addSubview:tmpLab];
    [tmpLab release];
    
    moreImg = [[UIImageView alloc] initWithFrame:CGRectMake(290, 160+14, 8, 12)];
    moreImg.image =[UIImage imageNamed:@"cell_more_identify_bg"];
    [imgView addSubview:moreImg];
    [moreImg release];

    buttomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buttomBtn.frame = CGRectMake(0, 160, 310, 40);
    buttomBtn.tag = 0x03;
    [buttomBtn addTarget:self action:@selector(handleMoreEvent:) forControlEvents:UIControlEventTouchUpInside];
    [imgView addSubview:buttomBtn];

    [moreInfoCell.contentView addSubview:imgView];
    [imgView release];
    
    return moreInfoCell;
}

- (void)handleMoreEvent:(id)sender
{
    if (!_companyInfo)
    {
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"未拉取到企业详细信息"];
        return;
    }
    NSInteger index = [sender tag];
    switch (index)
    {
        case 0x01://加入
        {
            //判断用户有无登录(无登录直接提示去登录return)
            if(USERSTATE_LOGIN != [[FDSUserManager sharedManager] getNowUserState]) /* 未登录成功 */
            {
                [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"对不起 你没有登录 无法加入"];
                return;
            }
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
            if ([_companyInfo.m_relation isEqualToString:@"no"])//”no”:表示没有加入
            {
                //发送加入请求
                [[FDSCompanyMessageManager sharedManager]joinGroup:@"company" :_companyID ];//”company”,”bar”,”team”
            }
            else
            {
                //发送取消加入请求
                [[FDSCompanyMessageManager sharedManager] quitGroup:@"company" :_companyID];
            }
        }
            break;
        case 0x02://拨打号码
        {
//            UIWebView *callWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith, kMSTableViewHeight-44)];
//            NSURL *telURL = [NSURL URLWithString:@"tel://0755-25579905"];// 貌似tel:// 或者 tel: 都行
//            [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
//            [self.view addSubview:callWebview];
//            [callWebview release];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_companyInfo.m_calls]]];
        }
            break;
        case 0x03://进入指定地图
        {
            FDSMapViewController *mapVC = [[FDSMapViewController alloc]init];
            CLLocationCoordinate2D center;
            center.longitude = [_companyInfo.m_longitude floatValue];//经度
            center.latitude = [_companyInfo.m_latitude floatValue];  //纬度
            mapVC.center = center;
            mapVC.address = _companyInfo.m_address;
            [self.navigationController pushViewController:mapVC animated:YES];
            [mapVC release];
        }
            break;
        case 0x04://查看所有评论
        {
            FDSCommentListViewController *commentListVC = [[FDSCommentListViewController alloc]init];
            commentListVC.commentObjectID = _companyID;
            commentListVC.companyInfo = _companyInfo;
            commentListVC.commentObjectType = @"company";//”company”,”product”,”designer”,”successfulcase”
            [self.navigationController pushViewController:commentListVC animated:YES];
            [commentListVC release];
        }
            break;
        default:
            break;
    }
}

#pragma mark - MoreTableCellClickInterface
- (void)didClickedButtonWithTag:(NSInteger)index withMark:(NSInteger)markTag
{
    if (100 == markTag)
    {
        switch (index)
        {
            case 0: //产品展示
            {
                if (_companyInfo.m_products)
                {
                    FDSShowProductViewController *showVC = [[FDSShowProductViewController alloc]init];
                    showVC.com_ID = _companyInfo.m_comId;
                    showVC.isSearch = NO;
                    [self.navigationController pushViewController:showVC animated:YES];
                    [showVC release];
                }
                else
                {
                    [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"该企业还未有产品展示"];
                }
            }
                break;
            case 1: //成功案例
            {
                if (_companyInfo.m_successfulcase)
                {
                    FDSShowSchemeViewController *showVC = [[FDSShowSchemeViewController alloc]init];
                    showVC.com_ID = _companyInfo.m_comId;
                    showVC.isSearch = NO;
                    [self.navigationController pushViewController:showVC animated:YES];
                    [showVC release];
                }
                else
                {
                    [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"该企业还未有成功案例"];
                }
            }
                break;
            case 2: //设计师展示
            {
                if (_companyInfo.m_designers)
                {
                    FDSShowDesignerViewController *showVC = [[FDSShowDesignerViewController alloc]init];
                    showVC.com_ID = _companyInfo.m_comId;
                    showVC.isSearch = NO;
                    [self.navigationController pushViewController:showVC animated:YES];
                    [showVC release];
                }
                else
                {
                    [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"该企业还未有设计师展示"];
                }
            }
                break;
            case 3: //会客厅
            {
                if ([_companyInfo.m_relation isEqualToString:@"no"])
                {
                    [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"请先加入该企业"];
                }
                else
                {
                    FDSChatViewController *chatVC = [[FDSChatViewController alloc] init];
                    /* 针对群聊操作 */
                    FDSMessageCenter *messageCenter = [[FDSMessageCenter alloc] init];
                    messageCenter.m_messageClass = FDSMessageCenterMessage_Class_USER; //个人信息
                    messageCenter.m_messageType = FDSMessageCenterMessage_Type_CHAT_GROUP;//群消息
                    messageCenter.m_icon = self.companyInfo.m_companyIcon; //消息中心头像都显示群头像
                    messageCenter.m_senderName = @"";
                    messageCenter.m_senderID = @"";
                    messageCenter.m_param1 = _companyID;
                    messageCenter.m_param2 = _companyInfo.m_companyNameZH;
                    messageCenter.m_newMessageCount = [[FDSDBManager sharedManager] getChatMessageUnread:messageCenter];
                    
                    chatVC.centerMessage = messageCenter;
                    [messageCenter release];
                    
                    [self.navigationController pushViewController: chatVC animated:YES];
                    [chatVC release];
                }
            }
                break;
            default:
                break;
        }
    }
    else if(200 == markTag)
    {
        //企业贴吧
//        FDSBusinessCardViewController *bcVC = [[FDSBusinessCardViewController alloc] init];
//        
//        bcVC.posBarInfo = [_companyInfo.m_barsArr objectAtIndex:index];
//        [self.navigationController pushViewController:bcVC animated:YES];
//        [bcVC release];
        
        FDSPosBarInfoViewController *barVC = [[FDSPosBarInfoViewController alloc] init];
        barVC.lastPageBar = [_companyInfo.m_barsArr objectAtIndex:index];
        barVC.bar_type = BAR_POST_TYPE_COMPANY;
        [self.navigationController pushViewController:barVC animated:YES];
        [barVC release];
    }
}

#pragma mark - MoreTableViewCellHideInterface
-(void)hideScrollview
{
    [_pageTable reloadData];
}

#pragma mark-MSTouchLabelDelegate
- (void)touchesWithLabelTag
{
    FDSMoreDetaiViewController *fdsMpage = [[FDSMoreDetaiViewController alloc]init];
    fdsMpage.companyInfo = _companyInfo;
    [self.navigationController pushViewController:fdsMpage animated:YES];
    [fdsMpage release];
}

#pragma mark - UITableViewDelegate UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (0 == row)
    {
        return 153.0;
    }
    else if(1 == row || 2 == row)
    {
        MoreTableViewCell *moreCell = (MoreTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        if (moreCell.useLoadMore)
        {
            return 121.0f;
        }
        else
        {
            return 41.0f;
        }
    }
    else if(3 == row)
    {
        return 220.0f;
    }
    else if(4 == row)
    {
        return 50.0f;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    //config the cell
    NSInteger index = [indexPath row];
    if (0 == index)
    {
        SummaryTableViewCell *summaryCell = [[[SummaryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"summaryCell"] autorelease];
        summaryCell.touchLab.delegate = self;

        summaryCell.titleLab.text = @"简介";
        if (_companyInfo)
        {
            summaryCell.summaryLab.text = _companyInfo.m_briefInfo;
        }
        summaryCell.touchLab.text = @"阅读更多";
        return summaryCell;
    }
    else if(1 == index)//更多内容
    {
        return moreContentCell;
    }
    else if(2 == index)        //更多贴吧
    {
        return postBarCell;
    }
    else if(3 == index)
    {
        UITableViewCell *moreInfoCell = [self initAllContentCell];
        moreInfoCell.backgroundColor = [UIColor clearColor];
        moreInfoCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return moreInfoCell;
    }
    else if(4 == index)
    {
        //*****_checkCommentCell
        UITableViewCell *checkCommentCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"checkCommentCell"] autorelease];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 310, 40)];
        imgView.userInteractionEnabled = YES;
        imgView.image = [[UIImage imageNamed:@"round_white_cellbg"]resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
        
        UILabel *tmpLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 290, 20)];
        tmpLab.backgroundColor = [UIColor clearColor];
        if (_companyInfo)
        {
            tmpLab.text = [NSString stringWithFormat:@"查看所有评论（%@）",_companyInfo.m_commentCount];
        }
        else
        {
            tmpLab.text = [NSString stringWithFormat:@"查看所有评论（0）"];
        }
        tmpLab.textColor = kMSTextColor;
        tmpLab.font=[UIFont systemFontOfSize:14];
        [imgView addSubview:tmpLab];
        [tmpLab release];
        
        UIImageView *moreImg = [[UIImageView alloc] initWithFrame:CGRectMake(290, 14, 8, 12)];
        moreImg.image =[UIImage imageNamed:@"cell_more_identify_bg"];
        [imgView addSubview:moreImg];
        [moreImg release];
        
        UIButton *buttomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        buttomBtn.frame = CGRectMake(0, 0, 310, 40);
        buttomBtn.tag = 0x04;
        [buttomBtn addTarget:self action:@selector(handleMoreEvent:) forControlEvents:UIControlEventTouchUpInside];
        [imgView addSubview:buttomBtn];
        
        [checkCommentCell.contentView addSubview:imgView];
        [imgView release];

        checkCommentCell.backgroundColor = [UIColor clearColor];
        checkCommentCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return checkCommentCell;
    }
    return cell;
}


@end

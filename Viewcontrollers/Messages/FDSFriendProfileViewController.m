//
//  FDSFriendProfileViewController.m
//  FDS
//
//  Created by zhuozhong on 14-2-18.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSFriendProfileViewController.h"
#import "FDSFriendDetailViewController.h"
#import "UIViewController+BarExtension.h"
#import "FDSDBManager.h"
#import "FDSChatViewController.h"
#import "FDSMessageCenter.h"
#import "CustomAlertView.h"
#import "FDSUserManager.h"
#import "SVProgressHUD.h"
#import "FDSSearchFriendViewController.h"
#import "FDSLoginViewController.h"
#import "FDSMySpaceViewController.h"
#import "FDSPublicManage.h"
#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface FDSFriendProfileViewController ()

@end

@implementation FDSFriendProfileViewController
@synthesize nameLab,sexImg,headImg,companyLab,jobLab,pageScroll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.friendInfo = nil;
        _isExist = NO;
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
    self.friendInfo = nil;
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[FDSUserCenterMessageManager sharedManager] registerObserver:self];
    
    /* 针对读取最新修改的备注名 */
    [self resetNameAndSexFrame];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[FDSUserCenterMessageManager sharedManager] unRegisterObserver:self];
}

- (void)resetNameAndSexFrame
{
    /*  设置相关显示位置 */
    NSString *nameStr;
    if (![self.friendInfo.m_remarkName isEqualToString:@"(null)"] && self.friendInfo.m_remarkName.length > 0)
    {
        nameStr = self.friendInfo.m_remarkName;   //优先展示备注名
    }
    else
    {
        nameStr = self.friendInfo.m_name;
    }
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                nameLab.font, NSFontAttributeName,
                                nil];
    CGSize titleSize;
    if(IOS_7)
    {
        titleSize = [nameStr sizeWithAttributes:attributes];
    }
    else
    {
        titleSize = [nameStr sizeWithFont:nameLab.font];
    }
    float nameWidth = 150.f;
    if (titleSize.width < nameWidth)
    {
        nameWidth = titleSize.width;
    }
    nameLab.frame = CGRectMake(105, 0, nameWidth, 25);
    nameLab.text = nameStr;
    
    
    sexImg.frame = CGRectMake(105+nameWidth+5, 3, 18, 18);
    if ([self.friendInfo.m_sex isEqualToString:@"女"])
    {
        sexImg.image = [UIImage imageNamed:@"profile_sexw_bg"];
    }
    else if ([self.friendInfo.m_sex isEqualToString:@"男"])
    {
        sexImg.image = [UIImage imageNamed:@"profile_sexm_bg"];
    }
    else
    {
        sexImg.image = nil;
    }
}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
    
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.url = [NSURL URLWithString:self.friendInfo.m_icon]; // 图片路径
    photo.srcImageView = headImg; // 来源于哪个UIImageView
    [photos addObject:photo];
    [photo release];
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    [browser release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith, kMSTableViewHeight-44)];
    pageScroll.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_back"]];
    pageScroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:pageScroll];
    [pageScroll release];

    CGFloat bgStartY = 70.0f;
    UIImageView *bgTopView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kMSScreenWith, bgStartY)];
    bgTopView.image = [UIImage imageNamed:@"add_frined_bg"];
    bgTopView.userInteractionEnabled = YES;
    [pageScroll addSubview:bgTopView];
    [bgTopView release];
    
    /* 中间空白部分 名字 性别等 */
    UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, bgStartY, kMSScreenWith, 25)];
    secView.backgroundColor = [UIColor whiteColor];
    [pageScroll addSubview:secView];
    [secView release];
    
    nameLab = [[UILabel alloc]initWithFrame:CGRectZero];
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.textColor = COLOR(56, 56, 56, 1);
    nameLab.font=[UIFont systemFontOfSize:15];
    [secView addSubview:nameLab];
    [nameLab release];
    
    sexImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    [secView addSubview:sexImg];
    [sexImg release];

    
    /* 头像 */
    
    headImg = [[EGOImageView alloc] initWithFrame:CGRectMake(50, bgStartY-25, 50, 50)];
    headImg.userInteractionEnabled = YES;
    headImg.layer.borderWidth = 1;
    headImg.layer.cornerRadius = 4.0;
    headImg.layer.masksToBounds=YES;
    headImg.layer.borderColor = [[UIColor colorWithRed:242.0f/255 green:242.0f/255 blue:242.0f/255 alpha:1.0f] CGColor];
    [headImg addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]autorelease]];
    [headImg initWithPlaceholderImage:[UIImage imageNamed:@"headphoto_s"]];
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@",self.friendInfo.m_icon];
    if (urlStr.length >= 4)
    {
        [urlStr insertString:@"_middle" atIndex:urlStr.length-4];
    }
    headImg.imageURL = [NSURL URLWithString:urlStr];

//        UIImage *placeholder = [UIImage imageNamed:@"headphoto_s"];
//        [headImg setImageURLStr:self.friendInfo.m_icon placeholder:placeholder];

    [pageScroll addSubview:headImg];
    [headImg release];

    /* 公司 职位 */
    bgStartY += 25+15;
    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(25, bgStartY+2, 25, 25)];
    iconImg.image = [UIImage imageNamed:@"company_common_logo_bg"];
    [pageScroll addSubview:iconImg];
    [iconImg release];
    
    companyLab = [[UILabel alloc]initWithFrame:CGRectMake(25+25+5, bgStartY-10, 120, 50)];
    companyLab.backgroundColor = [UIColor clearColor];
    companyLab.textColor = kMSTextColor;
    companyLab.numberOfLines = 2;
    companyLab.text = self.friendInfo.m_company;
    companyLab.font=[UIFont systemFontOfSize:14];
    [pageScroll addSubview:companyLab];
    [companyLab release];

    jobLab = [[UILabel alloc]initWithFrame:CGRectMake(105+90, bgStartY-10, 120, 50)];
    jobLab.backgroundColor = [UIColor clearColor];
    jobLab.textColor = kMSTextColor;
    jobLab.text = [NSString stringWithFormat:@"职位: %@",self.friendInfo.m_job];
    jobLab.numberOfLines = 2;
    jobLab.font=[UIFont systemFontOfSize:14];
    [pageScroll addSubview:jobLab];
    [jobLab release];

    /* ta 的资料  */
    bgStartY += 25+15;
    
    UIImageView *bgMidView = [[UIImageView alloc] initWithFrame:CGRectMake(10, bgStartY, kMSScreenWith-20, 100)];
    bgMidView.image = [[UIImage imageNamed:@"round_white_cellbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    bgMidView.userInteractionEnabled = YES;
    [pageScroll addSubview:bgMidView];
    [bgMidView release];
    
    UIImageView *logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 16, 18, 18)];
    logoImg.image =[UIImage imageNamed:@"frined_profile_logo"];
    [bgMidView addSubview:logoImg];
    [logoImg release];
    
    UILabel *tmpLab = [[UILabel alloc]initWithFrame:CGRectMake(18+20, 10, 150, 30)];
    tmpLab.backgroundColor = [UIColor clearColor];
    tmpLab.text = [NSString stringWithFormat:@"TA的资料"];
    tmpLab.textColor = kMSTextColor;
    tmpLab.font=[UIFont systemFontOfSize:15];
    [bgMidView addSubview:tmpLab];
    [tmpLab release];
    
    UIImageView *moreImg = [[UIImageView alloc] initWithFrame:CGRectMake(280, 19, 8, 12)];
    moreImg.image =[UIImage imageNamed:@"cell_more_identify_bg"];
    [bgMidView addSubview:moreImg];
    [moreImg release];
    
    UIButton *buttomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buttomBtn.frame = CGRectMake(0, 0, 300, 50);
    buttomBtn.tag = 0x01;
    [buttomBtn addTarget:self action:@selector(handleMoreEvent:) forControlEvents:UIControlEventTouchUpInside];
    [bgMidView addSubview:buttomBtn];

    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(1, 49, 298, 1)];
    tmpView.backgroundColor = kMSLineColor;
    [bgMidView addSubview:tmpView];
    [tmpView release];

    /* 他的动态 */
    logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 16+50, 18, 18)];
    logoImg.image =[UIImage imageNamed:@"friend_dynamic_logo"];
    [bgMidView addSubview:logoImg];
    [logoImg release];
    
    tmpLab = [[UILabel alloc]initWithFrame:CGRectMake(18+20, 10+50, 150, 30)];
    tmpLab.backgroundColor = [UIColor clearColor];
    tmpLab.text = [NSString stringWithFormat:@"TA的动态"];
    tmpLab.textColor = kMSTextColor;
    tmpLab.font=[UIFont systemFontOfSize:15];
    [bgMidView addSubview:tmpLab];
    [tmpLab release];
    
    moreImg = [[UIImageView alloc] initWithFrame:CGRectMake(280, 19+50, 8, 12)];
    moreImg.image =[UIImage imageNamed:@"cell_more_identify_bg"];
    [bgMidView addSubview:moreImg];
    [moreImg release];
    
    buttomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buttomBtn.frame = CGRectMake(0, 50, 300, 50);
    buttomBtn.tag = 0x02;
    [buttomBtn addTarget:self action:@selector(handleMoreEvent:) forControlEvents:UIControlEventTouchUpInside];
    [bgMidView addSubview:buttomBtn];
    
    
    /*  加好友  发消息 */
    bgStartY += 100+50;
    buttomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buttomBtn.frame = CGRectMake(20, bgStartY, 280, 50);
    buttomBtn.tag = 0x03;
    buttomBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [buttomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttomBtn setBackgroundImage:[UIImage imageNamed:@"friend_profile_normal_bg"] forState:UIControlStateNormal];
    [buttomBtn setBackgroundImage:[UIImage imageNamed:@"friend_profile_hl_bg"] forState:UIControlStateHighlighted];
    [buttomBtn addTarget:self action:@selector(handleMoreEvent:) forControlEvents:UIControlEventTouchUpInside];
    _isExist = [[FDSDBManager sharedManager] existFriend:self.friendInfo.m_friendID];
    if (_isExist)  //存在
    {
        [buttomBtn setTitle:@"发送消息" forState:UIControlStateNormal];
        [self homeNavbarWithTitle:self.friendInfo.m_name andLeftButtonName:@"btn_caculate" andRightButtonName:@"navbar_remark_bg"];
    }
    else
    {
        [buttomBtn setTitle:@"加为好友" forState:UIControlStateNormal];
        [self homeNavbarWithTitle:self.friendInfo.m_name andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    }
    [pageScroll addSubview:buttomBtn];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [[FDSUserCenterMessageManager sharedManager] getUserCard:self.friendInfo.m_friendID];
	// Do any additional setup after loading the view.
}

#pragma mark - FDSUserCenterMessageInterface Method
- (void)getUserCardCB:(FDSUser*)contactInfo :(NSString*)result
{
    [SVProgressHUD popActivity];
    /*  获取好友的个人名片 */
    if ([result isEqualToString:@"OK"])
    {
        self.friendInfo = contactInfo;
        
        /* 更新profile 信息 */
        [self resetNameAndSexFrame];
//        UIImage *placeholder = [UIImage imageNamed:@"headphoto_s"];
//        [headImg setImageURLStr:self.friendInfo.m_icon placeholder:placeholder];
//        [headImg initWithPlaceholderImage:[UIImage imageNamed:@"headphoto_s"]];
//        headImg.imageURL = [NSURL URLWithString:self.friendInfo.m_icon];
        NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@",self.friendInfo.m_icon];
        if (urlStr.length >= 4)
        {
            [urlStr insertString:@"_middle" atIndex:urlStr.length-4];
        }
        headImg.imageURL = [NSURL URLWithString:urlStr];

        companyLab.text = self.friendInfo.m_company;
        jobLab.text = [NSString stringWithFormat:@"职位: %@",self.friendInfo.m_job];
        
        UIButton *handleBtn = (UIButton*)[pageScroll viewWithTag:0x03];
        if ([self.friendInfo.m_friendType isEqualToString:@"friend"] && !_isExist)
        {
            _isExist = YES;
            /* 还未加入到本地的好友 */
            [handleBtn setTitle:@"发送消息" forState:UIControlStateNormal];
            
            [self homeNavbarWithTitle:self.friendInfo.m_name andLeftButtonName:@"btn_caculate" andRightButtonName:@"navbar_remark_bg"];
            
            /* 添加该好友到本地 */
            [[FDSDBManager sharedManager]AddFriendToDB:self.friendInfo];
        }
        else if(![self.friendInfo.m_friendType isEqualToString:@"friend"] && _isExist)
        {
            _isExist = NO;
            /* 本地还未删除的非好友 */
            [handleBtn setTitle:@"加为好友" forState:UIControlStateNormal];
            
            /* 非好友不需要修改备注名字 */
            [self homeNavbarWithTitle:self.friendInfo.m_name andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
            
            /* 从本地删除该好友 */
            [[FDSDBManager sharedManager]deleteUserFriend:self.friendInfo];
        }
        else if([self.friendInfo.m_friendType isEqualToString:@"friend"] && _isExist)
        {
            /*  更新本地该好友信息 */
            [[FDSDBManager sharedManager]updateUserFriend:self.friendInfo];
            if (_refreshNavbar)
            {
                [self homeNavbarWithTitle:self.friendInfo.m_name andLeftButtonName:@"btn_caculate" andRightButtonName:@"navbar_remark_bg"];
            }
        }
        else
        {
            if (_refreshNavbar)
            {
                [self homeNavbarWithTitle:self.friendInfo.m_name andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
            }
        }
        /* 可以通知好友页面重新刷新列表数据  重读UserFriend DB */
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"获取个人名片失败"];
    }
}

- (void)handleMoreEvent:(id)sender
{
    switch ([sender tag])
    {
        case 0x01://TA的资料
        {
            FDSFriendDetailViewController *detailVC = [[FDSFriendDetailViewController alloc] init];
            detailVC.friendInfo = _friendInfo;
            [self.navigationController pushViewController: detailVC animated:YES];
            [detailVC release];
        }
            break;
        case 0x02: //TA的动态
        {
            FDSMySpaceViewController *spaceVC = [[FDSMySpaceViewController alloc]init];
            spaceVC.isMeInfo = NO;
            spaceVC.friendID = _friendInfo.m_friendID;
            [self.navigationController pushViewController:spaceVC animated:YES];
            [spaceVC release];
        }
            break;
        case 0x03: //加好友 发消息
        {
            if (_isExist)//发消息
            {
                FDSChatViewController *chatVC = [[FDSChatViewController alloc] init];
                /* 针对联系人操作 */
                FDSMessageCenter *messageCenter = [[FDSMessageCenter alloc] init];
                messageCenter.m_messageClass = FDSMessageCenterMessage_Class_USER; //个人信息
                messageCenter.m_messageType = FDSMessageCenterMessage_Type_CHAT_PERSON;
                messageCenter.m_icon = _friendInfo.m_icon; //消息中心头像都显示好友头像
                messageCenter.m_senderName = _friendInfo.m_name;//消息中心名字都显示好友名字
                messageCenter.m_senderID = _friendInfo.m_friendID;//好友ID
                messageCenter.m_param1 = @"";
                messageCenter.m_param2 = @"";
                messageCenter.m_newMessageCount = [[FDSDBManager sharedManager] getChatMessageUnread:messageCenter];
                
                chatVC.centerMessage = messageCenter;
                [messageCenter release];
                
                [self.navigationController pushViewController: chatVC animated:YES];
                [chatVC release];
            }
            else //加好友
            {
                if(USERSTATE_LOGIN != [[FDSUserManager sharedManager] getNowUserState]) /* 未登录成功 */
                {
                    FDSLoginViewController *loginVC = [[FDSLoginViewController alloc] init];
                    [self.navigationController pushViewController:loginVC animated:YES];
                    [loginVC release];
                    return;
                }
                if ([self.friendInfo.m_friendID isEqualToString:[[FDSUserManager sharedManager] getNowUser].m_userID])
                {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"不能添加自己为好友!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    [alertView release];
                    return;
                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"好友验证" message:@"请发送验证消息,对方通过后你才能添加其为好友" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
//                CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"好友验证" message:@"请发送验证消息,对方通过后你才能添加其为好友" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                [alert show];
                [alert release];
            }
        }
            break;
        default:
            break;
    }
}

/* 修改好友备注名 */
-(void)handleRightEvent
{
    UIActionSheet*alert = [[UIActionSheet alloc]
                           initWithTitle:nil
                           delegate:self
                           cancelButtonTitle:NSLocalizedString(@"取消",nil)
                           destructiveButtonTitle:nil
                           otherButtonTitles:NSLocalizedString(@"备注名",nil),
                           nil];
    [alert showInView:self.view];
    [alert release];
}

#pragma UIAlertViewDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex) //send
    {
        /* 发送添加好友请求 */
        NSString *keywords = [alertView textFieldAtIndex:0].text;
        [[FDSUserCenterMessageManager sharedManager]addFriend:self.friendInfo.m_friendID :keywords];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


#pragma UIActionSheetDelegate Method
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex)
    {
        /* 修改好友备注名 */
        FDSSearchFriendViewController *searchFriendVC = [[FDSSearchFriendViewController alloc] init];
        searchFriendVC.addStyle = MODIFY_FRIEND_REMARK_NAME;
        searchFriendVC.friendInfo = self.friendInfo;
        [self.navigationController pushViewController: searchFriendVC animated:YES];
        [searchFriendVC release];
    }
}



@end

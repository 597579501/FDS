//
//  FDSBarCommentViewController.m
//  FDS
//
//  Created by zhuozhong on 14-3-5.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSBarCommentViewController.h"
#import "UIViewController+BarExtension.h"
#import "Constants.h"
#import "CommentView.h"
#import "EGOImageButton.h"
#import "FDSPublicManage.h"
#import "SVProgressHUD.h"
#import "FDSUserManager.h"
#import "FDSLoginViewController.h"
#import "FDSPublicManage.h"
#import "FDSFriendProfileViewController.h"
#import "FDSComment.h"
#import "FDSRevert.h"
#import "UMSocial.h"
#import "FDSDBManager.h"
#import "FDSPublicManage.h"
#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "ZZSharedManager.h"


@interface FDSBarCommentViewController ()
{
    
}

@property(nonatomic,retain)UIWebView        *loadWebView;
@property(nonatomic,retain)UITableViewCell  *topviewCell;

@end

@implementation FDSBarCommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.barPostInfo = nil;
        self.commentDataArray = nil;
        
        isRefresh = NO;// 默认不刷新
        loadMore = NO;
        
        _isTotop = NO;
        
        sucPublish = NO;
        
        isChange = NO;
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
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];

    [_topviewCell release];
    
    [self.commentDataArray removeAllObjects];
    self.commentDataArray = nil;
    
    self.barPostInfo = nil;

    [faceBoard release];
    [super dealloc];
}

- (void)didChangeReplyValue:(NSInteger)currentIndex
{
    isChange = YES;
    currentRow = currentIndex;
}

- (void)handleSucRefresh
{
    sucPublish = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[FDSBarMessageManager sharedManager]registerObserver:self];
    if (sucPublish) /* 发布成功 */
    {
        [_commentTabView reloadData];
        if (self.commentDataArray.count > 0)
        {
            [_commentTabView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
        
        NSInteger count = [self.barPostInfo.m_commentNumber integerValue];
        count += 1;
        self.barPostInfo.m_commentNumber = [NSString stringWithFormat:@"%d",count];
        _commentNumLab.text = self.barPostInfo.m_commentNumber;

        sucPublish = NO;
    }
    else if (isChange)
    {
        //only refresh row in chatTable
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentRow+1 inSection:0];
        [_commentTabView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        isChange = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[FDSBarMessageManager sharedManager]unRegisterObserver:self];
}

- (void)handleRightEvent
{
    if (self.barPostInfo.m_url)
    {
//        [UMSocialSnsService presentSnsIconSheetView:self
//                                             appKey:@"532be5fb56240b2cdf0a2c8d"
//                                          shareText:self.barPostInfo.m_url
//                                         shareImage:[UIImage imageNamed:@"icon@2x.png"]
//                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToDouban,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToEmail,UMShareToSms,nil]
//                                           delegate:nil];
        NSString * imagePath = self.barPostInfo.m_senderIcon;
        if(self.barPostInfo.m_images.count > 0)
        {
            imagePath = self.barPostInfo.m_images[0];
        }
        
        
        [ZZSharedManager setSharedParam:self :self.barPostInfo.m_title :self.barPostInfo.m_url :imagePath :self.barPostInfo.m_content];
    }
}

/*  发帖人头像点击  */
- (void)postImgPressed
{
    if (![self.barPostInfo.m_senderID isEqualToString:[[FDSUserManager sharedManager] getNowUser].m_userID]) //非本账号
    {
        FDSFriendProfileViewController *fpVC = [[FDSFriendProfileViewController alloc]init];
        FDSUser *userInfo = [[FDSUser alloc] init];
        userInfo.m_friendID = self.barPostInfo.m_senderID;
        userInfo.m_name = self.barPostInfo.m_senderName;
        userInfo.m_icon = self.barPostInfo.m_senderIcon;
        fpVC.friendInfo = userInfo;
        [userInfo release];
        [self.navigationController pushViewController:fpVC animated:YES];
        [fpVC release];
    }
}

/*  点击发帖内容img  */
- (void)contentImgPressed:(id)sender
{
    
}

/*  点击收藏该发帖  */
- (void)didCollectWithClick
{
    NSMutableArray *collectTypeData = [[FDSPublicManage sharePublicManager]getCollectedDataWithType:FDS_COLLECTED_MESSAGE_POSTBAR];
    if (collectTypeData)
    {
        if (self.barPostInfo.m_isCollect)
        {
            [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"你已经收藏过"];
        }
        else
        {
            FDSCollectedInfo *newCompanyInfo = [[FDSCollectedInfo alloc] init];
            newCompanyInfo.m_collectType = FDS_COLLECTED_MESSAGE_POSTBAR;
            newCompanyInfo.m_collectID = self.barPostInfo.m_postID;
            newCompanyInfo.m_collectTitle = self.barPostInfo.m_title;
            newCompanyInfo.m_collectIcon = self.barPostInfo.m_senderIcon;
            newCompanyInfo.m_collectTime = [[FDSPublicManage sharePublicManager] getNowDate];
            
            [[FDSDBManager sharedManager] addCollectedInfoToDB:newCompanyInfo]; //add to DB
            
            [collectTypeData insertObject:newCompanyInfo atIndex:0];//add to cache
            [newCompanyInfo release];
            
            self.barPostInfo.m_isCollect = YES;
            [_collectBtn setBackgroundImage:[UIImage imageNamed:@"post_collected_bg"] forState:UIControlStateNormal];//刷新指定cell收藏状态
            
            [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"收藏成功"];
        }
    }
    else
    {
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"对不起 你没有登录 无法收藏"];
    }
}

#pragma -mark UIWebViewDelegate method
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGRect frame = webView.frame;
    NSString *fitHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
    frame.size.height = [fitHeight floatValue];
    _loadWebView.frame = frame;
    _loadWebView.delegate = nil;
    if (IOS_7)
    {
        _loadWebView.scrollView.scrollEnabled = NO;
    }
    
    
    CGRect colframe = _collectBtn.frame;
    colframe.origin.y+=frame.size.height;
    _collectBtn.frame = colframe;

    colframe = _commentImg.frame;
    colframe.origin.y+=frame.size.height;
    _commentImg.frame = colframe;

    colframe = _lastLineView.frame;
    colframe.origin.y+=frame.size.height;
    _lastLineView.frame = colframe;

    colframe = _commentNumLab.frame;
    colframe.origin.y+=frame.size.height;
    _commentNumLab.frame = colframe;

//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [_commentTabView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    [_commentTabView reloadData];//解决下移后的_collectBtn按钮事件触发不了
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = COLOR(234, 234, 234, 1);

//    [self homeNavbarWithTitle:@"查看帖子详情" andLeftButtonName:@"btn_caculate" andRightButtonName:@"navbar_post_share_bg"];
    [self homeNavbarWithTitle:@"查看帖子详情" andLeftButtonName:@"btn_caculate" andRightButtonName:@"分享"];

    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [[FDSBarMessageManager sharedManager]getPost:self.barPostInfo.m_postID];//得到一个帖子
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [[FDSBarMessageManager sharedManager]getPostComment:self.barPostInfo.m_postID :@"before" :@"-1" :10];//得到一个帖子的评论
	// Do any additional setup after loading the view.
}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    int count = self.barPostInfo.m_images.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:self.barPostInfo.m_images[i]]; // 图片路径
        if (i<=3)
        {
            photo.srcImageView = imgViews.subviews[i]; // 来源于哪个UIImageView
        }
        [photos addObject:photo];
        [photo release];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    [browser release];
}

- (void)tabeleViewInit
{
    _commentTabView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0,kMSNaviHight, kMSScreenWith, kMSTableViewHeight-88) style:UITableViewStylePlain];
    _commentTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _commentTabView.delegate = self;
    _commentTabView.dataSource = self;
    _commentTabView.pullingDelegate = self;
    _commentTabView.headerOnly = YES;
    [self.view addSubview:_commentTabView];
    [_commentTabView release];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGes:)];
    tap.cancelsTouchesInView=NO;
    [_commentTabView addGestureRecognizer:tap];
    [tap release];
    
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_back"]];
    if ([_commentTabView respondsToSelector:@selector(setBackgroundView:)])
    {
        [_commentTabView setBackgroundView:backImg];
    }
    [backImg release];
    
    [self postBarInfoViewInit];
    
    [self allSubViewInit];
}

- (void)postBarInfoViewInit
{
    _topviewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"postTopCell"];
    _topviewCell.backgroundColor = [UIColor clearColor];
    _topviewCell.selectionStyle=UITableViewCellSelectionStyleNone;

    cell_H = 5.0f;
    
    /*  是否置顶  */
    if(_isTotop)
    {
        UIImageView *topImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, cell_H, 35, 20)];
        topImg.userInteractionEnabled = YES;
        topImg.image = [UIImage imageNamed:@"post_to_top"];
        [_topviewCell.contentView addSubview:topImg];
        [topImg release];
        
        cell_H +=20;
    }
    
    /*  发帖时间  */
    UILabel *publishTimeLab = [[UILabel alloc]initWithFrame:CGRectZero];
    publishTimeLab.backgroundColor = [UIColor clearColor];
    publishTimeLab.textColor = [UIColor blackColor];
    publishTimeLab.font=[UIFont systemFontOfSize:17];
    [_topviewCell.contentView addSubview:publishTimeLab];
    [publishTimeLab release];
    
    /*  发帖标题  */
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor blackColor];
    titleLab.font=[UIFont systemFontOfSize:17];
    [_topviewCell.contentView addSubview:titleLab];
    [titleLab release];
    
    NSInteger lineNum = [[FDSPublicManage sharePublicManager] handleShowContent:self.barPostInfo.m_title :titleLab.font :190];
    titleLab.numberOfLines = lineNum;
    titleLab.frame = CGRectMake(125, cell_H, 190, 25*lineNum);
    titleLab.text = self.barPostInfo.m_title;
    
    publishTimeLab.frame = CGRectMake(5, cell_H+(25*lineNum)/2-12, 120, 25);
    /*  时间戳转时间  */
    NSTimeInterval timeValue = [self.barPostInfo.m_sendTime doubleValue];
    NSDate *confromTime = [NSDate dateWithTimeIntervalSince1970:timeValue/1000];
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yy-MM-dd"];
    publishTimeLab.text = [NSString stringWithFormat:@"【%@】",[formatter stringFromDate:confromTime]];
    
    cell_H += 25*lineNum+5;

    /*  分隔线  */
    UIView *postLineView = [[UIView alloc] initWithFrame:CGRectMake(1, cell_H, 318, 1)];
    postLineView.backgroundColor = COLOR(211, 211, 211, 1);
    [_topviewCell.contentView addSubview:postLineView];
    [postLineView release];
    cell_H+=1;
    
    
    
    
    /*  发帖人头像  */
    EGOImageButton *headImg = [EGOImageButton buttonWithType:UIButtonTypeCustom];
    headImg.adjustsImageWhenHighlighted = NO;
    [headImg addTarget:self action:@selector(postImgPressed) forControlEvents:UIControlEventTouchUpInside];
    headImg.frame = CGRectMake(15, cell_H+5, 50, 50);
    headImg.layer.borderWidth = 1;
    headImg.layer.cornerRadius = 4.0;
    headImg.layer.masksToBounds=YES;
    headImg.placeholderImage = [UIImage imageNamed:@"headphoto_s"];
    [headImg setImageURL:[NSURL URLWithString:self.barPostInfo.m_senderIcon]];
    headImg.layer.borderColor = [[UIColor colorWithRed:242.0f/255 green:242.0f/255 blue:242.0f/255 alpha:1.0f] CGColor];
    [_topviewCell.contentView addSubview:headImg];
    
    /*  发帖人名字  */
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(15+55, cell_H+8, 250, 30)];
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.textColor = COLOR(55, 123, 198, 1);
    nameLab.text = self.barPostInfo.m_senderName;
    nameLab.font=[UIFont systemFontOfSize:15];
    [_topviewCell.contentView addSubview:nameLab];
    [nameLab release];
    
    cell_H+=60.0f;
    
    /*  分隔线  */
    postLineView = [[UIView alloc] initWithFrame:CGRectMake(1, cell_H, 318, 1)];
    postLineView.backgroundColor = COLOR(211, 211, 211, 1);
    [_topviewCell.contentView addSubview:postLineView];
    [postLineView release];
    cell_H+=1+5;

    
    
    if ([self.barPostInfo.m_contentType isEqualToString:@"html"])
    {
        _loadWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, cell_H, kMSScreenWith, 1)];
        _loadWebView.backgroundColor = [UIColor clearColor];
        _loadWebView.delegate = self;
//        _loadWebView.alpha = 0.0f;
        NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:self.barPostInfo.m_content]];
        [_loadWebView loadRequest:request];
        _loadWebView.scalesPageToFit =YES;
        [_topviewCell.contentView addSubview:_loadWebView];
        [_loadWebView release];
        cell_H+=1+5.0f;
    }
    else
    {
        NSInteger imageCount = self.barPostInfo.m_images.count;
        if (imageCount > 0)
        {
            /*  发帖图片内容  */
            if (3 >= imageCount)
            {
                imgViews = [[UIView alloc] initWithFrame:CGRectMake(0, cell_H, kMSScreenWith, 120)];
            }
            else if(6 >= imageCount)
            {
                imgViews = [[UIView alloc] initWithFrame:CGRectMake(0, cell_H, kMSScreenWith, 120*2+5)];
            }
            else
            {
                imgViews = [[UIView alloc] initWithFrame:CGRectMake(0, cell_H, kMSScreenWith, 120*3+10)];
            }
            imgViews.backgroundColor = [UIColor clearColor];
            [_topviewCell.contentView addSubview:imgViews];
            [imgViews release];
            
            CGFloat imageWidth = 100.0f;
            
            UIImageView *contentImg = nil;
            for (int i=0; i<imageCount; i++)
            {
                if (i <= 2)
                {
                    contentImg = [[UIImageView alloc] initWithFrame:CGRectMake(5+i*(imageWidth+5), (120+5)*(i/3), imageWidth, 120)];
                }
                else if(i <= 5)
                {
                    contentImg = [[UIImageView alloc] initWithFrame:CGRectMake(5+(i-3)*(imageWidth+5), (120+5)*(i/3), imageWidth, 120)];
                }
                else
                {
                    contentImg = [[UIImageView alloc] initWithFrame:CGRectMake(5+(i-6)*(imageWidth+5), (120+5)*(i/3), imageWidth, 120)];
                }
                contentImg.userInteractionEnabled = YES;
                contentImg.tag = i;
                [contentImg addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]autorelease]];
                
                NSString *imageUrl = [self.barPostInfo.m_images objectAtIndex:i];
                if (imageUrl && [imageUrl length]>0)
                {
                    UIImage *placeholder = [UIImage imageNamed:@"loading_logo_bg"];
                    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@",imageUrl];
                    if (urlStr.length >= 4)
                    {
                        [urlStr insertString:@"_middle" atIndex:urlStr.length-4];
                    }
                    [contentImg setImageURLStr:urlStr placeholder:placeholder];
                }
                else
                {
                    contentImg.image = [UIImage imageNamed:@"loading_logo_bg"];
                }
                [imgViews addSubview:contentImg];
                [contentImg release];
                if (i > 8) //最多只显示9张
                {
                    break;
                }
            }

            cell_H += imgViews.frame.size.height+5.0f;
        }
        
        /*  发帖内容  */
        if (self.barPostInfo.m_content.length > 0)
        {
            CommentView *postContentView = [[CommentView alloc]initWithFrame:CGRectZero];
            postContentView.backgroundColor = [UIColor clearColor];
            postContentView.fontSize = 14.0f;
            postContentView.maxlength = 310;
            postContentView.facialSizeWidth = 18;
            postContentView.facialSizeHeight = 18;
            postContentView.textlineHeight = 20;
            [_topviewCell.contentView addSubview:postContentView];
            [postContentView release];
            
            CGFloat viewheight = [postContentView getcurrentViewHeight:self.barPostInfo.m_content];
            postContentView.frame = CGRectMake(5, cell_H, kMSScreenWith-10, viewheight);
            [postContentView showMessage:self.barPostInfo.m_content];
            
            cell_H += viewheight+5;
        }
        else
        {
            cell_H +=5;
        }
    }
    
    /*   收藏   */
    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectBtn.frame = CGRectMake(240, cell_H+11, 20, 20);
    _collectBtn.adjustsImageWhenHighlighted = NO;
    if (self.barPostInfo.m_isCollect)
    {
        [_collectBtn setBackgroundImage:[UIImage imageNamed:@"post_collected_bg"] forState:UIControlStateNormal];
    }
    else
    {
        [_collectBtn setBackgroundImage:[UIImage imageNamed:@"post_uncollect_bg"] forState:UIControlStateNormal];
    }
    [_collectBtn addTarget:self action:@selector(didCollectWithClick) forControlEvents:UIControlEventTouchUpInside];
    [_topviewCell.contentView addSubview:_collectBtn];
    
    _commentImg = [[UIImageView alloc] initWithFrame:CGRectMake(265, cell_H+8, 25, 25)];
    _commentImg.image = [UIImage imageNamed:@"post_comment_bg"];
    _commentImg.backgroundColor = [UIColor clearColor];
    [_topviewCell.contentView addSubview:_commentImg];
    [_commentImg release];
    
    /*   评论数   */
    _commentNumLab = [[UILabel alloc] initWithFrame:CGRectMake(292, cell_H+8, 25, 25)];
    _commentNumLab.textColor = COLOR(69, 69, 69, 1);
    _commentNumLab.backgroundColor = [UIColor clearColor];
    _commentNumLab.font = [UIFont systemFontOfSize:16];
    _commentNumLab.textAlignment = NSTextAlignmentLeft;
    [_topviewCell.contentView addSubview:_commentNumLab];
    [_commentNumLab release];
    _commentNumLab.text = self.barPostInfo.m_commentNumber;
    cell_H+=40.0f;
    
    /*  分隔线  */
    _lastLineView = [[UIView alloc] initWithFrame:CGRectMake(1, cell_H, 318, 1)];
    _lastLineView.backgroundColor = COLOR(211, 211, 211, 1);
    [_topviewCell.contentView addSubview:_lastLineView];
    [_lastLineView release];
    cell_H+=1;
}


- (void)allSubViewInit
{
    /* 信息操作view */
    toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, kMSNaviHight+(kMSTableViewHeight-88), kMSScreenWith, 44)];
    toolBar.backgroundColor = COLOR(34, 34, 34, 1);
    [self.view addSubview:toolBar];
    [toolBar release];
    
    photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    photoBtn.frame = CGRectMake(10, 8, 28, 28);
    photoBtn.adjustsImageWhenHighlighted = NO;
    [photoBtn addTarget:self action:@selector(didSelectPhoto) forControlEvents:UIControlEventTouchUpInside];
    [photoBtn setBackgroundImage:[UIImage imageNamed:@"chat_photo_bg"] forState:UIControlStateNormal];
    [toolBar addSubview:photoBtn];
    
    keyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    keyboardButton.frame = CGRectMake(48, 8, 28, 28);
    keyboardButton.adjustsImageWhenHighlighted = NO;
    [keyboardButton addTarget:self action:@selector(exchangeTextAndEmoji:) forControlEvents:UIControlEventTouchUpInside];
    [keyboardButton setBackgroundImage:[UIImage imageNamed:@"board_emoji"] forState:UIControlStateNormal];
    [toolBar addSubview:keyboardButton];
    
    textView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(86, 5, 270-86, 34)];
    textView.font = [UIFont systemFontOfSize:16.0f];
    textView.textColor = kMSTextColor;
    textView.placeholder = @"输入信息内容";
    textView.delegate = self;
    //textView.contentInset = UIEdgeInsetsMake(6.0f, 6.0f, 6.0f, 6.0f);
    [textView.layer setCornerRadius:6];
    [textView.layer setMasksToBounds:YES];
    [toolBar addSubview:textView];
    [textView release];
    
    sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake(270, 0, 50, 44);
    sendButton.adjustsImageWhenHighlighted = NO;
    [sendButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendCommentMessage) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:sendButton];
    
    /* 表情view */
    if (!faceBoard)
    {
        faceBoard = [[FaceBoard alloc] init];
        faceBoard.delegate = self;
        faceBoard.inputTextView = textView;
    }
}


- (void)handleGes:(UIGestureRecognizer *)guestureRecognizer
{
    if ([textView isFirstResponder])
    {
        [textView resignFirstResponder];
    }
}

/*  发布带有图片的帖子评论  */
- (void)didSelectPhoto
{
    FDSSendCommentViewController *sendVC = [[FDSSendCommentViewController alloc] init];
    sendVC.delegate = self;
    sendVC.send_type = SEND_NEW_MESSAGE_TYPE_BAR;
    sendVC.recordList = self.commentDataArray;
    sendVC.objectID = self.barPostInfo.m_postID;
    
    [self.navigationController pushViewController:sendVC animated:YES];
    [sendVC release];
}

- (void)exchangeTextAndEmoji:(id)sender
{
    if ( isKeyboardShowing )
    {
        if ( ![textView.inputView isEqual:faceBoard] )
        {
            isSystemBoardShow = NO;
            textView.inputView = faceBoard;
        }
        else
        {
            isSystemBoardShow = YES;
            textView.inputView = nil;
        }
        [textView reloadInputViews];
    }
    else
    {
        if ( isFirstShowKeyboard )
        {
            isFirstShowKeyboard = NO;
            isSystemBoardShow = NO;
        }
        if ( !isSystemBoardShow )
        {
            textView.inputView = faceBoard;
        }
        [textView becomeFirstResponder];
    }
}


/** ################################ UIKeyboardNotification################################ **/

- (void)keyboardWillShow:(NSNotification *)notification
{
    isKeyboardShowing = YES;
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         CGRect frame = toolBar.frame;
                         frame.origin.y += keyboardHeight;
                         frame.origin.y -= keyboardRect.size.height;
                         toolBar.frame = frame;
                         
                         keyboardHeight = keyboardRect.size.height;
                     }];
    if ( isFirstShowKeyboard )
    {
        isFirstShowKeyboard = NO;
        isSystemBoardShow = YES;
    }
    
    if ( isSystemBoardShow )//显示键盘时
    {
        [keyboardButton setBackgroundImage:[UIImage imageNamed:@"board_emoji"] forState:UIControlStateNormal];
    }
    else//显示表情时
    {
        [keyboardButton setBackgroundImage:[UIImage imageNamed:@"board_system"] forState:UIControlStateNormal];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         CGRect frame = toolBar.frame;
                         frame.origin.y += keyboardHeight;
                         toolBar.frame = frame;
                         
                         keyboardHeight = 0;
                     }];
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    isKeyboardShowing = NO;
    isFirstShowKeyboard = YES;
    
    textView.inputView = nil;
    
    [keyboardButton setBackgroundImage:[UIImage imageNamed:@"board_emoji"]
                              forState:UIControlStateNormal];
}


/* 发布评论 */
- (void)sendCommentMessage
{
    if(USERSTATE_LOGIN != [[FDSUserManager sharedManager] getNowUserState]) /* 未登录成功 */
    {
//        FDSLoginViewController *loginVC = [[FDSLoginViewController alloc] init];
//        [self.navigationController pushViewController:loginVC animated:YES];
//        [loginVC release];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"对不起 你没有登录 不能评论" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    if (textView.text)
    {
        self.publishContent = [textView.text stringByTrimmingCharactersInSet:whitespace];
    }
    
    if (self.publishContent && self.publishContent.length > 0)
    {
        /* 发送 */
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        [[FDSBarMessageManager sharedManager] sendPostComment:@"comment" :self.barPostInfo.m_postID :@"" :self.publishContent :nil];
        
        textView.text = nil;
        textView.contentSize = CGSizeMake(184, 36);
        [self textViewDidChange:textView];
        [textView resignFirstResponder];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
//        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"内容不能为空"];
    }
}

#pragma mark - FDSBarMessageInterface Methods
//发布评论回调
- (void)sendPostCommentCB:(NSString *)result :(NSString *)commentID
{
    [SVProgressHUD popActivity];
    if ([result isEqualToString:@"OK"])
    {
        FDSComment *comment = [[FDSComment alloc] init];
        comment.m_commentID = commentID;
        comment.m_content = self.publishContent;
        FDSUser *userInfo = [[FDSUserManager sharedManager] getNowUser];
        comment.m_senderID = userInfo.m_userID;
        comment.m_senderIcon = userInfo.m_icon;
        comment.m_senderName = userInfo.m_name;
        comment.m_sendTime = [[FDSPublicManage sharePublicManager] getNowDate];
        comment.m_images = [[[NSMutableArray alloc] init] autorelease];
        comment.m_revertCount = 0;
        comment.m_revertsList = [[[NSMutableArray alloc] init] autorelease];
        
        [self.commentDataArray insertObject:comment atIndex:0];
        [comment release];
        
        NSInteger count = [self.barPostInfo.m_commentNumber integerValue];
        count += 1;
        self.barPostInfo.m_commentNumber = [NSString stringWithFormat:@"%d",count];
        _commentNumLab.text = self.barPostInfo.m_commentNumber;

        [_commentTabView reloadData];
        [_commentTabView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        
        self.publishContent = nil;
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"评论发布失败"];
    }
}

//得到一个帖子回调
- (void)getPostCB:(FDSBarPostInfo *)posBarInfo
{
    self.barPostInfo.m_title = posBarInfo.m_title;
    self.barPostInfo.m_contentType = posBarInfo.m_contentType;
    self.barPostInfo.m_content = posBarInfo.m_content;
    self.barPostInfo.m_url = posBarInfo.m_url;//获取帖子信息的分享URL
    self.barPostInfo.m_senderName  = posBarInfo.m_senderName;
    self.barPostInfo.m_senderIcon  = posBarInfo.m_senderIcon;
    self.barPostInfo.m_senderID  = posBarInfo.m_senderID;
    self.barPostInfo.m_sendTime  = posBarInfo.m_sendTime;
    self.barPostInfo.m_commentNumber = posBarInfo.m_commentNumber;
    self.barPostInfo.m_images = posBarInfo.m_images;
    
    [self tabeleViewInit];
}

//获取评论列表回调
- (void)getPostCommentCB:(NSMutableArray *)commentList
{
    if (isRefresh)
    {
        [_commentTabView tableViewDidFinishedLoading];
        [self.commentDataArray removeAllObjects];
    }
    else
    {
        [SVProgressHUD popActivity];
    }
    NSInteger beforeConut = [_commentDataArray count];
    if (self.commentDataArray)
    {
        [self.commentDataArray addObjectsFromArray:commentList];
    }
    else
    {
        self.commentDataArray = commentList;
    }
    
    if (commentList.count >= 10)/* 如果拉取到足够跳数 就显示加载更多*/
    {
        loadMore = YES;
    }
    else
    {
        loadMore = NO;
    }
    
    [_commentTabView reloadData];
    
    if (beforeConut > 0)
    {
        [_commentTabView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:beforeConut inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

#pragma-mark UITableViewDataSource UITableViewDelegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (loadMore)
    {
        return [self.commentDataArray count]+2;
    }
    else
    {
        return [self.commentDataArray count]+1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        if ([self.barPostInfo.m_contentType isEqualToString:@"html"])
        {
            return cell_H+_loadWebView.frame.size.height;
        }
        else
        {
            return cell_H;
        }
    }
    if (loadMore) //显示
    {
        if (indexPath.row == self.commentDataArray.count+1)//点击加载更多评论
        {
            return 5+40+20;
        }
        CommentFeedsCell *commentCell = (CommentFeedsCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return [commentCell getCurrentCellHeight];
    }
    else
    {
        CommentFeedsCell *commentCell = (CommentFeedsCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        if (indexPath.row == self.commentDataArray.count)
        {
            return [commentCell getCurrentCellHeight]+20;
        }
        return [commentCell getCurrentCellHeight];
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* commentStr = @"barCommentCellIndentify";
    
    if (indexPath.row == self.commentDataArray.count+1)  //点击加载更多
    {
        UITableViewCell *moreCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"barLoadMoreCell"] autorelease];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(5, 5, 310, 40);
        [button setBackgroundImage:[UIImage imageNamed:@"load_more_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"load_more_hl"] forState:UIControlStateHighlighted];
        [button setTitle:@"点击加载更多评论" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(loadmoreComment) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [moreCell.contentView addSubview:button];
        
        moreCell.backgroundColor = [UIColor clearColor];
        moreCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return moreCell;
    }
    else if(0 == indexPath.row)
    {
        return _topviewCell;
    }
    CommentFeedsCell* commentCell = [tableView dequeueReusableCellWithIdentifier:commentStr];
    if(nil == commentCell)
    {
        commentCell = [[[CommentFeedsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentStr] autorelease];
    }
    
    //loadData
    commentCell.indexTag = [indexPath row]-1;
    commentCell.delegate = self;
    [commentCell loadCellData:[self.commentDataArray objectAtIndex:indexPath.row-1]];
    return commentCell;
}

/*    点击加载更多   */
- (void)loadmoreComment
{
    isRefresh = NO;
    FDSComment *comment = [self.commentDataArray objectAtIndex:self.commentDataArray.count-1];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [[FDSBarMessageManager sharedManager]getPostComment:self.barPostInfo.m_postID :@"before" :comment.m_commentID :10];
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    isRefresh  = YES;
    [[FDSBarMessageManager sharedManager]getPostComment:self.barPostInfo.m_postID :@"before" :@"-1" :10];
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
}

- (NSDate *)pullingTableViewRefreshingFinishedDate
{
    NSDate *date = [NSDate date];
    return date;
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_commentTabView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_commentTabView tableViewDidEndDragging:scrollView];
}

/** ################################ UITextViewDelegate ################################ **/
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if( [text length] == 0 )//点击了删除键
    {
        if ( range.length > 1 )
        {
            return YES;
        }
        else
        {
            [faceBoard backFace];
            return NO;
        }
    }
    else //点击了非删除键
    {
        return YES;
    }
}

- (void)textViewDidChange:(UITextView *)_textView
{
    CGSize size;
    if (IOS_7)
    {
        CGSize constraint = CGSizeMake(textView.contentSize.width - 8.0f, CGFLOAT_MAX);
        size = [textView.text sizeWithFont: textView.font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        size.height += 16.0f;
        size.width = textView.contentSize.width;
    }
    else
    {
        size = textView.contentSize;
    }
    
    if ( size.height > 82 )
    {
        size.height = 82;
    }
    else if ( size.height < 34 )
    {
        size.height = 34;
    }
    if ( size.height != textView.frame.size.height )
    {
        if (size.height != 34)
        {
            size.height -= 2;
        }
        
        CGFloat span = size.height - textView.frame.size.height;
        
        CGRect frame = toolBar.frame;
        frame.origin.y -= span;
        frame.size.height += span;
        toolBar.frame = frame;
        
        CGFloat centerY = frame.size.height / 2;
        
        frame = textView.frame;
        frame.size = size;
        textView.frame = frame;
        
        CGPoint center = textView.center;
        center.y = centerY;
        textView.center = center;
        
        center = keyboardButton.center;
        center.y = centerY;
        keyboardButton.center = center;
        
        center = photoBtn.center;
        center.y = centerY;
        photoBtn.center = center;
        
        center = sendButton.center;
        center.y = centerY;
        sendButton.center = center;
    }
}


#pragma-mark CommentFeedBtnDelegate methods
- (void)didClickReplyBtn:(NSInteger)currentTag
{
    FDSRevertListViewController *revertVC = [[FDSRevertListViewController alloc] init];
    revertVC.commentInfo = [self.commentDataArray objectAtIndex:currentTag];
    revertVC.indexTag = currentTag;
    revertVC.delegate = self;
    revertVC.revertType = COMMENT_REVERT_SHOW_POSTBAR;
    [self.navigationController pushViewController:revertVC animated:YES];
    [revertVC release];
}

/*   删除处理   */
- (void)didClickDeleteBtn:(NSInteger)currentTag
{
    deleteIndex = currentTag;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除评论" message:@"确定删除吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    [alert release];
}

/* 评论人头像选择 */
- (void)didSelectCommentHead:(NSInteger)currentIndex
{
    FDSComment *commentInfo = [self.commentDataArray objectAtIndex:currentIndex];
    if (![commentInfo.m_senderID isEqualToString:[[FDSUserManager sharedManager] getNowUser].m_userID]) //非本账号
    {
        FDSFriendProfileViewController *fpVC = [[FDSFriendProfileViewController alloc]init];
        FDSUser *userInfo = [[FDSUser alloc] init];
        userInfo.m_friendID = commentInfo.m_senderID;
        userInfo.m_name = commentInfo.m_senderName;
        userInfo.m_icon = commentInfo.m_senderIcon;
        fpVC.friendInfo = userInfo;
        [userInfo release];
        [self.navigationController pushViewController:fpVC animated:YES];
        [fpVC release];
    }
}


/* 回复人头像选择 */
- (void)didSelectReplyHead:(NSInteger)currentIndex :(NSInteger)replyIndex
{
    FDSComment *commentInfo = [self.commentDataArray objectAtIndex:currentIndex];
    FDSRevert *revertInfo = [commentInfo.m_revertsList objectAtIndex:replyIndex];
    if (![revertInfo.m_senderID isEqualToString:[[FDSUserManager sharedManager] getNowUser].m_userID]) //非本账号
    {
        FDSFriendProfileViewController *fpVC = [[FDSFriendProfileViewController alloc]init];
        FDSUser *userInfo = [[FDSUser alloc] init];
        userInfo.m_friendID = revertInfo.m_senderID;
        userInfo.m_name = revertInfo.m_senderName;
        userInfo.m_icon = revertInfo.m_senderIcon;
        fpVC.friendInfo = userInfo;
        [userInfo release];
        [self.navigationController pushViewController:fpVC animated:YES];
        [fpVC release];
    }
}


#pragma-mark UIAlertViewDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex) //send
    {
        FDSComment *commentInfo = [self.commentDataArray objectAtIndex:deleteIndex];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        [[FDSBarMessageManager sharedManager]deletePostCommentRevert:self.barPostInfo.m_postID :@"comment" :commentInfo.m_commentID];
    }
}

#pragma-mark FDSCompanyMessageInterface methods
- (void)deletePostCommentRevertCB:(NSString *)result
{
    [SVProgressHUD popActivity];
    if ([result isEqualToString:@"OK"])
    {
        /* page */
        [self.commentDataArray removeObjectAtIndex:deleteIndex]; //cache
        
        NSInteger count = [self.barPostInfo.m_commentNumber integerValue];
        count -= 1;
        self.barPostInfo.m_commentNumber = [NSString stringWithFormat:@"%d",count];
        _commentNumLab.text = self.barPostInfo.m_commentNumber;
        [_commentTabView reloadData];
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"删除成功"];
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"删除失败"];
    }
}


@end

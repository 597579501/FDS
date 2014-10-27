//
//  FDSCommentListViewController.m
//  FDS
//
//  Created by zhuozhongkeji on 13-12-30.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "FDSCommentListViewController.h"
#import "UIViewController+BarExtension.h"
#import "Constants.h"
#import "SVProgressHUD.h"
#import "FDSUserManager.h"
#import "FDSLoginViewController.h"
#import "FDSPublicManage.h"
#import "FDSFriendProfileViewController.h"

@interface FDSCommentListViewController ()
{
}
@end

@implementation FDSCommentListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isRefresh = NO;// 默认不刷新
        loadMore = NO;
        self.publishContent = nil;
        self.companyInfo = nil;
        isChange = NO;
        
        sucPublish = NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [[FDSCompanyMessageManager sharedManager] registerObserver:self];
    
    if (sucPublish) /* 成功发布黄页评论 */
    {
        [_commentTabView reloadData];
        if (self.commentDataArray.count > 0)
        {
            [_commentTabView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
        if (self.companyInfo || [_commentObjectType isEqualToString:@"company"]) //只有公司主页才有评论总数
        {
            NSInteger count = [self.companyInfo.m_commentCount integerValue];
            count += 1;
            self.companyInfo.m_commentCount = [NSString stringWithFormat:@"%d",count];
        }
        sucPublish = NO;
    }
    else if (isChange)
    {
        //only refresh row in chatTable
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentRow inSection:0];
        [_commentTabView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        isChange = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[FDSCompanyMessageManager sharedManager] unRegisterObserver:self];
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
    self.publishContent = nil;
    
    self.companyInfo = nil;
    
    [self.commentDataArray removeAllObjects];
    self.commentDataArray = nil;
    
    [_commentObjectID release];
    [_commentObjectType release];
    
    [faceBoard release];
    [super dealloc];
}

- (void)allSubViewInit
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGes:)];
    tap.cancelsTouchesInView=NO;
    [_commentTabView addGestureRecognizer:tap];
    [tap release];
    
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

- (void)didSelectPhoto
{
    FDSSendCommentViewController *sendVC = [[FDSSendCommentViewController alloc] init];
    sendVC.delegate = self;
    sendVC.send_type = SEND_NEW_MESSAGE_TYPE_COMMENT;
    sendVC.recordList = self.commentDataArray;
    sendVC.commentObjectType = self.commentObjectType;
    sendVC.objectID = self.commentObjectID;

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


/** ################################ ViewController ################################ **/
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self homeNavbarWithTitle:@"所有评论" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _commentTabView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0,kMSNaviHight, kMSScreenWith, kMSTableViewHeight-88) style:UITableViewStylePlain];
    _commentTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _commentTabView.delegate = self;
    _commentTabView.dataSource = self;
    _commentTabView.pullingDelegate = self;
    _commentTabView.headerOnly = YES;
    [self.view addSubview:_commentTabView];
    [_commentTabView release];

    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_back"]];
    if ([_commentTabView respondsToSelector:@selector(setBackgroundView:)])
    {
        [_commentTabView setBackgroundView:backImg];
    }
    [backImg release];

    [self allSubViewInit];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];

    /* 拉取最新的10条评论 */
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [[FDSCompanyMessageManager sharedManager]getCompanyCommentList:_commentObjectID :_commentObjectType :@"-1" :@"before" :10];
	// Do any additional setup after loading the view.
}


#pragma-mark UIAlertViewDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex) //send
    {
        FDSComment *commentInfo = [self.commentDataArray objectAtIndex:deleteIndex];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        [[FDSCompanyMessageManager sharedManager]deleteCompanyCommentRevert:_commentObjectID :@"comment" :commentInfo.m_commentID];
    }
}

#pragma-mark FDSCompanyMessageInterface methods
- (void)deleteCompanyCommentRevertCB:(NSString*)result
{
    [SVProgressHUD popActivity];
    if ([result isEqualToString:@"OK"])
    {
        /* page */
        [self.commentDataArray removeObjectAtIndex:deleteIndex]; //cache
        [_commentTabView reloadData];
        
        if (self.companyInfo || [_commentObjectType isEqualToString:@"company"]) //只有公司主页才有评论总数
        {
            NSInteger count = [self.companyInfo.m_commentCount integerValue];
            count -= 1;
            self.companyInfo.m_commentCount = [NSString stringWithFormat:@"%d",count];
        }

//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:deleteIndex inSection:0];
//        [_commentTabView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"删除失败"];
    }
}

- (void)getCompanyCommentListCB:(NSMutableArray*)commentList
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
    
    if (commentList.count == 11)/* 如果拉取到足够跳数 就显示加载更多*/
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
        [_commentTabView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:beforeConut - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

/* 发布评论回调 */
- (void)companyCommentCB:(NSString*)result :(NSString*)commentID
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
        
        [_commentTabView reloadData];
        [_commentTabView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];

        self.publishContent = nil;
        
        if (self.companyInfo || [_commentObjectType isEqualToString:@"company"]) //只有公司主页才有评论总数
        {
            NSInteger count = [self.companyInfo.m_commentCount integerValue];
            count += 1;
            self.companyInfo.m_commentCount = [NSString stringWithFormat:@"%d",count];
        }
    }
    else
    {
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"评论发布失败"];
    }
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

//        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"对不起 你没有登录 不能评论"];
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
        [[FDSCompanyMessageManager sharedManager] companyComment:_commentObjectType :@"comment" :_commentObjectID :@"" :self.publishContent :nil];

        textView.text = nil;
        textView.contentSize = CGSizeMake(184, 36);
        [self textViewDidChange:textView];
        [textView resignFirstResponder];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"评论内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
//        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"评论内容不能为空"];
    }
}

#pragma-mark UITableViewDataSource UITableViewDelegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (loadMore)
    {
        return [self.commentDataArray count]+1;
    }
    else
    {
        return [self.commentDataArray count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentFeedsCell *commentCell = (CommentFeedsCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (loadMore) //显示
    {
        if (indexPath.row == self.commentDataArray.count)//点击加载更多评论
        {
            return 5+40+20;
        }
        return [commentCell getCurrentCellHeight];
    }
    else
    {
        if (indexPath.row == self.commentDataArray.count-1)
        {
            return [commentCell getCurrentCellHeight]+20;
        }
        return [commentCell getCurrentCellHeight];
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* commentStr = @"commentCellIndentify";
    
    if (indexPath.row == self.commentDataArray.count)  //点击加载更多
    {
        UITableViewCell *moreCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loadMoreCell"] autorelease];
        
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
    
    CommentFeedsCell* commentCell = [tableView dequeueReusableCellWithIdentifier:commentStr];
    if(nil == commentCell)
    {
        commentCell = [[[CommentFeedsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentStr] autorelease];
    }
    
    //loadData
    commentCell.indexTag = [indexPath row];
    commentCell.delegate = self;
    [commentCell loadCellData:[self.commentDataArray objectAtIndex:indexPath.row]];
    return commentCell;
}


/*    点击加载更多   */
- (void)loadmoreComment
{
    isRefresh = NO;
    FDSComment *comment = [self.commentDataArray objectAtIndex:self.commentDataArray.count-1];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [[FDSCompanyMessageManager sharedManager]getCompanyCommentList:_commentObjectID :_commentObjectType :comment.m_commentID :@"before" :10];
}

#pragma-mark CommentFeedBtnDelegate methods
- (void)didClickReplyBtn:(NSInteger)currentTag
{
    FDSRevertListViewController *revertVC = [[FDSRevertListViewController alloc] init];
    revertVC.commentInfo = [self.commentDataArray objectAtIndex:currentTag];
    revertVC.indexTag = currentTag;
    revertVC.delegate = self;
    revertVC.revertType = COMMENT_REVERT_SHOW_DYNAMIC;
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

/* 选择内容图片 */
- (void)didSelectContentImg:(NSInteger)currentIndex :(NSInteger)imgIndex
{
    
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

#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    isRefresh  = YES;
    [[FDSCompanyMessageManager sharedManager]getCompanyCommentList:_commentObjectID :_commentObjectType :@"-1" :@"before" :10];
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

@end

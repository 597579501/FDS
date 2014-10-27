//
//  FDSMySpaceViewController.m
//  FDS
//
//  Created by zhuozhongkeji on 14-1-14.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSMySpaceViewController.h"
#import "UIViewController+BarExtension.h"
#import "FDSUserManager.h"
#import "SVProgressHUD.h"
#import "FDSPublicManage.h"
#import "FDSFriendProfileViewController.h"

@interface FDSMySpaceViewController ()

@end

@implementation FDSMySpaceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if ( !sizeList )
        {
            sizeList = [[NSMutableDictionary alloc] init];
        }
        isFirstShowKeyboard = YES; //默认第一次显示键盘
        isRefresh = NO;// 默认不刷新
        loadMore = NO;
        
        self.publishContent = nil;
        self.friendID = nil;
        
        recordContentView = [[CommentView alloc]initWithFrame:CGRectZero];
        recordContentView.fontSize = 15.0f;
        recordContentView.facialSizeWidth = 18;
        recordContentView.facialSizeHeight = 18;
        recordContentView.textlineHeight = 20;  //用于计算cell高度
        
        sucPublish = NO;
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
    [[FDSUserCenterMessageManager sharedManager]registerObserver:self];
    
    if (sucPublish)
    {
        [sizeList removeAllObjects];
        [_spaceManageTable reloadData];
        if (self.dynamicDataArray.count > 0)
        {
            [_spaceManageTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
    sucPublish = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[FDSUserCenterMessageManager sharedManager]unRegisterObserver:self];
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
    
    self.friendID = nil;

    [faceBoard release];
    
    [recordContentView release];
    
    [sizeList removeAllObjects];
    [sizeList release];

    [self.dynamicDataArray removeAllObjects];
    self.dynamicDataArray = nil;
    
    [super dealloc];
}

/* 初始化发信息控件 */
- (void)allMessageControlInit
{
    /* 信息操作view */
    toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, kMSNaviHight+(kMSTableViewHeight-44), kMSScreenWith, 44)];
    toolBar.backgroundColor = COLOR(34, 34, 34, 1);
    [self.view addSubview:toolBar];
    [toolBar release];
    
    keyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    keyboardButton.frame = CGRectMake(10, 8, 28, 28);
    keyboardButton.adjustsImageWhenHighlighted = NO;
    [keyboardButton addTarget:self action:@selector(exchangeTextAndEmoji:) forControlEvents:UIControlEventTouchUpInside];
    [keyboardButton setBackgroundImage:[UIImage imageNamed:@"board_emoji"] forState:UIControlStateNormal];
    [toolBar addSubview:keyboardButton];
    
    textView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(48, 5, 270-48, 34)];
    textView.font = [UIFont systemFontOfSize:16.0f];
    textView.textColor = kMSTextColor;
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
    [sendButton addTarget:self action:@selector(sendRevertMessage) forControlEvents:UIControlEventTouchUpInside];
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
        textView.text = nil;
        textView.contentSize = CGSizeMake(222, 36);
        [self textViewDidChange:textView];
        [textView resignFirstResponder];
    }
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
                         frame.origin.y -= (keyboardRect.size.height+44);
                         toolBar.frame = frame;
                         
                         keyboardHeight = keyboardRect.size.height+44;
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
        
        center = sendButton.center;
        center.y = centerY;
        sendButton.center = center;
    }
}

- (void)handleSucRefresh
{
    sucPublish = YES;
}

- (void)handleRightEvent
{
    FDSSendCommentViewController *sendVC = [[FDSSendCommentViewController alloc] init];
    sendVC.delegate = self;
    sendVC.send_type = SEND_NEW_MESSAGE_TYPE_DYNAMIC;
    sendVC.recordList = self.dynamicDataArray;
    
    [self.navigationController pushViewController:sendVC animated:YES];
    [sendVC release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(_isMeInfo)
    {
        [self homeNavbarWithTitle:@"我的动态" andLeftButtonName:@"btn_caculate" andRightButtonName:@"navbar_post_new_bg"];
    }
    else
    {
        [self homeNavbarWithTitle:@"TA的动态" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    }
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _spaceManageTable = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith,kMSTableViewHeight-44) style:UITableViewStylePlain];
    _spaceManageTable.delegate = self;
    _spaceManageTable.dataSource = self;
    _spaceManageTable.pullingDelegate = self;
    _spaceManageTable.headerOnly = YES;
    _spaceManageTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_spaceManageTable];
    [_spaceManageTable release];
    
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_back"]];
    if ([_spaceManageTable respondsToSelector:@selector(setBackgroundView:)])
    {
        [_spaceManageTable setBackgroundView:backImg];
    }
    [backImg release];
    
    [self allMessageControlInit];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGes:)];
    tap.cancelsTouchesInView=NO;
    [_spaceManageTable addGestureRecognizer:tap];
    [tap release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    if (_isMeInfo)
    {
        [[FDSUserCenterMessageManager sharedManager]getUserRecord:[[FDSUserManager sharedManager] getNowUser].m_userID :@"-1" :@"before" :10];
    }
    else
    {
        [[FDSUserCenterMessageManager sharedManager]getUserRecord:self.friendID :@"-1" :@"before" :10];
    }
	// Do any additional setup after loading the view.
}

#pragma mark - FDSUserCenterMessageInterface Method
- (void)getUserRecordCB:(NSMutableArray *)recordList
{
    if (isRefresh)
    {
        [_spaceManageTable tableViewDidFinishedLoading];
        [self.dynamicDataArray removeAllObjects];
    }
    else
    {
        [SVProgressHUD popActivity];
    }
    NSInteger beforeConut = [_dynamicDataArray count];
    if (self.dynamicDataArray)
    {
        [self.dynamicDataArray addObjectsFromArray:recordList];
    }
    else
    {
        self.dynamicDataArray = recordList;
    }
    
    if (recordList.count >= 10)/* 如果拉取到足够跳数 就显示加载更多*/
    {
        loadMore = YES;
    }
    else
    {
        loadMore = NO;
    }
    [sizeList removeAllObjects];
    [_spaceManageTable reloadData];
    
    if (beforeConut > 0)
    {
        [_spaceManageTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:beforeConut - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}


#pragma mark - UITableViewDelegate UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (loadMore)
    {
        return [self.dynamicDataArray count]+1;
    }
    return [self.dynamicDataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.dynamicDataArray.count)//点击加载更多评论
    {
        return 5+40+20;
    }
    
    NSValue *sizeValue = [sizeList valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    if ( !sizeValue )
    {
        [self getContentSize:indexPath :[self.dynamicDataArray objectAtIndex:indexPath.row]];
        sizeValue = [sizeList valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    }
    CGSize size = [sizeValue CGSizeValue];
    if (indexPath.row == self.dynamicDataArray.count-1)
    {
        return size.height+=20;
    }
    return size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.dynamicDataArray.count)  //点击加载更多
    {
        UITableViewCell *moreCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"spaceLoadMoreCell"] autorelease];
        
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
    static NSString* cellIndify = @"SpaceDynamicListCell";
    SpaceDynamicListCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIndify];
    if(nil == cell)
    {
        cell = [[[SpaceDynamicListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndify] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //loadData
    [cell loadCellData:[self.dynamicDataArray objectAtIndex:indexPath.row]];
    cell.delegate = self;
    cell.indexTag = indexPath.row;
    return cell;
}

/*    点击加载更多   */
- (void)loadmoreComment
{
    isRefresh = NO;
    FDSComment *comment = [self.dynamicDataArray objectAtIndex:self.dynamicDataArray.count-1];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    if (_isMeInfo)
    {
        [[FDSUserCenterMessageManager sharedManager]getUserRecord:[[FDSUserManager sharedManager] getNowUser].m_userID :comment.m_commentID :@"before" :10];
    }
    else
    {
        [[FDSUserCenterMessageManager sharedManager]getUserRecord:self.friendID :comment.m_commentID :@"before" :10];
    }
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    isRefresh  = YES;
    if (_isMeInfo)
    {
        [[FDSUserCenterMessageManager sharedManager]getUserRecord:[[FDSUserManager sharedManager] getNowUser].m_userID :@"-1" :@"before" :10];
    }
    else
    {
        [[FDSUserCenterMessageManager sharedManager]getUserRecord:self.friendID :@"-1" :@"before" :10];
    }
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
    [_spaceManageTable tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_spaceManageTable tableViewDidEndDragging:scrollView];
}


- (void)sendRevertMessage
{
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    if (textView.text)
    {
        self.publishContent = [textView.text stringByTrimmingCharactersInSet:whitespace];
    }
    
    if (self.publishContent && self.publishContent.length > 0)
    {
        /* 发送 */
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        if (isComment) //发评论
        {
            [[FDSUserCenterMessageManager sharedManager]sendRecordCommentRevert:selectDynamic.m_commentID :self.publishContent :@"comment" :selectDynamic.m_senderID];
        }
        else //发回复
        {
            [[FDSUserCenterMessageManager sharedManager]sendRecordCommentRevert:selectDynamic.m_commentID :self.publishContent :@"revert" :selectReply.m_senderID];
        }
        
        
        textView.text = nil;
        textView.contentSize = CGSizeMake(222, 36);
        [self textViewDidChange:textView];
        [textView resignFirstResponder];
    }
    else
    {
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"发送内容不能为空"];
    }
}

- (void)sendRecordCommentRevertCB:(NSString *)result :(NSString *)commentID
{
    [SVProgressHUD popActivity];
    if ([result isEqualToString:@"OK"])
    {
        FDSRevert *revert = [[FDSRevert alloc] init];
        revert.m_revertID = commentID;
        revert.m_content = self.publishContent;
        FDSUser *userInfo = [[FDSUserManager sharedManager] getNowUser];
        revert.m_senderID = userInfo.m_userID;
        revert.m_senderName = userInfo.m_name;
        
        if (isComment)//发评论
        {
            revert.m_reveredName = @"";
        }
        else //发回复
        {
            revert.m_reveredName = selectReply.m_senderName;
        }
        
        [selectDynamic.m_revertsList addObject:revert];
        [revert release];
        
        [sizeList removeAllObjects]; //重新算高度
        [self.spaceManageTable reloadData];
        
        self.publishContent = nil;
    }
    else
    {
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"发送失败"];
    }
}

#pragma mark - SpaceFeedBtnDelegate Methods
/*  针对动态进行回复 */
- (void)didClickReplyBtn:(NSInteger)currentTag
{
    if(USERSTATE_LOGIN != [[FDSUserManager sharedManager] getNowUserState]) /* 未登录成功 */
    {
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"对不起 你没有登录 不能评论"];
        return;
    }
    if (!isKeyboardShowing)
    {
        isComment = YES;
        selectDynamic = [self.dynamicDataArray objectAtIndex:currentTag];
        
        textView.placeholder = [NSString stringWithFormat:@"评论%@动态",selectDynamic.m_senderName];
        [textView setNeedsDisplay];
        [textView becomeFirstResponder];
        if (currentTag < self.dynamicDataArray.count-1)
        {
            [_spaceManageTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:currentTag inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}

/* 删除动态处理 */
- (void)didClickDeleteComment:(NSInteger)currentTag
{
    deleteIndex = currentTag;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除动态" message:@"确定删除吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 0x01;
    [alert show];
    [alert release];
}

/* 评论人头像选择 */
- (void)didSelectCommentHead:(NSInteger)currentIndex
{
    FDSComment *commentInfo = [self.dynamicDataArray objectAtIndex:currentIndex];
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

/* 针对评论或回复进行回复 */
- (void)didSelectReplyBtn:(NSInteger)currentIndex :(NSInteger)replyIndex
{
    if(USERSTATE_LOGIN != [[FDSUserManager sharedManager] getNowUserState]) /* 未登录成功 */
    {
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"对不起 你没有登录 不能进行回复"];
        return;
    }
    if (!isKeyboardShowing)
    {
        isComment = NO;
        selectDynamic = [self.dynamicDataArray objectAtIndex:currentIndex];
        selectReply = [selectDynamic.m_revertsList objectAtIndex:replyIndex];
        
        textView.placeholder = [NSString stringWithFormat:@"回复%@",selectReply.m_senderName];
        [textView setNeedsDisplay];
        [textView becomeFirstResponder];
        if (currentIndex < self.dynamicDataArray.count-1)
        {
            [_spaceManageTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}

/* 针对评论或回复进行删除 */
- (void)didClickDeleteRecert:(NSInteger)currentIndex :(NSInteger)replyIndex
{
    deleteIndex = currentIndex;
    replyDelIndex = replyIndex;

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除回复" message:@"确定删除吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 0x02;
    [alert show];
    [alert release];
}

#pragma-mark UIAlertViewDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0x01 == alertView.tag)
    {
        if (1 == buttonIndex) //delete动态
        {
            isComment = YES;
            FDSComment *commentInfo = [self.dynamicDataArray objectAtIndex:deleteIndex];
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
            [[FDSUserCenterMessageManager sharedManager]deleteRecordCommentRevert:commentInfo.m_commentID :@"record" :commentInfo.m_commentID];
        }
    }
    else if(0x02 == alertView.tag)
    {
        if (1 == buttonIndex) //delete回复
        {
            isComment = NO;
            FDSComment *commentInfo = [self.dynamicDataArray objectAtIndex:deleteIndex];
            FDSRevert *revertInfo = [commentInfo.m_revertsList objectAtIndex:replyDelIndex];

            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
            if (revertInfo.m_reveredName && revertInfo.m_reveredName.length > 0)//回复
            {
                [[FDSUserCenterMessageManager sharedManager]deleteRecordCommentRevert:commentInfo.m_commentID :@"revert" :revertInfo.m_revertID];
            }
            else //评论
            {
                [[FDSUserCenterMessageManager sharedManager]deleteRecordCommentRevert:commentInfo.m_commentID :@"comment" :revertInfo.m_revertID];
            }
        }
    }
}

- (void)deleteRecordCommentRevertCB:(NSString *)result
{
    [SVProgressHUD popActivity];
    if ([result isEqualToString:@"OK"])
    {
        if (isComment)//delete动态
        {
            [self.dynamicDataArray removeObjectAtIndex:deleteIndex];
        }
        else//delete回复
        {
            FDSComment *commentInfo = [self.dynamicDataArray objectAtIndex:deleteIndex];
            [commentInfo.m_revertsList removeObjectAtIndex:replyDelIndex];
        }
        [sizeList removeAllObjects];
        [self.spaceManageTable reloadData];
    }
    else
    {
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"删除失败"];
    }
}

/*  获取对应cell 高度  */
- (void)getContentSize:(NSIndexPath*)indexPath :(FDSComment*)dataInfo
{
    CGFloat cell_H = 0.0f;
    cell_H +=5+50-15;
    if (dataInfo.m_content.length > 0)
    {
        recordContentView.maxlength = 235.0f;
        CGFloat viewheight = [recordContentView getcurrentViewHeight:dataInfo.m_content];
        cell_H += viewheight+10;
    }
    
    if (dataInfo.m_images.count > 0)
    {
        cell_H += 70+10;
    }
    
    if (dataInfo.m_content.length == 0 && dataInfo.m_images.count == 0)
    {
        /*  没有内容 没有图片  */
        cell_H += 20+10;
    }
    
    /*  回复列表  */
    if (dataInfo.m_revertsList.count > 0)
    {
        FDSRevert *revert = nil;
        NSInteger replyCellH = 5;
        for (int i=0; i<dataInfo.m_revertsList.count; i++)
        {
            revert = [dataInfo.m_revertsList objectAtIndex:i];
            
            NSString *nameTitle = nil;
            if (revert.m_reveredName && revert.m_reveredName.length>0)//回复
            {
                nameTitle = [NSString stringWithFormat:@"%@ 回复 %@",revert.m_senderName,revert.m_reveredName];
            }
            else
            {
                nameTitle = [NSString stringWithFormat:@"%@",revert.m_senderName];
            }
            
            NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:15], NSFontAttributeName,
                                        nil];
            NSString *tempStr = [NSString stringWithFormat:@"%@  %@",nameTitle,revert.m_content];
            CGSize titleSize;
            if(7.0 == IOS_7)
            {
                titleSize = [nameTitle sizeWithAttributes:attributes];
            }
            else
            {
                titleSize = [nameTitle sizeWithFont:[UIFont systemFontOfSize:15]];
            }
            CGFloat nameWidth = titleSize.width;
            
            if(7.0 == IOS_7)
            {
                titleSize = [tempStr sizeWithAttributes:attributes];
            }
            else
            {
                titleSize = [tempStr sizeWithFont:[UIFont systemFontOfSize:15]];
            }
            
            /* 需要先加入再算frame坐标 */
            CGFloat viewheight = 0.0f ;
            if (titleSize.width >= 270  && nameWidth >=200) //回复内容换行
            {
                recordContentView.maxlength = 270;
                viewheight = [recordContentView getcurrentViewHeight:revert.m_content];
                
                replyCellH+=(20+viewheight)+10;
            }
            else//回复内容不换行
            {
                recordContentView.maxlength = 270-10-nameWidth;
                viewheight = [recordContentView getcurrentViewHeight:revert.m_content];
                
                replyCellH+=viewheight+10;
            }
        }
        
        cell_H += replyCellH;
    }
    NSValue *sizeValue = [NSValue valueWithCGSize:CGSizeMake(kMSScreenWith-10,cell_H+15)];
    [sizeList setValue:sizeValue forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
}



@end

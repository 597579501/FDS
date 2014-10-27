//
//  FDSRevertListViewController.m
//  FDS
//
//  Created by zhuozhong on 14-2-26.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSRevertListViewController.h"
#import "UIViewController+BarExtension.h"
#import "EGOImageButton.h"
#import "CommentView.h"
#import "SVProgressHUD.h"
#import "FDSUserManager.h"
#import "FDSLoginViewController.h"
#import "FDSPublicManage.h"
#import "FDSFriendProfileViewController.h"
#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface FDSRevertListViewController ()
{
    NSInteger          cell_H;
    UITableViewCell    *headViewCell;
}
@end

@implementation FDSRevertListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.commentInfo = nil;
        self.revertDataArray = nil;
        isRefresh = NO;
        ischageReply = NO;
        self.publishContent = nil;
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
    [[FDSBarMessageManager sharedManager] registerObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[FDSCompanyMessageManager sharedManager] unRegisterObserver:self];
    [[FDSBarMessageManager sharedManager] unRegisterObserver:self];

    if (ischageReply && [_delegate respondsToSelector:@selector(didChangeReplyValue:)])
    {
        [_delegate didChangeReplyValue:_indexTag];
    }
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

    self.commentInfo = nil;

    [faceBoard release];
    
    [headViewCell release];
    
    [_revertDataArray removeAllObjects];
    self.revertDataArray = nil;
    
    [super dealloc];
}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    int count = self.commentInfo.m_images.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:self.commentInfo.m_images[i]]; // 图片路径
        if (i<=2)
        {
            photo.srcImageView = commentImgViews.subviews[i]; // 来源于哪个UIImageView
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self homeNavbarWithTitle:@"所有回复" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self allSubViewInit];
    
    [self allMessageControlInit];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
	// Do any additional setup after loading the view.
    
    /* 拉取最新的10条回复 */
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    if (COMMENT_REVERT_SHOW_DYNAMIC == self.revertType) //动态回复
    {
        [[FDSCompanyMessageManager sharedManager]getCompanyCommentRevertList:self.commentInfo.m_commentID :@"-1" :@"before" :10];
    }
    else if (COMMENT_REVERT_SHOW_POSTBAR == self.revertType) //贴吧回复
    {
        [[FDSBarMessageManager sharedManager]getPostCommentRevert:self.commentInfo.m_commentID :@"before" :@"-1" :10];
    }

}

- (void)allSubViewInit
{
    self.view.backgroundColor = COLOR(229, 229, 229, 1);
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, kMSNaviHight+10, kMSScreenWith-10, kMSTableViewHeight-44-20-44)];
    bgView.image = [[UIImage imageNamed:@"round_white_cellbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
    [bgView release];
 
    headViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headRevertViewCell"];
    headViewCell.backgroundColor = [UIColor clearColor];
    headViewCell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    /*  评论人头像  */
    EGOImageButton *commentHeadImg = [EGOImageButton buttonWithType:UIButtonTypeCustom];
    commentHeadImg.frame = CGRectMake(10, 10, 50, 50);
    commentHeadImg.adjustsImageWhenHighlighted = NO;
    [commentHeadImg addTarget:self action:@selector(btnCommentPressed) forControlEvents:UIControlEventTouchUpInside];
    commentHeadImg.layer.borderWidth = 1;
    commentHeadImg.layer.cornerRadius = 4.0;
    commentHeadImg.layer.masksToBounds=YES;
    commentHeadImg.placeholderImage = [UIImage imageNamed:@"headphoto_s"];
    [commentHeadImg setImageURL:[NSURL URLWithString:self.commentInfo.m_senderIcon]];
    commentHeadImg.layer.borderColor = [[UIColor colorWithRed:242.0f/255 green:242.0f/255 blue:242.0f/255 alpha:1.0f] CGColor];
    [headViewCell.contentView addSubview:commentHeadImg];

    /*  评论人名字  */
    UILabel *commentNameLab = [[UILabel alloc]initWithFrame:CGRectMake(65, 3, 120, 20)];
    commentNameLab.backgroundColor = [UIColor clearColor];
    commentNameLab.textColor = COLOR(55, 123, 198, 1);
    commentNameLab.font=[UIFont systemFontOfSize:15];
    commentNameLab.text = self.commentInfo.m_senderName;
    [headViewCell.contentView addSubview:commentNameLab];
    [commentNameLab release];
    
    /*  评论时间  */
    UILabel *commentTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(65, 27, 100, 15)];
    commentTimeLab.backgroundColor = [UIColor clearColor];
    commentTimeLab.textColor = kMSTextColor;
    commentTimeLab.font=[UIFont systemFontOfSize:12];
    
    /*  时间戳转时间  */
    NSTimeInterval timeValue = [self.commentInfo.m_sendTime doubleValue];
    NSDate *confromTime = [NSDate dateWithTimeIntervalSince1970:timeValue/1000];
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"MM-dd HH:mm:ss"];
    commentTimeLab.text = [formatter stringFromDate:confromTime];
    [headViewCell.contentView addSubview:commentTimeLab];
    [commentTimeLab release];
    
    /*  评论内容  */
    CommentView *commentContentView = [[CommentView alloc]initWithFrame:CGRectZero];
    commentContentView.backgroundColor = [UIColor clearColor];
    commentContentView.fontSize = 15.0f;
    commentContentView.maxlength = 235;
    commentContentView.facialSizeWidth = 18;
    commentContentView.facialSizeHeight = 18;
    commentContentView.textlineHeight = 20;
    [headViewCell.contentView addSubview:commentContentView];
    [commentContentView release];
    
    cell_H = 10+50-15; //内容高度起点
    
    CGFloat viewheight = [commentContentView getcurrentViewHeight:self.commentInfo.m_content];
    commentContentView.frame = CGRectMake(65, cell_H, 240, viewheight);
    [commentContentView showMessage:self.commentInfo.m_content];
    cell_H += viewheight+10;
    
    
    /*  评论图片内容  */
    commentImgViews = [[UIView alloc] initWithFrame:CGRectZero];
    commentImgViews.backgroundColor = [UIColor clearColor];
    [headViewCell.contentView addSubview:commentImgViews];
    [commentImgViews release];
    NSInteger imageCount = self.commentInfo.m_images.count;
    NSInteger imageWidth = 96.0f;
    if (imageCount > 0)
    {
        if (3 >= imageCount)
        {
            commentImgViews.frame = CGRectMake(0, cell_H, kMSScreenWith, 100);
        }
        else if(6 >= imageCount)
        {
            commentImgViews.frame = CGRectMake(0, cell_H, kMSScreenWith, 100*2+5);
        }
        else
        {
            commentImgViews.frame = CGRectMake(0, cell_H, kMSScreenWith, 100*3+10);
        }
        UIImageView *contentImg = nil;
        for (int i=0; i< imageCount; i++)
        {
            if (i <= 2)
            {
                contentImg = [[UIImageView alloc] initWithFrame:CGRectMake(5+i*(imageWidth+5), (100+5)*(i/3), imageWidth, 100)];
            }
            else if(i <= 5)
            {
                contentImg = [[UIImageView alloc] initWithFrame:CGRectMake(5+(i-3)*(imageWidth+5), (100+5)*(i/3), imageWidth, 100)];
            }
            else
            {
                contentImg = [[UIImageView alloc] initWithFrame:CGRectMake(5+(i-6)*(imageWidth+5), (100+5)*(i/3), imageWidth, 100)];
            }
            contentImg.userInteractionEnabled = YES;
            contentImg.tag = i;
            [contentImg addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)] autorelease]];
            
            if ([self.commentInfo.m_images objectAtIndex:i] && [[self.commentInfo.m_images objectAtIndex:i]length]>0)
            {
                UIImage *placeholder = [UIImage imageNamed:@"send_image_default"];
                NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@",[self.commentInfo.m_images objectAtIndex:i]];
                if (urlStr.length >= 4)
                {
                    [urlStr insertString:@"_middle" atIndex:urlStr.length-4];
                }
                [contentImg setImageURLStr:urlStr placeholder:placeholder];
            }
            else
            {
                contentImg.image = [UIImage imageNamed:@"send_image_default"];
            }
            [commentImgViews addSubview:contentImg];
            [contentImg release];
            
            if (i > 7) //最多只显示9张
            {
                break;
            }
        }

        cell_H += commentImgViews.frame.size.height+10;
    }
    
    
    _revertTableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(2,5, 306, bgView.frame.size.height-10) style:UITableViewStylePlain];
    _revertTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _revertTableView.delegate = self;
    _revertTableView.dataSource = self;
    _revertTableView.pullingDelegate = self;
    [bgView addSubview:_revertTableView];
    [_revertTableView release];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGes:)];
    tap.cancelsTouchesInView=NO;
    [bgView addGestureRecognizer:tap];
    [tap release];
}

/* 初始化发信息控件 */
- (void)allMessageControlInit
{
    /* 信息操作view */
    toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, kMSNaviHight+(kMSTableViewHeight-88), kMSScreenWith, 44)];
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


#pragma-mark UITableViewDataSource UITableViewDelegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.revertDataArray count]+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        return cell_H;
    }
    RevertFeedsCell *revertCell = (RevertFeedsCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [revertCell getCurrentCellHeight];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        return headViewCell;
    }
    static NSString* revertStr = @"revertCellIndentify";
    RevertFeedsCell* revertCell = [tableView dequeueReusableCellWithIdentifier:revertStr];
    if(nil == revertCell)
    {
        revertCell = [[[RevertFeedsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:revertStr] autorelease];
    }
    revertCell.indexRow = [indexPath row]-1;
    revertCell.delegate = self;
    /* config cell */
    [revertCell loadRevertCellData:[self.revertDataArray objectAtIndex:indexPath.row-1]];
    return revertCell;
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    isRefresh  = YES;
    isLoadMore = NO;
    /* 拉取最新的10条回复 */
    [[FDSCompanyMessageManager sharedManager]getCompanyCommentRevertList:self.commentInfo.m_commentID :@"-1" :@"after" :10];
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    isRefresh  = YES;
    isLoadMore = YES;
    
    if (self.revertDataArray.count > 0)
    {
        FDSRevert *revert = [self.revertDataArray objectAtIndex:self.revertDataArray.count-1];
        [[FDSCompanyMessageManager sharedManager]getCompanyCommentRevertList:self.commentInfo.m_commentID :revert.m_revertID :@"after" :10];
    }
    else
    {
        [_revertTableView tableViewDidFinishedLoading];
        _revertTableView.reachedTheEnd = YES; //到达底部后即不会有上提操作
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
    [_revertTableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_revertTableView tableViewDidEndDragging:scrollView];
}

- (void)handleGetDataCB:(NSMutableArray*)revertList
{
    if (isRefresh)
    {
        [_revertTableView tableViewDidFinishedLoading];
        if (!isLoadMore)  //刷新拉取最新10条  拉取更多则不需删除
        {
            [self.revertDataArray removeAllObjects];
        }
    }
    else
    {
        [SVProgressHUD popActivity];
    }
    if (self.revertDataArray)
    {
        [self.revertDataArray addObjectsFromArray:revertList];
    }
    else
    {
        self.revertDataArray = revertList;
    }
    
    if (revertList.count >= 10)/* 如果拉取到足够条数 就显示加载更多*/
    {
        _revertTableView.reachedTheEnd = NO;
    }
    else
    {
        _revertTableView.reachedTheEnd = YES; //到达底部后即不会有上提操作
    }
    
    [_revertTableView reloadData];
    
    if ([_revertDataArray count] > 9)
    {
        [_revertTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_revertDataArray count]  inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

#pragma mark - FDSBarMessageInterface Method
- (void)getPostCommentRevertCB:(NSMutableArray *)postCommentRevertList  //贴吧
{
    [self handleGetDataCB:postCommentRevertList];
}

#pragma mark - FDSCompanyMessageInterface Method
- (void)getCompanyCommentRevertListCB:(NSMutableArray*)revertList //黄页部分评论回复
{
    [self handleGetDataCB:revertList];
}


/* 对评论发布回复 */
- (void)sendRevertMessage
{
    if(USERSTATE_LOGIN != [[FDSUserManager sharedManager] getNowUserState]) /* 未登录成功 */
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"对不起 你没有登录 不能回复" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
//        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"对不起 你没有登录 不能回复"];
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
        if (COMMENT_REVERT_SHOW_DYNAMIC == self.revertType) //动态回复
        {
            [[FDSCompanyMessageManager sharedManager] companyComment:@"" :@"reply" :@"" :self.commentInfo.m_commentID :self.publishContent :nil];
        }
        else if (COMMENT_REVERT_SHOW_POSTBAR == self.revertType) //贴吧回复
        {
            [[FDSBarMessageManager sharedManager]sendPostComment:@"reply" :@"" :self.commentInfo.m_commentID :self.publishContent :nil];
        }
        
        
        textView.text = nil;
        textView.contentSize = CGSizeMake(222, 36);
        [self textViewDidChange:textView];
        [textView resignFirstResponder];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
//        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"发送内容不能为空"];
    }
}

- (void)handleSendReplyCB:(NSString*)result :(NSString*)commentID
{
    [SVProgressHUD popActivity];
    if ([result isEqualToString:@"OK"])
    {
        FDSRevert *revert = [[FDSRevert alloc] init];
        revert.m_revertID = commentID;
        revert.m_content = self.publishContent;
        FDSUser *userInfo = [[FDSUserManager sharedManager] getNowUser];
        revert.m_senderID = userInfo.m_userID;
        revert.m_senderIcon = userInfo.m_icon;
        revert.m_senderName = userInfo.m_name;
        revert.m_sendTime = [[FDSPublicManage sharePublicManager] getNowDate];
        
        [self.revertDataArray addObject:revert];
        [revert release];
        
        [_revertTableView reloadData];
        [_revertTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.revertDataArray count] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        
        self.publishContent = nil;
        
        ischageReply = YES;
        self.commentInfo.m_revertCount +=1;
        if (self.commentInfo.m_revertCount <= 2)
        {
            [self.commentInfo.m_revertsList addObject:revert];
        }
    }
    else
    {
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"回复失败"];
    }
}

/* 发布回复回调 */
- (void)companyCommentCB:(NSString*)result :(NSString*)commentID
{
    [self handleSendReplyCB:result :commentID];
}

/* 发布帖子回复回调 */
- (void)sendPostCommentCB:(NSString *)result :(NSString *)commentID
{
    [self handleSendReplyCB:result :commentID];
}

- (void)handleDelteRevert:(NSString*)result
{
    [SVProgressHUD popActivity];
    if ([result isEqualToString:@"OK"])
    {
        /* page */
        [self.revertDataArray removeObjectAtIndex:deleteIndex]; //cache
        [_revertTableView reloadData];
        
        ischageReply = YES;
        self.commentInfo.m_revertCount -= 1;
        if (deleteIndex <= 1)
        {
            if (self.commentInfo.m_revertCount < 2)
            {
                [self.commentInfo.m_revertsList removeObjectAtIndex:deleteIndex];
            }
            else
            {
                if(0 == deleteIndex)
                {
                    [self.commentInfo.m_revertsList removeAllObjects];
                    [self.commentInfo.m_revertsList addObject:[self.revertDataArray objectAtIndex:deleteIndex]];
                    [self.commentInfo.m_revertsList addObject:[self.revertDataArray objectAtIndex:deleteIndex+1]];
                }
                else
                {
                    [self.commentInfo.m_revertsList removeObjectAtIndex:deleteIndex];
                    [self.commentInfo.m_revertsList addObject:[self.revertDataArray objectAtIndex:deleteIndex]];
                }
            }
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除回复失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}


- (void)deleteCompanyCommentRevertCB:(NSString*)result
{
    [self handleDelteRevert:result];
}

- (void)deletePostCommentRevertCB:(NSString *)result
{
    [self handleDelteRevert:result];
}

#pragma mark - RevertDelDelegate Method
-(void)deleteRevertWithIndex:(NSInteger)currentIndex
{
    deleteIndex = currentIndex;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除回复" message:@"确定删除吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    [alert release];
}

- (void)didSelectRevertImgWithIndex:(NSInteger)currentTag
{
    FDSRevert *revertInfo = [self.revertDataArray objectAtIndex:currentTag];
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

- (void)btnCommentPressed
{
    if (![self.commentInfo.m_senderID isEqualToString:[[FDSUserManager sharedManager] getNowUser].m_userID])//非本账号
    {
        FDSFriendProfileViewController *fpVC = [[FDSFriendProfileViewController alloc]init];
        FDSUser *userInfo = [[FDSUser alloc] init];
        userInfo.m_friendID = self.commentInfo.m_senderID;
        userInfo.m_name = self.commentInfo.m_senderName;
        userInfo.m_icon = self.commentInfo.m_senderIcon;
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
        FDSRevert *revertInfo = [self.revertDataArray objectAtIndex:deleteIndex];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        if (COMMENT_REVERT_SHOW_DYNAMIC == self.revertType) //动态回复
        {
            [[FDSCompanyMessageManager sharedManager]deleteCompanyCommentRevert:self.commentInfo.m_commentID :@"revert" :revertInfo.m_revertID];
        }
        else if (COMMENT_REVERT_SHOW_POSTBAR == self.revertType) //贴吧回复
        {
            [[FDSBarMessageManager sharedManager]deletePostCommentRevert:self.commentInfo.m_commentID :@"revert" :revertInfo.m_revertID];
        }
    }
}

@end

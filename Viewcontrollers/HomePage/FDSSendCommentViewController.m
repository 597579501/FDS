//
//  FDSSendCommentViewController.m
//  FDS
//
//  Created by saibaqiao on 14-3-16.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSSendCommentViewController.h"
#import "Constants.h"
#import "UIViewController+BarExtension.h"
#import "FDSPublicManage.h"
#import "FDSPathManager.h"
#import "SVProgressHUD.h"
#import "FDSLoginViewController.h"
#import "FDSUserManager.h"
#import "FDSComment.h"

#define KMSMAXCONTENTLENGTH 2000

@interface FDSSendCommentViewController ()
{
    UIImageView *bgImg;
    UIButton *publishBtn;
}
@end

@implementation FDSSendCommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        imagesURL = [[NSMutableArray alloc] init];
        
        self.commentObjectType = nil;
        self.objectID = nil;
        
        self.recordList = nil;
        
        self.publishContent = nil;
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
    self.commentObjectType = nil;
    self.objectID = nil;
    
    self.recordList = nil;
    
    self.publishContent = nil;

    [imagesURL removeAllObjects];
    [imagesURL release];
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[FDSBarMessageManager sharedManager]registerObserver:self];
    [[FDSCompanyMessageManager sharedManager] registerObserver:self];
    [[FDSUserCenterMessageManager sharedManager] registerObserver:self];
    
    [[ZZUploadManager sharedUploadManager] registerObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[FDSBarMessageManager sharedManager]unRegisterObserver:self];
    [[FDSCompanyMessageManager sharedManager] unRegisterObserver:self];
    [[FDSUserCenterMessageManager sharedManager] unRegisterObserver:self];
    
    [[ZZUploadManager sharedUploadManager] unRegisterObserver:self];
    
    if([contextTextView isFirstResponder])
    {
        [contextTextView resignFirstResponder];
    }
}

- (void)AllSubviewInit
{
    scrollView = [[MSKeyboardScrollView alloc] initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith, kMSTableViewHeight-44)];
    [self.view addSubview:scrollView];
    [scrollView release];
    
    CGFloat start_Y = 10;
    
    addMenuView = [[MenuAddImageView alloc] initWithFrame:CGRectMake(0, start_Y, kMSScreenWith, 68) :5];
    addMenuView.delegate = self;
    addMenuView.totalNum = 9;
    [scrollView addSubview:addMenuView];
    [addMenuView release];
    
    start_Y+=68+10;
    bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, start_Y, kMSScreenWith-10, 125)];
    bgImg.image = [[UIImage imageNamed:@"round_white_cellbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    bgImg.userInteractionEnabled = YES;
    [scrollView addSubview:bgImg];
    [bgImg release];
    
    contextTextView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(2, 3, kMSScreenWith-18, 105)];
    contextTextView.placeholder = @"请输入发布内容";
    contextTextView.font = [UIFont systemFontOfSize:16.0f];
    contextTextView.textColor = kMSTextColor;
    contextTextView.delegate = self;
    [bgImg addSubview:contextTextView];
    [contextTextView release];
    
    numLab = [[UILabel alloc]initWithFrame:CGRectMake(110, 105, 190, 20)];
    numLab.textAlignment = NSTextAlignmentRight;
    numLab.backgroundColor = [UIColor clearColor];
    numLab.textColor = kMSTextColor;
    numLab.font=[UIFont systemFontOfSize:15];
    numLab.text = [NSString stringWithFormat:@"%d/%d",0,KMSMAXCONTENTLENGTH];
    [bgImg addSubview:numLab];
    [numLab release];

    start_Y+=125+20;
    
    //******发表button******
    publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    publishBtn.frame = CGRectMake(10, start_Y, kMSScreenWith-20, 45);
    [publishBtn setBackgroundImage:[UIImage imageNamed:@"registerbtn_normal_bg"] forState:UIControlStateNormal];
    [publishBtn setBackgroundImage:[UIImage imageNamed:@"registerbtn_hl_bg"] forState:UIControlStateHighlighted];
    [publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [publishBtn setTitle:@"发表" forState:UIControlStateNormal];
    publishBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [publishBtn addTarget:self action:@selector(btnPublishClicked) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:publishBtn];
    
    start_Y+=45+20+80;
    [scrollView setContentSize:CGSizeMake(kMSScreenWith, start_Y)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self homeNavbarWithTitle:@"上传图片" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    if(IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self AllSubviewInit];
	// Do any additional setup after loading the view.
}

#pragma-mark MenuAddBtnDelegate method
- (void)didSelectImagePicker
{
    UIActionSheet*alert = [[UIActionSheet alloc]
                           initWithTitle:@"选择照相还是相册"
                           delegate:self
                           cancelButtonTitle:NSLocalizedString(@"取消",nil)
                           destructiveButtonTitle:nil
                           otherButtonTitles:NSLocalizedString(@"相机拍摄",nil),
                           NSLocalizedString(@"手机相册",nil),
                           nil];
    [alert showInView:self.view];
    [alert release];
}

/*   通知页面重新布局   */
- (void)notifyPageLayout:(NSInteger)moveHeight
{
    CGRect rect = bgImg.frame;
    rect.origin.y+=moveHeight;
    bgImg.frame = rect;
    
    rect = publishBtn.frame;
    rect.origin.y+=moveHeight;
    publishBtn.frame = rect;
}


#pragma UIActionSheetDelegate method
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([actionSheet.title isEqualToString:@"选择照相还是相册"])
    {
        switch(buttonIndex)
        {
            case 1:
            {
                UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
                [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                [imagePicker setDelegate:self];
                [imagePicker setAllowsEditing:NO];
                
                [self presentViewController:imagePicker animated:YES completion:nil];
                [imagePicker release];
            }
                break;
            case 0:
            {
                UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
                
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                {
                    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
                    [imagePicker setDelegate:self];
                    [imagePicker setAllowsEditing:YES];
                }
                [self presentViewController:imagePicker animated:YES completion:nil];
                [imagePicker release];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark Picker Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img = nil;
	if (!img)
	{
		img = [info objectForKey:UIImagePickerControllerOriginalImage]; //原始图片
	}
    NSString *filepath = [FDSPublicManage fitSmallWithImage:img];
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (filepath && filepath.length>0)
    {
        NSData *thumbData = [NSData dataWithContentsOfFile:filepath];
        
        [addMenuView handleImageAdd:[UIImage imageWithContentsOfFile:filepath] :thumbData];
    }
}

- (BOOL)isValidSend
{
    if(USERSTATE_LOGIN != [[FDSUserManager sharedManager] getNowUserState]) /* 未登录成功 */
    {
        FDSLoginViewController *loginVC = [[FDSLoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        [loginVC release];
        return NO;
    }
    
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    if (contextTextView.text)
    {
        self.publishContent = [contextTextView.text stringByTrimmingCharactersInSet:whitespace];
        if (!self.publishContent || self.publishContent.length <= 0)
        {
            [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"内容不能为空!"];
            return NO;
        }
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"内容不能为空!"];
        return NO;
    }
    
    return YES;
}

- (void)sendAllMessage
{
    if (SEND_NEW_MESSAGE_TYPE_COMMENT == self.send_type)
    {
        [[FDSCompanyMessageManager sharedManager] companyComment:_commentObjectType :@"comment" :self.objectID :@"" :self.publishContent :imagesURL];
    }
    else if(SEND_NEW_MESSAGE_TYPE_BAR == self.send_type)
    {        /*  发表帖子评论  self.objectID为帖子ID */
        [[FDSBarMessageManager sharedManager] sendPostComment:@"comment" :self.objectID :@"" :self.publishContent :imagesURL];
    }
    else if(SEND_NEW_MESSAGE_TYPE_DYNAMIC == self.send_type)
    {
        [[FDSUserCenterMessageManager sharedManager]sendUserRecord:self.publishContent :imagesURL];
    }
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
}

/*  发布开始  */
- (void)btnPublishClicked
{
    [contextTextView resignFirstResponder];
    if ([self isValidSend])//有效输入才发送
    {
        uploadCount = 0;
        [imagesURL removeAllObjects];
        int count = addMenuView.imageList.count;
        if (0 == count)
        {
            [self sendAllMessage];
        }
        else
        {
//            for (int i=0; i<count; i++)
//            {
                [[ZZUploadManager sharedUploadManager]beginUploadRequest:[[FDSPathManager sharePathManager]getMessageImagePath] :[[FDSPublicManage sharePublicManager] getGUID] :@"" :@"all" :[addMenuView.imageList objectAtIndex:0] :@"jpg" ];
//            }
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        }
    }
}

#pragma mark ZZUploadInterface Delegate Method
- (void)uploadStateNotice:(ZZUploadRequest*)uploadRequest
{
    if (ZZUploadState_UPLOAD_OK == uploadRequest.m_uploadState || ZZUploadState_UPLOAD_FAIL == uploadRequest.m_uploadState)
    {
        uploadCount++;
        if (ZZUploadState_UPLOAD_OK == uploadRequest.m_uploadState) //上传图片到文件服务器成功
        {
            [imagesURL addObject:uploadRequest.m_filePath];
        }
        else //fail
        {
            
        }
        if (uploadCount < addMenuView.imageList.count)
        {
            [[ZZUploadManager sharedUploadManager]beginUploadRequest:[[FDSPathManager sharePathManager]getMessageImagePath] :[[FDSPublicManage sharePublicManager] getGUID] :@"" :@"all" :[addMenuView.imageList objectAtIndex:uploadCount] :@"jpg" ];
        }
        else
        {
            /*  图片上传结束  */
            [self sendAllMessage];
        }
    }
}

#pragma mark - FDSCompanyMessageInterface Method
/* 发布黄页模块评论回调 */
- (void)companyCommentCB:(NSString*)result :(NSString*)commentID
{
    [SVProgressHUD popActivity];
    if ([result isEqualToString:@"OK"])
    {
        /* 通知返回到上一个页面后刷新最新数据 */
        if ([self.delegate respondsToSelector:@selector(handleSucRefresh)])
        {
            [self.delegate handleSucRefresh];
        }

        FDSComment *comment = [[FDSComment alloc] init];
        comment.m_commentID = commentID;
        comment.m_content = self.publishContent;
        FDSUser *userInfo = [[FDSUserManager sharedManager] getNowUser];
        comment.m_senderID = userInfo.m_userID;
        comment.m_senderIcon = userInfo.m_icon;
        comment.m_senderName = userInfo.m_name;
        comment.m_sendTime = [[FDSPublicManage sharePublicManager] getNowDate];
        comment.m_images = [[[NSMutableArray alloc] init] autorelease];
        for (int j=0; j<imagesURL.count; j++)
        {
            [comment.m_images addObject:[imagesURL objectAtIndex:j]];
        }
        comment.m_revertCount = 0;
        comment.m_revertsList = [[[NSMutableArray alloc] init] autorelease];
        
        [self.recordList insertObject:comment atIndex:0];
        [comment release];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"评论发布失败"];
    }
}

#pragma mark - FDSBarMessageInterface Method
//发布帖子评论回调
- (void)sendPostCommentCB:(NSString *)result :(NSString *)commentID
{
    [SVProgressHUD popActivity];
    if ([result isEqualToString:@"OK"])
    {
        /* 通知返回到上一个页面后刷新最新数据 */
        if ([self.delegate respondsToSelector:@selector(handleSucRefresh)])
        {
            [self.delegate handleSucRefresh];
        }

        FDSComment *comment = [[FDSComment alloc] init];
        comment.m_commentID = commentID;
        comment.m_content = self.publishContent;
        FDSUser *userInfo = [[FDSUserManager sharedManager] getNowUser];
        comment.m_senderID = userInfo.m_userID;
        comment.m_senderIcon = userInfo.m_icon;
        comment.m_senderName = userInfo.m_name;
        comment.m_sendTime = [[FDSPublicManage sharePublicManager] getNowDate];
        comment.m_images = [[[NSMutableArray alloc] init] autorelease];
        for (int j=0; j<imagesURL.count; j++)
        {
            [comment.m_images addObject:[imagesURL objectAtIndex:j]];
        }
        comment.m_revertCount = 0;
        comment.m_revertsList = [[[NSMutableArray alloc] init] autorelease];
        [self.recordList insertObject:comment atIndex:0];
        [comment release];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"帖子评论发布失败"];
    }
}

- (void)sendUserRecordCB:(NSString *)result :(NSString *)recordID
{
    [SVProgressHUD popActivity];
    if ([result isEqualToString:@"OK"])
    {
        /* 通知返回到上一个页面后刷新最新数据 */
        if ([self.delegate respondsToSelector:@selector(handleSucRefresh)])
        {
            [self.delegate handleSucRefresh];
        }
        FDSComment *comment = [[FDSComment alloc] init];
        comment.m_commentID = recordID;
        comment.m_content = self.publishContent;
        FDSUser *userInfo = [[FDSUserManager sharedManager] getNowUser];
        comment.m_senderID = userInfo.m_userID;
        comment.m_senderIcon = userInfo.m_icon;
        comment.m_senderName = userInfo.m_name;
        comment.m_sendTime = [[FDSPublicManage sharePublicManager] getNowDate];
        comment.m_images = [[[NSMutableArray alloc] init] autorelease];
        for (int j=0; j<imagesURL.count; j++)
        {
            [comment.m_images addObject:[imagesURL objectAtIndex:j]];
        }
        comment.m_revertCount = 0;
        comment.m_revertsList = [[[NSMutableArray alloc] init] autorelease];
        [self.recordList insertObject:comment atIndex:0];
        [comment release];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"动态发布失败"];
    }
}

//在这个地方计算输入的字数
- (void)textViewDidChange:(UITextView *)textView
{
    int existTextNum = [textView.text length];
    numLab.text = [NSString stringWithFormat:@"%d/%d",existTextNum,KMSMAXCONTENTLENGTH];
}

//如果输入超过规定的字数KMSMAXLENGTH，就不再让输入
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location >= KMSMAXCONTENTLENGTH)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"最多只能输入%d字数",KMSMAXCONTENTLENGTH] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
//        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:[NSString stringWithFormat:@"最多只能输入%d字数",KMSMAXCONTENTLENGTH]];
        return  NO;
    }
    else
    {
        return YES;
    }
}

@end

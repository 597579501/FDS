//
//  FDSSendPostViewController.m
//  FDS
//
//  Created by zhuozhong on 14-3-14.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSSendPostViewController.h"
#import "UIViewController+BarExtension.h"
#import "Constants.h"
#import "FDSPublicManage.h"
#import "FDSPathManager.h"
#import "SVProgressHUD.h"
#import "FDSLoginViewController.h"
#import "FDSUserManager.h"

#define KMSMAXPOSTLENGTH 2000

@interface FDSSendPostViewController ()
{
    UIButton *publishBtn;
}
@end

@implementation FDSSendPostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        imagesURL = [[NSMutableArray alloc] init];
        
        self.barID = nil;
        self.barInfo = nil;
        
        self.publishTitle = nil;
        self.publishContent = nil;
        self.publishType = nil;
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
    self.barID = nil;
    self.barInfo = nil;

    self.publishTitle = nil;
    self.publishContent = nil;
    self.publishType = nil;

    [imagesURL release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[FDSBarMessageManager sharedManager]registerObserver:self];
    [[ZZUploadManager sharedUploadManager] registerObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[FDSBarMessageManager sharedManager]unRegisterObserver:self];
    [[ZZUploadManager sharedUploadManager] unRegisterObserver:self];
    if ([titleText isFirstResponder])
    {
        [titleText resignFirstResponder];
    }
    else if([contextTextView isFirstResponder])
    {
        [contextTextView resignFirstResponder];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = COLOR(234, 234, 234, 1);
    [self homeNavbarWithTitle:@"发表帖子" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    if(IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    scrollView = [[MSKeyboardScrollView alloc] initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith, kMSTableViewHeight-44)];
    [self.view addSubview:scrollView];
    [scrollView release];

    CGFloat start_Y = 2;
    if (BAR_POST_TYPE_COMPANY == _bar_type)
    {
        UILabel *publishLab = [[UILabel alloc]initWithFrame:CGRectMake(5, start_Y, 230, 30)];
        publishLab.backgroundColor = [UIColor clearColor];
        publishLab.textColor = COLOR(69, 69, 69, 1);
        publishLab.text = @"请选择发布类型";
        publishLab.font=[UIFont systemFontOfSize:15];
        [scrollView addSubview:publishLab];
        [publishLab release];
        
        start_Y +=2+30;
        
        NSArray *tmpArr = [NSArray arrayWithObjects:@"公司新闻",@"人物专访",@"活动",@"话题",@"招聘",nil];
        
        buttonView = [[MenuButtonView alloc] initWithFrame:CGRectMake(0, start_Y, kMSScreenWith, 40) :tmpArr :5];
        buttonView.backgroundColor = [UIColor clearColor];
        [scrollView addSubview:buttonView];
        [buttonView release];
        
        start_Y+=40+5;
    }
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(5, start_Y, 230, 30)];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = COLOR(69, 69, 69, 1);
    titleLab.text = @"请输入标题";
    titleLab.font=[UIFont systemFontOfSize:15];
    [scrollView addSubview:titleLab];
    [titleLab release];
    
    start_Y+=30;
    UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, start_Y, kMSScreenWith-10, 40)];
    bgImg.userInteractionEnabled = YES;
    bgImg.image = [[UIImage imageNamed:@"round_white_cellbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    [scrollView addSubview:bgImg];
    [bgImg release];
    
    titleText = [[UITextField alloc] initWithFrame:CGRectMake(5, 5+KFDSTextOffset, kMSScreenWith-20, 30)];
    titleText.delegate = self;
    titleText.borderStyle = UITextBorderStyleNone;
    titleText.font = [UIFont systemFontOfSize:16.0f];
    titleText.textColor = kMSTextColor;
    titleText.placeholder = @"标题";
    titleText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [bgImg addSubview:titleText];
    [titleText release];

    start_Y+=40+15;
    bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, start_Y, kMSScreenWith-10, 125)];
    bgImg.image = [[UIImage imageNamed:@"round_white_cellbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    bgImg.userInteractionEnabled = YES;
    [scrollView addSubview:bgImg];
    [bgImg release];
    
    contextTextView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(2, 3, kMSScreenWith-18, 105)];
    contextTextView.placeholder = @"请输入正文";
    contextTextView.delegate = self;
    contextTextView.font = [UIFont systemFontOfSize:16.0f];
    contextTextView.textColor = kMSTextColor;
    [bgImg addSubview:contextTextView];
    [contextTextView release];

    numLab = [[UILabel alloc]initWithFrame:CGRectMake(110, 105, 190, 20)];
    numLab.textAlignment = NSTextAlignmentRight;
    numLab.backgroundColor = [UIColor clearColor];
    numLab.textColor = kMSTextColor;
    numLab.font=[UIFont systemFontOfSize:15];
    numLab.text = [NSString stringWithFormat:@"%d/%d",0,KMSMAXPOSTLENGTH];
    [bgImg addSubview:numLab];
    [numLab release];

    
    start_Y+=125+20;
    addMenuView = [[MenuAddImageView alloc] initWithFrame:CGRectMake(0, start_Y, kMSScreenWith, 68) :5];
    addMenuView.delegate = self;
    addMenuView.totalNum = 18;  //可上传18张
    [scrollView addSubview:addMenuView];
    [addMenuView release];
    
    start_Y+=68+20;
    
    //******注册button******
    publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    publishBtn.frame = CGRectMake(10, start_Y, kMSScreenWith-20, 45);
    [publishBtn setBackgroundImage:[UIImage imageNamed:@"registerbtn_normal_bg"] forState:UIControlStateNormal];
    [publishBtn setBackgroundImage:[UIImage imageNamed:@"registerbtn_hl_bg"] forState:UIControlStateHighlighted];
    [publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [publishBtn setTitle:@"一键发表" forState:UIControlStateNormal];
    publishBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [publishBtn addTarget:self action:@selector(btnPublishClicked) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:publishBtn];
    
    start_Y+=45+20+220;
    [scrollView setContentSize:CGSizeMake(kMSScreenWith, start_Y)];
	// Do any additional setup after loading the view.
}


#pragma-mark UITextFieldDelegate methods
// called when 'return' key pressed. return NO to ignore.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
    CGRect rect = publishBtn.frame;
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
    if (titleText.text)
    {
        self.publishTitle = [titleText.text stringByTrimmingCharactersInSet:whitespace];
        if (!self.publishTitle || self.publishTitle.length <= 0)
        {
            [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"帖子标题不能为空!"];
            return NO;
        }
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"帖子标题不能为空!"];
        return NO;
    }
    
    if (contextTextView.text)
    {
        self.publishContent = [contextTextView.text stringByTrimmingCharactersInSet:whitespace];
        if (!self.publishContent || self.publishContent.length <= 0)
        {
            [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"帖子内容不能为空!"];
            return NO;
        }
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"帖子内容不能为空!"];
        return NO;
    }
    
    return YES;
}
/*  一键发表开始  */
- (void)btnPublishClicked
{
    [contextTextView resignFirstResponder];
    [titleText resignFirstResponder];
    if ([self isValidSend])//有效输入才发送
    {
        uploadCount = 0;
        [imagesURL removeAllObjects];
        
        if (BAR_POST_TYPE_COMPANY == _bar_type)
        {
            switch (buttonView.selectIndex) {
                case 0:
                {
                    self.publishType = @"news";
                }
                    break;
                case 1:
                {
                    self.publishType = @"interviwe";
                }
                    break;
                case 2:
                {
                    self.publishType = @"event";
                }
                    break;
                case 3:
                {
                    self.publishType = @"topic";
                }
                    break;
                case 4:
                {
                    self.publishType = @"hr";
                }
                    break;
                default:
                {
                    self.publishType = @"all";
                }
                    break;
            }
        }
        else
        {
            self.publishType = @"all";
        }
        
        int count = addMenuView.imageList.count;
        if (0 == count)
        {
            [[FDSBarMessageManager sharedManager]sendPost:self.barID :titleText.text :contextTextView.text :nil :self.publishType];
        }
        else
        {
//            for (int i=0; i<count; i++)
//            {
                [[ZZUploadManager sharedUploadManager]beginUploadRequest:[[FDSPathManager sharePathManager]getMessageImagePath] :[[FDSPublicManage sharePublicManager] getGUID] :@"" :@"all" :[addMenuView.imageList objectAtIndex:0] :@"jpg" ];
//            }
        }
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
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
            [[FDSBarMessageManager sharedManager]sendPost:self.barID :titleText.text :contextTextView.text :imagesURL :self.publishType];
        }
    }
}

#pragma mark FDSBarMessageInterface Delegate Method
- (void)sendPostCB:(NSString *)result :(NSString *)postID
{
    [SVProgressHUD popActivity];
    if ([result isEqualToString:@"OK"])
    {
        if ([self.delegate respondsToSelector:@selector(didSucRefresh)])
        {
            [self.delegate didSucRefresh];
        }
        FDSBarPostInfo *barPost = [[FDSBarPostInfo alloc] init];
        barPost.m_title = self.publishTitle;
        barPost.m_contentType = @"text";
        barPost.m_content = self.publishContent;
        barPost.m_postID = postID;
        
        FDSUser *userInfo = [[FDSUserManager sharedManager] getNowUser];
        barPost.m_senderName = userInfo.m_name;
        barPost.m_senderID = userInfo.m_userID;
        barPost.m_senderIcon = userInfo.m_icon;
        barPost.m_sendTime = [[FDSPublicManage sharePublicManager] getNowDate];
        
        barPost.m_commentNumber = @"0";
        barPost.m_isCollect = NO;
        barPost.m_images = [[[NSMutableArray alloc] init]autorelease];
        for (int j=0; j<imagesURL.count; j++)
        {
            [barPost.m_images addObject:[imagesURL objectAtIndex:j]];
        }
        [self.barInfo.m_barPostList insertObject:barPost atIndex:0];
        [barPost release];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [[FDSPublicManage sharePublicManager]showInfo:self.view MESSAGE:@"发帖失败！"];
    }
}

//在这个地方计算输入的字数
- (void)textViewDidChange:(UITextView *)textView
{
    int existTextNum = [textView.text length];
    numLab.text = [NSString stringWithFormat:@"%d/%d",existTextNum,KMSMAXPOSTLENGTH];
}

//如果输入超过规定的字数KMSMAXLENGTH，就不再让输入
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location >= KMSMAXPOSTLENGTH)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"最多只能输入%d字数",KMSMAXPOSTLENGTH] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return  NO;
    }
    else
    {
        return YES;
    }
}

// return NO to not change text
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 50)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"帖子标题最多只能输入%d字数",50] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return  NO;
    }
    else
    {
        return YES;
    }
}


@end

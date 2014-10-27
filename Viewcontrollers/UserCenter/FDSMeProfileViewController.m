//
//  FDSMeProfileViewController.m
//  FDS
//
//  Created by zhuozhongkeji on 14-1-13.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSMeProfileViewController.h"
#import "UIViewController+BarExtension.h"
#import "FDSEditBriefViewController.h"
#import "Constants.h"
#import "SchemeTableViewCell.h"
#import "FDSUserManager.h"
#import "FDSEditSexViewController.h"
#import "TimerLabel.h"
#import "FDSPathManager.h"
#import "SVProgressHUD.h"
#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "FDSPublicManage.h"

@interface FDSMeProfileViewController ()

@end

@implementation FDSMeProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        titleArr = [[NSArray alloc]initWithObjects:@"",@"基本信息",@"个人简介",@"联系方式", nil];
        isRefresh = NO;
        self.modifyContent = nil;
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
    [[ZZUploadManager sharedUploadManager]registerObserver:self];
    [[FDSUserCenterMessageManager sharedManager] registerObserver:self];
    if (isRefresh)
    {
        [_meInfoTable reloadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[ZZUploadManager sharedUploadManager]unRegisterObserver:self];
    [[FDSUserCenterMessageManager sharedManager] unRegisterObserver:self];
}

- (void)dealloc
{
    self.modifyContent = nil;
    [titleArr release];
    
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self homeNavbarWithTitle:@"我的资料" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _meInfoTable = [[UITableView alloc]initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith,kMSTableViewHeight-44) style:UITableViewStyleGrouped];
    _meInfoTable.delegate = self;
    _meInfoTable.dataSource = self;
    [self.view addSubview:_meInfoTable];
    [_meInfoTable release];
    
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_back"]];
    if ([_meInfoTable respondsToSelector:@selector(setBackgroundView:)])
    {
        [_meInfoTable setBackgroundView:backImg];
    }
    [backImg release];
	// Do any additional setup after loading the view.
}

#pragma mark - ProfileRefreshDelegate Method
- (void)didRefreshCurrPage
{
    isRefresh = YES;
}

#pragma mark - UITableViewDelegate UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:case 2:
        {
            return 1;
        }
        case 1:
        {
            return  6;
        }
        case 3:
        {
            return  3;
        }
        default:
            break;
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* myView = [[[UIView alloc] init] autorelease];
    myView.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 200, 22)];
    titleLabel.textColor = kMSTextColor;
    titleLabel.font =[UIFont systemFontOfSize:16];
    titleLabel.backgroundColor = [UIColor clearColor];
    
    if (section >= 0 && section < [titleArr count])
    {
        titleLabel.text = [NSString stringWithFormat:@"%@",[titleArr objectAtIndex:section]];
    }
    else
    {
        titleLabel.text = @"Unknow";
    }
    [myView addSubview:titleLabel];
    [titleLabel release];
    return myView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section)
    {
        return 5.0f;
    }
    else
    {
        return 35.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {
        return 100.0f;
    }
    else if (1 == indexPath.section || 3 == indexPath.section)
    {
        return 50.0f;
    }
    else if (2 == indexPath.section)
    {
        return 120.0f;
    }
    else
    {
        return 0.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FDSUser *userInfo = [[FDSUserManager sharedManager] getNowUser];
    static NSString *cellIdentifier = @"meInfoTableViewCell";
    DesignerDetailTableViewCell *detailCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (detailCell == nil)
    {
        detailCell = [[[DesignerDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier cellIndefy:UIDesignerDetailIndicator] autorelease];
    }
    if (0 == indexPath.section)
    {
        UITableViewCell *headCell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headCell"] autorelease];

        UILabel *designerNameLab = [[UILabel alloc]init];
        designerNameLab.backgroundColor = [UIColor clearColor];
        designerNameLab.textColor = kMSTextColor;
        designerNameLab.font=[UIFont systemFontOfSize:15];
        designerNameLab.frame = CGRectMake(95, 10, 170, 35);
        designerNameLab.text = userInfo.m_name;
        
        UILabel *professionLab = [[UILabel alloc]initWithFrame:CGRectMake(95, 55, 180, 30)];
        professionLab.backgroundColor = [UIColor clearColor];
        professionLab.textColor = kMSTextColor;
        professionLab.font=[UIFont systemFontOfSize:14];
        professionLab.text = [NSString stringWithFormat:@"ID:%@",userInfo.m_userID];
        
        EGOImageView *designerImg = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        designerImg.userInteractionEnabled = YES;
        designerImg.layer.borderWidth = 2;
        designerImg.layer.cornerRadius = 4.0;
        designerImg.layer.masksToBounds=YES;
        designerImg.tag = 0x100;
        designerImg.layer.borderColor =[[UIColor colorWithRed:242.0f/255 green:242.0f/255 blue:242.0f/255 alpha:1.0f] CGColor];
        [designerImg addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]autorelease]];
        UIImage *placeholder = [UIImage imageNamed:@"headphoto_s"];
        [designerImg setImageURLStr:userInfo.m_icon placeholder:placeholder];
        [headCell.contentView addSubview:designerImg];
//        [designerImg release];
        
        [headCell.contentView addSubview:designerNameLab];
        [designerNameLab release];
        
        [headCell.contentView addSubview:professionLab];
        [professionLab release];
        
        UIImageView* cellImg = [[UIImageView alloc] initWithFrame:CGRectMake(280+kMSCellOffsetsWidth, 44, 8, 12)];
        [cellImg setImage:[UIImage imageNamed:@"cell_more_identify_bg"]];
        [headCell.contentView addSubview:cellImg];
        [cellImg release];
        
        headCell.backgroundColor = [UIColor whiteColor];
        headCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return headCell;
    }
    else if(1 == indexPath.section)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                detailCell.detailKeyLab.text = @"昵称";
                detailCell.detailValueLab.text = userInfo.m_name;
            }
                break;
            case 1:
            {
                DesignerDetailTableViewCell *secCell = [[[DesignerDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"secInfoCell" cellIndefy:UIDesignerDetailImg] autorelease];
                secCell.detailKeyLab.text = @"性别";
                if (userInfo.m_sex.length >0)
                {
                    if ([userInfo.m_sex isEqualToString:@"女"])
                    {
                        secCell.appendImg.image = [UIImage imageNamed:@"profile_sexw_bg"];
                    }
                    else
                    {
                        secCell.appendImg.image = [UIImage imageNamed:@"profile_sexm_bg"];
                    }
                    [secCell loadCellWithData:userInfo.m_sex];
                }
                return secCell;
            }
                break;
            case 2:
            {
                detailCell.detailKeyLab.text = @"公司名称";
                if (userInfo.m_company.length > 0)
                {
                    detailCell.detailValueLab.text = userInfo.m_company;
                }
                else
                {
                    detailCell.detailValueLab.text = @"";
                }
            }
                break;
            case 3:
            {
                detailCell.detailKeyLab.text = @"职业";
                if (userInfo.m_job.length > 0)
                {
                    detailCell.detailValueLab.text = userInfo.m_job;
                }
                else
                {
                    detailCell.detailValueLab.text = @"";
                }
            }
                break;
            case 4:
            {
                detailCell.detailKeyLab.text = @"球龄";
                if (userInfo.m_golfAge.length > 0)
                {
                    detailCell.detailValueLab.text = userInfo.m_golfAge;
                }
                else
                {
                    detailCell.detailValueLab.text = @"";
                }
            }
                break;
            case 5:
            {
                detailCell.detailKeyLab.text = @"现差点";
                if (userInfo.m_handicap.length > 0)
                {
                    detailCell.detailValueLab.text = userInfo.m_handicap;
                }
                else
                {
                    detailCell.detailValueLab.text = @"";
                }
            }
                break;
            default:
                break;
        }
    }
    else if(2 == indexPath.section)
    {
        UITableViewCell *instrCell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"contentTextCell"] autorelease];
        UITextView *textview = [[UITextView alloc]initWithFrame:CGRectMake(5, 0, 290, 110)];
        textview.editable = NO;
        textview.textColor = COLOR(31, 31, 31, 1);
        textview.font = [UIFont systemFontOfSize:14];
        textview.text = userInfo.m_brief;
        [instrCell.contentView addSubview:textview];
        [textview release];

        UIButton *cellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cellBtn.adjustsImageWhenHighlighted = NO;
        cellBtn.frame = CGRectMake(230+kMSCellOffsetsWidth,90,70,30);
        [cellBtn addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
        [cellBtn setBackgroundImage:[UIImage imageNamed:@"profile_modify_bg"] forState:UIControlStateNormal];
        [instrCell.contentView addSubview:cellBtn];
        
        instrCell.backgroundColor = [UIColor whiteColor];
        instrCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return instrCell;
    }
    else  //3
    {
        switch (indexPath.row)
        {
            case 0:
            {
                detailCell.detailKeyLab.text = @"电话";
                if (userInfo.m_tel.length > 0)
                {
                    detailCell.detailValueLab.text = userInfo.m_tel;
                }
                else
                {
                    detailCell.detailValueLab.text = @"";
                }
            }
                break;
            case 1:
            {
                detailCell.detailKeyLab.text = @"手机";
                if (userInfo.m_phone.length > 0)
                {
                    detailCell.detailValueLab.text = userInfo.m_phone;
                }
                else
                {
                    detailCell.detailValueLab.text = @"";
                }
            }
                break;
            case 2:
            {
                detailCell.detailKeyLab.text = @"邮箱";
                if (userInfo.m_email.length > 0)
                {
                    detailCell.detailValueLab.text = userInfo.m_email;
                }
                else
                {
                    detailCell.detailValueLab.text = @"";
                }
            }
                break;
            default:
                break;
        }
    }
    return detailCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DesignerDetailTableViewCell* cell = (DesignerDetailTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    enum MODIFY_PROFILE modifyType = MODIFY_PROFILE_NONE;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (0 == section) //修改头像
    {
        modifyType = MODIFY_PROFILE_ICON;
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
    else if(1 == section && 1 == row)//修改性别
    {
        modifyType = MODIFY_PROFILE_SEX;
        FDSEditSexViewController *editProfile = [[FDSEditSexViewController alloc]init];
        editProfile.delegate = self;
        [self.navigationController pushViewController:editProfile animated:YES];
        [editProfile release];
    }
    else if(2 == section)//修改个人简介
    {
        return;
    }
    else  //修改其他
    {
        if (1 == section)
        {
            if (0 == row)
            {
                modifyType = MODIFY_PROFILE_NAME;
            }
            else if(2 == row)
            {
                modifyType = MODIFY_PROFILE_COMPANY;
            }
            else if(3 == row)
            {
                modifyType = MODIFY_PROFILE_JOB;
            }
            else if(4 == row)
            {
                modifyType = MODIFY_PROFILE_GOLFAGE;
            }
            else if(5 == row)
            {
                modifyType = MODIFY_PROFILE_HANDICAP;
            }
        }
        else if(3 == section)
        {
            if (0 == row)
            {
                modifyType = MODIFY_PROFILE_TEL;
            }
            else if(1 == row)
            {
                modifyType = MODIFY_PROFILE_PHONE;
            }
            else if(2 == row)
            {
                modifyType = MODIFY_PROFILE_EMAIL;
            }
        }
        FDSEditProfileViewController *editProfile = [[FDSEditProfileViewController alloc]init];
        editProfile.titleStr = cell.detailKeyLab.text;
        editProfile.contentStr = cell.detailValueLab.text;
        editProfile.modifyStyle = modifyType;
        editProfile.delegate = self;
        [self.navigationController pushViewController:editProfile animated:YES];
        [editProfile release];
    }
}


//******修改个人简介*****
- (void)buttonClicked
{
    //modifyType = MODIFY_PROFILE_BRIEF;
    FDSEditBriefViewController *editProfile = [[FDSEditBriefViewController alloc]init];
    editProfile.delegate = self;
    [self.navigationController pushViewController:editProfile animated:YES];
    [editProfile release];
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
//    UIImage *img = nil;
//	img = [info objectForKey:UIImagePickerControllerEditedImage]; //裁剪后的图片
//	if (!img)
//	{
//		img = [info objectForKey:UIImagePickerControllerOriginalImage]; //原始图片
//	}
//	
//    NSData *thumbData=nil;
//    if(img.size.width * img.size.height > 14400)
//    {// 是大图片，进行质量压缩
//        thumbData= [NSData dataWithData:UIImageJPEGRepresentation(img, 0.8)];
//        //新建压缩后的图片
//        img=[UIImage imageWithData:thumbData];
//    }
//	
//    //裁减图片到指定高宽
//    UIImage *newImage = [UIImageSize thumbnailOfImage:img Size:CGSizeMake(80.0, 80.0)];
//	thumbData = [NSData dataWithData:UIImagePNGRepresentation(newImage)];
//
//	//获取图片 将其转为NSData
//	NSUInteger yourImgSize = (([thumbData length]/8)/1024)/1.5/1024;
//	
//	if(yourImgSize > 50)
//	{
//		UIAlertView *tipsView=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Tips",nil) message:NSLocalizedString(@"The Size of the Image is out of 50kb",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil];
//		[tipsView show];
//		[tipsView release];
//		
//		[picker dismissViewControllerAnimated:YES completion:nil];
//		return;
//	}
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
//    [[ZZUploadManager sharedUploadManager]beginUploadRequest:[[FDSPathManager sharePathManager]getServerUserIcon] :[[FDSUserManager sharedManager]getNowUser].m_userID :@"" :@"all" :thumbData :@"jpg" ];
//	[picker dismissViewControllerAnimated:YES completion:nil];
    
    
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
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
//        [[ZZUploadManager sharedUploadManager]beginUploadRequest:[[FDSPathManager sharePathManager]getServerUserIcon] :[[FDSUserManager sharedManager]getNowUser].m_userID :@"" :@"all" :thumbData :@"jpg" ];
        [[ZZUploadManager sharedUploadManager]beginUploadRequest:[[FDSPathManager sharePathManager]getServerUserIcon] :[[FDSPublicManage sharePublicManager] getGUID] :@"" :@"all" :thumbData :@"jpg" ];//[[FDSPublicManage sharePublicManager] getGUID]
    }
}

#pragma mark ZZUploadInterface Delegate Method
-(void)uploadStateNotice:(ZZUploadRequest*)uploadRequest
{
    if (ZZUploadState_UPLOAD_OK == uploadRequest.m_uploadState || ZZUploadState_UPLOAD_FAIL == uploadRequest.m_uploadState)
    {
        if (ZZUploadState_UPLOAD_OK == uploadRequest.m_uploadState)
        {
            self.modifyContent = uploadRequest.m_filePath;
            [[FDSUserCenterMessageManager sharedManager]modifyUserCard:[[FDSUserManager sharedManager] getNowUser].m_userID :self.modifyContent :MODIFY_PROFILE_ICON];

        }
        else
        {
            [SVProgressHUD popActivity];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"上传失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }
}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
    
    MJPhoto *photo = [[MJPhoto alloc] init];
    FDSUser *userInfo = [[FDSUserManager sharedManager] getNowUser];

    photo.url = [NSURL URLWithString:userInfo.m_icon]; // 图片路径
//    photo.srcImageView = designerImg; // 来源于哪个UIImageView
    [photos addObject:photo];
    [photo release];
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    [browser release];
}

-(void)updateImageView
{
    [[FDSUserManager sharedManager]setNowUserWithStyle:MODIFY_PROFILE_ICON withContext:self.modifyContent];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_meInfoTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark FDSUserCenterMessageInterface Delegate Method
//修改个人名片
- (void)modifyUserCardCB:(NSString*)result
{
    [SVProgressHUD popActivity];
    if ([result isEqualToString:@"OK"])
    {
        if(self.modifyContent)
        {
//            [[EGOImageLoader sharedImageLoader]clearCacheForURL:[NSURL URLWithString:self.modifyContent]];
            [[EGOImageLoader sharedImageLoader]clearCacheForURL:[NSURL URLWithString:[[FDSUserManager sharedManager]getNowUser].m_icon]];
        }
        [self performSelector:@selector(updateImageView) withObject:nil afterDelay:1];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改头像失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}



@end

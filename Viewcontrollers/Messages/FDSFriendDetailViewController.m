//
//  FDSFriendDetailViewController.m
//  FDS
//
//  Created by zhuozhong on 14-2-19.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSFriendDetailViewController.h"
#import "UIViewController+BarExtension.h"
#import "SchemeTableViewCell.h"
#import "SVProgressHUD.h"
#import "FDSAdressBookViewController.h"

@interface FDSFriendDetailViewController ()

@end

@implementation FDSFriendDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        titleArr = [[NSArray alloc]initWithObjects:@"",@"基本信息",@"个人简介",@"联系方式", nil];
        self.friendInfo = nil;
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
    [titleArr release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[FDSUserCenterMessageManager sharedManager] registerObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[FDSUserCenterMessageManager sharedManager] unRegisterObserver:self];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self homeNavbarWithTitle:@"TA的资料" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _friendInfoTable = [[UITableView alloc]initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith,kMSTableViewHeight-44) style:UITableViewStyleGrouped];
    _friendInfoTable.delegate = self;
    _friendInfoTable.dataSource = self;
    [self.view addSubview:_friendInfoTable];
    [_friendInfoTable release];
    
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_back"]];
    if ([_friendInfoTable respondsToSelector:@selector(setBackgroundView:)])
    {
        [_friendInfoTable setBackgroundView:backImg];
    }
    [backImg release];

	// Do any additional setup after loading the view.
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
        case 1:case 3:
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
        titleLabel.text = @"";
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

// custom view for footer. will be adjusted to default or specified footer height
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (3 == section && [self.friendInfo.m_friendType isEqualToString:@"friend"])
    {
        UIView* myView = [[[UIView alloc] init] autorelease];
        myView.backgroundColor = [UIColor clearColor];
        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        delBtn.frame = CGRectMake(10, 25, 300, 50);
        [delBtn setBackgroundImage:[UIImage imageNamed:@"red_cell_normal_bg"] forState:UIControlStateNormal];
        [delBtn setBackgroundImage:[UIImage imageNamed:@"red_cell_hl_bg"] forState:UIControlStateHighlighted];
        [delBtn setTitle:@"删除好友" forState:UIControlStateNormal];
        [delBtn setTitleShadowColor:COLOR(173, 22, 18, 1) forState:UIControlStateNormal];
        [delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [delBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [delBtn addTarget:self action:@selector(subCurrentFriend) forControlEvents:UIControlEventTouchUpInside];
        [myView addSubview:delBtn];
        return myView;
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (3 == section && [self.friendInfo.m_friendType isEqualToString:@"friend"])
    {
        return 90.0f;
    }
    else
    {
        return 0.0f;
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
    static NSString *cellIdentifier = @"friendInfoTableViewCell";
    DesignerDetailTableViewCell *detailCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (detailCell == nil)
    {
        detailCell = [[[DesignerDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier cellIndefy:UIDesignerDetailDefault] autorelease];
    }
    if (0 == indexPath.section)
    {
        UITableViewCell *headCell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"friendheadCell"] autorelease];
        EGOImageView *designerImg = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        designerImg.layer.borderWidth = 2;
        designerImg.layer.cornerRadius = 4.0;
        designerImg.layer.masksToBounds=YES;
        designerImg.tag = 0x100;
        designerImg.layer.borderColor =[[UIColor colorWithRed:242.0f/255 green:242.0f/255 blue:242.0f/255 alpha:1.0f] CGColor];
        [designerImg initWithPlaceholderImage:[UIImage imageNamed:@"headphoto_s"]];
        
        UILabel *designerNameLab = [[UILabel alloc]init];
        designerNameLab.backgroundColor = [UIColor clearColor];
        designerNameLab.textColor = kMSTextColor;
        designerNameLab.frame = CGRectZero;
        designerNameLab.font=[UIFont systemFontOfSize:15];
        
        UILabel *professionLab = [[UILabel alloc]initWithFrame:CGRectMake(95, 55, 180, 30)];
        professionLab.backgroundColor = [UIColor clearColor];
        professionLab.textColor = kMSTextColor;
        professionLab.font=[UIFont systemFontOfSize:14];
        
        if (self.friendInfo)
        {
            designerImg.imageURL = [NSURL URLWithString:self.friendInfo.m_icon];
            professionLab.text = [NSString stringWithFormat:@"ID:%@",self.friendInfo.m_friendID];
            
            NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        designerNameLab.font, NSFontAttributeName,
                                        nil];
            CGSize titleSize;
            if(IOS_7)
            {
                titleSize = [self.friendInfo.m_name sizeWithAttributes:attributes];
            }
            else
            {
                titleSize = [self.friendInfo.m_name sizeWithFont:designerNameLab.font];
            }
            float nameWidth = 150.f;
            if (titleSize.width < nameWidth)
            {
                nameWidth = titleSize.width;
            }
            designerNameLab.frame = CGRectMake(95, 10, nameWidth, 35);
            designerNameLab.text = self.friendInfo.m_name;
            if (self.friendInfo.m_sex.length > 0)
            {
                UIImageView *sexImg = [[UIImageView alloc] initWithFrame:CGRectMake(95+nameWidth+5, 18, 18, 18)];
                if ([self.friendInfo.m_sex isEqualToString:@"女"])
                {
                    sexImg.image = [UIImage imageNamed:@"profile_sexw_bg"];
                }
                else
                {
                    sexImg.image = [UIImage imageNamed:@"profile_sexm_bg"];
                }
                [headCell.contentView addSubview:sexImg];
                [sexImg release];
            }
        }

        [headCell.contentView addSubview:designerImg];
        [designerImg release];
        
        [headCell.contentView addSubview:designerNameLab];
        [designerNameLab release];
        
        [headCell.contentView addSubview:professionLab];
        [professionLab release];
        
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
                detailCell.detailKeyLab.text = @"公司名称";
                if (self.friendInfo)
                {
                    detailCell.detailValueLab.text = self.friendInfo.m_company;
                }
            }
                break;
            case 1:
            {
                detailCell.detailKeyLab.text = @"职业";
                if (self.friendInfo)
                {
                    detailCell.detailValueLab.text = self.friendInfo.m_job;
                }
            }
                break;
            case 2:
            {
                detailCell.detailKeyLab.text = @"球龄";
                if (self.friendInfo)
                {
                    detailCell.detailValueLab.text = self.friendInfo.m_golfAge;
                }
            }
                break;
            default:
                break;
        }
    }
    else if(2 == indexPath.section)
    {
        UITableViewCell *instrCell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"friendTextCell"] autorelease];
        UITextView *textview = [[UITextView alloc]initWithFrame:CGRectMake(5, 0, 290, 110)];
        textview.editable = NO;
        textview.textColor = COLOR(31, 31, 31, 1);
        textview.font = [UIFont systemFontOfSize:14];
        if (self.friendInfo)
        {
            textview.text = self.friendInfo.m_brief;
        }
        [instrCell.contentView addSubview:textview];
        [textview release];
        
        instrCell.backgroundColor = [UIColor whiteColor];
        instrCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return instrCell;
    }
    else if(3 == indexPath.section)  //3
    {
        switch (indexPath.row)
        {
            case 0:
            {
                detailCell.detailKeyLab.text = @"电话";
                if (self.friendInfo)
                {
                    detailCell.detailValueLab.text = self.friendInfo.m_tel;
                }
            }
                break;
            case 1:
            {
                detailCell.detailKeyLab.text = @"手机";
                if (self.friendInfo)
                {
                    detailCell.detailValueLab.text = self.friendInfo.m_phone;
                }
            }
                break;
            case 2:
            {
                detailCell.detailKeyLab.text = @"邮箱";
                if (self.friendInfo)
                {
                    detailCell.detailValueLab.text = self.friendInfo.m_email;
                }
            }
                break;
            default:
                break;
        }
    }
    return detailCell;
}


- (void)subCurrentFriend
{
    /* 删除好友 */
    UIActionSheet*alert = [[UIActionSheet alloc]
                           initWithTitle:@"删除该好友后,对方列表也会将你删除!"
                           delegate:self
                           cancelButtonTitle:NSLocalizedString(@"取消",nil)
                           destructiveButtonTitle:nil
                           otherButtonTitles:NSLocalizedString(@"删除该好友",nil),
                           nil];
    [alert showInView:self.view];
    [alert release];
//    - (void)subFriend:(NSString*)friendID
}


#pragma UIActionSheetDelegate Method
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex)
    {
        /* 删除该好友 */
        [[FDSUserCenterMessageManager sharedManager]subFriend:self.friendInfo.m_friendID];
        
        for(UIViewController *controller in self.navigationController.viewControllers)
        {
            if([controller isKindOfClass:[FDSAdressBookViewController class]])
            {
                FDSAdressBookViewController *addressVC = (FDSAdressBookViewController*)controller;
                [self.navigationController popToViewController:addressVC animated:YES];
                return;
            }
        }
        
        /*   通讯录页面 还未压栈   */
        FDSAdressBookViewController *contactsVC = [[FDSAdressBookViewController alloc]init];
        [self.navigationController pushViewController:contactsVC animated:YES];
        [contactsVC release];
    }
}


@end

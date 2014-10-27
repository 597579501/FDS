//
//  FDSThirdAccManagerViewController.m
//  FDS
//
//  Created by zhuozhongkeji on 14-1-10.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSThirdAccManagerViewController.h"
#import "UIViewController+BarExtension.h"
#import "Constants.h"
#import "UMSocial.h"

@interface FDSThirdAccManagerViewController ()

@end

@implementation FDSThirdAccManagerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        snsInfoArr = [[NSMutableArray alloc] init];
        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithCapacity:4];
        [tmpDic setObject:[UIImage imageNamed:@"UMS_sina_icon"] forKey:@"IMG"];
        [tmpDic setObject:@"新浪微博" forKey:@"TEXT"];
        [tmpDic setObject:UMShareToSina forKey:@"PLATFORM"];
        [snsInfoArr addObject:tmpDic];
        
        tmpDic = [NSMutableDictionary dictionaryWithCapacity:4];
        [tmpDic setObject:[UIImage imageNamed:@"UMS_tencent_icon"] forKey:@"IMG"];
        [tmpDic setObject:@"腾讯微博" forKey:@"TEXT"];
        [tmpDic setObject:UMShareToTencent forKey:@"PLATFORM"];
        [snsInfoArr addObject:tmpDic];
        
        tmpDic = [NSMutableDictionary dictionaryWithCapacity:4];
        [tmpDic setObject:[UIImage imageNamed:@"UMS_wechat_session_icon"] forKey:@"IMG"];
        [tmpDic setObject:@"微信" forKey:@"TEXT"];
        [tmpDic setObject:UMShareToWechatSession forKey:@"PLATFORM"];
        [snsInfoArr addObject:tmpDic];
        
        tmpDic = [NSMutableDictionary dictionaryWithCapacity:4];
        [tmpDic setObject:[UIImage imageNamed:@"UMS_qq_icon"] forKey:@"IMG"];
        [tmpDic setObject:@"手机QQ" forKey:@"TEXT"];
        [tmpDic setObject:UMShareToQQ forKey:@"PLATFORM"];
        [snsInfoArr addObject:tmpDic];
        
        tmpDic = [NSMutableDictionary dictionaryWithCapacity:4];
        [tmpDic setObject:[UIImage imageNamed:@"UMS_qzone_icon"] forKey:@"IMG"];
        [tmpDic setObject:@"QQ空间" forKey:@"TEXT"];
        [tmpDic setObject:UMShareToQzone forKey:@"PLATFORM"];
        [snsInfoArr addObject:tmpDic];
        
        tmpDic = [NSMutableDictionary dictionaryWithCapacity:4];
        [tmpDic setObject:[UIImage imageNamed:@"UMS_renren_icon"] forKey:@"IMG"];
        [tmpDic setObject:@"人人网" forKey:@"TEXT"];
        [tmpDic setObject:UMShareToRenren forKey:@"PLATFORM"];
        [snsInfoArr addObject:tmpDic];
        
        tmpDic = [NSMutableDictionary dictionaryWithCapacity:4];
        [tmpDic setObject:[UIImage imageNamed:@"UMS_douban_icon"] forKey:@"IMG"];
        [tmpDic setObject:@"豆瓣" forKey:@"TEXT"];
        [tmpDic setObject:UMShareToDouban forKey:@"PLATFORM"];
        [snsInfoArr addObject:tmpDic];
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
    [snsInfoArr release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self homeNavbarWithTitle:@"账号管理" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _accountManageTable = [[UITableView alloc]initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith,kMSTableViewHeight-44) style:UITableViewStyleGrouped];
    _accountManageTable.delegate = self;
    _accountManageTable.dataSource = self;
    [self.view addSubview:_accountManageTable];
    [_accountManageTable release];
    
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_back"]];
    if ([_accountManageTable respondsToSelector:@selector(setBackgroundView:)])
    {
        [_accountManageTable setBackgroundView:backImg];
    }
    [backImg release];
	// Do any additional setup after loading the view.
}

#pragma mark - UITableViewDelegate UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [snsInfoArr count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* myView = [[[UIView alloc] init] autorelease];
    myView.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 70, 22)];
    titleLabel.textColor = kMSTextColor;
    titleLabel.font =[UIFont systemFontOfSize:16];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"绑定账号";
    [myView addSubview:titleLabel];
    [titleLabel release];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 9, 220, 20)];
    titleLabel.textColor = kMSTextColor;
    titleLabel.font =[UIFont systemFontOfSize:13];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"（绑定账号后,你可分享到不同平台.）";
    [myView addSubview:titleLabel];
    [titleLabel release];

    return myView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSDictionary *tmpDic = [snsInfoArr objectAtIndex:row];
//    UIImageView *bgView = [[[UIImageView alloc] init] autorelease];
    //判断对应平台是否授权
    if ([UMSocialAccountManager isOauthWithPlatform:[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"PLATFORM"]]])
    {
        UnBindTableViewCell *unBindCell = [[[UnBindTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UnBindTableViewCell"] autorelease];
        unBindCell.logoImg.image = [tmpDic objectForKey:@"IMG"];
        unBindCell.titleTextLab.text = [NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"TEXT"]];
       
        [unBindCell.cellBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [unBindCell.cellBtn setTitle:@"解绑" forState:UIControlStateNormal];
        [unBindCell.cellBtn setBackgroundImage:[UIImage imageNamed:@"red_btnbg"] forState:UIControlStateNormal];
        unBindCell.unBindTag = row;
        unBindCell.delegate = self;
        
        return unBindCell;
    }
    else
    {
        static NSString *cellIdentifier = @"profileTableViewCell";
        ProfileTableViewCell *profileCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (profileCell == nil)
        {
            profileCell = [[[ProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier cellIndefy:YES] autorelease];
        }
        profileCell.logoImg.image = [tmpDic objectForKey:@"IMG"];
        profileCell.titleTextLab.text = [NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"TEXT"]];
        return profileCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSDictionary *tmpDic = [snsInfoArr objectAtIndex:row];
    //判断对应平台是否授权
    if ([UMSocialAccountManager isOauthWithPlatform:[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"PLATFORM"]]])
    {
        return;
    }
    else
    {
        //进入授权页面
        [UMSocialSnsPlatformManager getSocialPlatformWithName:[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"PLATFORM"]]].loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                //获取微博用户名、uid、token等
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"PLATFORM"]]];
                NSLog(@"username is %@, uid is %@, token is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken);
                //刷新当前绑定结果得第三方cell授权情况
                NSArray  *indexArray=[NSArray  arrayWithObject:indexPath];
                [_accountManageTable reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
            }
        });
    }
}

#pragma mark - UnBindListenDelegate Method
- (void)notifyUnBindWithTag:(NSInteger)currentIndex
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"解绑" message:@"确定解除绑定吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = currentIndex;
    [alert show];
    [alert release];
}

#pragma mark - UIAlertViewDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex)
    {
        NSInteger currentIndex = alertView.tag;
        NSDictionary *tmpDic = [snsInfoArr objectAtIndex:currentIndex];
        [[UMSocialDataService defaultDataService] requestUnOauthWithType:[NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"PLATFORM"]] completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"unOauth response is %@",response);
                //刷新当前绑定结果得第三方cell授权情况
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
                NSArray  *indexArray=[NSArray  arrayWithObject:indexPath];
                [_accountManageTable reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    }
}

@end

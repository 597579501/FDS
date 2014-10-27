//
//  FDSCollectListViewController.m
//  FDS
//
//  Created by zhuozhong on 14-3-7.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSCollectListViewController.h"
#import "UIViewController+BarExtension.h"
#import "Constants.h"
#import "CollectedInfoCell.h"
#import "FDSDBManager.h"
#import "FDSBarCommentViewController.h"
#import "FDSCompanyDetailViewController.h"
#import "FDSProductDetailViewController.h"
#import "FDSDesignerDetailViewController.h"
#import "FDSSchemeDetailViewController.h"

@interface FDSCollectListViewController ()

@end

@implementation FDSCollectListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.collectInfo = nil;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self.collectInfo = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self homeNavbarWithTitle:self.collectInfo.m_typeTitle andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _collectedTable = [[UITableView alloc]initWithFrame:CGRectMake(0, kMSNaviHight, kMSScreenWith,kMSTableViewHeight-44) style:UITableViewStylePlain];
    _collectedTable.delegate = self;
    _collectedTable.dataSource = self;
    _collectedTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_collectedTable];
    [_collectedTable release];
    
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_back"]];
    if ([_collectedTable respondsToSelector:@selector(setBackgroundView:)])
    {
        [_collectedTable setBackgroundView:backImg];
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
    return [self.collectInfo.m_collectList count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (0 == row)
    {
        CollectedInfoCell *topCell = [[[CollectedInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"topCollectCell"] autorelease];
        topCell.iconImage.frame = CGRectMake(10, 10, 30, 30);
        topCell.contentLab.frame = CGRectMake(50, 5, 200, 40);
        topCell.contentLab.textColor = COLOR(69, 69, 69, 1);
        topCell.contentLab.font=[UIFont systemFontOfSize:16];

        topCell.iconImage.image = [UIImage imageNamed:self.collectInfo.m_typeIcon];
        topCell.contentLab.text = self.collectInfo.m_typeTitle;
        
        topCell.contentView.backgroundColor = COLOR(187, 187, 187, 1);
        
        return topCell;
    }
    static NSString *cellIdentifier = @"collectListTableViewCell";
    CollectedInfoCell *collectListCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    FDSCollectedInfo *dataInfo = [self.collectInfo.m_collectList objectAtIndex:row-1];
    if (collectListCell == nil)
    {
        collectListCell = [[[CollectedInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        collectListCell.contentLab.textColor = kMSTextColor;
        collectListCell.contentLab.font=[UIFont systemFontOfSize:14];
        collectListCell.iconImage.frame = CGRectMake(10, 5, 40, 40);
        collectListCell.contentLab.frame = CGRectMake(60, 7, 250, 36);
        
        collectListCell.iconImage.layer.borderWidth = 1;
        collectListCell.iconImage.layer.cornerRadius = 4.0;
        collectListCell.iconImage.layer.masksToBounds=YES;
        collectListCell.iconImage.layer.borderColor = [[UIColor colorWithRed:242.0f/255 green:242.0f/255 blue:242.0f/255 alpha:1.0f] CGColor];

    }
    [collectListCell.iconImage initWithPlaceholderImage:[UIImage imageNamed:@"send_image_default"]];
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@",dataInfo.m_collectIcon];
    if (urlStr.length >= 4)
    {
        [urlStr insertString:@"_middle" atIndex:urlStr.length-4];
    }
    collectListCell.iconImage.imageURL = [NSURL URLWithString:urlStr];
//    collectListCell.iconImage.imageURL = [NSURL URLWithString:dataInfo.m_collectIcon];
    collectListCell.contentLab.text = dataInfo.m_collectTitle;
    collectListCell.contentView.backgroundColor = [UIColor whiteColor];

    return collectListCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;

    if (0 == row)
    {
        return;
    }
    else
    {
        FDSCollectedInfo *dataInfo = [self.collectInfo.m_collectList objectAtIndex:row-1];
        switch (self.collectInfo.m_collectType)
        {
            case FDS_COLLECTED_MESSAGE_POSTBAR:// 帖子收藏
            {
                FDSBarCommentViewController *barCommentVC = [[FDSBarCommentViewController alloc] init];
                FDSBarPostInfo *tempBar = [[FDSBarPostInfo alloc] init];
                tempBar.m_postID = dataInfo.m_collectID; //对应跳到详情页面的ID
                tempBar.m_isCollect = YES;
                barCommentVC.barPostInfo = tempBar;
                [tempBar release];
                [self.navigationController pushViewController:barCommentVC animated:YES];
                [barCommentVC release];
            }
                break;
            case FDS_COLLECTED_MESSAGE_COMPANY:// 企业收藏
            {
                FDSCompanyDetailViewController *fdsDpage = [[FDSCompanyDetailViewController alloc]init];
                fdsDpage.companyID = dataInfo.m_collectID;
                fdsDpage.comName = dataInfo.m_collectTitle;
                [self.navigationController pushViewController:fdsDpage animated:YES];
                [fdsDpage release];
            }
                break;
            case FDS_COLLECTED_MESSAGE_SUCCASE:// 案例收藏
            {
                FDSSchemeDetailViewController *fdsVC = [[FDSSchemeDetailViewController alloc]init];
                FDSComSucCase *sunCase = [[FDSComSucCase alloc] init];
                sunCase.m_successfulcaseID = dataInfo.m_collectID;
                sunCase.m_title = dataInfo.m_collectTitle;
                sunCase.m_imagePathArr = [[[NSMutableArray alloc] init] autorelease];
                [sunCase.m_imagePathArr addObject:dataInfo.m_collectIcon];
                
                fdsVC.comSucCaseInfo = sunCase;
                [sunCase release];
                
                [self.navigationController pushViewController:fdsVC animated:YES];
                [fdsVC release];
            }
                break;
            case FDS_COLLECTED_MESSAGE_PRODUCT:// 产品收藏
            {
                FDSProductDetailViewController *fdsVC = [[FDSProductDetailViewController alloc]init];
                fdsVC.productID = dataInfo.m_collectID;
                fdsVC.companyID = @"";
                [self.navigationController pushViewController:fdsVC animated:YES];
                [fdsVC release];
            }
                break;
            case FDS_COLLECTED_MESSAGE_DESIGNER:// 设计师收藏
            {
                FDSDesignerDetailViewController *fdsVC = [[FDSDesignerDetailViewController alloc]init];
                fdsVC.designerID = dataInfo.m_collectID;
                [self.navigationController pushViewController:fdsVC animated:YES];
                [fdsVC release];
            }
                break;
            default:
                break;
        }
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row )
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle  forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        FDSCollectedInfo *dataInfo = [self.collectInfo.m_collectList objectAtIndex:indexPath.row-1];
        
        [[FDSDBManager sharedManager] deleteCollectedInfoFromDB:dataInfo.m_id]; //delete DB
        
        [self.collectInfo.m_collectList removeObjectAtIndex:indexPath.row-1]; //delete cache
        
        [_collectedTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft]; //delete cell
    }
}

@end

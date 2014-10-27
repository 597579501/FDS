//
//  FDSProductDetailViewController.m
//  FDS
//
//  Created by zhuozhongkeji on 13-12-27.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "FDSProductDetailViewController.h"
#import "UIViewController+BarExtension.h"
#import "Constants.h"
#import "SVProgressHUD.h"
#import "FDSCommentListViewController.h"
#import "FDSPublicManage.h"
#import "FDSDBManager.h"
#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "ZZSharedManager.h"

@interface FDSProductDetailViewController ()

@end

@implementation FDSProductDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.productInfo = nil;
        self.collectTypeData = nil;
    }
    return self;
}

- (void)dealloc
{
    self.collectTypeData = nil;
    
    self.productInfo = nil;
    _xhaScroll.autoScrollEnable = NO;
    [_companyID release];
    [_productID release];
    [super dealloc];
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
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[FDSCompanyMessageManager sharedManager] unRegisterObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self homeNavbarWithTitle:@"产品详情" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    if (IOS_7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = COLOR(218, 218, 218, 1);
    [self allSubViewInit];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [[FDSCompanyMessageManager sharedManager]getCompanyProductInfo:@"" withComId:_companyID withProductId:_productID];
	// Do any additional setup after loading the view.
}

- (void)allSubViewInit
{
    //ICON 数组展示
    UIImageView *bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(10 ,kMSNaviHight+5, kMSScreenWith-20, kMSTableViewHeight-44-50-10)];
    bgImg.image  = [[UIImage imageNamed:@"round_white_cellbg"]resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    bgImg.userInteractionEnabled = YES;
    bgImg.layer.borderWidth = 1;
    bgImg.layer.cornerRadius = 6.0;
    bgImg.layer.masksToBounds=YES;
    bgImg.layer.borderColor =[COLOR(188, 188, 188, 1) CGColor];

    [self.view addSubview:bgImg];
    [bgImg release];
    
    UILabel *titLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 40)];
    titLab.backgroundColor = [UIColor clearColor];
    titLab.textColor = kMSTextColor;
    titLab.text = @"商品资料图";
    titLab.font=[UIFont systemFontOfSize:16];
    titLab.textAlignment = NSTextAlignmentCenter;
    [bgImg addSubview:titLab];
    [titLab release];

    _xhaScroll = [[XHADScrollView alloc]initWithFrame:CGRectMake(0, 40, 300, 140) isVisiable:YES frame:CGRectMake(0, 130, 300, 10) circle:YES start:0];
    _xhaScroll.autoScrollEnable = YES;
//    _xhaScroll.pageControl.backgroundColor = COLOR(228, 228, 228, 1);
    _xhaScroll.pageControl.backgroundColor = [UIColor clearColor];

    [bgImg addSubview:_xhaScroll];
    [_xhaScroll release];

    //产品规格  名字 价格等展示
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 185, 300, 80+19)];
    tmpView.backgroundColor = COLOR(218, 218, 218, 1);
    [bgImg addSubview:tmpView];
    [tmpView release];
    
    _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 200, 40)];
    _nameLab.textAlignment = NSTextAlignmentCenter;
    _nameLab.backgroundColor = [UIColor clearColor];
    _nameLab.textColor = [UIColor blackColor];
    _nameLab.font=[UIFont systemFontOfSize:19];
    [tmpView addSubview:_nameLab];
    [_nameLab release];
    
    _storeNumLab = [[UILabel alloc]initWithFrame:CGRectMake(25, 5+30, 250, 20)];
    _storeNumLab.textAlignment = NSTextAlignmentCenter;
    _storeNumLab.backgroundColor = [UIColor clearColor];
    _storeNumLab.textColor = COLOR(69, 69, 69, 1);
    _storeNumLab.font=[UIFont systemFontOfSize:12];
    [tmpView addSubview:_storeNumLab];
    [_storeNumLab release];
    
    
    /*  包邮  */
    UIImageView *postImg = [[UIImageView alloc] initWithFrame:CGRectMake(90, 65, 50, 25)];
    postImg.userInteractionEnabled = YES;
    postImg.image = [UIImage imageNamed:@"product_postage_bg"];
    [tmpView addSubview:postImg];
    [postImg release];
    
    _postageLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 2, 50, 20)];
    _postageLab.backgroundColor = [UIColor clearColor];
    _postageLab.textColor = COLOR(69, 69, 69, 1);
    _postageLab.textAlignment = NSTextAlignmentCenter;
    _postageLab.font=[UIFont systemFontOfSize:12];
    [postImg addSubview:_postageLab];
    [_postageLab release];
    /*  包邮  */
    
    
    /*  立即购买  */
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.frame = CGRectMake(210, 65, 80, 25);
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyBtn setBackgroundImage:[UIImage imageNamed:@"product_buy_normal"] forState:UIControlStateNormal];
    [buyBtn setBackgroundImage:[UIImage imageNamed:@"product_buy_hl"] forState:UIControlStateHighlighted];
    [buyBtn addTarget:self action:@selector(buyBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [tmpView addSubview:buyBtn];
    /*  立即购买  */

//    tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 185+80+18, 300, 1)];
//    tmpView.backgroundColor = COLOR(213, 213, 213, 1);
//    [bgImg addSubview:tmpView];
//    [tmpView release];
    //产品简介
    _briefInfoText = [[UITextView alloc]initWithFrame:CGRectMake(5, 185+80+19, 290, bgImg.frame.size.height-(185+80+19+5))];
    _briefInfoText.editable = NO;
    _briefInfoText.textColor = COLOR(31, 31, 31, 1);
    _briefInfoText.font = [UIFont systemFontOfSize:14];
    [bgImg addSubview:_briefInfoText];
    [_briefInfoText release];

    
    //底部操作栏
    NSMutableDictionary *collectDic = [NSMutableDictionary dictionaryWithCapacity:3];
    [collectDic setObject:[UIImage imageNamed:@"show_connect_bg"] forKey:@"Default"];
    [collectDic setObject:[NSString stringWithFormat:@"收藏"] forKey:@"title"];
    
    NSMutableDictionary *shareDic = [NSMutableDictionary dictionaryWithCapacity:3];
    [shareDic setObject:[UIImage imageNamed:@"show_share_bg"] forKey:@"Default"];
    [shareDic setObject:[NSString stringWithFormat:@"分享"] forKey:@"title"];
    
    NSMutableDictionary *imDic = [NSMutableDictionary dictionaryWithCapacity:3];
    [imDic setObject:[UIImage imageNamed:@"show_comment_bg"] forKey:@"Default"];
    [imDic setObject:[NSString stringWithFormat:@"评论"] forKey:@"title"];
    
    NSArray *dicArr = [NSArray arrayWithObjects:collectDic,shareDic,imDic, nil];
    _menuButtomView = [[ButtomMenuView alloc] initWithFrame:CGRectMake(0, kMSNaviHight+kMSTableViewHeight-44-50, kMSScreenWith, 50) withDataArr:dicArr];
    _menuButtomView.delegate = self;
    [self.view addSubview:_menuButtomView];
    [_menuButtomView release];
}

- (void)getCompanyProductInfoCB:(FDSComProduct*)productInfo
{
    [SVProgressHUD popActivity];
    self.productInfo = productInfo;
    
    _nameLab.text = _productInfo.m_proName;
    _storeNumLab.text = [NSString stringWithFormat:@"库存: %@    销售量: %@    浏览量: %@",_productInfo.m_storeNumber,_productInfo.m_saleNumber,_productInfo.m_browserNumber];
    if ([_productInfo.m_postage isEqualToString:@"no"])
    {
        _postageLab.text = @"不包邮";
    }
    else
    {
        _postageLab.text = @"包邮";
    }

    _briefInfoText.text = _productInfo.m_briefInfo;

    _xhaScroll.datasource = self;
    _xhaScroll.delegate = self;
}

#pragma mark - OperSNSBtnDelegate Method
- (void)didSNSWithTag:(NSInteger)currTag
{
    switch (currTag)
    {
        case 0://产品收藏
        {
            self.collectTypeData = [[FDSPublicManage sharePublicManager]getCollectedDataWithType:FDS_COLLECTED_MESSAGE_PRODUCT];
            if (self.collectTypeData)
            {
                BOOL isExist = NO;
                FDSCollectedInfo *tempCollect = nil;
                for (int i=0; i<self.collectTypeData.count; i++)
                {
                    tempCollect = [self.collectTypeData objectAtIndex:i];
                    
                    if ([_productID isEqualToString:tempCollect.m_collectID])
                    {
                        isExist = YES;
                        break;
                    }
                }
                if (isExist)
                {
                    [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"你已经收藏过"];
                }
                else
                {
                    FDSCollectedInfo *newCompanyInfo = [[FDSCollectedInfo alloc] init];
                    newCompanyInfo.m_collectType = FDS_COLLECTED_MESSAGE_PRODUCT;
                    newCompanyInfo.m_collectID = _productID;
                    newCompanyInfo.m_collectTitle = self.productInfo.m_proName;
                    if (self.productInfo.m_imagePathArr.count > 0)
                    {
                        newCompanyInfo.m_collectIcon = [self.productInfo.m_imagePathArr objectAtIndex:0];
                    }
                    else
                    {
                        newCompanyInfo.m_collectIcon = @"";
                    }
                    newCompanyInfo.m_collectTime = [[FDSPublicManage sharePublicManager] getNowDate];
                    
                    [[FDSDBManager sharedManager] addCollectedInfoToDB:newCompanyInfo]; //add to DB
                    
                    [self.collectTypeData insertObject:newCompanyInfo atIndex:0];//add to cache
                    [newCompanyInfo release];
                    
                    [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"收藏成功"];
                }
            }
            else
            {
                [[FDSPublicManage sharePublicManager] showInfo:self.view MESSAGE:@"对不起 你没有登录 无法收藏"];
            }
        }
            break;
        case 1: //产品分享
        {
            [ZZSharedManager setSharedParam:self :_productInfo.m_proName :_productInfo.m_sharedLink :(_productInfo.m_imagePathArr.count>0)?[_productInfo.m_imagePathArr objectAtIndex:0]:nil :_productInfo.m_briefInfo];
        }
            break;
        case 2://产品评论
        {
            FDSCommentListViewController *commentListVC = [[FDSCommentListViewController alloc]init];
            commentListVC.commentObjectID = _productID;
            commentListVC.commentObjectType = @"product";//”company”,”product”,”designer”,”successfulcase”
            [self.navigationController pushViewController:commentListVC animated:YES];
            [commentListVC release];
        }
            break;
        default:
            break;
    }
}

#pragma mark - XHADScrollViewDatasource,XHADScrollViewDelegate Methods
- (NSInteger)numberOfPages
{
    NSInteger count = [_productInfo.m_imagePathArr count];
    if (0 == count)
    {
        return 1;  //显示默认图片
    }
    else
    {
        return [_productInfo.m_imagePathArr count];
    }
}

- (UIView *)pageAtIndex:(NSInteger)index
{
    UIImageView *tmpImg = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 140)] autorelease];
    if (0 < [_productInfo.m_imagePathArr count])
    {
        tmpImg.tag = index;
        UIImage *placeholder = [UIImage imageNamed:@"loading_logo_bg"];
        
        NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@",[_productInfo.m_imagePathArr objectAtIndex:index]];
        if (urlStr.length >= 4)
        {
            [urlStr insertString:@"_middle" atIndex:urlStr.length-4];
        }
        [tmpImg setImageURLStr:urlStr placeholder:placeholder];
    }
    else
    {
        tmpImg.image = [UIImage imageNamed:@"loading_logo_bg"];
    }
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont systemFontOfSize:15], NSFontAttributeName,
                                nil];
    CGSize titleSize;
    if(7.0 == IOS_7)
    {
        titleSize = [_productInfo.m_price sizeWithAttributes:attributes];
    }
    else
    {
        titleSize = [_productInfo.m_price sizeWithFont:[UIFont systemFontOfSize:15]];
    }

    UIImageView *priceImg = [[UIImageView alloc] initWithFrame:CGRectMake(300-titleSize.width-10-35, 110, titleSize.width+10+35, 30)];
    priceImg.userInteractionEnabled = YES;
    priceImg.image = [UIImage imageNamed:@"product_show_price"];
    [tmpImg addSubview:priceImg];
    [priceImg release];

    UILabel *tmpLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 10, 30)];
    tmpLab.backgroundColor = [UIColor clearColor];
    tmpLab.textColor = [UIColor whiteColor];
    tmpLab.text = @"¥";
    tmpLab.font=[UIFont systemFontOfSize:15];
    [priceImg addSubview:tmpLab];
    [tmpLab release];
    
    _priceLab = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, titleSize.width+5, 30)];
    _priceLab.backgroundColor = [UIColor clearColor];
    _priceLab.textColor = [UIColor redColor];
    _priceLab.text = _productInfo.m_price;
    _priceLab.font=[UIFont systemFontOfSize:15];
    [priceImg addSubview:_priceLab];
    [_priceLab release];

    return tmpImg;
}

- (void)didClickPage:(XHADScrollView *)csView atIndex:(NSInteger)index
{
    int count = _productInfo.m_imagePathArr.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:_productInfo.m_imagePathArr[i]]; // 图片路径
        [photos addObject:photo];
        [photo release];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = index; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    [browser release];
}

- (void)switchPageDone:(XHADScrollView *)csView atIndex:(NSInteger)index :(UIView*)pageView
{
    
}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
}

/*  立即购买事件  */
- (void)buyBtnPressed
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"卖家尚未开通此功能！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}


@end

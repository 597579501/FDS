//
//  FDSCorporateManageViewController.h
//  FDS
//
//  Created by zhuozhongkeji on 14-1-13.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSUserCenterMessageManager.h"

enum COMPANY_INFO_TYPE
{
    KCOMPANY_TYPE_ME_NONE,
    KCOMPANY_TYPE_ME_OWNED,
    KCOMPANY_TYPE_ME_JOINED,
    KCOMPANY_TYPE_ME_MAX
};

@interface CompanyDetail : NSObject

@property(nonatomic,retain)NSMutableArray          *companyList;
@property(nonatomic,retain)NSString                *companyTitle;

@property(nonatomic,assign)enum COMPANY_INFO_TYPE  companyType;

@end


@interface FDSCorporateManageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,FDSUserCenterMessageInterface>
{
    NSMutableArray  *companyInfoList;
}
@property(nonatomic,strong)UITableView     *companyTable;

@end

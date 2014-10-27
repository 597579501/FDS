//
//  SummaryTableViewCell.h
//  FDS
//
//  Created by zhuozhongkeji on 13-12-20.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSTouchLabel.h"

@interface SummaryTableViewCell : UITableViewCell
{
}
@property(nonatomic ,strong)UILabel        *titleLab;
@property(nonatomic ,strong)UILabel        *summaryLab;
@property(nonatomic ,strong)MSTouchLabel   *touchLab;

@end

//
//  PosBarIListCell.h
//  FDS
//
//  Created by zhuozhong on 14-2-28.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface PosBarListCell : UITableViewCell

@property(nonatomic,retain)EGOImageView       *logoImg;
@property(nonatomic,retain)UILabel            *nameLab;
@property(nonatomic,retain)UILabel            *followedLab;
@property(nonatomic,retain)UILabel            *followedNumLab;
@property(nonatomic,retain)UILabel            *posbarLab;
@property(nonatomic,retain)UILabel            *posbarNumLab;
@property(nonatomic,retain)UILabel            *posBarBriefLab;

@end

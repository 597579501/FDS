//
//  RecoreListCell.h
//  FDS
//
//  Created by zhuozhongkeji on 13-12-23.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
@interface RecoreListCell : UITableViewCell

@property(nonatomic,strong)EGOImageView  *imgView;
@property(nonatomic,strong)UILabel       *contentLab;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier addLine:(BOOL)add;

@end

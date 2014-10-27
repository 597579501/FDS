//
//  SummaryTableViewCell.m
//  FDS
//
//  Created by zhuozhongkeji on 13-12-20.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "SummaryTableViewCell.h"
#import "Constants.h"

@implementation SummaryTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 310, 143)];
        imgView.image = [[UIImage imageNamed:@"round_white_cellbg"]resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
        imgView.userInteractionEnabled = YES;

        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 30, 30)];
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.textColor = kMSTextColor;
        _titleLab.font=[UIFont systemFontOfSize:14];
        [imgView addSubview:_titleLab];
        
        UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(1, 30, 308, 1)];
        tmpView.backgroundColor = kMSLineColor;
        [imgView addSubview:tmpView];
        [tmpView release];
        
        _summaryLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 31, 300, 80)];
        _summaryLab.numberOfLines = 5;
        _summaryLab.backgroundColor = [UIColor clearColor];
        _summaryLab.textColor = kMSTextColor;
        _summaryLab.font=[UIFont systemFontOfSize:13];
        [imgView addSubview:_summaryLab];
        
        tmpView = [[UIView alloc] initWithFrame:CGRectMake(5, 111-30, 300, 30)];
        tmpView.backgroundColor = [UIColor whiteColor];
        tmpView.alpha = 0.5;
        [imgView addSubview:tmpView];
        [tmpView release];

        tmpView = [[UIView alloc] initWithFrame:CGRectMake(1, 111, 308, 1)];
        tmpView.backgroundColor = kMSLineColor;
        [imgView addSubview:tmpView];
        [tmpView release];
        
        tmpView = [[UIView alloc] initWithFrame:CGRectMake(222, 112, 1, 30)];
        tmpView.backgroundColor = kMSLineColor;
        [imgView addSubview:tmpView];
        [tmpView release];

        _touchLab = [[MSTouchLabel alloc]initWithFrame:CGRectMake(233, 112, 60, 30)];
        _touchLab.backgroundColor = [UIColor clearColor];
        _touchLab.textColor = kMSTextColor;
        _touchLab.font=[UIFont systemFontOfSize:14];
        _touchLab.userInteractionEnabled = YES;
        [imgView addSubview:_touchLab];
        
        UIImageView *moreImg = [[UIImageView alloc] initWithFrame:CGRectMake(292, 122, 7, 10)];
        moreImg.image =[UIImage imageNamed:@"cell_more_identify_bg"];
        [imgView addSubview:moreImg];
        [moreImg release];
        
        [self.contentView addSubview:imgView];
        [imgView release];
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc
{
    [_touchLab release];
    [_summaryLab release];
    [_titleLab release];
    [super dealloc];
}
@end

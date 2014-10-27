//
//  PosBarIListCell.m
//  FDS
//
//  Created by zhuozhong on 14-2-28.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "PosBarListCell.h"
#import "Constants.h"

@implementation PosBarListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _logoImg = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        _logoImg.userInteractionEnabled = YES;
        _logoImg.layer.borderWidth = 1;
        _logoImg.layer.cornerRadius = 4.0;
        _logoImg.layer.masksToBounds=YES;
        _logoImg.layer.borderColor = [[UIColor colorWithRed:242.0f/255 green:242.0f/255 blue:242.0f/255 alpha:1.0f] CGColor];
        [self.contentView addSubview:_logoImg];
        [_logoImg release];
        
        _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(70, 2, 230, 30)];
        _nameLab.backgroundColor = [UIColor clearColor];
        _nameLab.textColor = COLOR(69, 69, 69, 1);
        _nameLab.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:_nameLab];
        [_nameLab release];
        
        _followedLab = [[UILabel alloc]initWithFrame:CGRectMake(70, 28, 35, 20)];
        _followedLab.backgroundColor = [UIColor clearColor];
        _followedLab.textColor = kMSTextColor;
        _followedLab.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:_followedLab];
        [_followedLab release];
        
        _followedNumLab = [[UILabel alloc]initWithFrame:CGRectMake(70+35, 28, 45, 20)];
        _followedNumLab.backgroundColor = [UIColor clearColor];
        _followedNumLab.textColor = COLOR(233, 172, 136, 1);
        _followedNumLab.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:_followedNumLab];
        [_followedNumLab release];

        _posbarLab = [[UILabel alloc]initWithFrame:CGRectMake(70+90, 28, 35, 20)];
        _posbarLab.backgroundColor = [UIColor clearColor];
        _posbarLab.textColor = kMSTextColor;
        _posbarLab.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:_posbarLab];
        [_posbarLab release];

        _posbarNumLab = [[UILabel alloc]initWithFrame:CGRectMake(70+125, 28, 85, 20)];
        _posbarNumLab.backgroundColor = [UIColor clearColor];
        _posbarNumLab.textColor = COLOR(233, 172, 136, 1);
        _posbarNumLab.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:_posbarNumLab];
        [_posbarNumLab release];

        _posBarBriefLab = [[UILabel alloc]initWithFrame:CGRectMake(70, 45, 230, 20)];
        _posBarBriefLab.backgroundColor = [UIColor clearColor];
        _posBarBriefLab.textColor = kMSTextColor;
        _posBarBriefLab.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:_posBarBriefLab];
        [_posBarBriefLab release];

        UIImageView* cellImg = [[UIImageView alloc] initWithFrame:CGRectMake(302, 29, 8, 12)];
        [cellImg setImage:[UIImage imageNamed:@"cell_more_identify_bg"]];
        [self.contentView addSubview:cellImg];
        [cellImg release];
        
        UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 69, 320, 0.5)];
        tmpView.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
        [self.contentView addSubview:tmpView];
        [tmpView release];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}

@end

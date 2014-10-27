//
//  CollectedInfoCell.m
//  FDS
//
//  Created by zhuozhong on 14-3-7.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "CollectedInfoCell.h"
#import "Constants.h"

@implementation CollectedInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _iconImage = [[EGOImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_iconImage];
        [_iconImage release];
        
        _contentLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _contentLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_contentLab];
        [_contentLab release];
        
        UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, 320, 0.5)];
        tmpView.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
        [self.contentView addSubview:tmpView];
        [tmpView release];
        
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

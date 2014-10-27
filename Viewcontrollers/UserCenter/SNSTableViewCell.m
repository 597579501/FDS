//
//  SNSTableViewCell.m
//  FDS
//
//  Created by zhuozhongkeji on 14-1-15.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "SNSTableViewCell.h"
#import "Constants.h"

@implementation SNSTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _cellBgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _cellBgView.userInteractionEnabled = YES;
        [self.contentView addSubview:_cellBgView];
        [_cellBgView release];
        
        _headPhotoImg = [[EGOImageView alloc] initWithFrame:CGRectZero];
        [_cellBgView addSubview:_headPhotoImg];
        [_headPhotoImg release];
        
        _nameTextLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _nameTextLab.backgroundColor = [UIColor clearColor];
        _nameTextLab.textColor = kMSTextColor;
        _nameTextLab.font=[UIFont systemFontOfSize:14];
        [_cellBgView addSubview:_nameTextLab];
        [_nameTextLab release];
        
        _timeTextLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _timeTextLab.backgroundColor = [UIColor clearColor];
        _timeTextLab.textColor = COLOR(100, 54, 27, 1);
        _timeTextLab.font=[UIFont systemFontOfSize:12];
        [_cellBgView addSubview:_timeTextLab];
        [_timeTextLab release];

        _contentTextLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _contentTextLab.backgroundColor = [UIColor clearColor];
        _contentTextLab.textColor = kMSTextColor;
        _contentTextLab.font=[UIFont systemFontOfSize:15];
        [_cellBgView addSubview:_contentTextLab];
        [_contentTextLab release];
        
        _contentImgs = [[UIView alloc] initWithFrame:CGRectZero];
        _contentImgs.backgroundColor = [UIColor clearColor];
        [_cellBgView addSubview:_contentImgs];
        [_contentImgs release];

        _operItemsView = [[UIView alloc] initWithFrame:CGRectZero];
        _operItemsView.backgroundColor = [UIColor clearColor];
        [_cellBgView addSubview:_operItemsView];
        [_operItemsView release];

        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  RecoreListCell.m
//  FDS
//
//  Created by zhuozhongkeji on 13-12-23.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "RecoreListCell.h"
#import "Constants.h"

@implementation RecoreListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier addLine:(BOOL)add
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _imgView = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 15, 20, 20)];
        [self.contentView addSubview:_imgView];
        
        _contentLab = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 250, 40)];
        _contentLab.backgroundColor = [UIColor clearColor];
        _contentLab.textColor = kMSTextColor;
        _contentLab.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:_contentLab];
        
        UIImageView* cellImg = [[UIImageView alloc] initWithFrame:CGRectMake(302, 19, 8, 12)];
        [cellImg setImage:[UIImage imageNamed:@"cell_more_identify_bg"]];
        [self.contentView addSubview:cellImg];
        [cellImg release];
        
        if (add) //是否加间隔线
        {
            UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, 320, 0.5)];
            tmpView.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
            [self.contentView addSubview:tmpView];
            [tmpView release];
        }
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
    [_imgView release];
    [_contentLab release];
    [super dealloc];
}
@end

//
//  ProductTableViewCell.m
//  FDS
//
//  Created by zhuozhongkeji on 13-12-27.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "ProductTableViewCell.h"
#import "Constants.h"

@implementation ProductTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _productImg = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 5, 60, 60)];
        [self.contentView addSubview:_productImg];
        [_productImg release];
        
        _productName = [[UILabel alloc]initWithFrame:CGRectMake(80, 15, 220, 20)];
        _productName.backgroundColor = [UIColor clearColor];
        _productName.textColor = [UIColor blackColor];
        _productName.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:_productName];
        [_productName release];
        
        _tmpLab = [[UILabel alloc]initWithFrame:CGRectMake(230, 25, 10, 20)];
        _tmpLab.backgroundColor = [UIColor clearColor];
        _tmpLab.textColor = [UIColor blackColor];
        _tmpLab.text = @"¥";
        _tmpLab.font=[UIFont systemFontOfSize:16];
        [self.contentView addSubview:_tmpLab];
        [_tmpLab release];
        
        _productPrice = [[UILabel alloc]initWithFrame:CGRectMake(240, 25, 60, 20)];
        _productPrice.backgroundColor = [UIColor clearColor];
        _productPrice.textColor = [UIColor redColor];
        _productPrice.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:_productPrice];
        [_productPrice release];

        /* 浏览量 */
        _productStyle = [[UILabel alloc]initWithFrame:CGRectMake(80, 35, 150, 20)];
        _productStyle.backgroundColor = [UIColor clearColor];
        _productStyle.textColor = COLOR(69, 69, 69, 1);
        _productStyle.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:_productStyle];
        [_productStyle release];
        
        UIImageView* cellImg = [[UIImageView alloc] initWithFrame:CGRectMake(302, 29, 8, 12)];
        [cellImg setImage:[UIImage imageNamed:@"cell_more_identify_bg"]];
        [self.contentView addSubview:cellImg];
        [cellImg release];
        
//        UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 69, 320, 0.5)];
//        tmpView.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
//        [self.contentView addSubview:tmpView];
//        [tmpView release];
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

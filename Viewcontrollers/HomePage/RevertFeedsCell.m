//
//  RevertFeedsCell.m
//  FDS
//
//  Created by zhuozhong on 14-2-26.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "RevertFeedsCell.h"
#import "Constants.h"
#import "FDSUserManager.h"

@implementation RevertFeedsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _revertHeadImg = [EGOImageButton buttonWithType:UIButtonTypeCustom];
        _revertHeadImg.frame = CGRectMake(35, 5, 50, 50);
        _revertHeadImg.adjustsImageWhenHighlighted = NO;
        [_revertHeadImg addTarget:self action:@selector(btnSelPressed) forControlEvents:UIControlEventTouchUpInside];
        _revertHeadImg.layer.borderWidth = 1;
        _revertHeadImg.layer.cornerRadius = 4.0;
        _revertHeadImg.layer.masksToBounds=YES;
        _revertHeadImg.layer.borderColor = [[UIColor colorWithRed:242.0f/255 green:242.0f/255 blue:242.0f/255 alpha:1.0f] CGColor];
        [self.contentView addSubview:_revertHeadImg];
        
        /*  回复人名字  */
        _revertNameLab = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, 100, 20)];
        _revertNameLab.backgroundColor = [UIColor clearColor];
        _revertNameLab.textColor = COLOR(55, 123, 198, 1);
        _revertNameLab.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:_revertNameLab];
        [_revertNameLab release];

        /*  回复时间  */
        _revertTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(90, 21, 100, 15)];
        _revertTimeLab.backgroundColor = [UIColor clearColor];
        _revertTimeLab.textColor = kMSTextColor;
        _revertTimeLab.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:_revertTimeLab];
        [_revertTimeLab release];
        
        _revertContenView = [[CommentView alloc]initWithFrame:CGRectZero];
        _revertContenView.backgroundColor = [UIColor clearColor];
        _revertContenView.fontSize = 14.0f;
        _revertContenView.maxlength = 210;
        _revertContenView.facialSizeWidth = 18;
        _revertContenView.facialSizeHeight = 18;
        _revertContenView.textlineHeight = 20;
        [self.contentView addSubview:_revertContenView];
        [_revertContenView release];
        
        /*    删除   */
        _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _delBtn.frame = CGRectZero;
        [_delBtn addTarget:self action:@selector(btnDelPreesed) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_delBtn];
        
        _delImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _delImg.image = [UIImage imageNamed:@"delete_revert_icon"];
        _delImg.backgroundColor = [UIColor clearColor];
        [_delBtn addSubview:_delImg];
        [_delImg release];

        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)btnDelPreesed
{
    if ([self.delegate respondsToSelector:@selector(deleteRevertWithIndex:)])
    {
        [self.delegate deleteRevertWithIndex:_indexRow];
    }
}

- (void)btnSelPressed
{
    if ([self.delegate respondsToSelector:@selector(didSelectRevertImgWithIndex:)])
    {
        [self.delegate didSelectRevertImgWithIndex:_indexRow];
    }
}

- (void)loadRevertCellData:(FDSRevert*)revert
{
    _delBtn.frame = CGRectZero;
    _delImg.frame = CGRectZero;

    if ([revert.m_senderID isEqualToString:[[FDSUserManager sharedManager] getNowUser].m_userID])
    {
        _delBtn.frame = CGRectMake(90+100+10, 5, 50, 30);
        _delImg.frame = CGRectMake(12, 3, 25, 25);
    }

//    _revertHeadImg.placeholderImage = [UIImage imageNamed:@"headphoto_s"];
//    [_revertHeadImg setImageURL:[NSURL URLWithString:revert.m_senderIcon]];
    _revertHeadImg.placeholderImage = [UIImage imageNamed:@"headphoto_s"];
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@",revert.m_senderIcon];
    if (urlStr.length >= 4)
    {
        [urlStr insertString:@"_middle" atIndex:urlStr.length-4];
    }
    _revertHeadImg.imageURL = [NSURL URLWithString:urlStr];
    
    _revertNameLab.text = revert.m_senderName;
    
    /*  时间戳转时间  */
    NSTimeInterval timeValue = [revert.m_sendTime doubleValue];
    NSDate *confromTime = [NSDate dateWithTimeIntervalSince1970:timeValue/1000];
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"MM-dd HH:mm:ss"];
    _revertTimeLab.text = [formatter stringFromDate:confromTime];
    
    CELL_H = 37.0f;
    if (revert.m_content.length > 0)
    {
        CGFloat viewheight = [_revertContenView getcurrentViewHeight:revert.m_content];
        _revertContenView.frame = CGRectMake(90, CELL_H, 215, viewheight);
        [_revertContenView showMessage:revert.m_content];
        CELL_H += viewheight+5;
    }
    else
    {
        CELL_H+= 20+5;
    }
}

- (CGFloat)getCurrentCellHeight
{
    return CELL_H+5;
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

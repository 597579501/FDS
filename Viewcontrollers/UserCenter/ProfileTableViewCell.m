//
//  ProfileTableViewCell.m
//  FDS
//
//  Created by zhuozhongkeji on 14-1-8.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "ProfileTableViewCell.h"
#import "Constants.h"

@implementation ProfileTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellIndefy:(BOOL)isAdd
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _logoImg = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        [self.contentView addSubview:_logoImg];
        [_logoImg release];

        _titleTextLab = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 230, 40)];
        _titleTextLab.backgroundColor = [UIColor clearColor];
        _titleTextLab.textColor = kMSTextColor;
        _titleTextLab.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleTextLab];
        [_titleTextLab release];
        
        if (isAdd)
        {
            _detailCellImg = [[UIImageView alloc] initWithFrame:CGRectMake(280+kMSCellOffsetsWidth, 19, 8, 12)];
            [_detailCellImg setImage:[UIImage imageNamed:@"cell_more_identify_bg"]];
            [self.contentView addSubview:_detailCellImg];
            [_detailCellImg release];
        }
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}

//-(void)loadCellWithData:(NSString*)data
//{
//    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                _titleTextLab.font, NSFontAttributeName,
//                                nil];
//    CGSize titleSize;
//    if(IOS_7)
//    {
//        titleSize = [data sizeWithAttributes:attributes];
//    }
//    else
//    {
//        titleSize = [data sizeWithFont:_titleTextLab.font];
//    }
//    float nameWidth = 100.f;
//    if (titleSize.width < nameWidth)
//    {
//        nameWidth = titleSize.width;
//    }
//    _titleTextLab.frame = CGRectMake(50, 5, nameWidth, 40);
//    _titleTextLab.text = data;
//    if (_numflag)
//    {
//        _titleNumLab.frame = CGRectMake(50+nameWidth+2, 5, 50, 40);
//    }
//    else
//    {
//        _appendImg.frame = CGRectMake(50+nameWidth+2, 10, 30, 30);
//    }
//}

-(void)dealloc
{
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end

//*************设置CELL*******************
@implementation SettingTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _logoImg = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 13, 24, 24)];
        [self.contentView addSubview:_logoImg];
        [_logoImg release];

        _titleTextLab = [[UILabel alloc]initWithFrame:CGRectMake(50, 4, 200, 40)];
        _titleTextLab.backgroundColor = [UIColor clearColor];
        _titleTextLab.textColor = kMSTextColor;
        _titleTextLab.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleTextLab];
        [_titleTextLab release];
        
        UIImageView *detailCellImg = [[UIImageView alloc] initWithFrame:CGRectMake(280+kMSCellOffsetsWidth, 19, 8, 12)];
        [detailCellImg setImage:[UIImage imageNamed:@"cell_more_identify_bg"]];
        [self.contentView addSubview:detailCellImg];
        [detailCellImg release];
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

@end

//*************新消息提醒CELL*******************
@implementation NewMsgSetingTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _titleTextLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 180, 40)];
        _titleTextLab.backgroundColor = [UIColor clearColor];
        _titleTextLab.textColor = kMSTextColor;
        _titleTextLab.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleTextLab];
        [_titleTextLab release];
        
        _onOffSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(208+2*kMSCellOffsetsWidth, 13, 70, 24)];
        [_onOffSwitch addTarget:self action:@selector(clickSwitch) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_onOffSwitch];
        [_onOffSwitch release];
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)clickSwitch
{
    if ([self.delegate respondsToSelector:@selector(notifyChageSetingWithTag::)])
    {
        [self.delegate notifyChageSetingWithTag:_onOffSwitch.on :_currentIndex];
    }
}

-(void)dealloc
{
    [super dealloc];
}

@end


//*************解绑定CELL*******************
@implementation UnBindTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        [self.contentView addSubview:_logoImg];
        [_logoImg release];
        
        _titleTextLab = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 100, 40)];
        _titleTextLab.backgroundColor = [UIColor clearColor];
        _titleTextLab.textColor = kMSTextColor;
        _titleTextLab.font=[UIFont systemFontOfSize:15];
        
        [self.contentView addSubview:_titleTextLab];
        [_titleTextLab release];
        
        _cellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cellBtn.adjustsImageWhenHighlighted = NO;
        _cellBtn.frame = CGRectMake(220+kMSCellOffsetsWidth,10,70,30);
        [_cellBtn addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
        _cellBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_cellBtn];
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}


- (void)buttonClicked
{
    if ([self.delegate respondsToSelector:@selector(notifyUnBindWithTag:)])
    {
        [self.delegate notifyUnBindWithTag:_unBindTag];
    }
}

-(void)dealloc
{
    [super dealloc];
}

@end



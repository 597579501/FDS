//
//  MsgCenterTableViewCell.m
//  FDS
//
//  Created by zhuozhong on 14-2-7.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "MsgCenterTableViewCell.h"
#import "Constants.h"
#import "FDSMessageCenter.h"

@implementation MsgCenterTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _headImg = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
        _headImg.userInteractionEnabled = YES;
        _headImg.layer.borderWidth = 1;
        _headImg.layer.cornerRadius = 4.0;
        _headImg.layer.masksToBounds=YES;
        _headImg.layer.borderColor = [[UIColor colorWithRed:242.0f/255 green:242.0f/255 blue:242.0f/255 alpha:1.0f] CGColor];
        
        _unReadImg = [[UIImageView alloc]initWithFrame:CGRectMake(47, 2, 16, 16)];
        _unReadImg.image = [UIImage imageNamed:@"unread_img_bg"];
        _unReadImg.userInteractionEnabled = YES;
        
        _unReadNum = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 16, 16)];
        _unReadNum.backgroundColor = [UIColor clearColor];
        _unReadNum.textColor = [UIColor whiteColor];
        _unReadNum.textAlignment = NSTextAlignmentCenter;
        _unReadNum.font=[UIFont systemFontOfSize:10];
        [_unReadImg addSubview:_unReadNum];
        [_unReadNum release];
        
        _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(70, 0, 165, 30)];
        _nameLab.backgroundColor = [UIColor clearColor];
        _nameLab.textColor = [UIColor blackColor];
        _nameLab.font=[UIFont systemFontOfSize:16];
        
        _timeLab = [[UILabel alloc]initWithFrame:CGRectMake(240, 0, 80, 20)];
        _timeLab.backgroundColor = [UIColor clearColor];
        _timeLab.textColor = COLOR(144, 144, 144, 1);
        _timeLab.font=[UIFont systemFontOfSize:13];

        _contentLab = [[MessageCenterView alloc]initWithFrame:CGRectMake(70, 30, 240, 30)];
        _contentLab.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:_headImg];
        [_headImg release];
        
        [self.contentView addSubview:_unReadImg];
        [_unReadImg release];
        
        [self.contentView addSubview:_nameLab];
        [_nameLab release];
        
        [self.contentView addSubview:_timeLab];
        [_timeLab release];

        [self.contentView addSubview:_contentLab];
        [_contentLab release];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, 320, 0.5)];
        lineView.backgroundColor = COLOR(204, 204, 204, 1);
        [self.contentView addSubview:lineView];
        [lineView release];
        
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

- (void)dealloc
{
    [super dealloc];
}


@end






/* 好友搜索结果cell */
@implementation MsgSystemTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _headImg = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        _headImg.layer.borderWidth = 1;
        _headImg.layer.cornerRadius = 4.0;
        _headImg.layer.masksToBounds=YES;
        _headImg.layer.borderColor = [[UIColor colorWithRed:242.0f/255 green:242.0f/255 blue:242.0f/255 alpha:1.0f] CGColor];
        [self.contentView addSubview:_headImg];
        [_headImg release];
        
        _nameLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _nameLab.backgroundColor = [UIColor clearColor];
        _nameLab.textColor = COLOR(61, 61, 61, 1);
        _nameLab.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:_nameLab];
        [_nameLab release];
        
        _timeLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _timeLab.backgroundColor = [UIColor clearColor];
        _timeLab.textColor = kMSTextColor;
        _timeLab.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:_timeLab];
        [_timeLab release];
        
        _messageLab = [[UILabel alloc]initWithFrame:CGRectMake(80, 44, 150, 25)];
        _messageLab.backgroundColor = [UIColor clearColor];
        _messageLab.textColor = kMSTextColor;
        _messageLab.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:_messageLab];
        [_messageLab release];
        
        _resultLab = [[UILabel alloc]initWithFrame:CGRectMake(185, 23, 120, 35)];
        _resultLab.backgroundColor = [UIColor clearColor];
        _resultLab.textColor = kMSTextColor;
        _resultLab.textAlignment = NSTextAlignmentRight;
        _resultLab.font=[UIFont systemFontOfSize:16];
        [self.contentView addSubview:_resultLab];
        [_resultLab release];
        
        _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreeBtn.frame = CGRectMake(250, 10, 60, 25);
        [_agreeBtn setBackgroundImage:[UIImage imageNamed:@"system_agree_normal_bg"] forState:UIControlStateNormal];
        [_agreeBtn setBackgroundImage:[UIImage imageNamed:@"system_agree_hl_bg"] forState:UIControlStateHighlighted];
        [_agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
        [_agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_agreeBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        _agreeBtn.tag = 0x01;
        [_agreeBtn addTarget:self action:@selector(handleFriendReq:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_agreeBtn];

        _rejectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rejectBtn.frame = CGRectMake(250, 45, 60, 25);
        [_rejectBtn setBackgroundImage:[UIImage imageNamed:@"system_reject_normal_bg"] forState:UIControlStateNormal];
        [_rejectBtn setBackgroundImage:[UIImage imageNamed:@"system_reject_hl_bg"] forState:UIControlStateHighlighted];
        [_rejectBtn setTitle:@"拒绝" forState:UIControlStateNormal];
        [_rejectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_rejectBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        _rejectBtn.tag = 0x02;
        [_rejectBtn addTarget:self action:@selector(handleFriendReq:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_rejectBtn];

        //加间隔线
        UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 79, 320, 0.5)];
        tmpView.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
        [self.contentView addSubview:tmpView];
        [tmpView release];
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)loadCellWithData:(FDSMessageCenter*)data withDelegate:(id<OperFriendDelegate>)systemDelegate withCellTag:(NSInteger)tag
{
    if (!data)
    {
        return;
    }
    _indexTag = tag;
    _delegate = systemDelegate;
    
    _headImg.placeholderImage = [UIImage imageNamed:@"headphoto_s"];
    _headImg.imageURL = [NSURL URLWithString:data.m_icon];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                _nameLab.font, NSFontAttributeName,
                                nil];
    CGSize titleSize;
    if(IOS_7)
    {
        titleSize = [data.m_senderName sizeWithAttributes:attributes];
    }
    else
    {
        titleSize = [data.m_senderName sizeWithFont:_nameLab.font];
    }
    float nameWidth = 90.f;
    if (titleSize.width < nameWidth)
    {
        nameWidth = titleSize.width;
    }
    _nameLab.frame = CGRectMake(80, 6, nameWidth, 30);
    _nameLab.text = data.m_senderName;
    
    _timeLab.frame = CGRectMake(80+nameWidth+5, 6, 90, 30);
//    _timeLab.text = data.m_sendTime;
    NSTimeInterval timeValue = [data.m_sendTime doubleValue];
    NSDate *confromTime = [NSDate dateWithTimeIntervalSince1970:timeValue/1000];
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    _timeLab.text = [formatter stringFromDate:confromTime];

    
    if (FDSMessageCenterMessage_Type_ADD_FRIEND_SUC_RESULT != data.m_messageType)
    {
        _messageLab.hidden = NO;
        _messageLab.text = data.m_param1;
    }
    else
    {
        _messageLab.hidden = YES;
    }
    
    if(FDSMessageCenterMessage_Type_ADD_FRIEND_REQUEST == data.m_messageType)
    {
        _resultLab.hidden = YES;
        _rejectBtn.hidden = NO;
        _agreeBtn.hidden = NO;
    }
    else if(FDSMessageCenterMessage_Type_ADD_FRIEND_AGREE == data.m_messageType)
    {
        _resultLab.hidden = NO;
        _resultLab.text = @"已同意";
        
        _rejectBtn.hidden = YES;
        _agreeBtn.hidden = YES;
    }
    else if(FDSMessageCenterMessage_Type_ADD_FRIEND_REJECT == data.m_messageType)
    {
        _resultLab.hidden = NO;
        _resultLab.text = @"已拒绝";
        
        _rejectBtn.hidden = YES;
        _agreeBtn.hidden = YES;
    }
    else if(FDSMessageCenterMessage_Type_ADD_FRIEND_SUC_RESULT == data.m_messageType)
    {
        _resultLab.hidden = NO;
        _resultLab.text = @"已添加你为好友";
        
        _rejectBtn.hidden = YES;
        _agreeBtn.hidden = YES;
    }
    else// (data.m_messageClass == FDSMessageCenterMessage_Class_SYSTEM)
    {
        _resultLab.hidden = YES;
        _rejectBtn.hidden = YES;
        _agreeBtn.hidden = YES;
    }
}


- (void)handleFriendReq:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didOperWithTag::)])
    {
        [self.delegate didOperWithTag:[sender tag] :_indexTag];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)dealloc
{
    [super dealloc];
}

@end






@implementation ContactTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 30)];
        _nameLab.backgroundColor = [UIColor clearColor];
        _nameLab.textColor = COLOR(61, 61, 61, 1);
        _nameLab.font=[UIFont italicSystemFontOfSize:15];
        [self.contentView addSubview:_nameLab];
        [_nameLab release];
        
        _operBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _operBtn.frame = CGRectMake(240, 5, 70, 40);
        [_operBtn setBackgroundImage:[UIImage imageNamed:@"com_post_normal_bg"] forState:UIControlStateNormal];
        [_operBtn setBackgroundImage:[UIImage imageNamed:@"com_post_hl_bg"] forState:UIControlStateHighlighted];
        [_operBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_operBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_operBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_operBtn addTarget:self action:@selector(handleBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_operBtn];
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, 320, 0.5)];
        lineView.backgroundColor = COLOR(204, 204, 204, 1);
        [self.contentView addSubview:lineView];
        [lineView release];
        
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

- (void)handleBtnPressed
{
    if ([self.delegate respondsToSelector:@selector(didUserPressed::)])
    {
        [self.delegate didUserPressed:_section :_row];
    }
}

- (void)dealloc
{
    [super dealloc];
}

@end



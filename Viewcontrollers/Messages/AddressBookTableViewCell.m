//
//  AddressBookTableViewCell.m
//  FDS
//
//  Created by zhuozhong on 14-2-17.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "AddressBookTableViewCell.h"
#import "Constants.h"

@implementation AddressBookTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier addCellIndentify:(BOOL)add
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _headImg = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
        _headImg.layer.borderWidth = 1;
        _headImg.layer.cornerRadius = 4.0;
        _headImg.layer.masksToBounds=YES;
        _headImg.layer.borderColor = [[UIColor colorWithRed:242.0f/255 green:242.0f/255 blue:242.0f/255 alpha:1.0f] CGColor];
        [self.contentView addSubview:_headImg];
        [_headImg release];
        
        _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 200, 40)];
        _nameLab.backgroundColor = [UIColor clearColor];
        _nameLab.textColor = kMSTextColor;
        _nameLab.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:_nameLab];
        [_nameLab release];
        
        if (add)
        {
            _cellImg = [[UIImageView alloc] initWithFrame:CGRectMake(292-2*KFDSTextOffset, 24, 8, 12)];
            [_cellImg setImage:[UIImage imageNamed:@"cell_more_identify_bg"]];
            [self.contentView addSubview:_cellImg];
            [_cellImg release];
        }
        
        //加间隔线
        UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, 320, 0.5)];
        tmpView.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
        [self.contentView addSubview:tmpView];
        [tmpView release];
        
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
    [super dealloc];
}

@end





/* 好友搜索结果cell */
@implementation SearchResultTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _headImg = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
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
        
        _sexImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_sexImg];
        [_sexImg release];

        _companyLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _companyLab.backgroundColor = [UIColor clearColor];
        _companyLab.textColor = kMSTextColor;
        _companyLab.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:_companyLab];
        [_companyLab release];

        _jobLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _jobLab.backgroundColor = [UIColor clearColor];
        _jobLab.textColor = kMSTextColor;
        _jobLab.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:_jobLab];
        [_jobLab release];

        //加间隔线
        UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, 320, 0.5)];
        tmpView.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
        [self.contentView addSubview:tmpView];
        [tmpView release];
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)loadCellWithData:(FDSUser*)data
{
    if (!data)
    {
        return;
    }
    _headImg.placeholderImage = [UIImage imageNamed:@"headphoto_s"];
    _headImg.imageURL = [NSURL URLWithString:data.m_icon];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                _nameLab.font, NSFontAttributeName,
                                nil];
    CGSize titleSize;
    if(IOS_7)
    {
        titleSize = [data.m_name sizeWithAttributes:attributes];
    }
    else
    {
        titleSize = [data.m_name sizeWithFont:_nameLab.font];
    }
    float nameWidth = 100.f;
    if (titleSize.width < nameWidth)
    {
        nameWidth = titleSize.width;
    }
    _nameLab.frame = CGRectMake(70, 5, nameWidth, 30);
    _nameLab.text = data.m_name;
    
    _sexImg.frame = CGRectMake(70+nameWidth+5, 5, 18, 18);
    _sexImg.hidden = NO;
    if ([data.m_sex isEqualToString:@"女"])
    {
        _sexImg.image = [UIImage imageNamed:@"profile_sexw_bg"];
    }
    else if ([data.m_sex isEqualToString:@"男"])
    {
        _sexImg.image = [UIImage imageNamed:@"profile_sexm_bg"];
    }
    else
    {
        _sexImg.hidden = YES;
    }
    
    // company
    if (![data.m_company isEqualToString:@""])
    {
        _companyLab.hidden = NO;
        attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                      _companyLab.font, NSFontAttributeName,
                      nil];
        if(IOS_7)
        {
            titleSize = [data.m_company sizeWithAttributes:attributes];
        }
        else
        {
            titleSize = [data.m_company sizeWithFont:_companyLab.font];
        }
        nameWidth = 150.0f;
        if (titleSize.width < nameWidth)
        {
            nameWidth = titleSize.width;
        }
        _companyLab.frame = CGRectMake(70, 35, nameWidth, 25);
        _companyLab.text = data.m_company;
        
        _jobLab.frame = CGRectMake(70+nameWidth+10, 35, 310-(70+nameWidth+10), 25);
        _jobLab.text = data.m_job;
    }
    else
    {
        _companyLab.hidden = YES;
        _jobLab.frame = CGRectMake(70, 35, 240, 25);
        _jobLab.text = data.m_job;
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


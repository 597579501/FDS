//
//  SchemeTableViewCell.m
//  FDS
//
//  Created by zhuozhongkeji on 14-1-6.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "SchemeTableViewCell.h"
#import "Constants.h"
#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@implementation SchemeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 310, 171)];
        bgImg.image = [[UIImage imageNamed:@"round_white_cellbg"]resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
        bgImg.userInteractionEnabled = YES;
        bgImg.layer.borderWidth = 1;
        bgImg.layer.cornerRadius = 6.0;
        bgImg.layer.masksToBounds=YES;
        bgImg.layer.borderColor =[COLOR(188, 188, 188, 1) CGColor];

        _schemeLogoImg = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, 310, 140)];
        [bgImg addSubview:_schemeLogoImg];
        [_schemeLogoImg release];
        
        UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 140, 310, 1)];
        tmpView.backgroundColor = COLOR(188, 188, 188, 1);
        [bgImg addSubview:tmpView];
        [tmpView release];

        _schemeNameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 141, 238, 30)];
        _schemeNameLab.backgroundColor = [UIColor clearColor];
        _schemeNameLab.textAlignment = NSTextAlignmentCenter;
        _schemeNameLab.textColor = kMSTextColor;
        _schemeNameLab.font=[UIFont systemFontOfSize:14];
        [bgImg addSubview:_schemeNameLab];
        [_schemeNameLab release];
        
        tmpView = [[UIView alloc] initWithFrame:CGRectMake(238, 141, 1, 30)];
        tmpView.backgroundColor = COLOR(188, 188, 188, 1);
        [bgImg addSubview:tmpView];
        [tmpView release];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.adjustsImageWhenHighlighted = NO;
        btn.frame = CGRectMake(239,141,71,30);
        [btn setImageEdgeInsets:UIEdgeInsetsMake(1, 5, 1, 5)];
        [btn addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"查看详情" forState:UIControlStateNormal];
        [btn setTitleColor:kMSTextColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.titleLabel.text = @"查看详情";
        [bgImg addSubview:btn];
        
        [self.contentView addSubview:bgImg];
        [bgImg release];
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)buttonClicked
{
    if ([_delegate respondsToSelector:@selector(handleDetailWithIndex:)])
    {
        [_delegate handleDetailWithIndex:_currentIndex];
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

@implementation DesignerTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _designerImg = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
        _designerImg.userInteractionEnabled = YES;
        _designerImg.layer.borderWidth = 2;
        _designerImg.layer.cornerRadius = 4.0;
        _designerImg.layer.masksToBounds=YES;
        _designerImg.layer.borderColor =[[UIColor whiteColor] CGColor];
        
        _designerNameLab = [[UILabel alloc]initWithFrame:CGRectMake(80, 5, 220, 30)];
        _designerNameLab.backgroundColor = [UIColor clearColor];
        _designerNameLab.textColor = kMSTextColor;
        _designerNameLab.font=[UIFont systemFontOfSize:15];
        
        _professionLab = [[UILabel alloc]initWithFrame:CGRectMake(80, 35, 220, 20)];
        _professionLab.backgroundColor = [UIColor clearColor];
        _professionLab.textColor = kMSTextColor;
        _professionLab.font=[UIFont systemFontOfSize:14];
        
        [self.contentView addSubview:_designerImg];
        [_designerImg release];
        
        [self.contentView addSubview:_designerNameLab];
        [_designerNameLab release];
        
        [self.contentView addSubview:_professionLab];
        [_professionLab release];

        UIImageView* cellImg = [[UIImageView alloc] initWithFrame:CGRectMake(302, 24, 8, 12)];
        [cellImg setImage:[UIImage imageNamed:@"cell_more_identify_bg"]];
        [self.contentView addSubview:cellImg];
        [cellImg release];
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

@end

@implementation DesignerDetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellIndefy:(UIDesignerDetailCellType)type
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _detailKeyLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 40)];
        _detailKeyLab.backgroundColor = [UIColor clearColor];
        _detailKeyLab.textColor = kMSTextColor;
        _detailKeyLab.font=[UIFont systemFontOfSize:15];
        
        _detailValueLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, 180, 40)];
        _detailValueLab.backgroundColor = [UIColor clearColor];
        _detailValueLab.textColor = kMSTextColor;
        _detailValueLab.font=[UIFont systemFontOfSize:14];
        
        [self.contentView addSubview:_detailKeyLab];
        [_detailKeyLab release];
        
        [self.contentView addSubview:_detailValueLab];
        [_detailValueLab release];
        
        if (UIDesignerDetailIndicator == type)
        {
            _detailCellImg = [[UIImageView alloc] initWithFrame:CGRectMake(280+kMSCellOffsetsWidth, 19, 8, 12)];
            [_detailCellImg setImage:[UIImage imageNamed:@"cell_more_identify_bg"]];
            [self.contentView addSubview:_detailCellImg];
            [_detailCellImg release];
        }
        else if(UIDesignerDetailImg == type)
        {
            _appendImg = [[UIImageView alloc] initWithFrame:CGRectZero];
            [self.contentView addSubview:_appendImg];
            [_appendImg release];

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

-(void)loadCellWithData:(NSString*)data
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                _detailValueLab.font, NSFontAttributeName,
                                nil];
    CGSize titleSize;
    if(IOS_7)
    {
        titleSize = [data sizeWithAttributes:attributes];
    }
    else
    {
        titleSize = [data sizeWithFont:_detailValueLab.font];
    }
    float nameWidth = 100.f;
    if (titleSize.width < nameWidth)
    {
        nameWidth = titleSize.width;
    }
    _detailValueLab.frame = CGRectMake(100, 5, nameWidth, 40);
    _detailValueLab.text = data;
    
    _appendImg.frame = CGRectMake(100+nameWidth+2, 17, 15, 15);
}

-(void)dealloc
{
    [super dealloc];
}

@end

//************头像通用**************
@interface CommonHeaderTableViewCell()
{
    BOOL  isAppend;
    BOOL  isPlatform;
}
@end

@implementation CommonHeaderTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isAppend:(BOOL)append isPlat:(BOOL)plat
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        isAppend = append;  isPlatform = plat;
        _bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 100)];
        _bgImg.image = [[UIImage imageNamed:@"round_white_cellbg"]resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
        _bgImg.userInteractionEnabled = YES;
        [self.contentView addSubview:_bgImg];
        [_bgImg release];

        _headPhotoImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _headPhotoImg.layer.borderWidth = 2;
        _headPhotoImg.layer.cornerRadius = 4.0;
        _headPhotoImg.layer.masksToBounds=YES;
        _headPhotoImg.userInteractionEnabled = YES;
        [_headPhotoImg addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]autorelease]];
        _headPhotoImg.layer.borderColor =[[UIColor colorWithRed:242.0f/255 green:242.0f/255 blue:242.0f/255 alpha:1.0f] CGColor];
        [_bgImg addSubview:_headPhotoImg];
        [_headPhotoImg release];
        
        _nameLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _nameLab.backgroundColor = [UIColor clearColor];
        _nameLab.textColor = kMSTextColor;
        _nameLab.font=[UIFont systemFontOfSize:15];
        [_bgImg addSubview:_nameLab];
        [_nameLab release];
        
        _sexImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_bgImg addSubview:_sexImg];
        [_sexImg release];
        
        _detailLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _detailLab.backgroundColor = [UIColor clearColor];
        _detailLab.textColor = kMSTextColor;
        _detailLab.font=[UIFont systemFontOfSize:14];
        [_bgImg addSubview:_detailLab];
        [_detailLab release];

        _detailImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_bgImg addSubview:_detailImg];
        [_detailImg release];
        
        UIImageView* cellImg = [[UIImageView alloc] initWithFrame:CGRectMake(280, 44, 8, 12)];
        [cellImg setImage:[UIImage imageNamed:@"cell_more_identify_bg"]];
        [_bgImg addSubview:cellImg];
        [cellImg release];

        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)loadImgView:(NSString*)imageURL
{
    urlStr = imageURL;
    UIImage *placeholder = [UIImage imageNamed:@"headphoto_s"];
    [_headPhotoImg setImageURLStr:imageURL placeholder:placeholder];
}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
    
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.url = [NSURL URLWithString:urlStr]; // 图片路径
    photo.srcImageView = _headPhotoImg; // 来源于哪个UIImageView
    [photos addObject:photo];
    [photo release];
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    [browser release];
}

-(void)loadCellFrame:(NSString*)withName withDetail:(NSString*)detail
{
    _headPhotoImg.frame = CGRectMake(10, 10, 80, 80);
    
    //
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                _nameLab.font, NSFontAttributeName,
                                nil];
    CGSize titleSize;
    if(IOS_7)
    {
        titleSize = [withName sizeWithAttributes:attributes];
    }
    else
    {
        titleSize = [withName sizeWithFont:_nameLab.font];
    }
    float nameWidth = 150.f;
    if (titleSize.width < nameWidth)
    {
        nameWidth = titleSize.width;
    }
    _nameLab.frame = CGRectMake(95, 10, nameWidth, 35);
    _nameLab.text = withName;
    
    //
    if (isAppend)
    {
        _sexImg.frame = CGRectMake(95+nameWidth+5, 18, 18, 18);
    }
    else
    {
        _sexImg.frame = CGRectZero;
        _nameLab.frame = CGRectMake(95, 10, 180, 35);
    }
    //
    attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                  _detailLab.font, NSFontAttributeName,
                  nil];
    if(IOS_7)
    {
        titleSize = [detail sizeWithAttributes:attributes];
    }
    else
    {
        titleSize = [detail sizeWithFont:_detailLab.font];
    }
    nameWidth = 150.f;
    if (titleSize.width < nameWidth)
    {
        nameWidth = titleSize.width;
    }
    _detailLab.frame = CGRectMake(95, 55, nameWidth, 30);
    _detailLab.text = detail;
    
    //
    if (isPlatform)
    {
        _detailImg.frame = CGRectMake(95+nameWidth+5, 62, 18, 18);
    }
    else
    {
        _detailImg.frame = CGRectZero;
        _detailLab.frame = CGRectMake(95, 55, 180, 30);
    }
}

- (void)dealloc
{
    [super dealloc];
}

@end

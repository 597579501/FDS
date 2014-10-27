//
//  BarPostListCell.m
//  FDS
//
//  Created by zhuozhong on 14-3-4.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "BarPostListCell.h"
#import "Constants.h"
#import "FDSPublicManage.h"
#import "FDSUserManager.h"
#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@implementation BarPostListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        /*  cell背景 */
        _postCellImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _postCellImg.userInteractionEnabled = YES;
        [self.contentView addSubview:_postCellImg];
        [_postCellImg release];
        
        /*  发帖时间  */
        _publishTimeLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _publishTimeLab.backgroundColor = [UIColor clearColor];
        _publishTimeLab.textColor = [UIColor blackColor];
        _publishTimeLab.font=[UIFont systemFontOfSize:17];
        [_postCellImg addSubview:_publishTimeLab];
        [_publishTimeLab release];
        
        /*  发帖标题  */
        _titleLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.font=[UIFont systemFontOfSize:17];
        [_postCellImg addSubview:_titleLab];
        [_titleLab release];

        _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _delBtn.frame = CGRectZero;
        [_delBtn addTarget:self action:@selector(didDeleteWithClick) forControlEvents:UIControlEventTouchUpInside];
        [_postCellImg addSubview:_delBtn];
        
        _delImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _delImg.image = [UIImage imageNamed:@"delete_comment_icon"];
        _delImg.backgroundColor = [UIColor clearColor];
        [_delBtn addSubview:_delImg];
        [_delImg release];

        /*  发帖图片内容  */
        _imgViews = [[UIView alloc] initWithFrame:CGRectZero];
        _imgViews.backgroundColor = [UIColor clearColor];
        [_postCellImg addSubview:_imgViews];
        [_imgViews release];

        /*  发帖内容  */
        _postContentView = [[CommentView alloc]initWithFrame:CGRectZero];
        _postContentView.backgroundColor = [UIColor clearColor];
        _postContentView.fontSize = 14.0f;
        _postContentView.maxlength = 310;
        _postContentView.facialSizeWidth = 18;
        _postContentView.facialSizeHeight = 18;
        _postContentView.textlineHeight = 20;
        [_postCellImg addSubview:_postContentView];
        [_postContentView release];
        
        /*  分隔线  */
        _postLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _postLineView.backgroundColor = COLOR(211, 211, 211, 1);
        [_postCellImg addSubview:_postLineView];
        [_postLineView release];
    
        
        /*  发帖人头像  */
        _headImg = [EGOImageButton buttonWithType:UIButtonTypeCustom];
        _headImg.adjustsImageWhenHighlighted = NO;
        [_headImg addTarget:self action:@selector(postImgPressed) forControlEvents:UIControlEventTouchUpInside];
        _headImg.frame = CGRectZero;
        _headImg.layer.borderWidth = 1;
        _headImg.layer.cornerRadius = 4.0;
        _headImg.layer.masksToBounds=YES;
        _headImg.layer.borderColor = [[UIColor colorWithRed:242.0f/255 green:242.0f/255 blue:242.0f/255 alpha:1.0f] CGColor];
        [_postCellImg addSubview:_headImg];
        
        /*  发帖人名字  */
        _nameLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _nameLab.backgroundColor = [UIColor clearColor];
        _nameLab.textColor = COLOR(69, 69, 69, 1);
        _nameLab.font=[UIFont systemFontOfSize:15];
        [_postCellImg addSubview:_nameLab];
        [_nameLab release];
        
        /*   收藏   */
        _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectBtn.frame = CGRectZero;
        [_collectBtn addTarget:self action:@selector(didCollectWithClick) forControlEvents:UIControlEventTouchUpInside];
        [_postCellImg addSubview:_collectBtn];
        
        _commentImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _commentImg.image = [UIImage imageNamed:@"post_comment_bg"];
        _commentImg.backgroundColor = [UIColor clearColor];
        [_postCellImg addSubview:_commentImg];
        [_commentImg release];
        
        /*   评论数   */
        _commentNumLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _commentNumLab.textColor = COLOR(69, 69, 69, 1);
        _commentNumLab.backgroundColor = [UIColor clearColor];
        _commentNumLab.font = [UIFont systemFontOfSize:16];
        _commentNumLab.textAlignment = NSTextAlignmentLeft;
        [_postCellImg addSubview:_commentNumLab];
        [_commentNumLab release];
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)postImgPressed
{
    if ([self.delegate respondsToSelector:@selector(didHeadImgWithTag:)])
    {
        [self.delegate didHeadImgWithTag:_currentIndex];
    }
}

- (void)didCollectWithClick
{
    if ([self.delegate respondsToSelector:@selector(didCollectWithTag:)])
    {
        [self.delegate didCollectWithTag:_currentIndex];
    }
}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    int count = barInfo.m_images.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:barInfo.m_images[i]]; // 图片路径
        if (i<=3)
        {
            photo.srcImageView = _imgViews.subviews[i]; // 来源于哪个UIImageView
        }
        [photos addObject:photo];
        [photo release];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    [browser release];
}

/* 删除处理 */
-(void)didDeleteWithClick
{
    if ([_delegate respondsToSelector:@selector(didClickDeleteBtn:)])
    {
        [_delegate didClickDeleteBtn:_currentIndex];
    }
}

- (void)resetCellFrameData
{
    _imgViews.frame = CGRectZero;
    _delBtn.frame = CGRectZero;
    _delImg.frame = CGRectZero;
}

- (void)loadPostCellData:(FDSBarPostInfo*)dataInfo
{
    barInfo = dataInfo;
    [self resetCellFrameData];
    
    cell_H = 5.0f;

    NSInteger lineNum = [[FDSPublicManage sharePublicManager] handleShowContent:dataInfo.m_title :_titleLab.font :150];
    _titleLab.numberOfLines = lineNum;
    _titleLab.frame = CGRectMake(125, 5, 150, 25*lineNum);
    _titleLab.text = dataInfo.m_title;
    
    _publishTimeLab.frame = CGRectMake(5, (25*lineNum)/2-7, 120, 25);
    /*  时间戳转时间  */
    NSTimeInterval timeValue = [dataInfo.m_sendTime doubleValue];
    NSDate *confromTime = [NSDate dateWithTimeIntervalSince1970:timeValue/1000];
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yy-MM-dd"];
    _publishTimeLab.text = [NSString stringWithFormat:@"【%@】",[formatter stringFromDate:confromTime]];

    if ([dataInfo.m_senderID isEqualToString:[[FDSUserManager sharedManager] getNowUser].m_userID])
    {
        _delBtn.frame = CGRectMake(280, 0, 40, 50);
        _delImg.frame = CGRectMake(8, 12, 25, 25);
    }
    
    cell_H += 25*lineNum+15;

    /*  图片img  */
    for(UIView* objc in _imgViews.subviews)
    {
        [objc removeFromSuperview];
    }
    if ([dataInfo.m_contentType isEqualToString:@"text"])
    {
        NSInteger imageCount = dataInfo.m_images.count;
        if (imageCount > 0)
        {
//            CGFloat imageWidth = 310.f;
//            if (3 <= imageCount)
//            {
                CGFloat imageWidth = 75.0f;
//            }
//            else if(2 == imageCount)
//            {
//                imageWidth = 150.0f;
//            }
            
            _imgViews.frame = CGRectMake(0, cell_H, kMSScreenWith, 75);
            UIImageView *contentImg = nil;
            for (int i=0; i<imageCount; i++)
            {
                contentImg = [[UIImageView alloc] initWithFrame:CGRectMake(4+i*imageWidth+4*i, 0, imageWidth, 75)];
                contentImg.userInteractionEnabled = YES;
                contentImg.tag = i;
                [contentImg addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]autorelease]];
                
                NSString *imageUrl = [dataInfo.m_images objectAtIndex:i];
                if (imageUrl && [imageUrl length]>0)
                {
                    UIImage *placeholder = [UIImage imageNamed:@"loading_logo_bg"];
                    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@",imageUrl];
                    if (urlStr.length >= 4)
                    {
                        if ([FDSPublicManage currentDevice])
                        {
                            [urlStr insertString:@"_middle" atIndex:urlStr.length-4];
                        }
                        else
                        {
                            [urlStr insertString:@"_small" atIndex:urlStr.length-4];
                        }
                    }
                    [contentImg setImageURLStr:urlStr placeholder:placeholder];
                }
                else
                {
                    contentImg.image = [UIImage imageNamed:@"loading_logo_bg"];
                }
                
//                CGSize newSize = [FDSPublicManage fitsize:contentImg.image.size imageMaxSize:CGSizeMake(imageWidth, 100) isSizeFixed:NO];
//                
//                CGRect rect = contentImg.frame;
//                rect.size = newSize;
//                contentImg.frame = rect;
                
                [_imgViews addSubview:contentImg];
                [contentImg release];
                if (i > 2) //最多只显示4张
                {
                    break;
                }
            }
            
            cell_H += 75+15.0f;
        }
        
        if (dataInfo.m_content && dataInfo.m_content.length>0)
        {
            NSString *tmpStr = nil;
            if (dataInfo.m_content.length>120)
            {
                tmpStr = [NSString stringWithFormat:@"%@",[dataInfo.m_content substringToIndex:120]];
            }
            else
            {
                tmpStr = [NSString stringWithFormat:@"%@",dataInfo.m_content];
            }
            CGFloat viewheight = [_postContentView getcurrentViewHeight:tmpStr];
            _postContentView.frame = CGRectMake(5, cell_H, kMSScreenWith-10, viewheight);
            [_postContentView showMessage:tmpStr];
            
            cell_H += viewheight+5;
        }
    }
    else
    {
        _postContentView.frame = CGRectZero;
        cell_H += 5;
    }
    
    _postLineView.frame = CGRectMake(1, cell_H, 318, 1);
    cell_H +=1;
    
    _headImg.frame = CGRectMake(10, cell_H+5, 40, 40);
//    _headImg.placeholderImage = [UIImage imageNamed:@"headphoto_s"];
//    [_headImg setImageURL:[NSURL URLWithString:dataInfo.m_senderIcon]];
    _headImg.placeholderImage = [UIImage imageNamed:@"headphoto_s"];
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@",dataInfo.m_senderIcon];
    if (urlStr.length >= 4)
    {
        [urlStr insertString:@"_middle" atIndex:urlStr.length-4];
        _headImg.imageURL = [NSURL URLWithString:urlStr];
    }

    
    _nameLab.frame = CGRectMake(10+45, cell_H+10, 180, 25);
    _nameLab.text = dataInfo.m_senderName;
    
    _collectBtn.frame = CGRectMake(240, cell_H+21, 20, 20);
    _collectBtn.adjustsImageWhenHighlighted = NO;
    if (dataInfo.m_isCollect)
    {
        [_collectBtn setBackgroundImage:[UIImage imageNamed:@"post_collected_bg"] forState:UIControlStateNormal];
    }
    else
    {
        [_collectBtn setBackgroundImage:[UIImage imageNamed:@"post_uncollect_bg"] forState:UIControlStateNormal];
    }
    
    _commentImg.frame = CGRectMake(265, cell_H+18, 25, 25);
    
    _commentNumLab.frame = CGRectMake(292, cell_H+18, 25, 25);
    _commentNumLab.text = dataInfo.m_commentNumber;
    
    cell_H +=51;
    _postCellImg.image = [[UIImage imageNamed:@"rect_cell_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    _postCellImg.frame = CGRectMake(0, 0 ,kMSScreenWith, cell_H);
}

-(CGFloat)getCurrentCellHeight:(FDSBarPostInfo*)dataInfo
{
//    cell_H = 5.0f;
//    NSInteger lineNum = [self handleShowContent:dataInfo.m_title :_titleLab.font :200];
//    cell_H += 25*lineNum+5;
//    if (dataInfo.m_images.count > 0)
//    {
//        cell_H += 80+5.0f;
//    }
//    if (dataInfo.m_content && dataInfo.m_content.length>0)
//    {
//        NSString *tmpStr = nil;
//        if (dataInfo.m_content.length>120)
//        {
//            tmpStr = [NSString stringWithFormat:@"%@",[dataInfo.m_content substringToIndex:120]];
//        }
//        else
//        {
//            tmpStr = [NSString stringWithFormat:@"%@",dataInfo.m_content];
//        }
//        CGFloat viewheight = [_postContentView getcurrentViewHeight:tmpStr];
//        cell_H += viewheight+5;
//    }
//    
//    cell_H +=1;
//
//    cell_H+=50;
    
    cell_H+=10; //间隔空隙
    return cell_H;
}


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

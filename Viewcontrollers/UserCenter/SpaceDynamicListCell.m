//
//  SpaceDynamicListCell.m
//  FDS
//
//  Created by zhuozhong on 14-3-10.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "SpaceDynamicListCell.h"
#import "Constants.h"
#import "FDSRevert.h"
#import "FDSUserManager.h"
#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "FDSPublicManage.h"

#define K_BGCELL_SPACE      5
#define K_CONTENT_START_X   10
#define K_CONTENT_START_Y   10
#define K_PHOTO_WIDTH       50
#define K_PHOTO_HEIGHT      50

@implementation SpaceDynamicListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        /*  cell背景 */
        _commentCellImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _commentCellImg.userInteractionEnabled = YES;
        [self.contentView addSubview:_commentCellImg];
        [_commentCellImg release];
        
        /*  评论人头像  */
        _commentHeadImg = [EGOImageButton buttonWithType:UIButtonTypeCustom];
        _commentHeadImg.adjustsImageWhenHighlighted = NO;
        [_commentHeadImg addTarget:self action:@selector(commentImgPressed) forControlEvents:UIControlEventTouchUpInside];
        _commentHeadImg.frame = CGRectZero;
        _commentHeadImg.layer.borderWidth = 1;
        _commentHeadImg.layer.cornerRadius = 4.0;
        _commentHeadImg.layer.masksToBounds=YES;
        _commentHeadImg.layer.borderColor = [[UIColor colorWithRed:242.0f/255 green:242.0f/255 blue:242.0f/255 alpha:1.0f] CGColor];
        [_commentCellImg addSubview:_commentHeadImg];
        
        /*  评论人名字  */
        _commentNameLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _commentNameLab.backgroundColor = [UIColor clearColor];
        _commentNameLab.textColor = COLOR(55, 123, 198, 1);
        _commentNameLab.font=[UIFont systemFontOfSize:15];
        [_commentCellImg addSubview:_commentNameLab];
        [_commentNameLab release];
        
        /*    删除   */
        _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _delBtn.frame = CGRectZero;
        [_delBtn addTarget:self action:@selector(didDeleteWithClick) forControlEvents:UIControlEventTouchUpInside];
        [_commentCellImg addSubview:_delBtn];
        
        _delImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _delImg.image = [UIImage imageNamed:@"delete_comment_icon"];
        _delImg.backgroundColor = [UIColor clearColor];
        [_delBtn addSubview:_delImg];
        [_delImg release];
        
        /*  回复  */
        _replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _replyBtn.frame = CGRectZero;
        [_replyBtn addTarget:self action:@selector(didReplyWithClick) forControlEvents:UIControlEventTouchUpInside];
        [_commentCellImg addSubview:_replyBtn];
        
        _replyImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _replyImg.image = [UIImage imageNamed:@"revert_comment_icon"];
        _replyImg.backgroundColor = [UIColor clearColor];
        [_replyBtn addSubview:_replyImg];
        [_replyImg release];
        
        _replyLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _replyLab.textColor = COLOR(55, 123, 198, 1);
        _replyLab.backgroundColor = [UIColor clearColor];
        _replyLab.font = [UIFont systemFontOfSize:16];
        _replyLab.textAlignment = NSTextAlignmentLeft;
        _replyLab.text = @"回复";
        [_replyBtn addSubview:_replyLab];
        [_replyLab release];
        
        /*  评论时间  */
        _commentTimeLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _commentTimeLab.backgroundColor = [UIColor clearColor];
        _commentTimeLab.textColor = kMSTextColor;
        _commentTimeLab.font=[UIFont systemFontOfSize:12];
        [_commentCellImg addSubview:_commentTimeLab];
        [_commentTimeLab release];
        
        /*  评论内容  */
        _commentContentView = [[CommentView alloc]initWithFrame:CGRectZero];
        _commentContentView.backgroundColor = [UIColor clearColor];
        _commentContentView.fontSize = 15.0f;
        _commentContentView.maxlength = 235;
        _commentContentView.facialSizeWidth = 18;
        _commentContentView.facialSizeHeight = 18;
        _commentContentView.textlineHeight = 20;
        [_commentCellImg addSubview:_commentContentView];
        [_commentContentView release];
        
        /*  评论图片内容  */
        _commentImgViews = [[UIView alloc] initWithFrame:CGRectZero];
        _commentImgViews.backgroundColor = [UIColor clearColor];
        [_commentCellImg addSubview:_commentImgViews];
        [_commentImgViews release];
        
        /*  评论的回复列表  */
        _commentReplyViews = [[UIView alloc] initWithFrame:CGRectZero];
        _commentReplyViews.backgroundColor = [UIColor clearColor];
        [_commentCellImg addSubview:_commentReplyViews];
        [_commentReplyViews release];
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}


/*  针对动态进行回复 */
- (void)didReplyWithClick
{
    if ([self.delegate respondsToSelector:@selector(didClickReplyBtn:)])
    {
        [self.delegate didClickReplyBtn:_indexTag];
    }
}

/* 删除动态处理 */
-(void)didDeleteWithClick
{
    if ([_delegate respondsToSelector:@selector(didClickDeleteComment:)])
    {
        [_delegate didClickDeleteComment:_indexTag];
    }
}

/* 评论人头像选择 */
- (void)commentImgPressed
{
    if ([self.delegate respondsToSelector:@selector(didSelectCommentHead:)])
    {
        [self.delegate didSelectCommentHead:_indexTag];
    }
}

/* 针对评论或回复进行回复 */
- (void)replyImgPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didSelectReplyBtn::)])
    {
        [self.delegate didSelectReplyBtn:_indexTag :[sender tag]];
    }
}

/* 针对评论或回复进行删除 */
- (void)didDeleteReplyClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickDeleteRecert::)])
    {
        [self.delegate didClickDeleteRecert:_indexTag :[sender tag]];
    }
}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    int count = commentInfo.m_images.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:commentInfo.m_images[i]]; // 图片路径
        if (i<=2)
        {
            photo.srcImageView = _commentImgViews.subviews[i]; // 来源于哪个UIImageView
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

- (void)resetCommentFrame
{
    off_x = 0;
    cell_H = 0;
    
    _delBtn.frame = CGRectZero;
    _delImg.frame = CGRectZero;
    
    _commentContentView.frame = CGRectZero;
    _commentImgViews.frame = CGRectZero;
    _commentReplyViews.frame = CGRectZero;
}

- (void)loadCellData:(FDSComment*)commentData
{
    commentInfo = commentData;
    [self resetCommentFrame];
    
    off_x += K_CONTENT_START_X;
    _commentHeadImg.frame = CGRectMake(off_x, K_CONTENT_START_Y, K_PHOTO_WIDTH, K_PHOTO_HEIGHT);
//    _commentHeadImg.placeholderImage = [UIImage imageNamed:@"headphoto_s"];
//    [_commentHeadImg setImageURL:[NSURL URLWithString:commentData.m_senderIcon]];
    _commentHeadImg.placeholderImage = [UIImage imageNamed:@"headphoto_s"];
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@",commentData.m_senderIcon];
    if (urlStr.length >= 4)
    {
        [urlStr insertString:@"_middle" atIndex:urlStr.length-4];
    }
    _commentHeadImg.imageURL = [NSURL URLWithString:urlStr];

    
    off_x+=K_PHOTO_WIDTH+5;
    _commentNameLab.frame = CGRectMake(off_x, K_CONTENT_START_Y-7, 100, 20);
    _commentNameLab.text = commentData.m_senderName;
    
    if ([commentData.m_senderID isEqualToString:[[FDSUserManager sharedManager] getNowUser].m_userID])
    {
        _delBtn.frame = CGRectMake(off_x+100+20, K_CONTENT_START_Y-5, 30, 30);
        _delImg.frame = CGRectMake(12, 3, 25, 25);
    }
    
    _replyBtn.frame = CGRectMake(off_x+120+45, K_CONTENT_START_Y-5,70,30);
    _replyImg.frame = CGRectMake(0, 3, 25, 25);
    _replyLab.frame = CGRectMake(27, 0, 40, 30);
    
    _commentTimeLab.frame = CGRectMake(off_x,K_CONTENT_START_Y+17 ,100, 15);
    /*  时间戳转时间  */
    NSTimeInterval timeValue = [commentData.m_sendTime doubleValue];
    NSDate *confromTime = [NSDate dateWithTimeIntervalSince1970:timeValue/1000];
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"MM-dd HH:mm:ss"];
    _commentTimeLab.text = [formatter stringFromDate:confromTime];
    
    cell_H +=K_CONTENT_START_Y+K_PHOTO_HEIGHT-15;
    if (commentData.m_content.length > 0)
    {
        CGFloat viewheight = [_commentContentView getcurrentViewHeight:commentData.m_content];
        _commentContentView.frame = CGRectMake(off_x, cell_H, 240, viewheight);
        [_commentContentView showMessage:commentData.m_content];
        cell_H += viewheight+10;
    }
    
    for(UIView* objc in _commentImgViews.subviews)
    {
        [objc removeFromSuperview];
    }
    if (commentData.m_images.count > 0)
    {
        _commentImgViews.frame = CGRectMake(off_x, cell_H, 240, 70);
        
        UIImageView *contentImg = nil;
        for (int i=0; i<commentData.m_images.count; i++)
        {
            contentImg = [[UIImageView alloc] initWithFrame:CGRectMake(i*75, 0, 70, 70)];
            contentImg.userInteractionEnabled = YES;
            contentImg.tag = i;
            [contentImg addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]autorelease]];
            
            if ([commentData.m_images objectAtIndex:i] && [[commentData.m_images objectAtIndex:i]length]>0)
            {
                UIImage *placeholder = [UIImage imageNamed:@"send_image_default"];
                NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@",[commentData.m_images objectAtIndex:i]];
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
                contentImg.image = [UIImage imageNamed:@"send_image_default"];
            }
            [_commentImgViews addSubview:contentImg];
            [contentImg release];
            
            if (i > 1) //最多只显示3张
            {
                break;
            }
        }
        
        cell_H += 70+10;
    }
    
    if (commentData.m_content.length == 0 && commentData.m_images.count == 0)
    {
        /*  没有内容 没有图片  */
        cell_H += 20+10;
    }
    
    /*  回复列表  */
    for(UIView* objc in _commentReplyViews.subviews)
    {
        [objc removeFromSuperview];
    }
    if (commentData.m_revertsList.count > 0)
    {
        FDSRevert *revert = nil;
        NSInteger replyCellH = 5;
        for (int i=0; i<commentData.m_revertsList.count; i++)
        {
            revert = [commentData.m_revertsList objectAtIndex:i];
            
            UIButton *replyBtn = [EGOImageButton buttonWithType:UIButtonTypeCustom];
            [replyBtn setBackgroundImage:[UIImage imageNamed:@"reply_select_bg"] forState:UIControlStateHighlighted];
            replyBtn.frame = CGRectZero;
            replyBtn.tag = i;
            [replyBtn addTarget:self action:@selector(replyImgPressed:) forControlEvents:UIControlEventTouchUpInside];
            [_commentReplyViews addSubview:replyBtn];
            
            UILabel *replyNameLab = [[UILabel alloc]initWithFrame:CGRectZero];
            replyNameLab.backgroundColor = [UIColor clearColor];
            replyNameLab.textColor = COLOR(55, 123, 198, 1);
            replyNameLab.font=[UIFont systemFontOfSize:15];
            [replyBtn addSubview:replyNameLab];
            [replyNameLab release];
            if (revert.m_reveredName && revert.m_reveredName.length>0)//回复
            {
                replyNameLab.text = [NSString stringWithFormat:@"%@ 回复 %@",revert.m_senderName,revert.m_reveredName];
            }
            else
            {
                replyNameLab.text = revert.m_senderName;
            }
            NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        replyNameLab.font, NSFontAttributeName,
                                        nil];
            NSString *tempStr = [NSString stringWithFormat:@"%@  %@",replyNameLab.text,revert.m_content];
            CGSize titleSize;
            if(7.0 == IOS_7)
            {
                titleSize = [replyNameLab.text sizeWithAttributes:attributes];
            }
            else
            {
                titleSize = [replyNameLab.text sizeWithFont:replyNameLab.font];
            }
            CGFloat nameWidth = titleSize.width;
            
            if(7.0 == IOS_7)
            {
                titleSize = [tempStr sizeWithAttributes:attributes];
            }
            else
            {
                titleSize = [tempStr sizeWithFont:replyNameLab.font];
            }
            
            
            CommentView *replyContentView = [[CommentView alloc]initWithFrame:CGRectZero];
            replyContentView.backgroundColor = [UIColor clearColor];
            replyContentView.changeColor = YES;
            replyContentView.fontSize = 15.0f;
            replyContentView.facialSizeWidth = 18;
            replyContentView.facialSizeHeight = 18;
            replyContentView.textlineHeight = 20;
            [replyBtn addSubview:replyContentView];
            [replyContentView release];
            
            
            if ([revert.m_senderID isEqualToString:[[FDSUserManager sharedManager] getNowUser].m_userID])
            {
                UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                delBtn.tag = i;
                delBtn.frame = CGRectMake(270, replyCellH-5, 30, 30);
                [delBtn addTarget:self action:@selector(didDeleteReplyClick:) forControlEvents:UIControlEventTouchUpInside];
                [_commentReplyViews addSubview:delBtn];
                
                UIImageView *delImg = [[UIImageView alloc] initWithFrame:CGRectMake(12, 3, 25, 25)];
                delImg.image = [UIImage imageNamed:@"delete_revert_icon"];
                delImg.backgroundColor = [UIColor clearColor];
                [delBtn addSubview:delImg];
                [delImg release];
            }
            
            /* 需要先加入再算frame坐标 */
            CGFloat viewheight = 0.0f ;
            if (titleSize.width >= 270  && nameWidth >=200) //回复内容换行
            {
                replyNameLab.frame = CGRectMake(5, 0, 270, 20);
                replyContentView.maxlength = 270;
                
                viewheight = [replyContentView getcurrentViewHeight:revert.m_content];
                
                replyContentView.frame = CGRectMake(5, 20, 270, viewheight);
                
                replyBtn.frame = CGRectMake(5, replyCellH, 270, viewheight+20+2);
                replyCellH+=(20+replyContentView.frame.size.height)+10;
            }
            else//回复内容不换行
            {
                replyNameLab.frame = CGRectMake(5, 0, nameWidth, 20);
                replyContentView.maxlength = 270-10-nameWidth;
                
                viewheight = [replyContentView getcurrentViewHeight:revert.m_content];
                
                replyContentView.frame = CGRectMake(nameWidth+10, 1, 270-10-nameWidth, viewheight);
                
                replyBtn.frame = CGRectMake(5, replyCellH, 270, viewheight+2);
                replyCellH+=replyContentView.frame.size.height+10;
            }
            [replyContentView showMessage:revert.m_content];
            
//            CGRect rect = replyContentView.frame;
//            rect.origin.x =5;
//            rect.size.width = 270-5;
//            replyBtn.frame = rect;
        }
        
        _commentReplyViews.frame = CGRectMake(0, cell_H, kMSScreenWith-10, replyCellH);
        cell_H += replyCellH;
    }
    
    _commentCellImg.image = [[UIImage imageNamed:@"round_white_cellbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    _commentCellImg.frame = CGRectMake(5, 5 ,kMSScreenWith-10, cell_H);
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

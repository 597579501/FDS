//
//  DynamicCell.m
//  MacelInternet
//
//  Created by zhuozhongkeji on 13-12-30.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "DynamicCell.h"
#import "Constants.h"
#define     IOS_VERSION     [[[UIDevice currentDevice] systemVersion] floatValue]

#define     Screen_Width    [UIScreen mainScreen].bounds.size.width
//字体
#define     KFont20         [UIFont systemFontOfSize:20]
#define     KFont18         [UIFont systemFontOfSize:18]
#define     KFont16         [UIFont systemFontOfSize:16]
#define     KFont14         [UIFont systemFontOfSize:14]
#define     KFontBold14     [UIFont boldSystemFontOfSize:14]
#define     KFont12         [UIFont systemFontOfSize:12]

#define Kcell_start_x       10
#define Kcell_start_y       10
#define Khead_W_H           40

#define KLb_Max_W           240

#define KImgArea_W          240
#define KImgArea_H          240
#define KImg_W_H            74

#define KBt_W               50
#define KBt_H               20

@implementation DynamicCell

- (id)initWithStyle:(UITableViewCellStyle)style Delegate:(id)delegate reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        imgViews = [[NSMutableArray alloc] initWithCapacity:0];//保存图片数组方便处理图片
        self.backgroundColor = [UIColor clearColor];
        // Initialization code
        _cellDelegate = delegate;

        //头像
        headPhoto = [[EGOImageView alloc] initWithFrame:CGRectZero];
        headPhoto.placeholderImage = [UIImage imageNamed:@"headphoto_s"];
//        headPhoto.layer.cornerRadius = 8;
//        headPhoto.layer.masksToBounds = YES;
        [self addSubview:headPhoto];
        //昵称
        nickName = [[UILabel alloc] initWithFrame:CGRectZero];
        nickName.textColor = [UIColor redColor];
        [nickName setFont:KFont16];
        nickName.backgroundColor = [UIColor clearColor];
        nickName.textAlignment = NSTextAlignmentLeft;
        [self addSubview:nickName];
        
        deleteView = [[UIView alloc] initWithFrame:CGRectZero];
        deleteView.backgroundColor = [UIColor clearColor];
        [self addSubview:deleteView];
        
        deleteImgV = [[UIImageView alloc] initWithFrame:CGRectZero];
        deleteImgV.backgroundColor = [UIColor clearColor];
        [deleteView addSubview:deleteImgV];
        
        //动态文本
        dynamicText = [[UILabel alloc] initWithFrame:CGRectZero];
        dynamicText.font = KFont16;
        dynamicText.backgroundColor = [UIColor clearColor];
        dynamicText.textAlignment = NSTextAlignmentLeft;
        dynamicText.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:dynamicText];
        
        //初始化图片区域
        dynamicImgs = [[UIView alloc] initWithFrame:CGRectZero];
        dynamicImgs.backgroundColor = [UIColor clearColor];
        [self addSubview:dynamicImgs];

        //赞
        praiseView = [[UIView alloc] initWithFrame:CGRectZero];
        praiseView.backgroundColor = [UIColor clearColor];
        [self addSubview:praiseView];
        
        praiseImgV = [[UIImageView alloc] initWithFrame:CGRectZero];
        praiseImgV.backgroundColor = [UIColor clearColor];
        praiseImgV.image = [UIImage imageNamed:@"icon_praise"];
        [praiseView addSubview:praiseImgV];
        
        praiseLb = [[UILabel alloc] initWithFrame:CGRectZero];
        praiseLb.textColor = COLOR(123, 121, 123, 1);
        praiseLb.backgroundColor = [UIColor clearColor];
        praiseLb.font = KFont14;
        praiseLb.textAlignment = NSTextAlignmentLeft;
        [praiseView addSubview:praiseLb];
        
        //评论
        commentView = [[UIView alloc] initWithFrame:CGRectZero];
        commentView.backgroundColor = [UIColor clearColor];
        [self addSubview:commentView];
        
        commentImgV = [[UIImageView alloc] initWithFrame:CGRectZero];
        commentImgV.image = [UIImage imageNamed:@"icon_comments"];
        commentImgV.backgroundColor = [UIColor clearColor];
        [commentView addSubview:commentImgV];
        
        commentLb = [[UILabel alloc] initWithFrame:CGRectZero];
        commentLb.textColor = COLOR(123, 121, 123, 1);
        commentLb.backgroundColor = [UIColor clearColor];
        commentLb.font = KFont14;
        commentLb.textAlignment = NSTextAlignmentLeft;
        [commentView addSubview:commentLb];
        
        //时间
        dynamicTime = [[UILabel alloc] initWithFrame:CGRectMake(off_x, cell_H + Kcell_start_y, KLb_Max_W, KBt_H)];
        [dynamicTime setTextColor:COLOR(123, 121, 123, 1)];
        dynamicTime.font = KFont14;
        dynamicTime.backgroundColor = [UIColor clearColor];
        dynamicTime.textAlignment = NSTextAlignmentLeft;
        [self addSubview:dynamicTime];
        
        //收藏
        collectView = [[UIView alloc] initWithFrame:CGRectZero];
        collectView.backgroundColor = [UIColor clearColor];
        [self addSubview:collectView];
        
        collectImgV = [[UIImageView alloc] initWithFrame:CGRectZero];
        collectImgV.backgroundColor = [UIColor clearColor];
        [collectView addSubview:collectImgV];
        
        //举报
        reportView = [[UIView alloc] init];
        reportView.backgroundColor = [UIColor clearColor];
        [self addSubview:reportView];
        
        reportLb = [[UILabel alloc] init];
        reportLb.backgroundColor = [UIColor clearColor];
        reportLb.textAlignment = NSTextAlignmentLeft;
        reportLb.text = @"举报";
        reportLb.textColor = COLOR(123, 121, 123, 1);
        reportLb.font = KFont12;
        [reportView addSubview:reportLb];
        
        //回复
        replyLab = [[UILabel alloc]initWithFrame:CGRectZero];
        replyLab.backgroundColor = [UIColor clearColor];
        replyLab.textAlignment = NSTextAlignmentLeft;
        replyLab.textColor = [UIColor redColor];
        replyLab.text = @"回复";
        replyLab.font = KFont14;
        [self addSubview:replyLab];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tapped:)];
        tap.cancelsTouchesInView = NO;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)resetCellData
{
    cell_H = 0;
    cellData = nil;
    off_x = 0;
    [imgViews removeAllObjects];
    headPhoto.frame = CGRectZero;
    nickName.frame = CGRectZero;
    dynamicText.frame = CGRectZero;
    dynamicImgs.frame = CGRectZero;
    dynamicTime.frame = CGRectZero;
    collectView.frame = CGRectZero;
    commentView.frame = CGRectZero;
    praiseView.frame = CGRectZero;
    deleteView.frame = CGRectZero;
    collectImgV.frame = CGRectZero;
    commentImgV.frame = CGRectZero;
    praiseImgV.frame = CGRectZero;
    deleteImgV.frame = CGRectZero;     //删除
    commentLb.frame = CGRectZero;
    praiseLb.frame = CGRectZero;
}

- (void)dealloc
{
    [cellData release];
    [imgViews release];
    [headPhoto release];
    [nickName release];
    [dynamicImgs release];
    [dynamicText release];
    [dynamicTime release];
    [collectView release];
    [commentView release];
    [praiseView release];
    [deleteView release];
    [collectImgV release];
    [commentImgV release];
    [praiseImgV release];
    [deleteImgV release];     //删除
    [commentLb release];
    [praiseLb release];
    [replyLab release];

    [super dealloc];
}

- (void)LoadCellData:(ArticleData*)cellDataObj CellType:(UISelfDefCellType)cellType
{
//    [self resetCellData];
    imgViews = [[NSMutableArray alloc] initWithCapacity:0];//保存图片数组方便处理图片
    cellData = [cellDataObj retain];
    off_x = Kcell_start_x;
    if(UISelfDefCellStyle1 == cellType || UISelfDefCellStyle == cellType)
    {
        //头像
        headPhoto.frame = CGRectMake(Kcell_start_x, Kcell_start_y, Khead_W_H, Khead_W_H);
        NSString* imgUrl = cellDataObj.sender_headurl;
        if(nil != imgUrl)
        {
            if([imgUrl rangeOfString:@"http"].length > 0)
            {
                NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)imgUrl, NULL, NULL,  kCFStringEncodingUTF8));
                
                headPhoto.imageURL = [NSURL URLWithString:encodedString];
            }
            else
            {
                headPhoto.image = [UIImage imageNamed:imgUrl];
            }
        }
        off_x = Kcell_start_x*2 + Khead_W_H;
    }
    
    //昵称
    nickName.frame = CGRectMake(off_x, Kcell_start_y, 180, Khead_W_H/2);
    [nickName setText:cellDataObj.sender_name];
    
    //动态文本
    [self LoadDynamicTextData:cellDataObj.article_content];
    
    if(![self isStrNil:cellData.article_content] && cellDataObj.article_content.length > 0)//有文本条件下
    {
        cell_H = dynamicText.frame.origin.y + dynamicText.frame.size.height;
    }
    else
    {
        cell_H = Khead_W_H +Kcell_start_y*3/2;
    }
    
    for(UIView* objc in dynamicImgs.subviews)
    {
        [objc removeFromSuperview];
    }
    //初始化图片区域
    if([cellData.articleThumbnails count] > 0)
    {
        dynamicImgs.frame = CGRectMake(off_x, cell_H + Kcell_start_y, KImgArea_W, [self getImgsArea_H:[cellData.articleThumbnails count]]);
        
        [self initDynamicImgView:cellData.articleThumbnails];
        cell_H = dynamicImgs.frame.origin.y + dynamicImgs.frame.size.height;
    }
    
    if(UISelfDefCellStyle == cellType)
    {
        [self commentAndPraiseInit];
    }
    /*
    else if (UISelfDefCellStyle1 == cellType)
    {
        [self collectInit];
    }
    else if (UISelfDefCellStyle3 == cellType || UISelfDefCellStyle2 == cellType)
    {
        //收藏
        if(UISelfDefCellStyle3 == cellType)
        {
            collectView.frame = CGRectMake(Screen_Width - KBt_W, Kcell_start_y, KBt_W, KBt_H);
            
            UIImage* collectImg = [UIImage imageNamed:@"icon_uncollect_bg"];;
            CGRect  collectRc = CGRectMake(18, (KBt_H-24)/2, 24, 24);
            collectImgV.frame = collectRc;
            if(cellData.isMeCollect)
            {
                collectImg = [UIImage imageNamed:@"icon_collected_bg"];//[MLBUtils imageWithTintColor:collectImg Color:COLOR(255, 64, 89, 1)];
            }
            collectImgV.image = collectImg;
        }
        else
        {
            deleteView.frame = CGRectMake(Screen_Width - KBt_W, Kcell_start_y, KBt_W, KBt_H);
            CGRect  delImgRc = CGRectMake(18, (KBt_H-24)/2, 24, 24);
            deleteImgV.frame = delImgRc;
            UIImage* deleteImg = [UIImage imageNamed:@"icon_del"];
            deleteImgV.image = deleteImg;
        }
        [self commentAndPraiseInit];
    }
     */
}

- (BOOL)isStrNil:(NSString*)str
{
    if (str == nil || str == NULL) {
        return YES;
    }
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

- (CGFloat)getImgsArea_H:(NSInteger)imgsCount
{
    CGFloat off_h = 0;
    if (1 == imgsCount)
    {
        off_h = KImgArea_H;
    }
    else if (imgsCount < 4)
    {
        off_h = KImg_W_H;
    }
    else if (imgsCount < 7)
    {
        off_h = KImg_W_H*2 + 2;
    }
    else
    {
        off_h =KImg_W_H*3 + 2*2;
    }
    return off_h;
}

#pragma RemoveImgDownload
- (void)willMoveToSuperview:(UIView *)newSuperview
{
	[super willMoveToSuperview:newSuperview];
	
	if(!newSuperview)
    {
		[headPhoto cancelImageLoad];
	}
}

- (void)collectInit
{
    //收藏
    collectView.frame = CGRectMake(Screen_Width - KBt_W, Kcell_start_y, KBt_W, KBt_H);
    
    UIImage* collectImg = [UIImage imageNamed:@"icon_uncollect_bg"];;
    CGRect  collectRc = CGRectMake(18, (KBt_H-24)/2, 24, 24);
    collectImgV.frame = collectRc;
    if(cellData.isMeCollect)
    {
        collectImg = [UIImage imageNamed:@"icon_collected_bg"];//[MLBUtils imageWithTintColor:collectImg Color:COLOR(255, 64, 89, 1)];
    }
    collectImgV.image = collectImg;
    
    //举报
    CGFloat bt_x = Screen_Width - KBt_W;
    reportView.frame = CGRectMake(bt_x, cell_H + 5 - KBt_H, KBt_W, KBt_H);
    reportLb.frame = CGRectMake(10 + 5, 0, KBt_W, KBt_H);
    //赞
    bt_x = Screen_Width - KBt_W;
    praiseView.frame = CGRectMake(bt_x, cell_H + Kcell_start_y, KBt_W, KBt_H);
    
    UIImage* praiseImg = [UIImage imageNamed:@"icon_praise"];
    CGRect  praiseRc = CGRectMake(10, (KBt_H-14)/2, 14, 14);
    praiseImgV.frame = praiseRc;
    praiseImgV.image = praiseImg;
    
    praiseLb.frame = CGRectMake(praiseRc.origin.x + praiseRc.size.width + 5, 0, KBt_W - praiseRc.size.width, KBt_H);
    praiseLb.text = cellData.article_praiseNum;
    
    //时间
    dynamicTime.frame = CGRectMake(off_x, cell_H + Kcell_start_y, KLb_Max_W, KBt_H);
    [dynamicTime setText:cellData.article_time];
    
    cell_H = Kcell_start_y/2 + praiseView.frame.origin.y + praiseView.frame.size.height;
}

- (void)commentAndPraiseInit
{
    //按钮区域
    //回复
    CGFloat bt_x = Screen_Width - KBt_W*2-30;
    replyLab.frame = CGRectMake(bt_x+10, cell_H+Kcell_start_y, 30, KBt_H);
    
    //赞
    bt_x+=30;
    praiseView.frame = CGRectMake(bt_x, cell_H + Kcell_start_y, KBt_W, KBt_H);
    
    UIImage* praiseImg = [UIImage imageNamed:@"icon_praise"];
    praiseImgV.image = praiseImg;
    CGRect  praiseRc = CGRectMake(20, (KBt_H-14)/2, 14, 14);
    praiseImgV.frame = praiseRc;
    
    praiseLb.frame = CGRectMake(praiseRc.origin.x + praiseRc.size.width + 5, 0, KBt_W - praiseRc.size.width, KBt_H);
    praiseLb.text = cellData.article_praiseNum;
    
    //评论
    commentView.frame = CGRectMake(bt_x + KBt_W, cell_H + Kcell_start_y, KBt_W, KBt_H);
    
    UIImage* commentImg = [UIImage imageNamed:@"icon_comments"];
    CGRect  commentRc = CGRectMake(10, (KBt_H-14)/2, 14, 14);
    commentImgV.frame = commentRc;
    commentImgV.image = commentImg;
    
    commentLb.frame = CGRectMake(commentRc.origin.x + commentRc.size.width + 5, 0, KBt_W - commentRc.size.width, KBt_H);
    commentLb.text = cellData.article_commentNum;
    
    //时间
    dynamicTime.frame = CGRectMake(off_x, cell_H + Kcell_start_y, KLb_Max_W-130, KBt_H);
    [dynamicTime setText:cellData.article_time];
    
    cell_H = Kcell_start_y*3/2 + cell_H + KBt_H;
}

- (void)Tapped:(UITapGestureRecognizer*)tapPoint
{
//    NSLog(@"%f%f",pt.x,pt.y);
    if (![_cellDelegate respondsToSelector:@selector(CellTapped:currTag:)])
    {
        return;
    }
    CGPoint pt = [tapPoint locationInView:self];
    if(CGRectContainsPoint(headPhoto.frame, pt))//头像
    {
        [_cellDelegate CellTapped:UIStyleHeadPhoto currTag:_indexTag];
    }
    else if(CGRectContainsPoint(nickName.frame, pt))
    {
        [_cellDelegate CellTapped:UIStyleNickName currTag:_indexTag];
    }
    else if (CGRectContainsPoint(deleteView.frame, pt))//删除
    {
        [_cellDelegate CellTapped:UIStyleDelete currTag:_indexTag];
    }
    else if (CGRectContainsPoint(collectView.frame, pt))//收藏
    {
        [self DeelCollect];
        [_cellDelegate CellTapped:UIStyleCollect currTag:_indexTag];
    }
    else if (CGRectContainsPoint(reportView.frame, pt))
    {
        [_cellDelegate CellTapped:UIStyleReport currTag:_indexTag];
    }
    else if (CGRectContainsPoint(praiseView.frame, pt))//赞
    {
        
    }
    else if(CGRectContainsPoint(commentView.frame, pt))//评论
    {
        [_cellDelegate CellTapped:UIStyleComment currTag:_indexTag];
    }
    else if(CGRectContainsPoint(dynamicImgs.frame, pt))//图片
    {
        
    }
    else if(CGRectContainsPoint(replyLab.frame, pt))
    {
        [_cellDelegate CellTapped:UIStyleReply currTag:_indexTag]; //回复
    }
    else
    {
        [_cellDelegate CellTapped:UIStyleOther currTag:_indexTag];
    }
}

- (void)DeelCollect
{
    if(!cellData.isMeCollect)
    {
        cellData.isMeCollect = YES;
        collectImgV.image = [UIImage imageNamed:@"icon_collected_bg"];//[MLBUtils imageWithTintColor:collectImgV.image Color:COLOR(255, 64, 89, 1)];
    }
    else
    {
        cellData.isMeCollect = NO;
        collectImgV.image = [UIImage imageNamed:@"icon_uncollect_bg"];//[MLBUtils imageWithTintColor:collectImgV.image Color:COLOR(123, 121, 123, 1)];
    }
}

- (void)LoadDynamicTextData:(NSString*)str
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont systemFontOfSize:16], NSFontAttributeName,
                                //[NSColor redColor], NSForegroundColorAttributeName,
                                //[NSColor yellowColor], NSBackgroundColorAttributeName,
                                nil];
    
    CGSize titleSize; //[str sizeWithAttributes:attributes];
    if(7.0 == IOS_VERSION)
    {
        titleSize = [str sizeWithAttributes:attributes];
    }
    else
    {
        titleSize = [str sizeWithFont:[UIFont systemFontOfSize:16]];
    }
    
    NSInteger lineNum = titleSize.width/KLb_Max_W;
    if(0 != ((int)titleSize.width)%KLb_Max_W)
    {
        lineNum += 1;
    }
    //动态文本
    dynamicText.frame = CGRectMake(off_x, Kcell_start_y + Khead_W_H/2, KLb_Max_W, 20*lineNum);
    [dynamicText setText:str];
    dynamicText.numberOfLines = lineNum;
}

- (void)initDynamicImgView:(NSArray*)arr
{
    for(int i = 0;i< [arr count]; i++)
    {
        CGRect imgRc = [self GetImgRc:CGRectMake(0, 0, KImgArea_W, KImgArea_H) ImgCount:[arr count] index:i];
        EGOImageView* imgv = [[EGOImageView alloc] initWithFrame:imgRc];
        
        id objc = [arr objectAtIndex:i];
        if([objc isKindOfClass:[NSString class]])
        {
            NSString* imgUrl = objc;
            NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)imgUrl, NULL, NULL,  kCFStringEncodingUTF8));
            imgv.imageURL = [NSURL URLWithString:encodedString];
        }
        else if ([objc isKindOfClass:[UIImage class]])
        {
            imgv.image = objc;
        }
        [dynamicImgs addSubview:imgv];
        [imgViews addObject:imgv];
        
        if(1 == [arr count])
        {
            CGRect rc = dynamicImgs.frame;
            rc.size.width = imgv.frame.size.width;
            rc.size.height = imgv.frame.size.height;
            dynamicImgs.frame = rc;
        }
    }
}

- (CGRect)GetImgRc:(CGRect)srcRc ImgCount:(NSInteger)count index:(NSInteger)imgIndex
{
    CGRect rc = CGRectZero;
    if (1 == count)
    {
        if(0 == imgIndex)
        {
            CGSize size = CGSizeMake(KImgArea_W, KImgArea_H);
            if(cellData.thumb_W > 0 && cellData.thumb_H > 0)
            {
                size = [self scaleSize:CGSizeMake(KImgArea_W, KImgArea_H) ScaleSize:CGSizeMake(cellData.thumb_W, cellData.thumb_H)];
            }
            rc = CGRectMake(srcRc.origin.x, srcRc.origin.y, size.width, size.height);
        }
    }
    else if (count >=2 && count <= 6)//2*2
    {
        for(int i=0;i<count;i++)
        {
            if(i == imgIndex)
            {
                rc = CGRectMake(srcRc.origin.x + (i%3)*KImg_W_H + 2*(i%3), srcRc.origin.y+(i/3)*KImg_W_H + 2*(i/3), KImg_W_H, KImg_W_H);
            }
        }
    }
    else if (7 == count || 8 == count || 9 == count)//3*3
    {
        for(int i=0;i<count;i++)
        {
            if(i == imgIndex)
            {
                rc = CGRectMake(srcRc.origin.x + (i%3)*KImg_W_H + 2*(i%3), srcRc.origin.y+(i/3)*KImg_W_H + 2*(i/3), KImg_W_H, KImg_W_H);
            }
        }
    }
    
    return rc;
}

- (CGSize)scaleSize:(CGSize)belongSize ScaleSize:(CGSize)scaleSize
{
    CGSize size;
    CGFloat w_scale,h_scale;
    w_scale = (belongSize.width/scaleSize.width);
    h_scale = (belongSize.height/scaleSize.height);
    if(h_scale <= w_scale)
    {
        size = CGSizeMake(scaleSize.width * h_scale, scaleSize.height* h_scale);
    }
    else
    {
        size = CGSizeMake(scaleSize.width * w_scale, scaleSize.height* w_scale);
    }
    return size;
}

- (CGFloat)GetCurrentCellHeight
{
    return cell_H;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

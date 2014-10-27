//
//  MessageView.m
//  FaceBoardDome
//
//  Created by kangle1208 on 13-12-12.
//  Copyright (c) 2013年 Blue. All rights reserved.
//

#import "MessageView.h"
#import "FaceBoard.h"
#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#define FACE_ICON_NAME      @"^[0][0-8][0-5]$"


@implementation MessageView

@synthesize chatMsg;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.chatMsg = nil;
    }
    return self;
}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
    
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.url = [NSURL URLWithString:self.chatMsg.m_imageURL]; // 图片路径
    photo.srcImageView = imageButton; // 来源于哪个UIImageView
    [photos addObject:photo];
    [photo release];
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    [browser release];
}

- (void)showMessage:(FDSChatMessage *)message
{
    for(UIView* objc in self.subviews)
    {
        [objc removeFromSuperview];
    }

    imageButton = [[UIImageView alloc] init];
    imageButton.userInteractionEnabled = YES;
    [imageButton addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]autorelease]];
    imageButton.frame = CGRectZero;
    [self addSubview:imageButton];
    [imageButton release];
    
    self.chatMsg = message;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
	if ( self.chatMsg )
    {
        if (self.chatMsg.m_tmpImg.length > 0 || (![self.chatMsg.m_imageURL isEqualToString:@"(null)"] && self.chatMsg.m_imageURL.length > 0))
        {
            imageButton.hidden = NO;
            imageButton.frame = CGRectMake(7, 4, self.frame.size.width-14, self.frame.size.height-8);
            if (self.chatMsg.m_tmpImg.length > 0)
            {
                imageButton.image = [UIImage imageWithContentsOfFile:self.chatMsg.m_tmpImg];
            }
            else
            {
                if (self.chatMsg.m_imageURL && [self.chatMsg.m_imageURL length]>0)
                {
                    UIImage *placeholder = [UIImage imageNamed:@"send_image_default"];
                    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@",self.chatMsg.m_imageURL];
                    if (urlStr.length >= 4)
                    {
                        [urlStr insertString:@"_small" atIndex:urlStr.length-4];
                    }
                    [imageButton setImageURLStr:urlStr placeholder:placeholder];
                }
                else
                {
                    imageButton.image = [UIImage imageNamed:@"send_image_default"];
                }
            }
        }
        else
        {
            imageButton.hidden = YES;

            NSDictionary *faceMap = [[NSUserDefaults standardUserDefaults] objectForKey:@"FaceMap"];
            
            UIFont *font = [UIFont systemFontOfSize:16.0f];
            
            isLineReturn = NO;
            
            upX = VIEW_LEFT;
            upY = VIEW_TOP;
            NSMutableArray *msgContent = self.chatMsg.m_chatContent;
            for (int index = 0; index < [msgContent count]; index++)
            {
                NSString *str = [msgContent objectAtIndex:index];
                if ( [str hasPrefix:FACE_NAME_HEAD] )
                {
                    NSArray *imageNames = [faceMap allKeysForObject:str];
                    NSString *imageName = nil;
                    
                    if ( imageNames.count > 0 )
                    {
                        imageName = [imageNames objectAtIndex:0];
                    }
                    
                    UIImage *image = [UIImage imageNamed:imageName];
                    
                    if ( image )
                    {
                        if ( upX > ( VIEW_WIDTH_MAX ) )
                        {
                            isLineReturn = YES;
                            upX = VIEW_LEFT;
                            upY += VIEW_LINE_HEIGHT;
                        }
                        [image drawInRect:CGRectMake(upX, upY, KFacialSizeWidth, KFacialSizeHeight)];
                        
                        upX += KFacialSizeWidth;
                        
                        lastPlusSize = KFacialSizeWidth;
                    }
                    else
                    {
                        [self drawText:str withFont:font];
                    }
                }
                else
                {
                    NSRange range = [str rangeOfString:POST_NAME_HEAD];//发帖
                    NSRange range2 = [str rangeOfString:DYNAMIC_NAME_HEAD];
                    if (range.length > 0)
                    {
                        /*  发帖  */
                        if (range.location > 0)
                        {
                            [self drawText:[str substringToIndex:range.location] withFont:font];
                            str = [str substringFromIndex:range.location];
                            [self drawPostText:str withFont:font];
                        }
                    }
                    else if(range2.length > 0)
                    {
                        /*  发动态  */
                        if (range2.location > 0)
                        {
                            [self drawText:[str substringToIndex:range2.location] withFont:font];
                            str = [str substringFromIndex:range2.location];
                            [self drawDynamicText:str withFont:font];
                        }
                    }
                    else
                    {
                        [self drawText:str withFont:font];
                    }
                }
            }
        }
	}
}


/*  展示动态  */
- (void)drawDynamicText:(NSString*)string withFont:(UIFont*)font
{
    if (string.length >= DYNAMIC_NAME_LEN)
    {
        string = [string substringFromIndex:12];/* 去除［userRecord: 字符 */
        /*   反向查找  */
        NSRange range = [string rangeOfString:@":" options:NSBackwardsSearch];
        
        string = [string substringToIndex:string.length-1];
        NSString *dynamicTitle = [string substringToIndex:range.location];
        self.messageID = [string substringFromIndex:range.location+1];
        self.messageType = @"userRecord";
        
        upX = VIEW_LEFT;
        upY += VIEW_LINE_HEIGHT;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(upX, upY, self.frame.size.width, self.frame.size.height-upY);
        [button addTarget:self action:@selector(postBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        [self drawTextAndLine:dynamicTitle withFont:font];
    }
    else
    {
        [self drawText:string withFont:font];
    }
}



/*  展示帖子  */
- (void)drawPostText:(NSString*)string withFont:(UIFont*)font
{
    if (string.length >= POST_NAME_LEN)
    {
        string = [string substringFromIndex:6];/* 去除［post: 字符 */
        /*   反向查找  */
        NSRange range = [string rangeOfString:@":" options:NSBackwardsSearch];
        
        string = [string substringToIndex:string.length-1];
        NSString *postTitle = [string substringToIndex:range.location];
        self.messageID = [string substringFromIndex:range.location+1];
        self.messageType = @"POST";
        
        upX = VIEW_LEFT;
        upY += VIEW_LINE_HEIGHT;

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(upX, upY, self.frame.size.width, self.frame.size.height-upY);
        [button addTarget:self action:@selector(postBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        [self drawTextAndLine:postTitle withFont:font];
    }
    else
    {
        [self drawText:string withFont:font];
    }
}

/*   点击帖子详情   */
- (void)postBtnPressed
{
    if ([self.delegate respondsToSelector:@selector(didSelectMessage::)])
    {
        [self.delegate didSelectMessage:self.messageID :self.messageType];
    }
}

/*   绘制带有下划线的文字   */
- (void)drawTextAndLine:(NSString*)title withFont:(UIFont*)font
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor (context, 41/255.0,93/255.0,231/255.0, 1.0);
    for ( int index = 0; index < title.length; index++)
    {
        NSString *character = [title substringWithRange:NSMakeRange( index, 1 )];
        
        CGSize size = [character sizeWithFont:font
                            constrainedToSize:CGSizeMake(VIEW_WIDTH_MAX, VIEW_LINE_HEIGHT * 1.5)];
        if ( upX > VIEW_WIDTH_MAX )
        {
            isLineReturn = YES;
            
            upX = VIEW_LEFT;
            upY += VIEW_LINE_HEIGHT;
        }
        
        [character drawInRect:CGRectMake(upX, upY, size.width, self.bounds.size.height) withFont:font];
        
        
        upX += size.width;
        
        lastPlusSize = size.width;
    }
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathStroke);
}

- (void)drawText:(NSString *)string withFont:(UIFont *)font
{
    for ( int index = 0; index < string.length; index++)
    {
        NSString *character = [string substringWithRange:NSMakeRange( index, 1 )];

        CGSize size = [character sizeWithFont:font
                            constrainedToSize:CGSizeMake(VIEW_WIDTH_MAX, VIEW_LINE_HEIGHT * 1.5)];
        if ( upX > VIEW_WIDTH_MAX )
        {
            isLineReturn = YES;

            upX = VIEW_LEFT;
            upY += VIEW_LINE_HEIGHT;
        }

        [character drawInRect:CGRectMake(upX, upY, size.width, self.bounds.size.height) withFont:font];

        upX += size.width;

        lastPlusSize = size.width;
    }
}


/**
 * 判断字符串是否有效
 */
- (BOOL)isStrValid:(NSString *)srcStr forRule:(NSString *)ruleStr
{
    NSRegularExpression *regularExpression = [[NSRegularExpression alloc] initWithPattern:ruleStr
                                                                                  options:NSRegularExpressionCaseInsensitive
                                                                                    error:nil];
    
    NSUInteger numberOfMatch = [regularExpression numberOfMatchesInString:srcStr
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, srcStr.length)];
    [regularExpression release];
    
    return ( numberOfMatch > 0 );
}

- (void)dealloc
{
    self.messageType = nil;
    self.messageID = nil;
    
    self.chatMsg = nil;
    [super dealloc];
}

@end

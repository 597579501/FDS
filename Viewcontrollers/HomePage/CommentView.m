//
//  CommentView.m
//  FDS
//
//  Created by zhuozhong on 14-2-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "CommentView.h"
#import "FDSPublicManage.h"
#import "Constants.h"

@implementation CommentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _m_comment = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)showMessage:(NSString *)commentMessage
{
    if (commentMessage)
    {
        [_m_comment removeAllObjects];
        [[FDSPublicManage sharePublicManager] getMessageRange:commentMessage :_m_comment];
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    NSDictionary *faceMap = [[NSUserDefaults standardUserDefaults] objectForKey:@"FaceMap"];
    UIFont *font = [UIFont systemFontOfSize:_fontSize];
    upX = 0;
    upY = 0;
    for (int index = 0; index < [_m_comment count]; index++)
    {
        NSString *str = [_m_comment objectAtIndex:index];
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
                if (upX+_facialSizeWidth > _maxlength)
                {
                    upX = 0;
                    upY += _textlineHeight;
                }
                [image drawInRect:CGRectMake(upX, upY, _facialSizeWidth, _facialSizeHeight)];
                
                upX += _facialSizeWidth;
            }
            else
            {
                [self drawText:str withFont:font];
            }
        }
        else
        {
            [self drawText:str withFont:font];
        }
    }
}

- (void)drawText:(NSString *)string withFont:(UIFont *)font
{
    if (_changeColor)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor (context, 127/255.0,127/255.0,127/255.0, 1.0);
    }
    else
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor (context, 69/255.0,69/255.0,69/255.0, 1.0);
    }

    for ( int index = 0; index < string.length; index++)
    {
        NSString *character = [string substringWithRange:NSMakeRange( index, 1 )];
        
        CGSize size = [character sizeWithFont:font
                            constrainedToSize:CGSizeMake(_maxlength, _textlineHeight )];
        if (upX+size.width> _maxlength)
        {
            upX = 0;
            upY += _textlineHeight;
        }
        [character drawInRect:CGRectMake(upX, upY, size.width, self.bounds.size.height) withFont:font];
        upX += size.width;
    }
}

- (CGFloat)getcurrentViewHeight:(NSString*)commentMessage
{
    NSDictionary *faceMap = [[NSUserDefaults standardUserDefaults] objectForKey:@"FaceMap"];
    [_m_comment removeAllObjects];
    [[FDSPublicManage sharePublicManager] getMessageRange:commentMessage :_m_comment];

    UIFont *font = [UIFont systemFontOfSize:_fontSize];
    upX = 0;
    upY = 0;
    for (int index = 0; index < [_m_comment count]; index++)
    {
        NSString *str = [_m_comment objectAtIndex:index];
        if ( [str hasPrefix:FACE_NAME_HEAD] )
        {
            NSArray *imageNames = [faceMap allKeysForObject:str];
            NSString *imageName = nil;
            NSString *imagePath = nil;
            if ( imageNames.count > 0 )
            {
                imageName = [NSString stringWithFormat:@"%@@2x",[imageNames objectAtIndex:0]];
                imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
            }
            if ( imagePath )
            {
                if ( upX + _facialSizeWidth> _maxlength )
                {
                    upX = 0;
                    upY += _textlineHeight;
                }
                upX += _facialSizeWidth;
            }
            else
            {
                for ( int index = 0; index < str.length; index++)
                {
                    NSString *character = [str substringWithRange:NSMakeRange(index, 1 )];
                    CGSize size = [character sizeWithFont:font
                                        constrainedToSize:CGSizeMake(_maxlength, _textlineHeight )];
                    if ( upX+size.width> _maxlength )
                    {
                        upX = 0;
                        upY += _textlineHeight;
                    }
                    upX += size.width;
                }
            }
        }
        else
        {
            for ( int index = 0; index < str.length; index++)
            {
                NSString *character = [str substringWithRange:NSMakeRange( index, 1 )];
                CGSize size = [character sizeWithFont:font
                                    constrainedToSize:CGSizeMake(_maxlength, _textlineHeight)];
                if ( upX+size.width > _maxlength )
                {
                    upX = 0;
                    upY += _textlineHeight;
                }
                upX += size.width;
            }
        }
    }
    return upY+_textlineHeight;
}

- (void)dealloc
{
    self.m_comment = nil;
    [super dealloc];
}

@end

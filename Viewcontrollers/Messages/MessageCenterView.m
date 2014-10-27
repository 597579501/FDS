//
//  MessageCenterView.m
//  FDS
//
//  Created by saibaqiao on 14-2-14.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "MessageCenterView.h"
#import "Constants.h"

#define MESSAGEVIEW_LEFT       5.0f
#define KImageSizeWidth        20.0f
#define KImageSizeHeight       20.0f
#define KCharacterWidth        5.0f
#define KCenterMessageWidthMAX 240.0f

@implementation MessageCenterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.contentMessage = nil;
    }
    return self;
}

- (void)showContentMessage:(NSMutableArray*)content
{
    self.contentMessage = content;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	if ( self.contentMessage )
    {
        NSDictionary *faceMap = [[NSUserDefaults standardUserDefaults] objectForKey:@"FaceMap"];
        
        UIFont *font = [UIFont systemFontOfSize:15.0f];
		for (int index = 0; index < [self.contentMessage count]; index++)
        {
			NSString *str = [self.contentMessage objectAtIndex:index];
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
                    if (upX > KCenterMessageWidthMAX-15)
                    {
                        CGContextRef context = UIGraphicsGetCurrentContext();
                        CGContextSetRGBFillColor (context, 127/255.0,127/255.0,127/255.0, 1.0);
                        [@"..." drawInRect:CGRectMake(upX, 4, 15, self.bounds.size.height) withFont:font];
                        CGContextSaveGState(context);
                        CGContextDrawPath(context, kCGPathEOFillStroke);
                        break;
                    }
                    [image drawInRect:CGRectMake(upX, 4, KImageSizeWidth, KImageSizeHeight)];
                    upX += KImageSizeWidth;
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
}


- (void)drawText:(NSString *)string withFont:(UIFont *)font
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor (context, 127/255.0,127/255.0,127/255.0, 1.0);
    for ( int index = 0; index < string.length; index++)
    {
        NSString *character = [string substringWithRange:NSMakeRange( index, 1 )];
        
        CGSize size = [character sizeWithFont:font
                            constrainedToSize:CGSizeMake(KCenterMessageWidthMAX, 30)];
        if (upX > KCenterMessageWidthMAX-15)
        {
            [@"..." drawInRect:CGRectMake(upX, 4, 15, self.bounds.size.height) withFont:font];
            break;
        }
        [character drawInRect:CGRectMake(upX, 4, size.width, self.bounds.size.height) withFont:font];
        upX += size.width;
    }
    CGContextSaveGState(context);
    CGContextDrawPath(context, kCGPathEOFillStroke);
}

- (void)dealloc
{
    self.contentMessage = nil;
    [super dealloc];
}

@end

//
//  UnderLineButton.m
//  GIFT
//
//  Created by zhuozhong on 14-4-4.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "UnderLineButton.h"

@implementation UnderLineButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (UnderLineButton *) underLineButton
{
    UnderLineButton * button = [[UnderLineButton alloc] init];
    return [button autorelease];
}

// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGRect textRect = self.titleLabel.frame;
    
    //need to put the line at top of descenders (negative value)
    CGFloat descender = self.titleLabel.font.descender+2.0f;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    //set to same color as text
    CGContextSetStrokeColorWithColor(contextRef, self.titleLabel.textColor.CGColor);
    
    CGContextMoveToPoint(contextRef, textRect.origin.x, textRect.origin.y + textRect.size.height + descender);
    
    CGContextAddLineToPoint(contextRef, textRect.origin.x + textRect.size.width, textRect.origin.y + textRect.size.height + descender);
    
    CGContextClosePath(contextRef);
    CGContextDrawPath(contextRef, kCGPathStroke);
}

@end

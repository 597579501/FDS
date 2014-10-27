//
//  MyLabel.m
//  UITapGesture
//
//  Created by xuym on 12-11-1.
//  Copyright (c) 2012年 xuym. All rights reserved.
//

#import "MSTouchLabel.h"
#define MyColor [UIColor colorWithRed:32/255.0 green:201.0/255 blue:15.0/255 alpha:1]
@implementation MSTouchLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    // Get bounds
//    CGRect f = self.bounds;
//    CGFloat yOff = f.origin.y + f.size.height - 1.0;
//    // Calculate text width
//    CGSize tWidth = [self.text sizeWithFont:self.font];
//    
//    // Draw underline
//    CGContextRef con = UIGraphicsGetCurrentContext();
//    CGContextSetStrokeColorWithColor(con, MyColor.CGColor);
//    CGContextSetLineWidth(con, 1.0);
//    CGContextMoveToPoint(con, f.origin.x, yOff);
//    CGContextAddLineToPoint(con, f.origin.x + tWidth.width, yOff);
//    CGContextStrokePath(con);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self setTextColor:kMSBtnNormalColor];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setTextColor:[UIColor grayColor]];
    UITouch *touch = [touches anyObject];
    CGPoint points = [touch locationInView:self];
    if (points.x >= 0 && points.y >= 0 && points.x <= self.frame.size.width && points.y <= self.frame.size.height)
    {
        [self.delegate touchesWithLabelTag];
    }
}

@end

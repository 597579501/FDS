//
//  CustomAlertView.m
//  textAlertView
//
//  Created by lv xingtao on 12-10-13.
//  Copyright (c) 2012年 lv xingtao. All rights reserved.
//
#import "CustomAlertView.h"
#import "Constants.h"

#define kAlertViewBounce         20
#define kAlertViewBorder         10
#define kAlertButtonHeight       44

#define kAlertViewTitleFont             [UIFont systemFontOfSize:18]
#define kAlertViewTitleShadowOffset     CGSizeMake(0, -1)

#define kAlertViewMessageFont           [UIFont systemFontOfSize:16]
#define kAlertViewMessageShadowOffset   CGSizeMake(0, -1)

#define kAlertViewButtonFont            [UIFont systemFontOfSize:16]
#define kAlertViewButtonShadowOffset    CGSizeMake(0, -1)

#define kAlertViewBackground            @"alert-window"
#define kAlertViewBackgroundCapHeight   38

@implementation CustomAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

-(void)layoutSubviews
{
    for (UIView *v in self.subviews)
    {
        if ([v isKindOfClass:[UIImageView class]])
        {
            UIImageView *imageV = (UIImageView *)v;
            imageV.image = [[UIImage imageNamed:kAlertViewBackground] stretchableImageWithLeftCapWidth:4 topCapHeight:4];
        }
        if ([v isKindOfClass:[UILabel class]])
        {
            UILabel *label = (UILabel *)v;
            if ([label.text isEqualToString:self.title])
            {
                label.font = kAlertViewTitleFont;
                label.numberOfLines = 1;
//                label.lineBreakMode = NSLineBreakByWordWrapping;
                label.textColor = COLOR(61, 61, 61, 1);
                label.backgroundColor = [UIColor clearColor];
                label.textAlignment = NSTextAlignmentCenter;
//                label.shadowColor = kAlertViewTitleShadowColor;
//                label.shadowOffset = kAlertViewTitleShadowOffset;
            }
            else
            {
                label.font = kAlertViewMessageFont;
                label.numberOfLines = 2;
//                label.lineBreakMode = NSLineBreakByWordWrapping;
                label.textColor = COLOR(61, 61, 61, 1);
                label.backgroundColor = [UIColor clearColor];
                label.textAlignment = NSTextAlignmentCenter;
//                label.shadowColor = kAlertViewTitleShadowColor;
//                label.shadowOffset = kAlertViewMessageShadowOffset;
            }
        }
        if ([v isKindOfClass:NSClassFromString(@"UIAlertButton")])
        {
            UIButton *button = (UIButton *)v;
            if (button.tag == 1)  //取消
            {
                [button setBackgroundImage:[UIImage imageNamed:@"alert_normal_button_gray"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"alert_hl_button_gray"] forState:UIControlStateHighlighted];
                [button setTitleColor:COLOR(61, 61, 61, 1) forState:UIControlStateNormal];
            }
            else //发送
            {
                [button setBackgroundImage:[UIImage imageNamed:@"alert_normal_button_send"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"alert_hl_button_send"] forState:UIControlStateHighlighted];
                [button setTitleColor:[UIColor colorWithWhite:244.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            }
            button.titleLabel.font = kAlertViewButtonFont;
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
//            button.titleLabel.shadowOffset = kAlertViewButtonShadowOffset;
//            button.backgroundColor = [UIColor clearColor];
//            [button setTitleShadowColor:kAlertViewButtonShadowColor forState:UIControlStateNormal];
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

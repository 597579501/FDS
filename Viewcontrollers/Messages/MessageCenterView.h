//
//  MessageCenterView.h
//  FDS
//
//  Created by saibaqiao on 14-2-14.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCenterView : UIView
{
    CGFloat upX;
}


@property(nonatomic,retain) NSMutableArray   *contentMessage;

- (void)showContentMessage:(NSMutableArray*)content;

@end

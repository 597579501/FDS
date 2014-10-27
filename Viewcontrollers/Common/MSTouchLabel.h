//
//  MyLabel.h
//  UITapGesture
//
//  Created by xuym on 12-11-1.
//  Copyright (c) 2012年 xuym. All rights reserved.
//



// two labels of LoggViewController


#import <UIKit/UIKit.h>

@class MSTouchLabel;

@protocol MSTouchLabelDelegate <NSObject>

- (void)touchesWithLabelTag;

@end

@interface MSTouchLabel : UILabel

@property (nonatomic, assign) id<MSTouchLabelDelegate>delegate;

@end

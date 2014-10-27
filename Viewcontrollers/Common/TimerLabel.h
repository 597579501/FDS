//
//  TimerLabel.h
//  SP2P
//
//  Created by Michael on 8/17/13.
//  Copyright (c) 2013 sls001. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TimerLabelDelegate <NSObject>

- (void)comebackaction;

@end

@interface TimerLabel : UILabel
{
    NSTimeInterval  timeInterval;
   
}
@property (nonatomic, retain)  NSTimer         *m_timer;
@property (nonatomic, assign) id<TimerLabelDelegate>delegate;
- (void)updateLabelPerSecondOnBackground:(NSString *)text ;
- (void)invalidTime;

@end

@interface UIImageSize : NSObject {
    
}
+(UIImage *)thumbnailOfImage:(UIImage *)oldImage Size:(CGSize)newSize;
@end

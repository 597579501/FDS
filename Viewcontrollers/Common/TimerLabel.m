//
//  TimerLabel.m
//  SP2P
//
//  Created by Michael on 8/17/13.
//  Copyright (c) 2013 sls001. All rights reserved.
//

#import "TimerLabel.h"

#define kOneDaySeconds (24 * 60 * 60)
#define kOneHourSeconds (60 * 60)
#define kOneMinuteSeconds 60

@implementation TimerLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)invalidTime
{
    if ([self.m_timer isValid])
    {
        //需要设置失效 否则时间未到返回别的页面会crash
        [self.m_timer invalidate];
    }
}

- (void)updateLabelPerSecondOnBackground:(NSString *)text 
{
    timeInterval = [text integerValue];
    self.m_timer = [NSTimer timerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(updateText:)
                                       userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.m_timer forMode:NSRunLoopCommonModes];
}

- (void)updateText:(NSTimer *)timer
{
    timeInterval--;
    if (timeInterval == 0)
    {
        self.text = @"";
        [self.m_timer invalidate];
        [self.delegate comebackaction];
    }
    else
    {
//        self.text = [self getIntervalStringFromTimeInterval];
        self.text = [NSString stringWithFormat:@"接受短信大约需要%@钟",[self getIntervalStringFromTimeInterval]];
    }
}

- (NSString *)getIntervalStringFromTimeInterval
{
    int days = (int)timeInterval / kOneDaySeconds;
    int hours = ((int)timeInterval % kOneDaySeconds) / kOneHourSeconds;
    int minutes = (((int)timeInterval % kOneDaySeconds) % kOneHourSeconds) / kOneMinuteSeconds;
    int seconds = (((int)timeInterval % kOneDaySeconds) % kOneHourSeconds) % kOneMinuteSeconds;
    
    NSString *intervalStr = @"";
    if (days == 0 && hours == 0 && minutes == 0)
    {
        intervalStr = [NSString stringWithFormat:@"%d秒", seconds];
    }
    else
    {
        intervalStr = [NSString stringWithFormat:@"%d天%d小时%d分%d秒",days, hours, minutes, seconds];
    }
    return intervalStr;
}

- (void)dealloc
{
    self.m_timer = nil;
    [super dealloc];
}


@end


@implementation UIImageSize
+(UIImage *)thumbnailOfImage:(UIImage *)oldImage Size:(CGSize)newSize{
	UIGraphicsBeginImageContext(newSize);
	[oldImage drawInRect:CGRectMake(0.0, 0.0, newSize.width, newSize.height)];
	UIImage *newImage  = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}
@end


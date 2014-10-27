//
//  FDSPublicMessageManager.h
//  FDS
//
//  Created by zhuozhong on 13-12-3.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "ZZMessageManager.h"
#import "FDSPublicMessageInterface.h"
#import "ZZSessionManagerInterface.h"
#import "ZZSessionManager.h"
@interface FDSPublicMessageManager : ZZMessageManager<ZZSessionManagerInterface>
{
    NSTimer *m_timer;
}
+(FDSPublicMessageManager*)sharedManager;
-(void)registerObserver:(id<FDSPublicMessageInterface>)observer;
-(void)unRegisterObserver:(id<FDSPublicMessageInterface>)observer;
-(void)getOffLineMessages;
@end

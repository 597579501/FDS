//
//  ZZMessageManager.h
//  ZZFramework
//
//  Created by zhuozhongkeji on 13-10-17.
//  Copyright (c) 2013年 zhuozhongkeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZSessionManagerInterface.h"
#import "ZZSocketInterface.h"

@interface ZZMessageManager : NSObject<ZZSessionManagerInterface,ZZSocketInterface>
{
}

@property (nonatomic,retain) NSMutableArray *observerArray;

-(void)registerMessageManager:(ZZMessageManager*)messageManager :(NSString*)messageClass;
-(void)sendMessage:(NSDictionary*)message;

@end

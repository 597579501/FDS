//
//  FDSPublicManage.h
//  FDS
//
//  Created by zhuozhong on 14-2-14.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDSCollectedInfo.h"

@interface FDSPublicManage : NSObject
{
    NSMutableArray      *collectedArr;  //收藏列表
    
    BOOL                isQueryCollect;//是否查询过收藏表
}

+ (id)sharePublicManager;

- (void)showInfo:(UIView *)view MESSAGE:(NSString*)message;

- (void)getMessageRange:(NSString*)message :(NSMutableArray*)array;

- (NSString *)getNowDate;

- (NSDate*)getDateFromInterval:(NSString*)interval;

- (NSString *)transformDate:(NSString *)dateString;

- (NSString *)getGUID;

- (NSInteger)handleShowContent:(NSString*)contentText :(UIFont*)font :(NSInteger)maxLength;


/* 获取收藏信息 */
- (NSMutableArray*)getCollectedInfo;

/* 获取对应类型收藏数据 */
- (NSMutableArray*)getCollectedDataWithType:(enum FDS_COLLECTED_MESSAGE_TYPE)type;

/* 获取收藏总数 */
- (NSInteger)getCollectedTotal;

- (void)addCollectedWithType:(FDSCollectedInfo*)collectedInfo;
- (void)deleteCollectedWithtype:(FDSCollectedInfo*)collectedInfo;

/*  切换账号 清除缓存操作 */
-(void)handleLogoutAccount;


+ (NSString *)fitSmallWithImage:(UIImage *)image;
+ (CGSize)fitsize:(CGSize)thisSize imageMaxSize:(CGSize)maxSize isSizeFixed:(BOOL)isSizeFixedBool;
+ (BOOL)currentDevice;

@end

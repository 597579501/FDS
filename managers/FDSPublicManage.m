//
//  FDSPublicManage.m
//  FDS
//
//  Created by zhuozhong on 14-2-14.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSPublicManage.h"
#import "sys/utsname.h"
#import "Constants.h"
#import "FDSUserManager.h"
#import "FDSDBManager.h"
#import "UIToastAlert.h"
#import "FDSPathManager.h"

#define IMAGE_MIX_MAX_LENGTH 100

static FDSPublicManage *sharePublicManager = nil;
@implementation FDSPublicManage

+ (id)sharePublicManager
{
    if (sharePublicManager == nil)
    {
        sharePublicManager = [[super allocWithZone:NULL] init];
        [sharePublicManager publicManagerInit];
    }
    return sharePublicManager;
}

- (void)dealloc
{
    [collectedArr removeAllObjects];
    [collectedArr release];
    
    [super dealloc];
}

- (void)publicManagerInit
{
    isQueryCollect = NO; //默认未查询
    collectedArr = [[NSMutableArray alloc] init];
    
    FDSCollectedInfo *collectType = [[FDSCollectedInfo alloc] init];
    collectType.m_collectType = FDS_COLLECTED_MESSAGE_POSTBAR;
    collectType.m_typeIcon = @"postbar_collected_bg";
    collectType.m_typeTitle = @"帖子收藏";
    collectType.m_collectList = [[NSMutableArray alloc] init];
    [collectedArr addObject:collectType];
    [collectType release];

    collectType = [[FDSCollectedInfo alloc] init];
    collectType.m_collectType = FDS_COLLECTED_MESSAGE_COMPANY;
    collectType.m_typeIcon = @"company_collected_bg";
    collectType.m_typeTitle = @"企业收藏";
    collectType.m_collectList = [[NSMutableArray alloc] init];
    [collectedArr addObject:collectType];
    [collectType release];

    collectType = [[FDSCollectedInfo alloc] init];
    collectType.m_collectType = FDS_COLLECTED_MESSAGE_SUCCASE;
    collectType.m_typeIcon = @"succase_collected_bg";
    collectType.m_typeTitle = @"案例收藏";
    collectType.m_collectList = [[NSMutableArray alloc] init];
    [collectedArr addObject:collectType];
    [collectType release];

    collectType = [[FDSCollectedInfo alloc] init];
    collectType.m_collectType = FDS_COLLECTED_MESSAGE_PRODUCT;
    collectType.m_typeIcon = @"product_collected_bg";
    collectType.m_typeTitle = @"产品收藏";
    collectType.m_collectList = [[NSMutableArray alloc] init];
    [collectedArr addObject:collectType];
    [collectType release];

    collectType = [[FDSCollectedInfo alloc] init];
    collectType.m_collectType = FDS_COLLECTED_MESSAGE_DESIGNER;
    collectType.m_typeIcon = @"designer_collected_bg";
    collectType.m_typeTitle = @"设计师收藏";
    collectType.m_collectList = [[NSMutableArray alloc] init];
    [collectedArr addObject:collectType];
    [collectType release];
}

//展示提示信息
- (void)showInfo:(UIView *)view MESSAGE:(NSString*)message
{
//    UIToastAlert *toast = [UIToastAlert toastForMessage:message];
    UIToastAlert *toast = [UIToastAlert shortToastForMessage:message atPosition:UIToastAlertPositionBottom];
    toast._tintColor = [UIColor grayColor];
    [toast show:view];
}

/**
 * 解析输入的文本
 *
 * 根据文本信息分析出哪些是表情，哪些是文字
 */
- (void)getMessageRange:(NSString*)message :(NSMutableArray*)array
{
    NSRange range = [message rangeOfString:FACE_NAME_HEAD];
    
    //判断当前字符串是否存在表情的转义字符串
    if ( range.length > 0 )
    {
        if ( range.location > 0 )
        {
            [array addObject:[message substringToIndex:range.location]];
            message = [message substringFromIndex:range.location];
            if ( message.length > FACE_NAME_LEN )
            {
                [array addObject:[message substringToIndex:FACE_NAME_LEN]];
                message = [message substringFromIndex:FACE_NAME_LEN];
                [self getMessageRange:message :array];
            }
            else if ( message.length > 0 )    // 排除空字符串
            {
                [array addObject:message];
            }
        }
        else  //第一个就是/s得表情字符
        {
            if ( message.length > FACE_NAME_LEN )
            {
                [array addObject:[message substringToIndex:FACE_NAME_LEN]];
                message = [message substringFromIndex:FACE_NAME_LEN];
                [self getMessageRange:message :array];
            }
            else if ( message.length > 0 )// 排除空字符串
            {
                [array addObject:message];
            }
        }
    }
    else
    {
        [array addObject:message];
    }
}

- (NSString *)getNowDate
{
    NSDate *date = [NSDate date];
    NSTimeInterval time = [date timeIntervalSince1970] * 1000;
    long long int temp = (long long int)time;
    NSString *dateString = [NSString stringWithFormat:@"%lld",temp];
    return dateString;
}

- (NSDate*)getDateFromInterval:(NSString*)interval
{
    long long int timeSecs = [interval longLongValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSecs];
    return date;
}

- (NSString *)transformDate:(NSString *)dateString
{
    long long int timeSecs = [dateString longLongValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSecs];
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"MM-dd HH:mm:ss"];
    NSString *dateShort = [formatter stringFromDate:date];
    return dateShort;
}

- (NSString *)getGUID
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(NSString*)uuid_string_ref];
    
    CFRelease(uuid_string_ref);
    return uuid;
}

- (NSInteger)handleShowContent:(NSString*)contentText :(UIFont*)font :(NSInteger)maxLength
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                font, NSFontAttributeName,
                                nil];
    CGSize titleSize;
    if(7.0 == IOS_7)
    {
        titleSize = [contentText sizeWithAttributes:attributes];
    }
    else
    {
        titleSize = [contentText sizeWithFont:font];
    }
    
    NSInteger lineNum = titleSize.width/maxLength;
    if(0 != ((int)titleSize.width)%maxLength)
    {
        lineNum += 1;
    }
    return lineNum;
}


/*  获取收藏信息 获得数据不为空即是登陆成功 */
- (NSMutableArray*)getCollectedInfo
{
    /*   登录成功   以及  还未查询过收藏表信息   */
    if (USERSTATE_LOGIN == [[FDSUserManager sharedManager] getNowUserState] && !isQueryCollect)
    {
        NSMutableArray *tmpInfoArr = [[FDSDBManager sharedManager] getNowUserFromCollectedDB];
        if(tmpInfoArr)
        {
            FDSCollectedInfo *collectInfo = nil;
            for (int i=0; i<tmpInfoArr.count; i++)
            {
                collectInfo = [tmpInfoArr objectAtIndex:i];
                FDSCollectedInfo *cacheInfo = nil;
                for (int j=0; j<collectedArr.count; j++)
                {
                    cacheInfo = [collectedArr objectAtIndex:j];
                    if (collectInfo.m_collectType == cacheInfo.m_collectType)
                    {
                        [cacheInfo.m_collectList addObject:collectInfo];
                        break;
                    }
                }
            }
        }
        
        isQueryCollect = YES;
        return collectedArr;
    }
    /*   未登录成功   或者  还未查询过收藏表信息   */
    else if(USERSTATE_LOGIN != [[FDSUserManager sharedManager] getNowUserState] || !isQueryCollect)
    {
        return nil;
    }
    else
    {
        return collectedArr;
    }
}

/* 获取对应类型收藏数据 */
- (NSMutableArray*)getCollectedDataWithType:(enum FDS_COLLECTED_MESSAGE_TYPE)type
{
    if ([self getCollectedInfo])
    {
        BOOL isFind = NO;
        FDSCollectedInfo *collectedInfo = nil;
        for (int i=0; i<collectedArr.count; i++)
        {
            collectedInfo = [collectedArr objectAtIndex:i];
            if (collectedInfo.m_collectType == type)
            {
                isFind = YES;
                break;
            }
        }
        if (isFind)
        {
            return collectedInfo.m_collectList;
        }
        else
        {
            return nil;
        }
    }
    else
    {
        return nil;
    }
}

/* 获取收藏总数 */
- (NSInteger)getCollectedTotal
{
    /* 未登录成功 */
    NSInteger tempCount = 0;
    if ([self getCollectedInfo])
    {
        FDSCollectedInfo *collectedInfo = nil;
        for (int i=0; i<collectedArr.count; i++)
        {
            collectedInfo = [collectedArr objectAtIndex:i];
            tempCount += collectedInfo.m_collectList.count;
        }
    }
    return tempCount;
}


/*  添加收藏  */
- (void)addCollectedWithType:(FDSCollectedInfo*)collectedInfo
{
    FDSCollectedInfo *cacheInfo = nil;
    for (int i=0;i<collectedArr.count ;i++)
    {
        cacheInfo = [collectedArr objectAtIndex:i];
        if (collectedInfo.m_collectType == cacheInfo.m_collectType)
        {
            [cacheInfo.m_collectList insertObject:collectedInfo atIndex:0];
            break;
        }
    }
}

/*  删除收藏 */
- (void)deleteCollectedWithtype:(FDSCollectedInfo*)collectedInfo
{
    FDSCollectedInfo *cacheInfo = nil;
    for (int i=0;i<collectedArr.count ;i++)
    {
        cacheInfo = [collectedArr objectAtIndex:i];
        if (collectedInfo.m_collectType == cacheInfo.m_collectType)
        {
            FDSCollectedInfo *tempInfo = nil;
            for (int j=0; j<cacheInfo.m_collectList.count; j++)
            {
                tempInfo = [cacheInfo.m_collectList objectAtIndex:j];
                if ([tempInfo.m_collectID isEqualToString:collectedInfo.m_collectID])
                {
                    [cacheInfo.m_collectList removeObjectAtIndex:j];
                    break;
                }
            }
            break;
        }
    }
}

/*  切换账号 清除缓存操作 */
-(void)handleLogoutAccount
{
    isQueryCollect = NO;
    FDSCollectedInfo *cacheInfo = nil;
    for (int i=0;i<collectedArr.count ;i++)
    {
        cacheInfo = [collectedArr objectAtIndex:i];
        [cacheInfo.m_collectList removeAllObjects];
    }
}


//[根据给出的图片尺寸算出新的图片尺寸]
+ (CGSize)fitsize:(CGSize)thisSize imageMaxSize:(CGSize)maxSize isSizeFixed:(BOOL)isSizeFixedBool
{
    CGSize newSize;
    if (isSizeFixedBool == YES)
    {
        //按照width = 640处理
        if (thisSize.width >= thisSize.height)
        {
            CGFloat imageW = 640.0;
            CGFloat imageH = (imageW * thisSize.height)/thisSize.width;
            newSize = CGSizeMake(imageW, imageH);
        }
        else
        {
            CGFloat imageH = 640.0;
            CGFloat imageW = (imageH * thisSize.width)/thisSize.height;
            newSize = CGSizeMake(imageW, imageH);
        }
    }
    else
    {
        if(thisSize.width == 0 && thisSize.height ==0)
            return CGSizeMake(0, 0);
        CGFloat wscale = thisSize.width/maxSize.width;
        CGFloat hscale = thisSize.height/maxSize.height;
        CGFloat scale = (wscale > hscale) ? wscale : hscale;
        newSize = CGSizeMake(thisSize.width/scale, thisSize.height/scale);
    }
    
    return newSize;
}

+ (NSString *)fitSmallWithImage:(UIImage *)image
{
    UIImage *customImage = nil;
    NSString *filePath = [[FDSPathManager sharePathManager] getchatImagePath];
    filePath = [filePath stringByAppendingFormat:@"/%@.jpg",[[FDSPublicManage sharePublicManager] getGUID]];

    if (image)
    {
        customImage = image;
    }
    //若图片不存在直接返回空
    if (customImage == nil)
    {
        return nil;
    }
    CGSize size = [FDSPublicManage fitsize:customImage.size imageMaxSize:CGSizeZero isSizeFixed:YES];
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [customImage drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if ([UIImageJPEGRepresentation(newImage, 1.0) length]/1024 > IMAGE_MIX_MAX_LENGTH)
    {
        NSData  *newImageData = UIImageJPEGRepresentation(newImage, 0.8);
        if(newImageData && [newImageData length]/1024 > IMAGE_MIX_MAX_LENGTH)
        {
            newImage = [UIImage imageWithData:newImageData];
            newImageData = UIImageJPEGRepresentation(newImage, 0.6);
            [newImageData writeToFile:filePath atomically:YES];
            return filePath;
        }
        else
        {
            [newImageData writeToFile:filePath atomically:YES];
            return filePath;
        }
    }
    [UIImageJPEGRepresentation(newImage, 1.0) writeToFile:filePath atomically:YES];
    return filePath;
}


+ (BOOL)currentDevice
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString isEqualToString:@"iPhone4,1"] || [deviceString isEqualToString:@"iPhone5,1"] || [deviceString isEqualToString:@"iPhone5,3"]||[deviceString isEqualToString:@"iPhone5,4"]||[deviceString isEqualToString:@"iPhone6,2"]||[deviceString isEqualToString:@"iPhone6,1"])
    {
        return YES;  //4s 以上设备
    }
    else
    {
        return NO;
    }
}

@end

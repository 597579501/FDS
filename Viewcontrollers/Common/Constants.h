//
//  Constants.h
//  FDS
//
//  Created by zhuozhongkeji on 13-12-20.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#ifndef FDS_Constants_h
#define FDS_Constants_h

#define kMSBtnNormalColor  [UIColor colorWithRed:0/255.0 green:104/255.0 blue:255/255.0 alpha:1]
#define kMSTextColor       [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1]
#define kMSLineColor       [UIColor colorWithRed:237/255.0 green:234/255.0 blue:234/255.0 alpha:1]
#define COLOR(R, G, B, A)  [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#define kMSScreenWith CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#define kMSScreenHeight ((IOS_7) ? CGRectGetHeight([UIScreen mainScreen].bounds) : CGRectGetHeight([UIScreen mainScreen].applicationFrame))

#define kMSGUIDESCREENHEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
//#define SCREEN_HEIGHT  (CGRectGetHeight([UIScreen mainScreen].bounds))
#define IOS_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)

#define kMSNaviHight ((IOS_7) ? 64 : 0)
#define kMSNavigationBarHeight ((IOS_7) ? 0 : 44)
#define kMSTableViewHeight ((IOS_7) ? (kMSScreenHeight-20) : kMSScreenHeight)
#define kMSBarHight ((IOS_7) ? 20 : 0)
#define KFDSTextOffset ((IOS_7) ? 0 : 5)
#define kMSCellOffsetsWidth ((IOS_7) ? 20 : 0)

#define FACE_NAME_HEAD  @"[face"

#define POST_NAME_HEAD @"[post:"
#define POST_NAME_LEN  9

#define DYNAMIC_NAME_HEAD @"[userRecord:"
#define DYNAMIC_NAME_LEN  15

// 表情转义字符的长度（ /s占2个长度，xxx占3个长度，共5个长度 ）
#define FACE_NAME_LEN   8

#endif

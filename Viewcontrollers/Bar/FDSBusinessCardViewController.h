//
//  FDSBusinessCardViewController.h
//  FDS
//
//  Created by zhuozhong on 14-2-28.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSBarMessageManager.h"
#import "FDSCompanyMessageManager.h"

@interface FDSBusinessCardViewController : UIViewController<FDSBarMessageInterface,FDSCompanyMessageInterface>

@property(nonatomic,retain)FDSPosBar         *posBarInfo;

@property(nonatomic,retain)UILabel           *followedNumLab;//关注该帖子人数
@property(nonatomic,retain)UILabel           *posbarNumLab;//帖子数
@property(nonatomic,assign)UIButton          *followBtn; //关注button （用于取消 和 加入）
@property(nonatomic,retain)UIImageView       *followImg;
@property(nonatomic,retain)UILabel           *followLab;
@property(nonatomic,retain)UITextView        *textview;

@end

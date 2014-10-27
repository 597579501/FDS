//
//  ProfileTableViewCell.h
//  FDS
//
//  Created by zhuozhongkeji on 14-1-8.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface ProfileTableViewCell : UITableViewCell

@property(nonatomic,strong)EGOImageView  *logoImg;
@property(nonatomic,strong)UILabel       *titleTextLab;
@property(nonatomic,strong)UIImageView   *detailCellImg;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellIndefy:(BOOL)isAdd;

@end

//*************设置CELL*******************
@interface SettingTableViewCell : UITableViewCell
{
}
@property(nonatomic,strong)UILabel       *titleTextLab;
@property(nonatomic,strong)EGOImageView  *logoImg;
@end


//*************新消息提醒CELL*******************
@protocol MsgSetingListenDelegate <NSObject>

- (void)notifyChageSetingWithTag:(BOOL)status :(NSInteger)currentIndex;

@end

@interface NewMsgSetingTableViewCell : UITableViewCell
{
    
}
@property(nonatomic,assign)NSInteger     currentIndex;
@property(nonatomic,assign)id<MsgSetingListenDelegate> delegate;
@property(nonatomic,strong)UILabel       *titleTextLab;
@property(nonatomic,strong)UISwitch      *onOffSwitch;
@end


//*************解绑定CELL*******************

@protocol UnBindListenDelegate <NSObject>

- (void)notifyUnBindWithTag:(NSInteger)currentIndex;

@end

@interface UnBindTableViewCell : UITableViewCell
{
    
}
@property(nonatomic,assign)NSInteger     unBindTag;
@property(nonatomic,assign)id<UnBindListenDelegate> delegate;

@property(nonatomic,strong)UIImageView   *logoImg;
@property(nonatomic,strong)UILabel       *titleTextLab;
@property(nonatomic,strong)UIButton      *cellBtn;
@end



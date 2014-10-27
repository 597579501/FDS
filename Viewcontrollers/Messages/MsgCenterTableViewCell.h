//
//  MsgCenterTableViewCell.h
//  FDS
//
//  Created by zhuozhong on 14-2-7.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "MessageCenterView.h"
#import "FDSMessageCenter.h"

@interface MsgCenterTableViewCell : UITableViewCell

@property(nonatomic,strong)EGOImageView  *headImg;
@property(nonatomic,strong)UIImageView   *unReadImg;
@property(nonatomic,strong)UILabel       *unReadNum;
@property(nonatomic,strong)UILabel       *nameLab;
@property(nonatomic,strong)UILabel       *timeLab;
@property(nonatomic,strong)MessageCenterView     *contentLab;

@end


@protocol OperFriendDelegate <NSObject>

- (void)didOperWithTag:(NSInteger)currentTag :(NSInteger)withCellIndex;

@end

@interface MsgSystemTableViewCell : UITableViewCell

@property(nonatomic,assign)id<OperFriendDelegate> delegate;

@property(nonatomic, assign)NSInteger           indexTag; //标识当前cell索引

@property(nonatomic,strong)EGOImageView  *headImg;
@property(nonatomic,strong)UILabel       *nameLab;
@property(nonatomic,strong)UILabel       *timeLab;
@property(nonatomic,strong)UILabel       *messageLab;
@property(nonatomic,strong)UILabel       *resultLab; //操作结果

@property(nonatomic,strong)UIButton      *agreeBtn;
@property(nonatomic,strong)UIButton      *rejectBtn;

-(void)loadCellWithData:(FDSMessageCenter*)data withDelegate:(id<OperFriendDelegate>)systemDelegate withCellTag:(NSInteger)tag;

@end




@protocol ContactDetailDelegate <NSObject>

- (void)didUserPressed:(NSInteger)section :(NSInteger)row;

@end

@interface ContactTableViewCell : UITableViewCell

@property(nonatomic,retain)UILabel       *nameLab;
@property(nonatomic,retain)UIButton      *operBtn;

@property(nonatomic,assign) NSInteger    section;
@property(nonatomic,assign) NSInteger    row;

@property(nonatomic,assign)id<ContactDetailDelegate> delegate;

@end

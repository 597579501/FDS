//
//  MessageListCell.h
//  InsurancePlatform
//
//  Created by kangle1208 on 13-12-10.
//  Copyright (c) 2013年 CENTRIN. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "FDSChatMessage.h"
#import "MessageView.h"
#import "EGOImageView.h"


#define MSG_CELL_MIN_HEIGHT 70

#define MSG_VIEW_MIN_HEIGHT 32

@protocol MessageListDelegate <NSObject>

@optional

- (void)didSelectCopy:(NSInteger)currentIndex;

- (void)didSelectDel:(NSInteger)currentIndex;

- (void)didSelectFrdIcon:(NSInteger)currentIndex;

- (void)didSelectDetail:(NSString*)messageID :(NSString*)messageType;
@end

@interface MessageListCell : UITableViewCell<MessageViewDelegate>

@property(nonatomic,assign)NSInteger   currentIndexRow;//当前cell索引
@property(nonatomic,assign)id<MessageListDelegate> delegate;

@property (nonatomic, retain) IBOutlet  EGOImageButton *frdIconView;

@property (nonatomic, retain) IBOutlet EGOImageView *ownIconView;

@property (nonatomic, retain) IBOutlet UILabel *chatTimeLabel;

@property (nonatomic, retain) IBOutlet UIImageView *msgBgView;

@property (nonatomic, retain) IBOutlet MessageView *messageView;

@property(nonatomic,retain)IBOutlet UIActivityIndicatorView *activityView;

- (void)refreshForFrdMsg:(FDSChatMessage *)message withSize:(CGSize)size;

- (void)refreshForOwnMsg:(FDSChatMessage *)message withSize:(CGSize)size;

- (void)setBordRect;

/* 气泡上增加长按弹出菜单 */
- (void)addMenuItemInMessageView;

- (IBAction)btnFrdLogopressed:(id)sender;

@end

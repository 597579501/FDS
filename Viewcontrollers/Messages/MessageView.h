//
//  MessageView.h
//  FaceBoardDome
//
//  Created by kangle1208 on 13-12-12.
//  Copyright (c) 2013年 Blue. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "FDSChatMessage.h"
#import "EGOImageButton.h"

#define KFacialSizeWidth    20.0f

#define KFacialSizeHeight   20.0f

#define KCharacterWidth     8.0f


#define VIEW_LINE_HEIGHT    24.0f

#define VIEW_LEFT           16.0f

#define VIEW_RIGHT          16.0f

#define VIEW_TOP            8.0f


#define VIEW_WIDTH_MAX      166.0f

@protocol MessageViewDelegate <NSObject>

@optional

- (void)didSelectMessage:(NSString*)messageID :(NSString*)messageType;

@end

@interface MessageView : UIView {

    CGFloat upX;

    CGFloat upY;

    CGFloat lastPlusSize;

    CGFloat viewWidth;

    CGFloat viewHeight;

    BOOL isLineReturn;
    
    UIImageView *imageButton; //显示发送image
}

@property(nonatomic,retain) NSString   *messageID;
@property(nonatomic,retain) NSString   *messageType;

@property(nonatomic,assign)id<MessageViewDelegate>  delegate;

@property (nonatomic, retain) FDSChatMessage *chatMsg;


- (void)showMessage:(FDSChatMessage *)message;


@end

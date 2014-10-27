//
//  MessageListCell.m
//  InsurancePlatform
//
//  Created by kangle1208 on 13-12-10.
//  Copyright (c) 2013年 CENTRIN. All rights reserved.
//


#import "MessageListCell.h"


#define MSG_VIEW_LEFT   62

#define MSG_VIEW_RIGHT  258

#define MSG_VIEW_TOP    30

#define MSG_VIEW_BOTTOM 8


@implementation MessageListCell


@synthesize frdIconView, ownIconView, chatTimeLabel, msgBgView, messageView,activityView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setBordRect
{
    if (!ownIconView.image)
    {
        frdIconView.layer.borderWidth = 1;
        frdIconView.layer.cornerRadius = 4.0;
        frdIconView.layer.masksToBounds=YES;
        frdIconView.layer.borderColor = [[UIColor colorWithRed:242.0f/255 green:242.0f/255 blue:242.0f/255 alpha:1.0f] CGColor];
    }
    else
    {
        ownIconView.layer.borderWidth = 1;
        ownIconView.layer.cornerRadius = 4.0;
        ownIconView.layer.masksToBounds=YES;
        ownIconView.layer.borderColor = [[UIColor colorWithRed:242.0f/255 green:242.0f/255 blue:242.0f/255 alpha:1.0f] CGColor];
    }
}

/* 气泡上增加长按弹出菜单 */
- (void)addMenuItemInMessageView
{
    UIMenuItem *copyMenuItem = [[UIMenuItem alloc] initWithTitle:@"拷贝" action:@selector(chatCopy:)];
    UIMenuItem *deleteMenuItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteChat:)];
    [[UIMenuController sharedMenuController] setMenuItems: @[copyMenuItem,deleteMenuItem]];
    [copyMenuItem release];
    [deleteMenuItem release];
    //    [[UIMenuController sharedMenuController] update];
    
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:recognizer];
    [recognizer release];
}


- (void)longPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        MessageListCell *cell = (MessageListCell *)recognizer.view;
        [cell becomeFirstResponder];
        
        [[UIMenuController sharedMenuController] setTargetRect:cell.frame inView:cell.superview];
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return (action == @selector(chatCopy:) || action == @selector(deleteChat:));
}

- (void)chatCopy:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didSelectCopy:)])
    {
        [self.delegate didSelectCopy:_currentIndexRow];
    }
}

- (void)deleteChat:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didSelectDel:)])
    {
        [self.delegate didSelectDel:_currentIndexRow];
    }
}

- (IBAction)btnFrdLogopressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didSelectFrdIcon:)])
    {
        [self.delegate didSelectFrdIcon:_currentIndexRow];
    }
}

- (void)refreshForOwnMsg:(FDSChatMessage *)message withSize:(CGSize)size
{
//    ownIconView.placeholderImage = [UIImage imageNamed:@"headphoto_s"];
//    ownIconView.imageURL = [NSURL URLWithString:message.m_senderIcon];
    [ownIconView initWithPlaceholderImage:[UIImage imageNamed:@"headphoto_s"]];
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@",message.m_senderIcon];
    if (urlStr.length >= 4)
    {
        [urlStr insertString:@"_middle" atIndex:urlStr.length-4];
    }
    ownIconView.imageURL = [NSURL URLWithString:urlStr];

    frdIconView.hidden = YES;
    if (CHAT_MESSAGE_SHOW_TIP == message.m_showtime)
    {
        /*  时间戳转时间  */
        NSTimeInterval timeValue = [message.m_chatTime doubleValue];
        NSDate *confromTime = [NSDate dateWithTimeIntervalSince1970:timeValue/1000];
        NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"MM-dd HH:mm:ss"];
        chatTimeLabel.text = [formatter stringFromDate:confromTime];
    }
    else
    {
        chatTimeLabel.text = nil;
    }

    CGRect frame = messageView.frame;
    frame.origin.x = MSG_VIEW_RIGHT - size.width;
    frame.size = size;
    
    msgBgView.frame = frame;
    msgBgView.image = [[UIImage imageNamed:@"chat_bg_own"]
                         resizableImageWithCapInsets:UIEdgeInsetsMake( 23, 23, 7, 23 )];
    
    frame.origin.x -= 2;
    messageView.frame = frame;
    if (size.width >= VIEW_WIDTH_MAX + VIEW_LEFT)
    {
        frame.origin.x -= 3;
        messageView.frame = frame;
    }
    
    CGPoint center = activityView.center;
    center.y = msgBgView.frame.size.height/2;
    frame = activityView.frame;
    frame.origin.x = msgBgView.frame.origin.x - 5 - frame.size.width;
    activityView.center = center;
    activityView.frame = frame;
    if (MSG_STATE_SENDING == message.m_send_state)
    {
        [activityView setHidden:NO];
        [activityView startAnimating];
    }
    else
    {
        [activityView stopAnimating];
        [activityView setHidden:YES];
    }
    messageView.delegate = self;
    [messageView showMessage:message];
}

- (void)refreshForFrdMsg:(FDSChatMessage *)message withSize:(CGSize)size
{
    ownIconView.image = nil;
    frdIconView.hidden = NO;
//    frdIconView.placeholderImage = [UIImage imageNamed:@"headphoto_s"];
//    frdIconView.imageURL = [NSURL URLWithString:message.m_senderIcon];
    [frdIconView initWithPlaceholderImage:[UIImage imageNamed:@"headphoto_s"]];
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@",message.m_senderIcon];
    if (urlStr.length >= 4)
    {
        [urlStr insertString:@"_middle" atIndex:urlStr.length-4];
    }
    frdIconView.imageURL = [NSURL URLWithString:urlStr];

    if (CHAT_MESSAGE_SHOW_TIP == message.m_showtime)
    {
        NSTimeInterval timeValue = [message.m_chatTime doubleValue];
        NSDate *confromTime = [NSDate dateWithTimeIntervalSince1970:timeValue/1000];
        NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"MM-dd HH:mm:ss"];
        chatTimeLabel.text = [formatter stringFromDate:confromTime];
    }
    else
    {
        chatTimeLabel.text = nil;
    }

    CGRect frame = messageView.frame;
    frame.origin.x = MSG_VIEW_LEFT;
    frame.size = size;

    msgBgView.frame = frame;
    msgBgView.image = [[UIImage imageNamed:@"chat_bg_frd"]
                         resizableImageWithCapInsets:UIEdgeInsetsMake( 23, 23, 7, 23 )];
    frame.origin.x += 3;
    messageView.frame = frame;
    if (size.width >= VIEW_WIDTH_MAX + VIEW_LEFT)
    {
        frame.origin.x -= 2;
        messageView.frame = frame;
    }
    [activityView setHidden:YES];
    messageView.delegate = self;
    [messageView showMessage:message];
}


- (void)didSelectMessage:(NSString *)messageID :(NSString *)messageType
{
    if ([self.delegate respondsToSelector:@selector(didSelectDetail::)])
    {
        [self.delegate didSelectDetail:messageID :messageType];
    }
}

- (void)dealloc
{
    [frdIconView release];
    [ownIconView release];
    [chatTimeLabel release];
    [messageView release];
    [activityView release];
    [super dealloc];
}

@end

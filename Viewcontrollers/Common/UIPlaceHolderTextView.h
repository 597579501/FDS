//
//  UIPlaceHolderTextView.h
//  SP2P
//
//  Created by Michael on 8/23/13.
//  Copyright (c) 2013 sls001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor  *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end

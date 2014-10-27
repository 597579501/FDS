//
//  DropDownView.h
//  TicketProject
//
//  Created by sls002 on 13-7-12.
//  Copyright (c) 2013年 sls002. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropDownViewDelegate <NSObject>

-(void)dropItemDidSelectedText:(NSString *)text AtIndex:(NSInteger)index;

@end

@interface DropDownView : UIView
{
    UIImageView *selectedView;
}

@property (nonatomic,retain) NSArray *items;
@property (nonatomic,assign) id<DropDownViewDelegate> delegate;
@property (nonatomic,assign) NSInteger   selectIndex;

-(id)initWithFrame:(CGRect)frame Items:(NSArray *)array;

-(void)show;
-(void)hide;

@end

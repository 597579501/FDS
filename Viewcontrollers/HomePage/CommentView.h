//
//  CommentView.h
//  FDS
//
//  Created by zhuozhong on 14-2-25.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentView : UIView
{
    CGFloat upX;
    
    CGFloat upY;
    
    CGFloat viewWidth;
    
    CGFloat viewHeight;
}

@property(nonatomic,retain) NSMutableArray  *m_comment;

@property(nonatomic,assign) BOOL        changeColor;
@property(nonatomic,assign) NSInteger   maxlength;
@property(nonatomic,assign) NSInteger   facialSizeWidth;
@property(nonatomic,assign) NSInteger   facialSizeHeight;
@property(nonatomic,assign) NSInteger   textlineHeight;// 单行字符高度

@property(nonatomic,assign) CGFloat   fontSize; //对应字体尺寸

- (void)showMessage:(NSString *)commentMessage;
- (CGFloat)getcurrentViewHeight:(NSString*)commentMessage;

@end

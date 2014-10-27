//
//  ProductTableViewCell.h
//  FDS
//
//  Created by zhuozhongkeji on 13-12-27.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
@interface ProductTableViewCell : UITableViewCell

@property(nonatomic,strong) EGOImageView *productImg;
@property(nonatomic,strong) UILabel      *productName;

@property(nonatomic,strong) UILabel      *tmpLab;
@property(nonatomic,strong) UILabel      *productPrice;
@property(nonatomic,strong) UILabel      *productStyle;

@end

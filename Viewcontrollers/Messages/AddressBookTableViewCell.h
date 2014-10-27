//
//  AddressBookTableViewCell.h
//  FDS
//
//  Created by zhuozhong on 14-2-17.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "FDSUser.h"

@interface AddressBookTableViewCell : UITableViewCell

@property(nonatomic,strong)EGOImageView  *headImg;
@property(nonatomic,strong)UILabel       *nameLab;
@property(nonatomic,strong)UIImageView   *cellImg;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier addCellIndentify:(BOOL)add;

@end



/* 好友搜索结果cell */
@interface SearchResultTableViewCell : UITableViewCell

@property(nonatomic,strong)EGOImageView  *headImg;
@property(nonatomic,strong)UILabel       *nameLab;
@property(nonatomic,strong)UIImageView   *sexImg;
@property(nonatomic,strong)UILabel       *companyLab;
@property(nonatomic,strong)UILabel       *jobLab;

-(void)loadCellWithData:(FDSUser*)data;

@end

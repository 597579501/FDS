//
//  SchemeTableViewCell.h
//  FDS
//
//  Created by zhuozhongkeji on 14-1-6.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

typedef NS_ENUM(NSInteger, UIDesignerDetailCellType)//页面样式类型
{
    UIDesignerDetailDefault = 0, //默认只有两段文本类型
    UIDesignerDetailIndicator,   //包括两段文本类型和箭头标示
    UIDesignerDetailImg,         //包括两段文本 文本后带icon 并有箭头标
    UIDesignerDetailOther
};

@protocol SchemeDetailDelegate <NSObject>

- (void)handleDetailWithIndex:(NSInteger)currIndex;

@end

@interface SchemeTableViewCell : UITableViewCell

@property(nonatomic,assign)id<SchemeDetailDelegate> delegate;
@property(nonatomic,strong)EGOImageView   *schemeLogoImg;
@property(nonatomic,strong)UILabel       *schemeNameLab;
@property(nonatomic,assign)NSInteger     currentIndex;
@end

@interface DesignerTableViewCell : UITableViewCell

@property(nonatomic,strong)EGOImageView  *designerImg;
@property(nonatomic,strong)UILabel       *designerNameLab;
@property(nonatomic,assign)UILabel       *professionLab;
@end

@interface DesignerDetailTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel       *detailKeyLab;
@property(nonatomic,strong)UILabel       *detailValueLab;
@property(nonatomic,strong)UIImageView   *detailCellImg;

@property(nonatomic,strong)UIImageView   *appendImg; //文本后面追加img
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellIndefy:(UIDesignerDetailCellType)type;
-(void)loadCellWithData:(NSString*)data;

@end


@interface CommonHeaderTableViewCell : UITableViewCell
{
    NSString *urlStr;
}
@property(nonatomic,strong)UIImageView        *bgImg;
@property(nonatomic,strong)UIImageView        *headPhotoImg;
@property(nonatomic,strong)UILabel            *nameLab;
@property(nonatomic,strong)UIImageView        *sexImg;
@property(nonatomic,strong)UILabel            *detailLab;
@property(nonatomic,strong)UIImageView        *detailImg;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isAppend:(BOOL)append isPlat:(BOOL)plat;

- (void)loadImgView:(NSString*)imageURL;

-(void)loadCellFrame:(NSString*)withName withDetail:(NSString*)detail;


@end

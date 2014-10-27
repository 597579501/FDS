//
//  FDSComProduct.h
//  FDS
//
//  Created by zhuozhongkeji on 14-1-17.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDSComProduct : NSObject

@property(nonatomic,retain) NSString  *m_protypeID;    //产品分类ID
@property(nonatomic,retain) NSString  *m_protypeName;  //产品分类名
@property(nonatomic,retain) NSString  *m_proName;      //产品名字
@property(nonatomic,retain) NSString  *m_proIcon;      //产品icon
@property(nonatomic,retain) NSString  *m_productID;    //产品id
@property(nonatomic,retain) NSString  *m_storeNumber;  //
@property(nonatomic,retain) NSString  *m_saleNumber;  //
@property(nonatomic,retain) NSString  *m_briefInfo;    //产品简介
@property(nonatomic,retain) NSString  *m_price;        //产品价格
@property(nonatomic,retain) NSString  *m_browserNumber;//产品浏览量
@property(nonatomic,retain) NSString  *m_postage;      //产品是否包邮 yes,包邮，no不包邮

@property(nonatomic,retain) NSMutableArray   *m_imagePathArr;
@property(nonatomic,retain) NSString  *m_sharedLink;    //产品分享


@property(nonatomic,assign) BOOL      suc_productList;
@property(nonatomic,retain) NSMutableArray   *m_modulesArr;  //更多产品列表信息
@end

//
//  FDSComProduct.m
//  FDS
//
//  Created by zhuozhongkeji on 14-1-17.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "FDSComProduct.h"

@implementation FDSComProduct

- (void)dealloc
{
    self.m_protypeID = nil;    //产品分类ID
    self.m_protypeName = nil;  //产品分类名
    self.m_proName = nil;      //产品名字
    self.m_proIcon = nil;      //产品icon
    self.m_productID = nil;    //产品id
    self.m_storeNumber = nil;  //
    self.m_saleNumber = nil;   //
    self.m_briefInfo = nil;    //产品icon
    self.m_price = nil;        //产品价格
    self.m_sharedLink = nil;
    [self.m_modulesArr removeAllObjects];
    self.m_modulesArr = nil;
    self.m_browserNumber = nil;
    self.m_postage = nil;
    [self.m_imagePathArr removeAllObjects];
    self.m_imagePathArr = nil;
    
    [super dealloc];
}

@end

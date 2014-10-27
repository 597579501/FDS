//
//  FDSMapViewController.h
//  FDS
//
//  Created by zhuozhongkeji on 13-12-24.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface FDSMapViewController : UIViewController<BMKMapViewDelegate>
{
    BMKPointAnnotation* annotation;
    BMKMapView* mapView;
}

@property(nonatomic,assign) CLLocationCoordinate2D   center;
@property(nonatomic,retain) NSString                 *address;
@end

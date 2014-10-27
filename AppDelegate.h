//
//  AppDelegate.h
//  FDS
//
//  Created by Naval on 13-12-3.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BMKMapManager;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>
{
    BMKMapManager   *_mapManager;
    UITabBarItem    *item3;
}
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,retain) UITabBarController *tabBarController;

@end

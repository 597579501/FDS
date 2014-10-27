//
//  AppDelegate.m
//  FDS
//
//  Created by Naval on 13-12-3.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "AppDelegate.h"
#import "BMapKit.h"
#import "FDSHomePageNavViewController.h"
#import "FDSBarNavViewController.h"
#import "FDSMessagesNavViewController.h"
#import "FDSUserCenerNavViewController.h"
#import "ZZDownloadManager.h"
#import "UINavigationBar+MSExtension.h"
#import "ZZSessionManager.h"
#import "UMSocial.h"

#import "FDSUserManager.h"
#import "FDSUserCenterMessageManager.h"
#import "FDSCompanyMessageManager.h"
#import "FDSPathManager.h"
#import "FDSDBManager.h"
#import "FDSPushManager.h"
#import "ZZUserDefaults.h"
#import "FDSGuideViewController.h"
#import "FDSPublicMessageManager.h"
#import "Constants.h"
#import "ZZSharedManager.h"

@implementation AppDelegate

/*  system start */
-(void)systemInit
{
    [ZZSessionManager sharedSessionManager];
    
    [FDSUserCenterMessageManager sharedManager];//用户消息模块初始化
    [FDSCompanyMessageManager sharedManager];
    [FDSBarMessageManager sharedManager];
    
    [FDSPublicMessageManager sharedManager];
    
    [FDSUserManager sharedManager ];// 用户管理器初始化
    
    [FDSPathManager sharePathManager];
    [FDSDBManager sharedManager];
    [FDSPushManager sharePushManager];
    [self registerPushService];
    [[ZZSessionManager sharedSessionManager] createSessionConnect];
    
    [ZZSharedManager shareManager];
}

- (void)dealloc
{
    if (_mapManager)
    {
        [_mapManager stop];
        [_mapManager release];
    }
    [item3 release];
    [_window release];
    [super dealloc];
}

- (void)addMessageCountMark
{
    if (_tabBarController.selectedIndex!=2)
    {
        [item3 setFinishedSelectedImage:[UIImage imageNamed:@"tabBar_meaasge_select_bg"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabBar_meaasge_normal_active_bg"]];
    }
}

- (void)removeMessageCountMark
{
    [item3 setFinishedSelectedImage:[UIImage imageNamed:@"tabBar_meaasge_select_bg"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabBar_meaasge_normal_bg"]];
}

- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMessageCountMark) name:SYSTEM_NOTIFICATION_TAB_MESSAGE_ADD_MARK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeMessageCountMark) name:SYSTEM_NOTIFICATION_TAB_MESSAGE_SUB_MARK object:nil];
}

- (void)navBarInit:(UINavigationBar*)navbar
{
    UIImage *backgroundImage = [UIImage imageNamed:@"bg_navbar"];
    if (IOS_7)
    {
        [navbar setTranslucent:YES];
    }
    else
    {
        backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:5 topCapHeight:6];
    }
    [navbar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
}

- (void)addTabViewControllers
{
    _tabBarController = [[UITabBarController alloc] init];
    
    FDSHomePageNavViewController * homePageNav = [[FDSHomePageNavViewController alloc] init];
    [self navBarInit:homePageNav.navigationBar];
    
	FDSBarNavViewController * barNav = [[FDSBarNavViewController alloc] init];
    [self navBarInit:barNav.navigationBar];

    FDSMessagesNavViewController * messageNav = [[FDSMessagesNavViewController alloc] init];
    [self navBarInit:messageNav.navigationBar];

    FDSUserCenerNavViewController *userCenterNav = [[FDSUserCenerNavViewController alloc] init];
    [self navBarInit:userCenterNav.navigationBar];

	NSArray * viewControllers = [[[NSArray alloc] initWithObjects:homePageNav,barNav,messageNav,userCenterNav,nil] autorelease];
	_tabBarController.viewControllers = viewControllers;
    [viewControllers release];

    UIImageView *tab_imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabBar_bg"]];
    tab_imgv.frame = CGRectMake(0,0,320,49);
    tab_imgv.contentMode = UIViewContentModeScaleToFill;
    [[_tabBarController tabBar] insertSubview:tab_imgv atIndex:1];
    [tab_imgv release];
    
    if (IOS_7)
    {
        _tabBarController.tabBar.translucent = NO;
    }
    
    /*  替换阴影选中为半透明 */
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"fds_custom_bg"]];

    [_tabBarController.tabBar setClipsToBounds:YES];
	_tabBarController.delegate = self;
    
    UITabBarItem *item1 = [[[UITabBarItem alloc] initWithTitle:nil image:nil tag:0] autorelease];
    [item1 setFinishedSelectedImage:[UIImage imageNamed:@"tabBar_homepage_select_bg"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabBar_homepage_normal_bg"]];
    item1.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0);
    homePageNav.tabBarItem = item1;
    
    UITabBarItem *item2 = [[[UITabBarItem alloc] initWithTitle:nil image:nil tag:1] autorelease];
    [item2 setFinishedSelectedImage:[UIImage imageNamed:@"tabBar_homebar_select_bg"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabBar_homebar_normal_bg"]];
    item2.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0);
    barNav.tabBarItem = item2;
    
    item3 = [[[UITabBarItem alloc] initWithTitle:nil image:nil tag:2] autorelease];
    [item3 setFinishedSelectedImage:[UIImage imageNamed:@"tabBar_meaasge_select_bg"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabBar_meaasge_normal_bg"]];
    item3.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0);
    messageNav.tabBarItem = item3;
    
    UITabBarItem *item4 = [[[UITabBarItem alloc] initWithTitle:nil image:nil tag:3] autorelease];
    [item4 setFinishedSelectedImage:[UIImage imageNamed:@"tabBar_meprofile_select_bg"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabBar_meprofile_normal_bg"]];
    item4.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0);
    userCenterNav.tabBarItem = item4;

    [item1 release]; [item2 release]; [item4 release];
    [homePageNav release];  [barNav release];  [messageNav release];  [userCenterNav release];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self systemInit];
    [self registerNotifications];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.

    
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"9ZWTBNwG9g07hGXrYSLG34cb"  generalDelegate:nil];
    if (!ret)
    {
        NSLog(@"manager start failed!");
    }
    
    [self addTabViewControllers];
    NSString *firstRun = [ZZUserDefaults getUserDefault:ISFIRSTRUN];
    if (firstRun == nil)
    {
        [ZZUserDefaults setUserDefault:ISFIRSTRUN :@"YES"];
        FDSGuideViewController *guideVC = [[FDSGuideViewController alloc] init];
        guideVC.isFirstLunch = YES;
        [self.window addSubview:guideVC.view];
        self.window.rootViewController = guideVC;
        [guideVC release];
    }
    else
    {
        [self.window addSubview:_tabBarController.view];
        self.window.rootViewController=_tabBarController;
        [_tabBarController release];
    }
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
//    [[ZZDownloadManager sharedManager ] startDownloadRequest:[NSURL URLWithString:@"http://www.zhuozhongkeji.com/images/mycom/201310303425.png"] :nil];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

//处理微信和新浪微博客户端的回调
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[ZZSessionManager sharedSessionManager] distroySessionConnect];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[ZZSessionManager sharedSessionManager] createSessionConnect];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UMSocialSnsService  applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
/*   push  */
- (void)registerPushService
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if( [userDefault objectForKey:@"deviceToken"] == nil)
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *newToken = [deviceToken description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@"" ];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:newToken forKey:@"deviceToken"];
    
    [userDefault synchronize];

}

@end

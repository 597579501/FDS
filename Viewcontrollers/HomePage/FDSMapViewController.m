//
//  FDSMapViewController.m
//  FDS
//
//  Created by zhuozhongkeji on 13-12-24.
//  Copyright (c) 2013年 zhuozhong. All rights reserved.
//

#import "FDSMapViewController.h"
#import "UIViewController+BarExtension.h"
#import "Constants.h"

@interface FDSMapViewController ()

@end

@implementation FDSMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    if (mapView)
    {
        [mapView release];
        mapView = nil;
    }
    [_address release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    // 添加一个PointAnnotation
    annotation= [[BMKPointAnnotation alloc]init];
	annotation.coordinate = _center;
	annotation.title = @"具体位置";
	annotation.subtitle = _address;
	[mapView addAnnotation:annotation];
    
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(_center, BMKCoordinateSpanMake(0.05, 0.05));
    BMKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [mapView setRegion:adjustedRegion animated:YES];
    
    [mapView setShowsUserLocation:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [mapView viewWillAppear];
    mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [mapView removeAnnotation:annotation];
    [mapView viewWillDisappear];
    mapView.delegate = nil; // 不用时，置nil
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self homeNavbarWithTitle:@"位置定位" andLeftButtonName:@"btn_caculate" andRightButtonName:nil];
    mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0,kMSNaviHight , kMSScreenWith , kMSTableViewHeight-44)];
    self.view = mapView;
	// Do any additional setup after loading the view.
}


// Override
#pragma -mark BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)_annotation
{
	if ([_annotation isKindOfClass:[BMKPointAnnotation class]])
    {
		BMKPinAnnotationView *newAnnotation = [[[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"] autorelease];
		newAnnotation.pinColor = BMKPinAnnotationColorPurple;
		newAnnotation.animatesDrop = YES;
		newAnnotation.draggable = NO;
        [newAnnotation setSelected:YES animated:YES];
		return newAnnotation;
	}
	return nil;
}

// Overrides
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    NSLog(@"paopaoclick");
}

@end

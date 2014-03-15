//
//  MapViewController.h
//  Shutterbug
//
//  Created by Weiwei Shi on 3/13/14.
//  Copyright (c) 2014 weiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class MapViewController;

@protocol MapViewControllerDelegate <NSObject>

- (UIImage *)mapViewController:(MapViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation;

@end

@interface MapViewController : UIViewController

@property (nonatomic, strong) NSArray *annotations;
@property (nonatomic, weak) id <MapViewControllerDelegate> delegate;

@end

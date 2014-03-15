//
//  FlickrPhotoAnnotation.h
//  Shutterbug
//
//  Created by Weiwei Shi on 3/13/14.
//  Copyright (c) 2014 weiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FlickrPhotoAnnotation : NSObject <MKAnnotation>

+ (FlickrPhotoAnnotation *)annotationForPhoto:(NSDictionary *)photo;

@property (nonatomic, strong) NSDictionary *photo;

@end

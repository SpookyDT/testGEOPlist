//
//  LocationAnnotation.h
//  EBGeolocationTest
//
//  Created by Spooky on 4.8.15.
//  Copyright (c) 2015 Spooky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LocationAnnotation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

@end

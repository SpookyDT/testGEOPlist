//
//  MapViewController.m
//  EBGeolocationTest
//
//  Created by Spooky on 4.8.15.
//  Copyright (c) 2015 Spooky. All rights reserved.
//

#import "MapViewController.h"
#import "LocationAnnotation.h"

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Map";
    
    // Do any additional setup after loading the view, typically from a nib.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Logs" ofType:@"plist"];
    NSMutableArray *logs = [[NSMutableArray alloc] initWithContentsOfFile:path];
    NSMutableArray *annotations = [NSMutableArray new];
    for (NSDictionary *dictionary in logs)
    {
        if (dictionary[@"Location"])
        {
            NSString *locationString = dictionary[@"Location"];
            NSArray *components = [locationString componentsSeparatedByString:@"\n"];
            NSString *latitudeString = [components[0] stringByReplacingOccurrencesOfString:@"latitude " withString:@""];
            NSString *longitudeString = [components[1] stringByReplacingOccurrencesOfString:@"longitude " withString:@""];
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([latitudeString doubleValue], [longitudeString doubleValue]);
            NSString *title = dictionary[@"Event"];
            LocationAnnotation *la = [[LocationAnnotation alloc] init];
            la.coordinate = coordinate;
            la.title = title;
            la.subtitle = [NSString stringWithFormat:@"%@", (NSDate *)dictionary[@"Time"]];
            [annotations addObject:la];
        }
    }
    
    [self.mapView addAnnotations:annotations];

    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    [self.mapView setVisibleMapRect:zoomRect animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    LocationAnnotation *la = (LocationAnnotation *)annotation;
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    //NSLog(@"%@", la.title);
    if ([la.title isEqualToString:@"EventTypeLocationSubmitFailed"])
        pin.pinColor = MKPinAnnotationColorRed;
    else
        pin.pinColor = MKPinAnnotationColorGreen;
    [pin setCanShowCallout:YES];
    return pin;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

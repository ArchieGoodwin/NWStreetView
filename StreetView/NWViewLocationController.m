//
//  WPViewLocationController.m
//  WP4square
//
//  Created by Sergey Dikarev on 8/19/12.
//  Copyright (c) 2012 Sergey Dikarev. All rights reserved.
//

#import "NWViewLocationController.h"
#import <MapKit/MapKit.h>
#import "MapAnnotation.h"
#import "STImageAnnotationView.h"
#import "NWmanager.h"
@interface NWViewLocationController ()

@end

@implementation NWViewLocationController
@synthesize location;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    isMapShown = NO;

    NWmanager *wp = [[NWmanager alloc] init];


    NSDictionary *dict = [wp createDict:@"Apple" lat:37.3323314100 lng:-122.0312186000];
    self.location = dict;
    
    
    lblTitle.text = [location objectForKey:@"name"];


    [self addAnnotationsToMap];

    [self checkStreetView];
    [super viewDidLoad];
}


-(void)checkStreetView
{
    
    //[self loadWebView];
    NWViewLocationController *controller = self;
    NWmanager *wp = [[NWmanager alloc] init];
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake([[location objectForKey:@"latitude"] doubleValue], [[location objectForKey:@"longitude"] doubleValue]);

    [wp isStreetViewAvailable:loc completionBlock:^(NSString *res, NSError *error) {
        
        if(!error)
        {
            if(res)
            {
                [controller loadWebView:res];
            }
            else
            {
                [controller btnSwitchMap:nil];
                btnSwitch.hidden = YES;
                webView.hidden = YES;
            }

        }
        else
        {
            [controller btnSwitchMap:nil];
        }
        
    }];
}




-(void)loadWebView:(NSString *)panoIdOfPlace
{
    NSString *urlGoogle = [NSString stringWithFormat:@"http://maps.google.com/maps?layer=c&cbp=0,,,,30&panoid=%@", panoIdOfPlace];
       
    NSLog(@"urlGoogle = %@", urlGoogle);
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlGoogle];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [webView loadRequest:requestObj];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{

    

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"web error: %@", [error description]);
}



#pragma mark Map methods

- (void)centerMap2{
    
    if([mapView.annotations count] == 0)
        return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(id <MKAnnotation> annotation in mapView.annotations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = 0.001; // Add a little extra space on the sides
    region.span.longitudeDelta = 0.001; // Add a little extra space on the sides
    
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
    
}

-(void)addAnnotationsToMap
{
    for(MapAnnotation *m in mapView.annotations)
    {
        if(![m isKindOfClass:[MKUserLocation class]])
        {
            [mapView removeAnnotation:m];
        }
    }
    

            
            
    CLLocationDegrees longitude = [[location objectForKey:@"longitude"] doubleValue];
    CLLocationDegrees latitude = [[location objectForKey:@"latitude"] doubleValue];
    CLLocationCoordinate2D placeLocation;
    placeLocation.latitude = latitude;
    placeLocation.longitude = longitude;
    
    
    
    MapAnnotation *m = [[MapAnnotation alloc] initWithUser:placeLocation name:[location objectForKey:@"name"] annotationType:WPMapAnnotationCategoryImage];

    [mapView addAnnotation:m];


    
    
}


-(IBAction)btnSwitchMap:(id)sender
{
    if(isMapShown)
    {
        //show street view on full screen
        mapView.frame = CGRectMake(235, 360, 75, 75);
        webView.frame = CGRectMake(0, 43, 320, 416);
        [self.view bringSubviewToFront:mapView];
        [self.view bringSubviewToFront:btnSwitch];
        isMapShown = NO;
        
    }
    else
    {
        //show map on full screen
        mapView.frame = CGRectMake(0, 43, 320, 416);
        webView.frame = CGRectMake(235, 360, 75, 75);
        [self.view bringSubviewToFront:webView];
        [self.view bringSubviewToFront:btnSwitch];
        isMapShown = YES;
    }
}

-(void)mapView:(MKMapView *)mapView1 didAddAnnotationViews:(NSArray *)views
{
    [self centerMap2];
}

- (MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id<MKAnnotation>)a
{
    MKAnnotationView* annotationView = nil;
    
    NSString* identifier = @"Image";
    
    STImageAnnotationView* imageAnnotationView = (STImageAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if(nil == imageAnnotationView)
    {
        imageAnnotationView = [[STImageAnnotationView alloc] initWithAnnotation:a reuseIdentifier:identifier];
        
    }
    
    annotationView = imageAnnotationView;

    annotationView.canShowCallout = YES;
    //UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //[detailButton addTarget:self action:@selector(loadWebView) forControlEvents:UIControlEventTouchUpInside];
    //annotationView.rightCalloutAccessoryView = detailButton;
    annotationView.calloutOffset = CGPointMake(0, 4);
    annotationView.centerOffset =  CGPointMake(0, -20);
    return annotationView;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

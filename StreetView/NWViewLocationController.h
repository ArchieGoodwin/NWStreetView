//
//  WPViewLocationController.h
//  WP4square
//
//  Created by Sergey Dikarev on 8/19/12.
//  Copyright (c) 2012 Sergey Dikarev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface NWViewLocationController : UIViewController <MKMapViewDelegate, UIWebViewDelegate>
{
    NSDictionary *location;
    IBOutlet  MKMapView * mapView;
    IBOutlet UIWebView *webView;
    BOOL isMapShown;
    IBOutlet UIButton *btnSwitch;
    IBOutlet UILabel *lblTitle;
}
@property (nonatomic, retain) NSDictionary *location;
@end

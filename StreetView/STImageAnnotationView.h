//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface STImageAnnotationView : MKAnnotationView
{
	UIImageView* _imageView;
}

@property (nonatomic, retain) UIImageView* imageView;
@end


//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef enum {

	WPMapAnnotationCategoryImage = 0
} WPMapAnnotationType;

@interface MapAnnotation : NSObject<MKAnnotation> {
@private
	NSString * title;
	NSString * subtitle;
	NSInteger tag;
	CLLocationCoordinate2D coordinate;
	NSString* _userData;
	WPMapAnnotationType    _annotationType;
}

@property(nonatomic, retain) NSString * title;
@property(nonatomic, retain) NSString * subtitle;
@property(assign) NSInteger tag;
@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString* userData;
@property WPMapAnnotationType annotationType;

- (id)initWithUser:(CLLocationCoordinate2D)coord  name:(NSString *)name annotationType:(WPMapAnnotationType) annotationType;
@end

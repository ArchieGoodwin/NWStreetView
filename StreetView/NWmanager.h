//
//  NWmanager.h
//
//  Created by Sergey Dikarev on 8/21/12.
//  Copyright (c) 2012 Sergey Dikarev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <coreLocation/CoreLocation.h>
typedef void (^NWisStreetViewCompletionBlock)        (NSString *panoIdOfPlace, NSError *error);



@interface NWmanager : NSObject



-(void)isStreetViewAvailable:(CLLocationCoordinate2D)location completionBlock:(NWisStreetViewCompletionBlock)completionBlock;
-(NSDictionary *)createDict:(NSString *)locName lat:(double)lat lng:(double)lng;
@end

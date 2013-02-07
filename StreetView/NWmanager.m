//
//  NWmanager.m
//
//  Created by Sergey Dikarev on 8/21/12.
//  Copyright (c) 2012 Sergey Dikarev. All rights reserved.
//

#import "NWmanager.h"
#import "URLConnection.h"


@interface NWmanager () {

    
}

@end
@implementation NWmanager



-(void)isStreetViewAvailable:(CLLocationCoordinate2D)location completionBlock:(NWisStreetViewCompletionBlock)completionBlock
{
    NSString *loc = [NSString stringWithFormat:@"%.10f,%.10f&", location.latitude, location.longitude];
    NWisStreetViewCompletionBlock completeBlock = [completionBlock copy];

    
    NSString *connectionString = [NSString stringWithFormat:@"http://cbk0.google.com/cbk?output=json&ll=%@", loc];
    NSLog(@"connect to: %@",connectionString);
    
    [URLConnection asyncConnectionWithURLString:connectionString
                                completionBlock:^(NSData *data, NSURLResponse *response)
                                {
                                    NSLog(@"Data length %d", [data length]);
                                    NSMutableDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                    //NSLog(@"%@", json);
                                    
                                    if([json objectForKey:@"Location"] == nil)
                                        completeBlock(@"", nil);
                                    
                                    //NSLog(@"panoId: %@",[[json objectForKey:@"Location"] objectForKey:@"panoId"]);
                                    
                                    completeBlock([[json objectForKey:@"Location"] objectForKey:@"panoId"], nil);
                                }
                                errorBlock:^(NSError *error)
                                {
                                                                     
                                    NSMutableDictionary* details = [NSMutableDictionary dictionary];
                                    [details setValue:[error description] forKey:NSLocalizedDescriptionKey];
                                    // populate the error object with the details
                                    NSError *err = [NSError errorWithDomain:@"world" code:200 userInfo:details];
                                    
                                    completeBlock(NO, err);
                                    
                                    
                                }];
}




-(NSDictionary *)createDict:(NSString *)locName lat:(double)lat lng:(double)lng
{
    // 1. "id" в Foursquare 2. "name" 3. "latitude" 4. "longitude") о выбранной (либо заданной) POI.
    NSDictionary *resultDict = [[NSDictionary alloc] initWithObjectsAndKeys: locName, @"name", [NSString stringWithFormat:@"%.7f", lat], @"latitude", [NSString stringWithFormat:@"%.7f", lng], @"longitude", nil];
    return resultDict;
}

@end

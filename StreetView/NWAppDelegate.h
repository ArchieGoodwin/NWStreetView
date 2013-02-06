//
//  NWAppDelegate.h
//  StreetView
//
//  Created by Sergey Dikarev on 2/6/13.
//  Copyright (c) 2013 Sergey Dikarev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NWViewController;

@interface NWAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NWViewController *viewController;

@end

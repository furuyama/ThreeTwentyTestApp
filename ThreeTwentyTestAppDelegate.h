//
//  ThreeTwentyTestAppDelegate.h
//  ThreeTwentyTest
//
//  Created by y.furuyama on 11/03/09.
//  Copyright 2011 日本技芸 All rights reserved.
//

#import <UIKit/UIKit.h>

@class ThreeTwentyTestViewController;

@interface ThreeTwentyTestAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UIViewController *rootViewController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UIViewController *rootViewController;

@end


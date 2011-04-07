//
//  RootViewController.h
//  ThreeTwentyTest
//
//  Created by y.furuyama on 11/03/09.
//  Copyright 2011 日本技芸 All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>

@interface RootViewController : UIViewController <UITextFieldDelegate>{
	NSMutableArray *result;
	UITextField *searchField;
}

@property (nonatomic, retain) NSMutableArray *result;
@property (nonatomic, retain) UITextField *searchField;

@end

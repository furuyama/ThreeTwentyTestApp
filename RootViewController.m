    //
//  RootViewController.m
//  ThreeTwentyTest
//
//  Created by y.furuyama on 11/03/09.
//  Copyright 2011 日本技芸 All rights reserved.
//

#import "RootViewController.h"
#import "MockPhotoSource.h"
#import <Three20/Three20.h>
#import "JSON.h"

@implementation RootViewController
@synthesize result;
@synthesize searchField;

NSString *const FlickrAPIKey = @"5cc2b1241240271ea45d401507bb9a47";

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor blackColor];
	self.title = @"Flickr Search"; 
	
	self.searchField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 280, 30)];
	searchField.center = CGPointMake(160, 120);
	searchField.borderStyle = UITextBorderStyleRoundedRect;
	searchField.placeholder = @"Please enter your search word...";
	searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
	searchField.delegate = self;
	[self.view addSubview:searchField];
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	button.frame = CGRectMake(0, 0, 100, 30);
	[button setTitle:@"Search!" forState:UIControlStateNormal];
	button.center = CGPointMake(160, 180);
	[button addTarget:self action:@selector(searchFlickrPhotos) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:button];
	
	self.result = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.1 green:0.5 blue:1.0 alpha:1.0];
}

//ボタンを押したときに呼ばれるメソッド
-(void)searchFlickrPhotos {
	NSString *searchWord = searchField.text;
	
	//サーチクエリーの作成(20枚の写真を要求), フォーマットはJSON(format=json)で純粋なJSONデータのみ取得する(nojsoncallback=1)
	NSString *urlString = [NSString stringWithFormat:
	 @"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=20&format=json&nojsoncallback=1", FlickrAPIKey, searchWord];
	NSURL *url = [NSURL URLWithString:urlString];
	
	//NSURLConnectionを作成して通信開始
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[connection release];
	[request release];
	
}

//データが送られてくると呼ばれるメソッド
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSDictionary *results = [jsonString JSONValue];
	NSArray *photos = [[results objectForKey:@"photos"] objectForKey:@"photo"];
	for (NSDictionary *photo in photos) {

		NSString *photoURL = 
		[NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_m.jpg", 
		 [photo objectForKey:@"farm"], [photo objectForKey:@"server"], 
		 [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];
		
		NSString *smallPhotoURL = 
		[NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_s.jpg", 
		 [photo objectForKey:@"farm"], [photo objectForKey:@"server"], 
		 [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];
		
		[result addObject:[[[MockPhoto alloc] initWithURL:photoURL smallURL:smallPhotoURL size:CGSizeZero] autorelease]];
	}
}

//通信が全て終わると呼ばれるメソッド
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	TTPhotoViewController *photoViewController = [[TTPhotoViewController alloc] init];
	photoViewController.photoSource = [[[MockPhotoSource alloc] initWithType:MockPhotoSourceNormal title:@"Flickr Photos" photos:self.result photos2:nil] autorelease];
	[self.navigationController pushViewController:photoViewController animated:YES];
}

//TextField関係
- (void)textFieldDidBeginEditing:(UITextField *)textField {
	[textField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField*)sender {
    [sender resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[result release];
	[searchField release];
    [super dealloc];
}


@end

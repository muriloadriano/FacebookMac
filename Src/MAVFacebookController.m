//
//  MAVFacebookController.m
//  FacebookMac
//
//  Created by Murilo Adriano Vasconcelos on 15/05/13.
//  Copyright (c) 2013 Murilo Adriano Vasconcelos. All rights reserved.
//

#import "MAVFriendContainer.h"
#import "MAVFacebookController.h"
#import "MAVFriendWindowController.h"
#import "MAVTrayViewController.h"
#import "NSImage+RoundedCorner.h"

MAVFacebookController* FBController = nil;

@implementation MAVFacebookController

- (MAVFacebookController*)init {
	self = [super init];
	hasToken = NO;
	self.fb = [[PhFacebook alloc] initWithApplicationID:@"YOURAPPID"
											   delegate:self];

	//[self.fb invalidateCachedToken];

	[self.fb getAccessTokenForPermissions:
	 [NSArray arrayWithObjects: @"read_stream",
	  @"xmpp_login", @"read_mailbox", nil] cached: NO];
	return self;
}

- (void)sendRequest:(NSString*)request {
	if (hasToken) {
		[self.fb sendRequest:request];
		NSLog(@"******** REQUEST SENT *******");
	}
	else {
		NSLog(@"Tried to send request without token!");
	}
}

- (void)tokenResult:(NSDictionary *)result {
	if ([[result valueForKey:@"valid"] boolValue]) {
		hasToken = true;

		NSLog(@"Token %@", self.fb.accessToken);
		self.chatStream = [[MAVChatStream alloc]
							initWithToken:self.fb.accessToken];
	}
	else {
		NSLog(@"NO TOKEN!");
	}
}

- (void)requestResult:(NSDictionary *)result {
	NSData* data = [(NSString*)[result objectForKey:@"result"]
					dataUsingEncoding:NSUTF8StringEncoding];
	NSError* error = nil;
	NSDictionary* friendsDict = (NSDictionary*)[NSJSONSerialization
												JSONObjectWithData:data
												options:0 error:&error];

	if (error) {
		NSLog(@"Error requesting: %@", [error description]);
		return;
	}

	NSURL* imageURL = [NSURL URLWithString:[[[friendsDict objectForKey:@"picture"]
											 objectForKey:@"data"] objectForKey:@"url"]];

	NSString* userId = [friendsDict objectForKey:@"id"];

	NSData* imageData = [NSData dataWithContentsOfURL:imageURL];
	MAVFriendWindowController* friendWindow = [[MAVFriendDict objectForKey:userId] controller];
	NSImage* img = [[NSImage alloc] initWithData:imageData];
	[img setSize:(NSSize){70, 70}];
	[[friendWindow imageView] setImage:[img roundCornersImageCornerRadius:35]];

}

- (void)sendChatMessage:(NSString *)message to:(NSString *)friendId {
	[self.chatStream sendMessage:message to:friendId];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
//                         change:(NSDictionary *)change context:(void *)context {
//    if (object == self.operationQueue && [keyPath isEqualToString:@"operations"]) {
//        if ([self.operationQueue.operations count] == 0) {
//			[MAVTray.tableView reloadData];
//            NSLog(@"queue has completed");
//        }
//    }
//    else {
//		[super observeValueForKeyPath:keyPath ofObject:object
//                               change:change context:context];
//    }
//}

//- (BOOL)needsAuthentication:(NSString *)authenticationURL forPermissions:(NSString *)permissions {
//	NSLog(@"AUTH: %@ permissions: %@", authenticationURL, permissions);
//	return NO;
//}

@end
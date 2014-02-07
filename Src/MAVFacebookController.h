//
//  MAVFacebookController.h
//  FacebookMac
//
//  Created by Murilo Adriano Vasconcelos on 15/05/13.
//  Copyright (c) 2013 Murilo Adriano Vasconcelos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PhFacebook/PhFacebook.h>

#import "MAVChatStream.h"
#import "MAVFacebookFriend.h"

@interface MAVFacebookController : NSObject <PhFacebookDelegate> {
	BOOL hasToken;
}

@property (strong) PhFacebook* fb;
@property (strong) MAVChatStream* chatStream;

- (MAVFacebookController*)init;
- (void)sendRequest:(NSString*)request;
- (void)tokenResult:(NSDictionary*)result;
- (void)requestResult:(NSDictionary*)result;
- (void)sendChatMessage:(NSString*)message to:(NSString*)friendId;
//- (BOOL) needsAuthentication:(NSString*)authenticationURL forPermissions:(NSString*)permissions;
//- (void) willShowUINotification:(PhFacebook*)sender;
//- (void) didDismissUI:(PhFacebook*)sender;
@end

extern MAVFacebookController* FBController;
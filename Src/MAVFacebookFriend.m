//
//  MAVFacebookFriend.m
//  FacebookMac
//
//  Created by Murilo Adriano Vasconcelos on 16/05/13.
//  Copyright (c) 2013 Murilo Adriano Vasconcelos. All rights reserved.
//

#import "MAVFacebookFriend.h"

@implementation MAVFacebookFriend;
+ (MAVFacebookFriend*)friendNamed:(NSString *)name identifier:(NSString *)identifier
						   avatar:(NSImage *)avatar username:(NSString *)username {
	MAVFacebookFriend* friend = [[MAVFacebookFriend alloc] init];
	[friend setName:name];
	[friend setUsername:username];
	[friend setIdentifier:identifier];
	[friend setAvatar:avatar];
	[friend setOnline:[NSImage imageNamed:@"NSStatusNone"]];
	[friend setHasLocalAvatar:NO];

	return friend;
}
@end

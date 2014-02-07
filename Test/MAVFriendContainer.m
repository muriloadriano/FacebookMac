//
//  MAVFriendContainer.m
//  FacebookMac
//
//  Created by Murilo Adriano Vasconcelos on 26/12/13.
//  Copyright (c) 2013 Murilo Adriano Vasconcelos. All rights reserved.
//

#import "MAVFriendContainer.h"

NSMutableDictionary* MAVFriendDict = nil;

@implementation MAVFriendContainer
- (MAVFriendWindowController*)getValidController {
	if ([self controller] == nil) {
		[self setController:[MAVFriendWindowFactory createFriendWindow:[self fbFriend]]];
	}

	return [self controller];
}
@end

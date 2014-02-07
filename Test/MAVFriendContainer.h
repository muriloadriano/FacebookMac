//
//  MAVFriendContainer.h
//  FacebookMac
//
//  Created by Murilo Adriano Vasconcelos on 26/12/13.
//  Copyright (c) 2013 Murilo Adriano Vasconcelos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAVFacebookFriend.h"
#import "MAVFriendWindowController.h"

NSMutableDictionary* MAVFriendDict;

@interface MAVFriendContainer : NSObject
@property (strong) MAVFacebookFriend* fbFriend;
@property (strong) MAVFriendWindowController* controller;

- (MAVFriendWindowController*)getValidController;
@end


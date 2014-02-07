//
//  MAVFacebookFriend.h
//  FacebookMac
//
//  Created by Murilo Adriano Vasconcelos on 16/05/13.
//  Copyright (c) 2013 Murilo Adriano Vasconcelos. All rights reserved.
//

#import <Foundation/Foundation.h>

NSImage* MAVFriendAvailable;
NSImage* MAVFriendNotAvailable;

@interface MAVFacebookFriend : NSObject
@property (copy) NSString* name;
@property (copy) NSString* identifier;
@property (copy) NSString* username;
@property (strong) NSImage* avatar;
@property BOOL hasLocalAvatar;
@property (weak) NSImage* online;
+ (MAVFacebookFriend*)friendNamed:(NSString*)name identifier:(NSString*)identifier
						   avatar:(NSImage*)avatar username:(NSString*)username;
@end

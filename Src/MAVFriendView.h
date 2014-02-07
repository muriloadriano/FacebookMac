//
//  MAVImageView.h
//  Test
//
//  Created by Murilo Adriano Vasconcelos on 10/05/13.
//  Copyright (c) 2013 Murilo Adriano Vasconcelos. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MAVFacebookFriend.h"

@interface MAVFriendView : NSImageView <NSDraggingSource> {
	NSTrackingArea* trackingArea;
}
@property (copy) NSString* friendId;
- (void) mouseDown:(NSEvent *)theEvent;
@end

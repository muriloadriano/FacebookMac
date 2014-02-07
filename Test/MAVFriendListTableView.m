//
//  MAVFriendListTableView.m
//  FacebookMac
//
//  Created by Murilo Adriano Vasconcelos on 14/05/13.
//  Copyright (c) 2013 Murilo Adriano Vasconcelos. All rights reserved.
//

#import "MAVFriendListTableView.h"
#import "MAVTrayViewController.h"
#import "MAVFriendWindowController.h"

@implementation MAVFriendListTableView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}

- (void)updateTrackingAreas {
	[super updateTrackingAreas];

	if (trackingArea) {
		[self removeTrackingArea:trackingArea];
	}

	NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveAlways;

	trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect
									options:options owner:self userInfo:nil];

	[self addTrackingArea:trackingArea];
}
 

- (void)mouseMoved:(NSEvent *)theEvent {
	NSPoint p = theEvent.locationInWindow;
    NSPoint tablePoint = [self convertPoint:p fromView:nil];
    NSInteger newRowNum = [self rowAtPoint:tablePoint];
	NSIndexSet* index = [NSIndexSet indexSetWithIndex:newRowNum];
	[self selectRowIndexes:index byExtendingSelection:NO];
}

- (void)mouseDown:(NSEvent *)theEvent {
	NSPoint p = theEvent.locationInWindow;
    NSPoint tablePoint = [self convertPoint:p fromView:nil];
    NSInteger newRowNum = [self rowAtPoint:tablePoint];

	MAVFacebookFriend* friend = [MAVTray.arrController.arrangedObjects objectAtIndex:newRowNum];
	[MAVFriendWindowFactory createFriendWindow:friend];
}

@end

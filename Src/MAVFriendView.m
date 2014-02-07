//
//  MAVImageView.m
//  Test
//
//  Created by Murilo Adriano Vasconcelos on 10/05/13.
//  Copyright (c) 2013 Murilo Adriano Vasconcelos. All rights reserved.
//

#import "MAVFriendContainer.h"
#import "MAVFriendView.h"
#import "MAVFriendWindowController.h"

static NSString* MAVWindowDragType = @"com.wordpress.murilo.windowDragType";

@implementation MAVFriendView

- (void)updateTrackingAreas {
	[super updateTrackingAreas];

	if (trackingArea) {
		[self removeTrackingArea:trackingArea];
	}

	NSTrackingAreaOptions options = NSTrackingInVisibleRect
		| NSTrackingMouseEnteredAndExited
		| NSTrackingActiveAlways;

	trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect
		options:options owner:self userInfo:nil];

	[self addTrackingArea:trackingArea];
}

- (void)mouseEntered:(NSEvent *)theEvent {
	[NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0.25f];
	[[[self window] animator] setAlphaValue:0.2f];
    [[NSAnimationContext currentContext] setCompletionHandler:^{
        [[self window] setAlphaValue:1.0f];
    }];
    [NSAnimationContext endGrouping];
}

- (void)mouseExited:(NSEvent *)theEvent {
	if ([[[[MAVFriendDict objectForKey:[self friendId]] controller] chatWindow] alphaValue] == 0.0) {
		[NSAnimationContext beginGrouping];
		[[NSAnimationContext currentContext] setDuration:0.25f];
		[[[self window] animator] setAlphaValue:1.0f];
		[[NSAnimationContext currentContext] setCompletionHandler:^{
			[[self window] setAlphaValue:0.2f];
		}];
		[NSAnimationContext endGrouping];
	}
}

- (void)mouseDragged:(NSEvent *)theEvent {
	NSPasteboard* pBoard = [NSPasteboard pasteboardWithName:NSDragPboard];
	[pBoard declareTypes:[NSArray arrayWithObject:MAVWindowDragType] owner:self];
	[pBoard setData:[self.friendId dataUsingEncoding:NSUTF8StringEncoding]
			forType:MAVWindowDragType];

	[self dragImage:[self image] at:[theEvent locationInWindow]
			 offset:NSZeroSize event:theEvent
		 pasteboard:pBoard source:self slideBack:NO];
}

- (void)draggingSession:(NSDraggingSession *)session willBeginAtPoint:(NSPoint)screenPoint {
	MAVFriendWindowController* controller = [[MAVFriendDict objectForKey:self.friendId] controller];
	[controller.chatWindow orderOut:self];
}

- (void)draggingSession:(NSDraggingSession *)session movedToPoint:(NSPoint)screenPoint {
	NSPoint location = [self.window frame].origin;

	location.x -= screenPoint.y;
	location.y -= screenPoint.x;
	[self.window setFrameOrigin:location];
}

- (void)draggingSession:(NSDraggingSession *)session endedAtPoint:(NSPoint)screenPoint
			  operation:(NSDragOperation)operation {
	screenPoint.x -= 40;
	screenPoint.y -= 40;
	[self.window setFrameOrigin:screenPoint];

	MAVFriendWindowController* controller = [[MAVFriendDict objectForKey:self.friendId] controller];
	[controller.chatWindow setPoint:NSMakePoint(NSMidX([self.window frame]),
												NSMidY([self.window frame]))
							   side:MAPositionRightBottom];
	[controller.chatWindow makeKeyAndOrderFront:self];

	[NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0.5f];
    [[NSAnimationContext currentContext] setCompletionHandler:^{
        [[MAVFriendWindowFactory dumpSpace] orderOut:self];
        [[MAVFriendWindowFactory dumpSpace] setAlphaValue:1.f];
    }];
    [[[MAVFriendWindowFactory dumpSpace] animator] setAlphaValue:0.f];
    [NSAnimationContext endGrouping];
}

- (NSDragOperation)draggingSession:(NSDraggingSession *)session
sourceOperationMaskForDraggingContext:(NSDraggingContext)context {
	[[MAVFriendWindowFactory dumpSpace] setAlphaValue:0.f];
    [[MAVFriendWindowFactory dumpSpace] makeKeyAndOrderFront:self];
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0.5f];
    [[[MAVFriendWindowFactory dumpSpace] animator] setAlphaValue:1.f];
    [NSAnimationContext endGrouping];
	
	return NSDragOperationGeneric;
}

- (void)mouseDown:(NSEvent *)theEvent {
	MAVFriendWindowController* controller = [[MAVFriendDict objectForKey:self.friendId] controller];
	[[controller chatWindow] setAlphaValue:1.0 - [[controller chatWindow] alphaValue]];
}
@end

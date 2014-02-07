//
//  MAVRoundView.m
//  Test
//
//  Created by Murilo Adriano Vasconcelos on 10/05/13.
//  Copyright (c) 2013 Murilo Adriano Vasconcelos. All rights reserved.
//

#import "MAVFriendWindowController.h"
#import "MAVDumpView.h"
#import "MAVFriendContainer.h"

static NSString* MAVWindowDragType = @"com.wordpress.murilo.windowDragType";

@implementation MAVDumpView

- (id)initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];

	return self;
}

- (void)drawRect:(NSRect)dirtyRect {
	NSBezierPath* path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:100.0f yRadius:150.0f];
	[[NSColor blackColor] set];
	[path fill];
}

- (void)updateTrackingAreas {
	[super updateTrackingAreas];

	if (trackingArea) {
		[self removeTrackingArea:trackingArea];
	}

	NSTrackingAreaOptions options = NSTrackingInVisibleRect
		| NSTrackingMouseEnteredAndExited
	| NSTrackingActiveAlways | NSTrackingEnabledDuringMouseDrag;
	
	trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];

	[self addTrackingArea:trackingArea];

	[self registerForDraggedTypes:[NSArray arrayWithObject:MAVWindowDragType]];
}

- (void)draggingExited:(id<NSDraggingInfo>)sender {
	// Emits mouse exited so the window can be restored to the initial state
	[self mouseExited:nil];
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;

	// Emits mouse entered so the window can be animated
	[self mouseEntered:nil];

    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];

    if ( [[pboard types] containsObject:NSColorPboardType] ) {
        if (sourceDragMask & NSDragOperationGeneric) {
            return NSDragOperationGeneric;
        }
    }
    if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
        if (sourceDragMask & NSDragOperationLink) {
            return NSDragOperationLink;
        } else if (sourceDragMask & NSDragOperationCopy) {
            return NSDragOperationCopy;
        }
    }
    return NSDragOperationCopy;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;

    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];


	if ([[pboard types] containsObject:MAVWindowDragType]) {
		// Takes a string, convert it to a long long and cast it to a window
		NSString* str = [pboard propertyListForType:MAVWindowDragType];
		MAVFriendWindowController* controller = [[MAVFriendDict objectForKey:str] controller];
		NSLog(@"Attempting to get window %@", str);

		if (controller != nil) {
			[controller.window close];
			[controller.chatWindow close];
			NSLog(@"Window closed");
		}
	
		return YES;
	}

	return NO;
}

- (void)mouseEntered:(NSEvent *)theEvent {
	NSRect rect = self.window.frame;
	rect.origin.x -= (256 - rect.size.width) / 2;
	rect.size.width = 256;
	[self.window setFrame:rect display:YES animate:YES];
	[self drawRect:self.window.frame];
}

- (void)mouseExited:(NSEvent *)theEvent {
	NSRect rect = self.window.frame;
	rect.origin.x += (rect.size.width - 192) / 2;
	rect.size.width = 192;
	[self.window setFrame:rect display:YES animate:YES];
	[self drawRect:self.window.frame];
}

@end

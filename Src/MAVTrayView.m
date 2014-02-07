//
//  MAVTrayView.m
//  FacebookMac
//
//  Created by Murilo Adriano Vasconcelos on 13/05/13.
//  Copyright (c) 2013 Murilo Adriano Vasconcelos. All rights reserved.
//

#import "MAVTrayView.h"

#define OFFLINE_ALPHA 0.4
#define TRAY_WIDTH 24

@implementation MAVTrayView

/*- (void)drawRect:(NSRect)dirtyRect {
	NSBezierPath* path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:4.0f yRadius:6.0f];
	[[NSColor blackColor] set];
	[self setAlphaValue:.85f];
	[self.window setBackgroundColor:[NSColor clearColor]];
	[path fill];
}*/

- (id)init {
    //CGFloat height = floor([NSStatusBar systemStatusBar].thickness);
    self = [super initWithFrame:NSMakeRect(0, 0, TRAY_WIDTH, TRAY_WIDTH)];
    if (self) {
		active = NO;

        //imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, IMAGEWIDTH, height)];
		//[imageView setImage:[NSImage imageNamed:@"facebook"]];
		//[self addSubview:imageView];

		NSRect pos = [self frame];
		pos.origin.y -= 5;

		txtIcon = [[NSTextField alloc] initWithFrame:pos];
		[txtIcon setFont:[NSFont fontWithName:@"Metrize-Icons" size:16]];
		[txtIcon setTextColor:[NSColor blackColor]];
		[txtIcon setAlphaValue:0.5f];
		[txtIcon setDrawsBackground:NO];
		[txtIcon setStringValue:@"\ue045"];
		[txtIcon setSelectable:NO];
		[txtIcon setEditable:NO];
		[txtIcon setBezeled:NO];
		[txtIcon setAlignment:NSCenterTextAlignment];
		[txtIcon setToolTip:@"FacebookMac - Offline"];

		[self addSubview:txtIcon];

        statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:TRAY_WIDTH]; 
		[statusItem setView:self];
        [self updateUI];
    }
    return self;
}

- (void)setConnected:(BOOL)status {
	isConnected = status;
	if (status) {
		[txtIcon setAlphaValue:1.0f];
		[txtIcon setToolTip:@"FacebookMac - Online"];
	}
	else {
		[txtIcon setAlphaValue:OFFLINE_ALPHA];
		[txtIcon setToolTip:@"FacebookMac - Offline"];
	}
	[self updateUI];
}

- (void)drawRect:(NSRect)dirtyRect {
	[self setBounds:dirtyRect];
    if (active) {
        [[NSColor selectedMenuItemColor] setFill];
        NSRectFill(dirtyRect);
		[txtIcon setTextColor:[NSColor whiteColor]];
    } else {
        [[NSColor clearColor] setFill];
        NSRectFill(dirtyRect);
		[txtIcon setAlphaValue:isConnected ? 1.0f : OFFLINE_ALPHA];
		[txtIcon setTextColor:[NSColor blackColor]];
    }

	[self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)theEvent
{
	[self showPopover];
    [self setActive:YES];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    //[self setActive:NO];
}

- (void)updateUI
{
    [self setNeedsDisplay:YES];
}

- (void)setActive:(BOOL)newValue {
    active = newValue;
    [self updateUI];
}

- (void)showPopover {
	BOOL hadntPopover = (popover == nil);
    if (hadntPopover) {
        popover = [[NSPopover alloc] init];
        popover.contentViewController = [MAVTrayViewController trayViewController];
		[popover setAppearance:NSPopoverAppearanceMinimal];
		[popover setBehavior:NSPopoverBehaviorTransient];
		[popover setDelegate:self];
    }

	[popover showRelativeToRect:[self bounds] ofView:self preferredEdge:NSMinYEdge];
}

- (void)popoverWillClose:(NSNotification *)notification {
	[self setActive:NO];
}
@end

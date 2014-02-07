//
//  MAVAppDelegate.m
//  Test
//
//  Created by Murilo Adriano Vasconcelos on 09/05/13.
//  Copyright (c) 2013 Murilo Adriano Vasconcelos. All rights reserved.
//

#import "MAVFriendWindowController.h"
#import "MAVAppDelegate.h"
#import "MAVTrayView.h"

@implementation MAVAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	MAVFriendAvailable = [NSImage imageNamed:@"NSStatusAvailable"];
	MAVFriendNotAvailable = [NSImage imageNamed:@"NSStatusNone"];

	[self.dumpWindow setOpaque:NO];
	[self.dumpWindow setBackgroundColor:[NSColor clearColor]];
	[self.dumpWindow orderOut:self];

	[MAVFriendWindowFactory setDumpSpace:self.dumpWindow];

	[self setTrayView:[[MAVTrayView alloc] init]];
	[self setTrayViewController:[MAVTrayViewController trayViewController]];

	FBController = [[MAVFacebookController alloc] init];
}

@end
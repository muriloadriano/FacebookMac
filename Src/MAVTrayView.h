//
//  MAVTrayView.h
//  FacebookMac
//
//  Created by Murilo Adriano Vasconcelos on 13/05/13.
//  Copyright (c) 2013 Murilo Adriano Vasconcelos. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MAVTrayViewController.h"

@interface MAVTrayView : NSView <NSPopoverDelegate> {
	BOOL active;
	//NSImageView *imageView;
	NSStatusItem *statusItem;
	NSPopover *popover;
	NSTextField *txtIcon;
	BOOL isConnected;
}

- (void)showPopover;
- (void)updateUI;
- (void)setActive:(BOOL)active;
- (void)setConnected:(BOOL)status;
@end
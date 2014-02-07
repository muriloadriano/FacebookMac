//
//  MAVFriendWindowController.m
//  FacebookMac
//
//  Created by Murilo Adriano Vasconcelos on 11/05/13.
//  Copyright (c) 2013 Murilo Adriano Vasconcelos. All rights reserved.
//

#import "NSImage+RoundedCorner.h"
#import <CoreGraphics/CoreGraphics.h>

#import "MAVChatStream.h"
#import "MAVFacebookController.h"
#import "MAVFriendContainer.h"
#import "MAVFriendView.h"
#import "MAVFriendWindowController.h"

extern NSImage* MAVFriendAvailable;
extern NSImage* MAVFriendNotAvailable;

@implementation MAVFriendWindowController

@synthesize window;

- (void)loadFriendWindow:(MAVFacebookFriend*)fbFriend {
	[NSBundle loadNibNamed:@"FriendWindow" owner:self];

	[self.window setOpaque:NO];
	[self.window setBackgroundColor:[NSColor clearColor]];

	NSSize size = {70, 70};
	NSImage* image = [[fbFriend avatar] copy];
	[image setSize:size];

	[self.imageView setImage:[image roundCornersImageCornerRadius:35]];
	[self.imageView setFriendId:fbFriend.identifier];
	[self.window makeKeyAndOrderFront:self.window];
}

- (IBAction)sendAction:(id)sender {
	NSString* input = [[[self textInput] string] stringByReplacingOccurrencesOfString:@"\n"
																		   withString:@"</br/>"];

	if ([input length] == 0) {
		NSLog(@"input empty!");
		return;
	}

	[FBController sendChatMessage:input to:[self.imageView friendId]];
	[self appendMessageToChat:input direction:MAVMessageSent];

	[[self textInput] setString:@""];
}

- (void)appendMessageToChat:(NSString *)message direction:(MAVMessageDirection)direction {
	WebView* chat = [self chatArea];
	NSData* data = [[[chat mainFrame] dataSource] data];
	NSString* htmlContent = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

	NSLog(@"HTML CONTENT: %@", htmlContent);

	NSString* newContent = message;
	if ([htmlContent length] > 20) {
		newContent = [NSString stringWithFormat:@"%@<br/><div class='%@'>%@</div><br><br><br><br><br>",
								[htmlContent substringToIndex:[htmlContent length] - 20],
								(direction == MAVMessageReceived) ? @"received" : @"sent",
								message];
	}
	[[chat mainFrame] loadHTMLString:newContent baseURL:nil];
}

- (void)showFullChatWindow {
	[self.window setAlphaValue:1.0f];
	[self.chatWindow setAlphaValue:1.0f];
	[self.window makeKeyAndOrderFront:self];
	[self.chatWindow makeKeyAndOrderFront:self];
	[self.window makeKeyAndOrderFront:self];
}

@end

@implementation MAVFriendWindowFactory

static NSWindow* dumpSpace = nil;

+ (void)initializeUI:(MAVFriendContainer*)fc {
	MAVFriendWindowController* fwc = [fc controller];

	NSPoint midPoint = NSMakePoint(NSMidX([fwc.window frame]), NSMidY([fwc.window frame]));
	fwc.chatWindow = [[MAAttachedWindow alloc] initWithView:fwc.chatView
											attachedToPoint:midPoint
													 onSide:MAPositionRightBottom
												 atDistance:42];
	[fwc.chatWindow setBackgroundColor:[NSColor whiteColor]];
	[fwc.chatWindow makeKeyAndOrderFront:self];
	[fwc.chatWindow setReleasedWhenClosed:NO];
	[fwc.chatWindow setStyleMask:[fwc.chatWindow styleMask] | NSResizableWindowMask];

	[fwc.nameLabel setStringValue:[fc.fbFriend name]];

	if ([fc.fbFriend online] == MAVFriendNotAvailable) {
		[fwc.statusLabel setStringValue:@"Offline"];
	}

	[fwc.chatView setWantsLayer:YES];
	[fwc.chatView.layer setMasksToBounds:YES];
	[fwc.chatView.layer setCornerRadius:8.0f];

	[fwc.chatWindow makeFirstResponder:fwc.textInput];
	//MAVChatWindowResponder* cwResponder = [[MAVChatWindowResponder alloc] init] ;
	//[fwc.chatWindow setNextResponder:cwResponder];

	[fwc.testeWindow setBackgroundColor:[NSColor whiteColor]];
	[fwc.testeWindow setAlphaValue:0.9f];
}

+ (MAVFriendWindowController*)createFriendWindow:(MAVFacebookFriend*)fbFriend {
	MAVFriendContainer* fc = [MAVFriendDict objectForKey:[fbFriend identifier]];

	if ([fc controller] != nil) {
		[fc.controller showFullChatWindow];
		return fc.controller;
	}

	MAVFriendWindowController* friendWindow = [[MAVFriendWindowController alloc] init];
	[fc setController:friendWindow];

	// If the friend's avatar is a low resolution avatar got from XMPP, get the good quality one.
	if (![fbFriend hasLocalAvatar]) {
		NSString* request = [NSString stringWithFormat:@"/%@?fields=picture.height(120).width(120)",
							 [fbFriend identifier]];

		NSLog(@"Requesting photo: %@", request);

		[FBController performSelectorInBackground:@selector(sendRequest:) withObject:request];
		[fbFriend setHasLocalAvatar:YES];
	}

	[friendWindow loadFriendWindow:fbFriend];

	[NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0.3f];
	[[[friendWindow window] animator] setAlphaValue:0.15f];
    [[NSAnimationContext currentContext] setCompletionHandler:^{
        [[friendWindow window] setAlphaValue:1.0f];
    }];
    [NSAnimationContext endGrouping];

	[friendWindow.window makeKeyAndOrderFront:nil];
	[friendWindow.window setReleasedWhenClosed:NO];


	[self initializeUI:fc];

	CALayer* bottomBorder = [CALayer layer];
	bottomBorder.borderColor = [[NSColor lightGrayColor] CGColor];
	bottomBorder.borderWidth = 1;
	bottomBorder.frame = CGRectMake(-1, 0,
									CGRectGetWidth([[friendWindow titleBar] frame]), 1);

	[[[friendWindow titleBar] layer] addSublayer:bottomBorder];

	CALayer* bg = [CALayer layer];
	bg.backgroundColor = CGColorCreateGenericRGB(75, 75, 75, 0.3f);
	bg.frame = CGRectMake(0, 0,
						  CGRectGetWidth([[friendWindow titleBar] frame]),
						  CGRectGetHeight([[friendWindow titleBar] frame]));

	[[[friendWindow titleBar] layer] addSublayer:bg];


	NSString* initialHtmlChatPath = [[NSBundle mainBundle] pathForResource:@"chat" ofType:@"html"];
	NSString* htmlContent = [NSString stringWithContentsOfFile:initialHtmlChatPath
													  encoding:NSUTF8StringEncoding
														 error:nil];

	[[[friendWindow chatArea] mainFrame] loadHTMLString:htmlContent baseURL:nil];
	NSLog(@"ZICA: %@", htmlContent);

	[[[friendWindow chatScrollView] layer] setBorderWidth:1];
	[[[friendWindow chatScrollView] layer] setBorderColor:[[NSColor lightGrayColor] CGColor]];

	CALayer* upBorder = [CALayer layer];
	upBorder.borderColor = [[NSColor lightGrayColor] CGColor];
	upBorder.borderWidth = 1;
	upBorder.frame = CGRectMake(-1, CGRectGetHeight([[friendWindow bottomBar] frame]) - 1,
									CGRectGetWidth([[friendWindow bottomBar] frame]), 1);
	[[[friendWindow bottomBar] layer] addSublayer:upBorder];

	return friendWindow;
}

+ (void)setDumpSpace:(NSWindow *)dumpWindow {
	dumpSpace = dumpWindow;
}

+ (NSWindow*)dumpSpace {
	return dumpSpace;
}

@end

#pragma mark Responders

@implementation MAVChatWindowResponder

- (void)cancelOperation:(id)sender {
	NSLog(@"responder");
	MAAttachedWindow* window = sender;
	if ([window isVisible]) {
		[window close];
	}
}

@end

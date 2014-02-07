//
//  MAVFriendWindowController.h
//  FacebookMac
//
//  Created by Murilo Adriano Vasconcelos on 11/05/13.
//  Copyright (c) 2013 Murilo Adriano Vasconcelos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "MAVFriendView.h"
#import "MAVFacebookFriend.h"
#import "MAAttachedWindow.h"

typedef enum MAVMessageDirection {
	MAVMessageSent = 0,
	MAVMessageReceived = 1
} MAVMessageDirection;

@interface MAVFriendWindowController : NSWindowController
@property (weak) IBOutlet MAVFriendView *imageView;
@property (strong) IBOutlet NSWindow *window;
@property (strong) IBOutlet NSView *titleBar;
@property (weak) IBOutlet WebView *chatArea;
@property (unsafe_unretained) IBOutlet NSTextView *textInput;
@property (weak) IBOutlet NSButton *sendButton;
@property (weak) IBOutlet NSScrollView *chatScrollView;
@property (weak) IBOutlet NSView *bottomBar;
@property (strong) IBOutlet NSView *chatView;
@property (weak) IBOutlet NSTextField *nameLabel;
@property (weak) IBOutlet NSTextField *statusLabel;
@property (strong) MAAttachedWindow *chatWindow;
@property (strong) IBOutlet NSWindow *testeWindow;
@property (weak) IBOutlet NSView *testeView;

- (void)showFullChatWindow;
- (IBAction)sendAction:(id)sender;
- (void)loadFriendWindow:(MAVFacebookFriend*)fbFriend;
- (void)appendMessageToChat:(NSString*)message direction:(MAVMessageDirection)direction;
@end

#pragma mark Object Factory

@interface MAVFriendWindowFactory : NSObject
+ (MAVFriendWindowController*)createFriendWindow:(MAVFacebookFriend*)fbFriend;
+ (void)setDumpSpace:(NSWindow*)dumpWindow;
+ (NSWindow*)dumpSpace;
@end

#pragma mark Responders

@interface MAVChatWindowResponder : NSResponder
- (void)cancelOperation:(id)sender;
@end

@interface MAVFriendViewResponder : NSResponder
- (void)cancelOperation:(id)sender;
@end
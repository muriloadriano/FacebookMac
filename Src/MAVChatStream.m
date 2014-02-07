//
//  MAVChatController.m
//  FacebookMac
//
//  Created by Murilo Adriano Vasconcelos on 20/05/13.
//  Copyright (c) 2013 Murilo Adriano Vasconcelos. All rights reserved.
//

#import "MAVAppDelegate.h"
#import "MAVChatStream.h"
#import "MAVFriendContainer.h"
#import "MAVTrayViewController.h"
#import "MAVFacebookFriend.h"
#import "XMPPFramework.h"

static NSString* kFacebookId = @"142524382599594";

extern NSImage* MAVFriendAvailable;
extern NSImage* MAVFriendNotAvailable;

@implementation MAVChatStream

- (MAVChatStream*)initWithToken:(NSString *)token {
	dispatch_queue_t operationQueue = dispatch_get_main_queue();

	self = [super initWithFacebookAppId:kFacebookId];
	self.token = token;
	[self addDelegate:self delegateQueue:operationQueue];

	NSError* error = nil;
	if (![self connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
		NSLog(@"Couldn't connect %@", [error description]);
	}

	self.xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
	self.xmppvCardTempModule = [[XMPPvCardTempModule alloc]
								initWithvCardStorage:self.xmppvCardStorage];
	self.xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc]
								  initWithvCardTempModule:self.xmppvCardTempModule];

	self.roasterStorage = [[XMPPRosterCoreDataStorage alloc] init];
	self.roster = [[XMPPRoster alloc] initWithRosterStorage:self.roasterStorage];
	[self.roster addDelegate:self delegateQueue:operationQueue];

	[self.roster activate:self];
	[self.xmppvCardAvatarModule activate:self];
	[self.xmppvCardTempModule activate:self];

	return self;
}

- (void)sendMessage:(NSString*)message to:(NSString*)friendId {
	NSString* friendJid = [NSString stringWithFormat:@"-%@@chat.facebook.com", friendId];

	XMPPElement* body = [XMPPElement elementWithName:@"body" stringValue:message];
	XMPPMessage* msg = [XMPPMessage messageWithType:@"chat"
												 to:[XMPPJID jidWithString:friendJid]];
	[msg addChild:body];

	NSLog(@"Generated message %@", [msg description]);

	[self sendElement:msg];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate Methods
////////////////////////////////////////////////////////////////////////////////

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	NSLog(@"Connect!");

	NSError* error = nil;

	if (![self isSecure]) {
		if (![self secureConnection:&error]) {
			NSLog(@"Couldn't STARTTLS! %@", [error description]);
			return;
		}
	}
	else if (![self authenticateWithFacebookAccessToken:self.token error:&error]) {
		NSLog(@"NOT AUTH ::: %@", [error description]);
		return;
	}

	MAVTrayView* trayView = [[NSApp delegate] trayView];
	[trayView setConnected:YES];

	NSLog(@"No immediate AUTH errors!");
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error {
	NSLog(@"DID NOT AUTH: %@", [error description]);
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
	NSLog(@" ______ CHAT AUTH _______");
	[self.roster fetchRoster];
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
	MAVTrayView* trayView = [[NSApp delegate] trayView];
	[trayView setConnected:NO];
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
	NSLog(@"XMPP ISSECURE!!!");
}

- (void)xmppRoster:(XMPPRoster *)sender didRecieveRosterItem:(NSXMLElement *)item {
	NSString* name = [[item attributeForName:@"name"] stringValue];
	NSString* uid = [[[item attributeForName:@"jid"] stringValue] substringFromIndex:1];
	uid = [[uid componentsSeparatedByString:@"@"] objectAtIndex:0];

	NSData* imgData = [self.xmppvCardAvatarModule photoDataForJID:
					   [XMPPJID jidWithString:[[item attributeForName:@"jid"] stringValue]]];
	NSImage* friendImage = [[NSImage alloc] initWithData:imgData];

	MAVFacebookFriend* friend = [MAVFacebookFriend friendNamed:name
													identifier:uid
														avatar:friendImage
													  username:uid];
	[MAVTray addFriend:friend];
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
	NSLog(@"PRESENCE: - %@", [presence description]);

	NSString* xmppId = [[presence attributeForName:@"from"] stringValue];
	NSString* userId = [[xmppId substringFromIndex:1]
						substringToIndex:[xmppId rangeOfString:@"@"].location-1];

	NSString* presenceType = [[presence attributeForName:@"type"] stringValue];

	BOOL online = NO;
	if (presenceType && [presenceType isEqualToString:@"unavailable"]) {
		NSLog(@"%@ unavailable", userId);
	}
	else {
		NSLog(@"%@ online", userId);
		online = YES;
	}

	MAVFriendContainer* cont = [MAVFriendDict objectForKey:userId];
	MAVFriendWindowController* windowController = [cont controller];

	if (windowController) {
		[[windowController statusLabel] setStringValue:online ? @"Available" : @"Offline"];
	}

	MAVFacebookFriend* ff = [cont fbFriend];
	[ff setOnline:online ? MAVFriendAvailable : MAVFriendNotAvailable];

	[[MAVTray tableView] reloadData];
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
	NSLog(@"DidReceiveMESSAGE, %@", [message description]);

	if ([message isChatMessageWithBody]) {

		NSString *messageData = [[message elementForName:@"body"] stringValue];

		NSString *userId = [[[[message attributeForName:@"from"] stringValue] substringFromIndex:1]
							substringToIndex:[[[message attributeForName:@"from"] stringValue]
											  rangeOfString:@"@"].location-1];


		//NSLog(@"%@\n\n", user);
		NSLog(@"Message (%@): %@", userId, messageData);

		MAVFriendWindowController* fwc = [[MAVFriendDict objectForKey:userId] getValidController];
		[fwc appendMessageToChat:messageData direction:MAVMessageReceived];
	}
}

@end

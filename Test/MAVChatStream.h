//
//  MAVChatController.h
//  FacebookMac
//
//  Created by Murilo Adriano Vasconcelos on 20/05/13.
//  Copyright (c) 2013 Murilo Adriano Vasconcelos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"
#import "XMPPFramework.h"

@interface MAVChatStream : XMPPStream <XMPPStreamDelegate, XMPPRosterDelegate>

@property (copy) NSString* token;
@property (strong) XMPPRoster* roster;
@property (strong) XMPPvCardCoreDataStorage *xmppvCardStorage;
@property (strong) XMPPvCardTempModule *xmppvCardTempModule;
@property (strong) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (strong) XMPPRosterCoreDataStorage *roasterStorage;

- (void)sendMessage:(NSString*)message to:(NSString*)friendId;
- (MAVChatStream*)initWithToken:(NSString *)token;
- (void)xmppStreamDidConnect:(XMPPStream *)sender;
@end

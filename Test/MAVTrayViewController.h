//
//  MAVTrayViewController.h
//  FacebookMac
//
//  Created by Murilo Adriano Vasconcelos on 13/05/13.
//  Copyright (c) 2013 Murilo Adriano Vasconcelos. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MAVFacebookFriend.h"

#define MAVTray [MAVTrayViewController trayViewController]

@interface MAVTrayViewController : NSViewController
@property (strong) IBOutlet NSTableView *tableView;
@property (strong) IBOutlet NSSearchFieldCell *searchField;
@property (strong) IBOutlet NSArrayController *arrController;

- (void)addFriend:(MAVFacebookFriend*)fbFriend;
+ (MAVTrayViewController*)trayViewController;

- (IBAction)updateFilterAction:(id)sender;
@end

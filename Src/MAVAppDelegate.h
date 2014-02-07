//
//  MAVAppDelegate.h
//  Test
//
//  Created by Murilo Adriano Vasconcelos on 09/05/13.
//  Copyright (c) 2013 Murilo Adriano Vasconcelos. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MAVTrayView.h"
#import "MAVFacebookController.h"

@interface MAVAppDelegate : NSObject <NSApplicationDelegate>
@property (strong) IBOutlet NSWindow *dumpWindow;
@property (strong) MAVTrayViewController *trayViewController;
@property (strong) MAVTrayView *trayView;
@end

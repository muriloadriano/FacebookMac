//
//  MAVTrayViewController.m
//  FacebookMac
//
//  Created by Murilo Adriano Vasconcelos on 13/05/13.
//  Copyright (c) 2013 Murilo Adriano Vasconcelos. All rights reserved.
//

#import "MAVTrayViewController.h"
#import "MAVFriendContainer.h"
#import <QuartzCore/QuartzCore.h>

@implementation MAVTrayViewController

static MAVTrayViewController* singletonTrayView = nil;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	[self loadView];

	// Fixing the blur when scrolling
	NSClipView* cv = (NSClipView*)[self.tableView superview];
	[cv setCopiesOnScroll:NO];

	[self.arrController setSortDescriptors:
	 [NSArray arrayWithObjects:
	  [NSSortDescriptor sortDescriptorWithKey:@"online" ascending:YES
								   comparator:^(id obj1, id obj2) {
									   if (obj1 < obj2) {
										   return NSOrderedAscending;
									   }
									   return NSOrderedDescending;
								   }],
	  [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES
									 selector:@selector(caseInsensitiveCompare:)], nil]];

	[self.tableView setRowHeight:32];

    return self;
}

+ (MAVTrayViewController*)trayViewController {
	if (singletonTrayView == nil) {
		singletonTrayView = [[MAVTrayViewController alloc] initWithNibName:@"MAVTrayViewController"
																	bundle:[NSBundle mainBundle]];
	}
	return singletonTrayView;
}

- (void)addFriend:(MAVFacebookFriend*)fbFriend {
	if (MAVFriendDict == nil) {
		MAVFriendDict = [[NSMutableDictionary alloc] init];
	}

	MAVFriendContainer* fc = [[MAVFriendContainer alloc] init];
	[fc setFbFriend:fbFriend];

	[self.arrController addObject:fbFriend];
	[self.arrController rearrangeObjects];

	[MAVFriendDict setObject:fc forKey:[fbFriend identifier]];
}

- (IBAction)updateFilterAction:(id)sender {
	NSLog(@"UPDATE SEARCH");
	NSString* searchString = [self.searchField stringValue];
	NSPredicate* predicate = nil;

	if (![searchString isEqualTo:@""]) {
		NSMutableDictionary* dict = [NSMutableDictionary new];
		[dict setObject:searchString forKey:@"searchString"];
		predicate = [[NSPredicate predicateWithFormat:@"(name contains[cd] $searchString)"]
					 predicateWithSubstitutionVariables:dict];
	}

	[self.arrController setFilterPredicate:predicate];
}

@end

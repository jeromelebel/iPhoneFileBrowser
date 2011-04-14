//
//  UntitledAppDelegate.m
//  Untitled
//
//  Created by Jérôme Lebel on 29/01/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "UntitledAppDelegate.h"
#import "FolderController.h"

@implementation UntitledAppDelegate

@synthesize window, savedLocation;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    self.savedLocation = [[NSUserDefaults standardUserDefaults] objectForKey:@"DefaultPath"];
    if (savedLocation == nil || ![savedLocation isKindOfClass:[NSString class]]) {
        self.savedLocation = @"/";
    }
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
    
    NSArray *pathComponents;
    pathComponents = [savedLocation pathComponents];
    if ([pathComponents count] > 1) {
        [(FolderController *)navigationController.topViewController restoreLevel:pathComponents withIndex:1];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] setObject:savedLocation forKey:@"DefaultPath"];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
}


- (void)dealloc
{
	[navigationController release];  
    [savedLocation release];
	[window release];
	[super dealloc];
}

@end

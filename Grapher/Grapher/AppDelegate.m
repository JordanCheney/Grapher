//
//  AppDelegate.m
//  Grapher
//
//  Created by Jordan Cheney on 3/20/14.
//  Copyright (c) 2014 Swarthmore College. All rights reserved.
//

#import <DBChooser/DBChooser.h>

#import "AppDelegate.h"
#import "DropBoxController.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    DropBoxController *mainViewController = [[DropBoxController alloc] init];
    
    self.window.rootViewController = mainViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url sourceApplication:(NSString *)source annotation:(id)annotation
{
    
    if ([[DBChooser defaultChooser] handleOpenURL:url]) {
        // This was a Chooser response and handleOpenURL automatically ran the
        // completion block
        return YES;
    }
    
    return NO;
}

@end

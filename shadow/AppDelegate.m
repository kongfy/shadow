//
//  AppDelegate.m
//  shadow
//
//  Created by kongfy on 14-4-1.
//  Copyright (c) 2014年 com.kongfy. All rights reserved.
//

#import "AppDelegate.h"

#import "ShadowViewController.h"
#import "ShadowObject.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    

    ShadowViewController *rootVC = [[ShadowViewController alloc] init];
    
    ShadowObject *object = nil;
    NSMutableArray *objectsArray = [[NSMutableArray alloc] initWithCapacity:20];
    object = [[ShadowObject alloc] initWithDistance:200.0 X:-1.0 Y:0.0 Z:0.0];
    [objectsArray addObject:object];
    object = [[ShadowObject alloc] initWithDistance:10.0 X:0.0 Y:0.0 Z:1.0];
    [objectsArray addObject:object];
    object = [[ShadowObject alloc] initWithDistance:1000.0 X:1.0 Y:1.0 Z:1.0];
    [objectsArray addObject:object];
    
    rootVC.objects = objectsArray;
    
    self.window.rootViewController = rootVC;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

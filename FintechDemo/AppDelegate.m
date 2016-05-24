//
//  AppDelegate.m
//  FintechDemo
//
//  Created by Ívar Örn Helgason on 18/05/16.
//  Copyright © 2016 Ívar Örn Helgason. All rights reserved.
//

#import "AppDelegate.h"
#import "NXOAuth2.h"
#import "Constants.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [UITabBar appearance].tintColor = [UIColor colorWithRed:0.0/255.0 green:72.0/255.0 blue:142.0/255.0 alpha:1.0];
    
    // Override point for customization after application launch.
    [[NXOAuth2AccountStore sharedStore] setClientID:@"<API CLIENT ID>"
                                             secret:@"<API CLIENT SECRET>" 
                                              scope:[NSSet setWithObjects:kArionFintechAuthorizationScopes, nil]
                                   authorizationURL:[NSURL URLWithString:kArionFintechAuthorizationUrl]
                                           tokenURL:[NSURL URLWithString:kArionFintechAuthorizationTokenUrl]
                                        redirectURL:[NSURL URLWithString:kArionFintechRedirectUrl]
                                      keyChainGroup:@"is.arionfintech.ios.demo"
                                     forAccountType:kArionFintechOAuth2AccountType];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Url Scheme handling
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSDictionary *dict = [self parseQueryString:[url query]];
    NSLog(@"query dict: %@", dict);
    if([[url absoluteString] hasPrefix:kArionFintechRedirectUrl])
    {
        [[NXOAuth2AccountStore sharedStore] handleRedirectURL:url];
    }
    return NO;
}

- (NSDictionary *)parseQueryString:(NSString *)query
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}

@end

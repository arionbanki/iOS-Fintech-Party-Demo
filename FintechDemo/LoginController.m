	//
//  LoginController.m
//  FintechDemo
//
//  Created by Ívar Örn Helgason on 18/05/16.
//  Copyright © 2016 Ívar Örn Helgason. All rights reserved.
//

#import "LoginController.h"
#import "NXOAuth2.h"
#import "Constants.h"

@interface LoginController()
{
    __weak IBOutlet UIWebView *_loginview;
}
@end

@implementation LoginController

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreAccountsDidChangeNotification
                                                      object:[NXOAuth2AccountStore sharedStore]
                                                       queue:nil
                                                  usingBlock:^(NSNotification *aNotification){
                                                      [self performSegueWithIdentifier:@"unwindFromLoginWithSuccess" sender:self];
                                                  }];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreDidFailToRequestAccessNotification
                                                      object:[NXOAuth2AccountStore sharedStore]
                                                       queue:nil
                                                  usingBlock:^(NSNotification *aNotification){
                                                      NSLog(@"Failed logging in");
                                                      [self performSegueWithIdentifier:@"unwindFromLoginWithFailure" sender:self];
                                                  }];
    
    [self setupAuthHeaders];
    
    
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"arionFintechApi"
                                   withPreparedAuthorizationURLHandler:^(NSURL *preparedURL){
                                        [_loginview loadRequest:[NSURLRequest requestWithURL:preparedURL]];
                                   }];
}

-(void)setupAuthHeaders
{
    NSMutableDictionary *configuration = [NSMutableDictionary dictionaryWithDictionary:[[NXOAuth2AccountStore sharedStore] configurationForAccountType:kArionFintechOAuth2AccountType]];
    NSMutableDictionary *customHeaderFields = [NSMutableDictionary dictionary];
    [customHeaderFields setObject:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
    [configuration setObject:customHeaderFields forKey:kNXOAuth2AccountStoreConfigurationCustomHeaderFields];
    
    NSMutableDictionary *customHeaderFields2 = [NSMutableDictionary dictionary];
    [customHeaderFields2 setObject:kArionFintechDeveloperKey forKey:@"Ocp-Apim-Subscription-Key"];
    [configuration setObject:customHeaderFields2 forKey:kNXOAuth2AccountStoreConfigurationAdditionalAuthenticationParameters];
    
    [[NXOAuth2AccountStore sharedStore] setConfiguration:configuration forAccountType:kArionFintechOAuth2AccountType];
}


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
}

#pragma mark - UIWebView

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    /* Show network activity indicator */
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    /* Hide network activity indicator */
    [UIApplication sharedApplication].networkActivityIndicatorVisible = FALSE;
}

@end

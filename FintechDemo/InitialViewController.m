//
//  InitialViewController.m
//  FintechDemo
//
//  Created by Ívar Örn Helgason on 19/05/16.
//  Copyright © 2016 Ívar Örn Helgason. All rights reserved.
//

#import "InitialViewController.h"
#import "NXOAuth2.h"
#import "Constants.h"


@interface InitialViewController ()

@end

@implementation InitialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /* Check if we have an active session */
    if([[[NXOAuth2AccountStore sharedStore] accountsWithAccountType:kArionFintechOAuth2AccountType] firstObject] != nil)
    {
        [self performSegueWithIdentifier:@"showTabBarSegue" sender:self];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindFromLoginWithSuccess:(UIStoryboardSegue *)unwindSegue
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"showTabBarSegue" sender:self];
    });
}

- (IBAction)unwindFromLoginWithFailure:(UIStoryboardSegue *)unwindSegue
{
    
}

- (IBAction)unwindFromLogoutAction:(UIStoryboardSegue *)unwindSegue
{
    
}

- (IBAction)unwindFromLoginWithUserCancelling:(UIStoryboardSegue *)unwindSegue
{
    
}
@end

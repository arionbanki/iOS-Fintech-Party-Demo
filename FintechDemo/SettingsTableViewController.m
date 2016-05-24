//
//  SettingsTableViewController.m
//  FintechDemo
//
//  Created by Ívar Örn Helgason on 20.5.2016.
//  Copyright © 2016 Ívar Örn Helgason. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "NXOAuth2.h"
#import "Constants.h"

@interface SettingsTableViewController()
{
    
    __weak IBOutlet UILabel *_labelJWTInfoSubject;
    __weak IBOutlet UILabel *_labelJWTInfoClientID;
    __weak IBOutlet UILabel *_labelJWTInfoTokenExpires;
    __weak IBOutlet UILabel *_labelJWTInfoScope;
}

@end
@implementation SettingsTableViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *jwtContents = [self decodeJWT:[[[[NXOAuth2AccountStore sharedStore] accountsWithAccountType:kArionFintechOAuth2AccountType] firstObject] accessToken].accessToken];
    
    [_labelJWTInfoSubject setText:[jwtContents objectForKey:@"sub" ]];
    [_labelJWTInfoClientID setText:[jwtContents objectForKey:@"client_id" ]];
    [_labelJWTInfoTokenExpires setText:[NSString stringWithFormat:@"%@", [jwtContents objectForKey:@"exp" ]]];
    [_labelJWTInfoScope setText:[jwtContents objectForKey:@"scope" ]];
    
}

- (IBAction)performLogout:(id)sender
{
    //TODO: Call logout action on authorization server.
    
    for(NXOAuth2Account *account in [[NXOAuth2AccountStore sharedStore] accountsWithAccountType:kArionFintechOAuth2AccountType])
    {
        [[NXOAuth2AccountStore sharedStore] removeAccount:account];
    }
    
    [self performSegueWithIdentifier:@"unwindFromLogoutAction" sender:self];
}

-(NSDictionary*) decodeJWT:(NSString*) token
{
    NSArray *segments = [token componentsSeparatedByString:@"."];
    NSString *base64String = [segments objectAtIndex: 1];
    NSLog(@"%@", base64String);
    
    int requiredLength = (int)(4 * ceil((float)[base64String length] / 4.0));
    unsigned long nbrPaddings = requiredLength - [base64String length];
    
    if (nbrPaddings > 0) {
        NSString *padding =
        [[NSString string] stringByPaddingToLength:nbrPaddings
                                        withString:@"=" startingAtIndex:0];
        base64String = [base64String stringByAppendingString:padding];
    }
    
    base64String = [base64String stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
    base64String = [base64String stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
    
    NSData *decodedData =
    [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    NSString *decodedString =
    [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", decodedString);
    
    NSDictionary *jsonDictionary =
    [NSJSONSerialization JSONObjectWithData:[decodedString
                                             dataUsingEncoding:NSUTF8StringEncoding]
                                    options:0 error:nil];
    NSLog(@"%@", jsonDictionary);
    
    return jsonDictionary;
    
}

@end

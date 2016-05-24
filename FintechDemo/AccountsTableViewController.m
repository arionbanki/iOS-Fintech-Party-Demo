//
//  AccountsTableViewController.m
//  FintechDemo
//
//  Created by Ívar Örn Helgason on 19/05/16.
//  Copyright © 2016 Ívar Örn Helgason. All rights reserved.
//

#import "AccountsTableViewController.h"
#import "NXOAuth2.h"
#import "Constants.h"

@interface AccountsTableViewController ()
{
    NSMutableArray *_accounts;
    NXOAuth2Connection *_acitveConnection;
}
@end

@implementation AccountsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _accounts = [NSMutableArray arrayWithCapacity:0];
    [self fetchAccounts];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    _accounts = nil;
    _acitveConnection = nil; 
}

- (void)fetchAccounts
{
    /* Show network activity indicator */
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    
    
    NXOAuth2Request *theRequest = [[NXOAuth2Request alloc] initWithResource:[NSURL URLWithString:kArionFintechAccountsUrl]
                                                                     method:@"GET"
                                                                 parameters:nil];
    
    /* Assign logged in account to request */
    theRequest.account = [[[NXOAuth2AccountStore sharedStore] accountsWithAccountType:kArionFintechOAuth2AccountType] firstObject];
    
    NSMutableURLRequest *signedRequest = [[theRequest signedURLRequest] mutableCopy];
    [signedRequest setHTTPMethod:@"GET"];
    [signedRequest setValue:kArionFintechDeveloperKey forHTTPHeaderField:@"Ocp-Apim-Subscription-Key"];
    
    _acitveConnection = [[NXOAuth2Connection alloc] initWithRequest:signedRequest
                                                               requestParameters:nil
                                                                     oauthClient:theRequest.account.oauthClient
                                                          sendingProgressHandler:nil
                                                                 responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error){
                                                                     
                                                                     /* Hide network activity indicator */
                                                                     [UIApplication sharedApplication].networkActivityIndicatorVisible = FALSE;
                                                                     [self.refreshControl endRefreshing];
                                                                     
                                                                     /* Process the response */
                                                                     if(error != nil)
                                                                     {
                                                                         NSLog(@"%@", error);
                                                                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                                         message:error.localizedDescription
                                                                                                                        delegate:self
                                                                                                               cancelButtonTitle:@"OK"
                                                                                                               otherButtonTitles:nil];
                                                                         [alert show];
                                                                     }
                                                                     else //NoError
                                                                     {
                                                                         /* Remove old data */
                                                                         [_accounts removeAllObjects];
                                                                         
                                                                         NSError *jsonParseError = nil;
                                                                         id object = [NSJSONSerialization
                                                                                      JSONObjectWithData:responseData
                                                                                      options:0
                                                                                      error:&error];
                                                                         
                                                                         if(jsonParseError)
                                                                         {
                                                                             /* JSON was malformed */
                                                                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parser error"
                                                                                                                             message:jsonParseError.localizedDescription
                                                                                                                            delegate:self
                                                                                                                   cancelButtonTitle:@"OK"
                                                                                                                   otherButtonTitles:nil];
                                                                             [alert show];
                                                                         }
                                                                         
                                                                         /* Data ok */
                                                                         if([object isKindOfClass:[NSDictionary class]])
                                                                         {
                                                                             NSArray *data = [object objectForKey:@"account"];
                                                                             for(NSDictionary *accountItem in data)
                                                                             {
                                                                                 NSArray *accountItemForCell = [NSArray arrayWithObjects:[accountItem objectForKey:@"accountID"], [accountItem objectForKey:@"availableAmount"], nil];
                                                                                 [_accounts addObject:accountItemForCell];
                                                                             }
                                                                             
                                                                             /* Hide network activity indicator */
                                                                             [UIApplication sharedApplication].networkActivityIndicatorVisible = FALSE;
                                                                             [self.tableView reloadData];
                                                                         }
                                                                         else /* Incorrect data format */
                                                                         {
                                                                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid data format"
                                                                                                                             message:jsonParseError.localizedDescription
                                                                                                                            delegate:self
                                                                                                                   cancelButtonTitle:@"OK"
                                                                                                                   otherButtonTitles:nil];
                                                                             [alert show];
                                                                         }
                                                                         
                                                                     }
                                                            }];
    
    
    
}

- (IBAction)pullToRefresh:(id)sender
{
    [self fetchAccounts];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_accounts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accountCell" forIndexPath:indexPath];
    NSArray *cellData = [_accounts objectAtIndex:indexPath.row];
    
    /* Configure cell... */
    [cell.textLabel setText:[cellData objectAtIndex:0]];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@", [cellData objectAtIndex:1]]];
    
    return cell;
}

@end

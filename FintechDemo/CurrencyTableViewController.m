//
//  CurrencyTableViewController.m
//  FintechDemo
//
//  Created by Ívar Örn Helgason on 20.5.2016.
//  Copyright © 2016 Ívar Örn Helgason. All rights reserved.
//

#import "CurrencyTableViewController.h"
#import "AFNetworking.h"
#import "Constants.h"

@interface CurrencyTableViewController ()
{
    NSMutableArray *_currencyItems;
}
@end

@implementation CurrencyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currencyItems = [NSMutableArray arrayWithCapacity:0];
    [self fetchDataFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    _currencyItems = nil; 
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _currencyItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"currencyCell" forIndexPath:indexPath];
    
    /* Configure the cell...*/
    [cell.textLabel setText:[[_currencyItems objectAtIndex:indexPath.row] objectForKey:@"currencyCode"] ];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"Kaup %@ / Sala %@", [[_currencyItems objectAtIndex:indexPath.row] objectForKey:@"buyRate"], [[_currencyItems objectAtIndex:indexPath.row] objectForKey:@"sellRate"]]];
    return cell;
}

- (IBAction)pullToRefresh:(id)sender
{
    [self fetchDataFromServer];
}

- (void) fetchDataFromServer
{
    /* Show network activity indicator */
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:kArionFintechDeveloperKey forHTTPHeaderField:@"Ocp-Apim-Subscription-Key"];
    [manager GET:kArionFintechCurrencyUrl parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        [_currencyItems removeAllObjects];
        
        for(NSDictionary *item in [responseObject objectForKey:@"currencyWithBuyAndSellRate"])
        {
            [_currencyItems addObject:[NSDictionary dictionaryWithDictionary:item]];
            
        }
        
        /* Hide network activity indicator */
        [UIApplication sharedApplication].networkActivityIndicatorVisible = FALSE;
        
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


@end

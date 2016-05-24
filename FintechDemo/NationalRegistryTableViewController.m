//
//  NationalRegistryTableViewController.m
//  FintechDemo
//
//  Created by Ívar Örn Helgason on 20.5.2016.
//  Copyright © 2016 Ívar Örn Helgason. All rights reserved.
//

#import "NationalRegistryTableViewController.h"
#import "AFNetworking.h"
#import "Constants.h"

@interface NationalRegistryTableViewController ()
{
    NSMutableArray *_searchResults;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation NationalRegistryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _searchResults = [NSMutableArray arrayWithCapacity:0];
 }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    _searchResults = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchResults.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nationalRegistrySearchResultsCell" forIndexPath:indexPath];
    
    /* Configure the cell... */
    [cell.textLabel setText:[[_searchResults objectAtIndex:indexPath.row] objectForKey:@"FullName"] ];
    [cell.detailTextLabel setText:[[_searchResults objectAtIndex:indexPath.row] objectForKey:@"Home"] ];
    return cell;
}

#pragma mark UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"Search Button Clicked. SearchText is: %@", searchBar.text);
    [searchBar resignFirstResponder];
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([searchBar.text rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        /* If input consists only of the digits 0 through 9 we'll assume it's kennitala */
        [self searchByKennitala:searchBar.text];
    }
    else
    {
        [self searchByName:searchBar.text];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length ==  0)
    {
        [searchBar resignFirstResponder];
    }
    [_searchResults removeAllObjects];
    [self.tableView reloadData];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

#pragma mark Search methods
- (void) searchByKennitala:(NSString*) searchString
{
    /* Show network activity indicator */
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:kArionFintechDeveloperKey forHTTPHeaderField:@"Ocp-Apim-Subscription-Key"];
    [manager GET:[NSString stringWithFormat:kArionFintechNationalRegistryPartyUrl, searchString] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        [_searchResults removeAllObjects];
        [_searchResults addObject:[NSDictionary dictionaryWithDictionary:responseObject]];
        
        /* Hide network activity indicator */
        [UIApplication sharedApplication].networkActivityIndicatorVisible = FALSE;
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void) searchByName:(NSString*) searchString
{
    /* Show network activity indicator */
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:kArionFintechDeveloperKey forHTTPHeaderField:@"Ocp-Apim-Subscription-Key"];
    [manager GET:[NSString stringWithFormat:kArionFintechNationalRegistryPartiesUrl, [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        [_searchResults removeAllObjects];
        
        for(NSDictionary *item in responseObject)
        {
            [_searchResults addObject:[NSDictionary dictionaryWithDictionary:item]];
        }
        /* Hide network activity indicator */
        [UIApplication sharedApplication].networkActivityIndicatorVisible = FALSE;
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end

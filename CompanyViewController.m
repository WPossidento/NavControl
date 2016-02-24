//
//  CompanyViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import "CompanyViewController.h"


@interface CompanyViewController ()

@end

@implementation CompanyViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject)];
    
    self.sharedManager = [MyManager sharedManager];

    self.title = @"Mobile device makers";
    
    NSLog(@"%@", [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://download.finance.yahoo.com/d/quotes.csv?s=BP.L&f=sl1d1t1c1ohgv&e=.csv"] encoding:NSUTF8StringEncoding error:nil]);

    
}

-(void)toggleEdit{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    
    if (self.tableView.editing)
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
    else
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self setEditing:NO animated:NO];

    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.sharedManager.companyList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    cell.textLabel.text = [[ self.sharedManager.companyList objectAtIndex:[indexPath row]  ] companyName];
    cell.imageView.image = [[self.sharedManager.companyList objectAtIndex:[indexPath row]] companyLogo];
    
    
    
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.sharedManager.companyList removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    
    
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [self.sharedManager.companyList exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}



#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.productViewController.title = [[self.sharedManager.companyList objectAtIndex:[indexPath row]] companyName];
    
    self.sharedManager.currentCompanyNumber = [indexPath row];
    
    if (self.tableView.editing == YES) {
        
        NSLog(@"EDIT MODE!!!");
        [self editCompany];

        
    } else {
    
        [self.navigationController
         pushViewController:self.productViewController
         animated:YES];
        
    }

}

-(void) insertNewObject {
    self.addCompanyViewController = [[AddCompanyViewController alloc] initWithNibName:@"AddCompanyViewController" bundle:nil];
    
    self.addCompanyViewController.title = @"Add New Company";
    
    [self.navigationController
     pushViewController:self.addCompanyViewController animated:YES];
    
}

-(void) editCompany {
    self.addCompanyViewController = [[AddCompanyViewController alloc] initWithNibName:@"AddCompanyViewController" bundle:nil];
    
//    self.addCompanyViewController = [[AddCompanyViewController alloc] initWithCompany: [self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber]];

    
    self.addCompanyViewController.title = [NSString stringWithFormat: @"Edit %@", [[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] companyName]];
    
        [self.navigationController
     pushViewController:self.addCompanyViewController animated:YES];
    
}


@end

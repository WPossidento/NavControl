//
//  CompanyViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import "CompanyViewController.h"


@interface CompanyViewController ()

@property (nonatomic) NSManagedObjectContext *context;
@property (nonatomic) NSManagedObjectModel *model;

@end

@implementation CompanyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *undoButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(undoButtonClicked)];
    
    self.navigationItem.rightBarButtonItems = @[self.editButtonItem, undoButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject)];

    self.title = @"Mobile device makers";
    
    self.sharedManager = [MyManager sharedManager];
    
    
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    cell.textLabel.text = [[ self.sharedManager.companyList objectAtIndex:[indexPath row]] name];
    //cell.imageView.image = [UIImage imageNamed:[[self.sharedManager.companyList objectAtIndex:[indexPath row]] logo]];
    cell.imageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.png",self.sharedManager.imagesPath, [self.sharedManager.companyList objectAtIndex:indexPath.row].name]];
    
//    NSLog(@"imagespath:%@",[NSString stringWithFormat:@"%@/%@.png",self.sharedManager.imagesPath, [[self.sharedManager.companyList objectAtIndex:[indexPath row]] name]]);
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
        //[self.sharedManager deleteCompany:indexPath.row];
        //[self.sharedManager updatePositionForCompany];
        
        [self.sharedManager deleteCompanyFromCoreData:indexPath.row];
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
    [self.sharedManager updatePositionInCoreDataForCompaniesFrom: (NSUInteger)fromIndexPath.row To:(NSUInteger)toIndexPath.row];
    
    Company *comp = [self.sharedManager.companyList objectAtIndex:fromIndexPath.row];
    [self.sharedManager.companyList removeObject:comp];
    [self.sharedManager.companyList insertObject:comp atIndex:toIndexPath.row];

    [self.tableView reloadData];
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
    self.productViewController.title = [[self.sharedManager.companyList objectAtIndex:[indexPath row]] name];
    
    self.sharedManager.currentCompanyNumber = [indexPath row];
    
    if (self.tableView.editing == YES) {
        
        NSLog(@"EDIT MODE!!!");
        self.sharedManager.isCompanyInEditMode = YES;
        [self editCompany];

        
    } else {
        
        [self.navigationController
         pushViewController:self.productViewController
         animated:YES];
        
    }

}

-(void) insertNewObject {
    
    AddCompanyViewController *addCompanyViewController = [[AddCompanyViewController alloc] initWithNibName:@"AddCompanyViewController" bundle:nil];
    
    addCompanyViewController.title = @"Add New Company";
    
    self.sharedManager.isCompanyInEditMode = NO;

    [self.navigationController
     pushViewController:addCompanyViewController animated:YES];
    
    [addCompanyViewController release];
    
}

-(void) editCompany {
    AddCompanyViewController *addCompanyViewController = [[AddCompanyViewController alloc] initWithNibName:@"AddCompanyViewController" bundle:nil];
    
    addCompanyViewController.title = [NSString stringWithFormat: @"Edit %@", [[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] name]];
    
        [self.navigationController
     pushViewController:addCompanyViewController animated:YES];
    
    [addCompanyViewController release];
    
}

-(void) undoButtonClicked {
    
    [self.sharedManager undoLastAction];
    [self.tableView reloadData];
}


@end

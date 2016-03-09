//
//  ProductViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import "ProductViewController.h"

@interface ProductViewController ()

@property (nonatomic, retain) NSMutableArray *products;
@property (nonatomic, retain) NSMutableArray *productsLogos;

@end

@implementation ProductViewController

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
    UIBarButtonItem *undoButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self.sharedManager action:@selector(undoButtonClicked)];
    
    self.navigationItem.rightBarButtonItems = @[self.editButtonItem, undoButton];
    
    self.sharedManager = [MyManager sharedManager];
    
    self.tableView.allowsSelectionDuringEditing = YES;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self setEditing:NO animated:NO];
    
    NSLog(@"current company: %lu", self.sharedManager.currentCompanyNumber);

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
    return [[[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    // Configure the cell...
    
    
    cell.textLabel.text = [[[[self.sharedManager.companyList  objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] objectAtIndex:indexPath.row] name];
    
//    cell.imageView.image = [UIImage imageNamed:[[[[self.sharedManager.companyList  objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] objectAtIndex:indexPath.row] logo]];
    
    cell.imageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.png",self.sharedManager.imagesPath, [[[[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] objectAtIndex:indexPath.row] name]]];
    
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
        
        
        [[[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber ] productsList] removeObjectAtIndex:indexPath.row];
        //[self.sharedManager deleteProduct:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    
    [self.sharedManager updatePositionInCoreDataForProductsFrom:fromIndexPath.row To:toIndexPath.row];
    
    Product *prod = [[[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] objectAtIndex:fromIndexPath.row];
    [[[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] removeObject:prod];
    [[[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] insertObject:prod atIndex:toIndexPath.row];
    
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
//     Navigation logic may go here, for example:
//     Create the next view controller.
//
//     Pass the selected object to the new view controller.
//    
//     Push the view controller.
//    [self.navigationController pushViewController:detailViewController animated:YES];

    
    self.sharedManager.currentProductNumber = indexPath.row;
    
    if (self.tableView.editing == YES) {
        
        NSLog(@"EDIT MODE!!!");
        
        EditProductViewController *editProductViewController = [[EditProductViewController alloc] initWithNibName:@"EditProductViewController" bundle:nil];

        editProductViewController.title = [NSString stringWithFormat:@"Edit %@",[[[[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] objectAtIndex:indexPath.row] name]];
        
        [self.navigationController
         pushViewController:editProductViewController animated:YES];
        
        [self setEditing:NO animated:NO];
        
        [editProductViewController release];
        
    } else {
        
        WebViewController *webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];

        webViewController.title = [[[[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber]productsList] objectAtIndex:indexPath.row] name];
        
        [self.navigationController
         pushViewController:webViewController animated:YES];
        
        [webViewController release];

        
    }

}

-(void) undoButtonClicked {
    
    [self.sharedManager undoLastAction];
    [self.tableView reloadData];
}



@end

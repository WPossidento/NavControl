//
//  ProductViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import "ProductViewController.h"

@interface ProductViewController ()
{
    int counter;
}

@property (nonatomic, retain) NSMutableArray *products;
@property (nonatomic, retain) NSMutableArray *productsLogos;

@property (nonatomic, retain) WebViewController *webViewController;


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
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.sharedManager = [MyManager sharedManager];
    
    self.products = [[NSMutableArray alloc] initWithObjects:
                     [[NSMutableArray alloc] initWithObjects: @"iPad", @"iPod Touch",@"iPhone", nil],
                     [[NSMutableArray alloc] initWithObjects:@"Galaxy S4", @"Galaxy Note", @"Galaxy Tab", nil],
                     [[NSMutableArray alloc] initWithObjects: @"Lumia 950XL", @"Lumia 550", @"Lumia 1520", nil],
                     [[NSMutableArray alloc] initWithObjects: @"Signature", @"The New Signature Touch", @"Aster", nil],
                     nil];
    
    self.productsLogos = [[NSMutableArray alloc] initWithObjects:
                          [[NSMutableArray alloc] initWithObjects:@"ipad.png",@"ipod.png",@"iphone.png", nil],
                          [[NSMutableArray alloc] initWithObjects: @"s4.png",@"note.png",@"tab.png", nil],
                          [[NSMutableArray alloc] initWithObjects:@"lumia950xl.png",@"lumia550.png",@"lumia1520.png", nil],
                          [[NSMutableArray alloc] initWithObjects:@"signature.png",@"stouch.jpeg",@"aster.png", nil],
                          nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    cell.textLabel.text = [[[[self.sharedManager.companyList  objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] objectAtIndex:indexPath.row] productName];
    
    cell.imageView.image = [UIImage imageNamed:[[[[self.sharedManager.companyList  objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] objectAtIndex:indexPath.row] productLogo]];
    
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
        
        [[self.products objectAtIndex:counter] removeObjectAtIndex:indexPath.row];
        [[self.productsLogos objectAtIndex:counter] removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [[[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
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
        self.webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
//
//     Pass the selected object to the new view controller.
//    
//     Push the view controller.
//    [self.navigationController pushViewController:detailViewController animated:YES];

    self.webViewController.title = [[[[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber]productsList] objectAtIndex:indexPath.row] productName];
    
    self.sharedManager.currentProductNumber = indexPath.row;
    [self.navigationController
     pushViewController:self.webViewController animated:YES];
}



@end

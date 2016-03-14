//
//  ProductCollectionViewController.m
//  NavCtrl
//
//  Created by Vladyslav Gusakov on 3/11/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "ProductCollectionViewController.h"

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

@interface ProductCollectionViewController ()

@property (nonatomic, retain) MyManager *sharedManager;

@end

@implementation ProductCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[CustomCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellWithReuseIdentifier: reuseIdentifier];
    
    self.installsStandardGestureForInteractiveMovement = YES;
    
    UIBarButtonItem *undoButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(undoButtonClicked)];
    
    self.navigationItem.rightBarButtonItems = @[self.editButtonItem, undoButton];

    
    // Do any additional setup after loading the view.
    self.sharedManager = [MyManager sharedManager];
    
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self setEditing:NO animated:NO];
    
    [self.collectionView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber].productsList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    NSString *pathToName = [[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber].productsList objectAtIndex:indexPath.row].name;
    
    cell.imageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.png",self.sharedManager.imagesPath, [[[[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] objectAtIndex:indexPath.row] name]]];
    
    cell.companyNameLabel.text = pathToName;
    
    if (self.editing) {
        
        cell.deleteButton.hidden = NO;
        
//        CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-5.0));
//        CGAffineTransform rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(5.0));
//        
//        cell.transform = leftWobble;  // starting point
//        
//        [CustomCell animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction animations:^{
//            [CustomCell setAnimationRepeatAutoreverses:YES];
//            cell.transform = rightWobble; // end here & auto-reverse
//            
//        } completion:nil];
        
    }
    else {
        cell.deleteButton.hidden = YES;
//        [cell.layer removeAllAnimations];
    }
    
    [cell.deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WebViewController *webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    
    self.sharedManager.currentProductNumber = indexPath.row;

    if (self.editing == YES) {
        
        NSLog(@"EDIT MODE!!!");
        
        EditProductViewController *editProductViewController = [[EditProductViewController alloc] initWithNibName:@"EditProductViewController" bundle:nil];
        
        editProductViewController.title = [NSString stringWithFormat:@"Edit %@",[[[[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] objectAtIndex:indexPath.row] name]];
        
        [self.navigationController
         pushViewController:editProductViewController animated:YES];
        
        [self setEditing:NO animated:NO];
        
        [editProductViewController release];
        
    } else {
        
    webViewController.title = [[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber].productsList objectAtIndex:self.sharedManager.currentProductNumber].name;
    
    [self.navigationController pushViewController:webViewController animated:YES];
    }
    
    
}

-(void) collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    [self.sharedManager updatePositionInCoreDataForProductsFrom:sourceIndexPath.row To:destinationIndexPath.row];
    
    Product *prod = [[[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] objectAtIndex:sourceIndexPath.row];
    
    if (destinationIndexPath.row == 0) {
        prod.pos = [[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] productsList].firstObject.pos/2;
    } else
        if (destinationIndexPath.row == [[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] productsList].count-1) {
            prod.pos = [[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] productsList].lastObject.pos + 1024;
        } else {
            // to do
            prod.pos = ([[[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] objectAtIndex:destinationIndexPath.row].pos + [[[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] objectAtIndex:destinationIndexPath.row + 1].pos)/2;
        }
    
    [[[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] removeObject:prod];
    [[[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] insertObject:prod atIndex:destinationIndexPath.row];

    
    [self.collectionView reloadData];
    
    
}


-(void) deleteButtonClicked: (id) sender {
    
    UIButton *senderButton = (UIButton*) sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell: (CustomCell *)[[senderButton superview] superview]];
    
    [self.sharedManager deleteProductFromCoreData:indexPath.row];
    [[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber].productsList removeObjectAtIndex:indexPath.row];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    [self.collectionView reloadData];
    
}

-(void) undoButtonClicked {
    
    [self.sharedManager undoLastAction];
    [self.collectionView reloadData];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end

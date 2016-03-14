//
//  CompanyCollectionViewController.m
//  NavCtrl
//
//  Created by Vladyslav Gusakov on 3/11/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "CompanyCollectionViewController.h"

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)


@interface CompanyCollectionViewController ()

@property (nonatomic, retain) MyManager *sharedManager;
@end

@implementation CompanyCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
     self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[CustomCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellWithReuseIdentifier: reuseIdentifier];
    
    // Do any additional setup after loading the view.
    self.sharedManager = [MyManager sharedManager];
    
    UIBarButtonItem *undoButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(undoButtonClicked)];
    
    self.navigationItem.rightBarButtonItems = @[self.editButtonItem, undoButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject)];
    
    self.installsStandardGestureForInteractiveMovement = YES;
    
    self.title = @"Mobile Device Makers";
}

-(void) viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
    
    [self setEditing:NO animated:NO];
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
    return self.sharedManager.companyList.count;
}

- (CustomCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    cell.imageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.png",self.sharedManager.imagesPath, [self.sharedManager.companyList objectAtIndex:indexPath.row].name]];
    
    cell.companyNameLabel.text = [self.sharedManager.companyList objectAtIndex:indexPath.row].name;
    
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
    
    ProductCollectionViewController *productCollectionViewController = [[ProductCollectionViewController alloc] initWithNibName:@"ProductCollectionViewController" bundle:nil];
    
    productCollectionViewController.title = [self.sharedManager.companyList objectAtIndex:indexPath.row].name;
    self.sharedManager.currentCompanyNumber = indexPath.row;
    
    if (self.editing == YES) {
        
        NSLog(@"EDIT MODE!!!");
        self.sharedManager.isCompanyInEditMode = YES;
        [self editCompany];
    } else {
        
        [self.navigationController pushViewController:productCollectionViewController animated:YES];
    }
    
    
    
    
}


-(void) collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    [self.sharedManager updatePositionInCoreDataForCompaniesFrom: (NSUInteger)sourceIndexPath.row To:(NSUInteger)destinationIndexPath.row];
    
    Company *comp = [self.sharedManager.companyList objectAtIndex:sourceIndexPath.row];
    [self.sharedManager.companyList removeObject:comp];
    [self.sharedManager.companyList insertObject:comp atIndex:destinationIndexPath.row];
    
    [self.collectionView reloadData];

    
}

-(void) insertNewObject {
    
    AddCompanyViewController *addCompanyViewController = [[AddCompanyViewController alloc] initWithNibName:@"AddCompanyViewController" bundle:nil];
    
    addCompanyViewController.title = @"Add New Company";
    
    self.sharedManager.isCompanyInEditMode = NO;
    
    [self.navigationController pushViewController:addCompanyViewController animated:YES];
    
    [addCompanyViewController release];
    
}

-(void) editCompany {
    AddCompanyViewController *addCompanyViewController = [[AddCompanyViewController alloc] initWithNibName:@"AddCompanyViewController" bundle:nil];
    
    addCompanyViewController.title = [NSString stringWithFormat: @"Edit %@", [[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] name]];
    
    [self.navigationController
     pushViewController:addCompanyViewController animated:YES];
    
    [addCompanyViewController release];
    
}

-(void) deleteButtonClicked: (id) sender {
    
    UIButton *senderButton = (UIButton*) sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell: (CustomCell *)[[senderButton superview] superview]];
    
    [self.sharedManager deleteCompanyFromCoreData:indexPath.row];
    [self.sharedManager.companyList removeObjectAtIndex:indexPath.row];
    [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
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

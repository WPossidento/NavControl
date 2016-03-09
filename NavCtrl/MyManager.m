//
//  DAO.m
//  NavCtrl
//
//  Created by Vladyslav Gusakov on 2/3/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "MyManager.h"

static MyManager *sharedMyManager = nil;

@interface MyManager ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation MyManager

{
    NSFileManager *fileManager;
    NSEntityDescription *companyEntityDescription;
    NSEntityDescription *productEntityDescription;
    bool isFirstLaunch;
    NSError *error;
}


//#pragma mark Singleton Methods
//+ (MyManager*)sharedManager
//{
//    // 1
//    static MyManager *_sharedInstance = nil;
//    
//    // 2
//    static dispatch_once_t oncePredicate;
//    
//    // 3
//    dispatch_once(&oncePredicate, ^{
//        _sharedInstance = [[MyManager alloc] init];
//    });
//    return _sharedInstance;
//}
#pragma mark Singleton Methods
+ (id)sharedManager {
    @synchronized(self) {
        if(sharedMyManager == nil)
            sharedMyManager = [[super allocWithZone:NULL] init];
    }
    return sharedMyManager; 
}

+ (id)allocWithZone:(NSZone *)zone {
    return [[self sharedManager] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return UINT_MAX; //denotes an object that cannot be released
}

- (oneway void)release {
    // never release
}

- (id)autorelease {
    return self;
}

#pragma mark - Init
- (id)init {
    if (self = [super init]) {
        NSLog(@"Init DAO");
        
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        
        self.imagesPath = [documentsPath stringByAppendingPathComponent:@"images"];
        
        fileManager = [NSFileManager defaultManager];
        
        //check for the first launch
        
        if (![fileManager fileExistsAtPath: [documentsPath stringByAppendingPathComponent:@"Core_Data.sqlite"]])
            
            isFirstLaunch = true;
        else
            isFirstLaunch = false;
        
        companyEntityDescription = [NSEntityDescription entityForName:@"Company" inManagedObjectContext:self.managedObjectContext];
        
        productEntityDescription = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.managedObjectContext];
        
        if (isFirstLaunch == true ) {
            [self createDataAtFirstLaunch];
        }
        else {
            //get companies from coredata;
            [self getCompaniesFromCoreData];
        }
        
        self.managedObjectContext.undoManager = [[[NSUndoManager alloc] init] autorelease];
        
    }
    return self;
}

- (void) createDataAtFirstLaunch {
    
    Product *iphone = [[Product alloc] initWithName:@"iPhone" andLogo:@"iphone.png" andURL:@"https://apple.com/iphone"];
    Product *ipod = [[Product alloc] initWithName:@"iPod" andLogo:@"ipod.png" andURL:@"https://apple.com/ipod"];
    Product *ipad = [[Product alloc] initWithName:@"iPad" andLogo:@"ipad.png" andURL:@"https://apple.com/ipad"];
    
    Company *apple = [[Company alloc] initWithName:@"Apple mobile devices" andLogo:@"apple_s.png" andProducts:[NSMutableArray arrayWithObjects: iphone, ipod, ipad, nil]];
    
    Product *galaxyS4 = [[Product alloc] initWithName:@"Galaxy S4" andLogo:@"s4.png" andURL:@"http://www.samsung.com/global/microsite/galaxys4/"];
    Product *galaxyNote = [[Product alloc] initWithName:@"Galaxy Note" andLogo:@"note.png" andURL:@"http://www.samsung.com/global/microsite/galaxynote/"];
    Product *galaxyTab = [[Product alloc] initWithName:@"Galaxy Tab" andLogo:@"tab.png" andURL:@"http://www.samsung.com/global/microsite/galaxytab/"];
    
    Company *samsung = [[Company alloc] initWithName:@"Samsung mobile devices" andLogo:@"samsung_s.png" andProducts:[NSMutableArray arrayWithObjects: galaxyS4, galaxyNote, galaxyTab, nil]];
    
    Product *lumia950XL = [[Product alloc] initWithName:@"Lumia 950XL" andLogo:@"lumia950xl.png" andURL:@"https://www.microsoft.com/en-us/mobile/phone/lumia950-xl-dual-sim/"];
    Product *lumia550 = [[Product alloc] initWithName:@"Lumia 550" andLogo:@"lumia550.png" andURL:@"https://www.microsoft.com/en-us/mobile/phone/lumia550/"];
    Product *lumia1520 = [[Product alloc] initWithName:@"Lumia 1520" andLogo:@"lumia1520.png" andURL:@"https://www.microsoft.com/en-us/mobile/phone/lumia1520/"];
    
    Company *microsoft = [[Company alloc] initWithName:@"Microsoft mobile devices" andLogo:@"microsoft.png" andProducts:[NSMutableArray arrayWithObjects:lumia950XL, lumia550, lumia1520, nil]];
    
    Product *signature = [[Product alloc] initWithName:@"Signature" andLogo:@"signature.png" andURL:@"http://www.vertu.com/us/en/collections/signature/"];
    Product *stouch = [[Product alloc] initWithName:@"The New Signature Touch" andLogo:@"stouch.jpeg" andURL:@"http://www.vertu.com/us/en/collections/signature-touch/"];
    Product *aster = [[Product alloc] initWithName:@"Aster" andLogo:@"aster.png" andURL:@"http://www.vertu.com/us/en/collections/aster/"];
    
    Company *vertu = [[Company alloc] initWithName:@"Vertu mobile devices" andLogo:@"vertu_s.png" andProducts:[NSMutableArray arrayWithObjects: signature, stouch, aster, nil]];
    
    self.companyList = [[NSMutableArray alloc] initWithObjects:apple, samsung, microsoft, vertu, nil];
    
    //create images folder
    
    [self createImagesFolder];
    
    //fill Core Data database
    [self fillCoreDataDB];
    
    NSLog(@"First launch data CREATED");
}

-(void) createImagesFolder {
    
    if (![fileManager fileExistsAtPath:self.imagesPath]) {
        [fileManager createDirectoryAtPath:self.imagesPath withIntermediateDirectories:NO attributes:nil error:&error];
        NSLog(@"'Images' folder created");
        
        //load additional images
        NSString *imageFile = [self.imagesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"noimg.png"]];
        
        NSLog(@"noimg.png image loaded");
        NSData *imgData = UIImagePNGRepresentation([UIImage imageNamed:@"noimg.png"]);
        [imgData writeToFile:imageFile atomically:YES];
        
        
    }
    else {
        NSLog(@"Failed to create 'images' folder OR it already exists");
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Core_Data" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Core_Data.sqlite"];
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
//         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
//         * Simply deleting the existing store:
        //[[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];

         //@{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}

        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


-(void) fillCoreDataDB {
    
    int i = 1024;
    int j = 1024;
    
    for (Company *newCompany in self.companyList) {
        
        Company_MO *newCompanyMO = [[Company_MO alloc] initWithEntity:companyEntityDescription insertIntoManagedObjectContext: self.managedObjectContext];
        
        [newCompanyMO setValue: newCompany.name forKey:@"name"];
        [newCompanyMO setValue: newCompany.logo forKey:@"logo"];
        [newCompanyMO setValue:@(i) forKey:@"pos"];
        i+=1024;
        
        //copy company image to 'images' folder
        
        NSString *imageFile = [self.imagesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",newCompany.name]];
        
        if (![fileManager fileExistsAtPath:imageFile]) {
            NSLog(@"company image loaded");
            NSData *companyImgData = UIImagePNGRepresentation([UIImage imageNamed:newCompany.logo]);
            [companyImgData writeToFile:imageFile atomically:YES];
        }
        
        //        NSMutableSet *productsList = [newCompanyMO mutableSetValueForKey:@"productsList"];
        
        for (Product *newProduct in newCompany.productsList) {
            
            Product_MO *newProductMO = [[Product_MO alloc] initWithEntity:productEntityDescription insertIntoManagedObjectContext: self.managedObjectContext];
            
            [newProductMO setValue:newProduct.name forKey:@"name"];
            [newProductMO setValue:newProduct.logo forKey:@"logo"];
            [newProductMO setValue:newProduct.url forKey:@"url"];
            [newProductMO setValue:@(j) forKey:@"pos"];
            j+=1024;
            
            [newCompanyMO addProductsListObject:newProductMO];
            //            [newProductMO setCompany:newCompanyMO]; another way
            //            [productsList addObject: newProductMO]; another way
            
            //copy product image to 'images' folder
            
            NSString *productImageFile = [self.imagesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",newProduct.name]];
            
            if (![fileManager fileExistsAtPath:productImageFile]) {
                NSLog(@"product image loaded");
                NSData *productImgData = UIImagePNGRepresentation([UIImage imageNamed:newProduct.logo]);
                [productImgData writeToFile:productImageFile atomically:YES];
            }
            
        }
        
        j = 1024;
        
        
        [self saveAllToCoreData];
        
    }

    
}

-(void) getCompaniesFromCoreData {
   
    self.companyList = [[[NSMutableArray alloc] init] autorelease];

    // Fetching
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Company"];
    
    // Add Sort Descriptor
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"pos" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Execute Fetch Request
    NSError *fetchError = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    
    if (!fetchError) {
        for (Company_MO *managedObject in result) {
            
            NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pos" ascending:YES]];
            
            NSMutableArray *productsListMO = [NSMutableArray arrayWithArray:[[managedObject.productsList allObjects] sortedArrayUsingDescriptors:sortDescriptors]];

            NSMutableArray *productsList = [[NSMutableArray alloc] init];
            
            for (Product_MO *productMO in productsListMO) {
                Product *newProduct = [[Product alloc] initWithName:productMO.name andLogo:productMO.logo andURL:productMO.url];
                [productsList addObject:newProduct];
                [newProduct release];
            }
            
            Company *newCompany = [[Company alloc] initWithName:managedObject.name andLogo:managedObject.logo andProducts: productsList];
            
            [productsList release];
            
            newCompany.pos = managedObject.pos;
            
            [self.companyList addObject:newCompany];
        }
        
    } else {
        NSLog(@"Error fetching data.");
        NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
    }
}

-(void) saveNewCompanyToCoreData {
    Company_MO *newCompanyMO = [[Company_MO alloc] initWithEntity:companyEntityDescription insertIntoManagedObjectContext:self.managedObjectContext];
    
    [newCompanyMO setValue:self.companyList.lastObject.name forKey:@"name"];
    [newCompanyMO setValue:self.companyList.lastObject.name forKey:@"logo"];
    [newCompanyMO setValue:@(self.companyList.count-1) forKey:@"pos"];
    
    int j = 1024;
    
    for (Product *product in self.companyList.lastObject.productsList) {
        Product_MO *productMO = [[Product_MO alloc] initWithEntity:productEntityDescription insertIntoManagedObjectContext:self.managedObjectContext];
        [productMO setValue:product.name forKey:@"name"];
        [productMO setValue:product.name forKey:@"logo"];
        [productMO setValue:product.url forKey:@"url"];
        [productMO setValue:@(j) forKey:@"pos"];
        
        [newCompanyMO addProductsListObject:productMO];
        j+=1024;
    }
    
    [self saveAllToCoreData];
 
}

-(void) updatePositionInCoreDataForCompaniesFrom: (NSUInteger) fromIndex To: (NSUInteger) toIndex {
    
    NSNumber *newPosition = @(0);
    // Fetching
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Company"];
    // Create Predicate
    NSPredicate *predicate;
    
    if (toIndex == 0) {
        
        predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"name", self.companyList.firstObject.name];
        
    }
    else
        
        if (toIndex == self.companyList.count-1) {
            predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"name", self.companyList.lastObject.name];
        }
        else
        
        {
        
        predicate = [NSPredicate predicateWithFormat:@"%K == %@ || %K == %@", @"name", [self.companyList objectAtIndex:toIndex+1].name, @"name", [self.companyList objectAtIndex:toIndex].name];
        }
    
    [fetchRequest setPredicate:predicate];
    
    // Execute Fetch Request
    NSError *fetchError = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    
    if (!fetchError) {
        for (Company_MO *managedObject in result) {
            NSLog(@"pos: %@", managedObject.pos);
            newPosition = @([managedObject.pos integerValue] + [newPosition integerValue]);
        }
        
    } else {
        NSLog(@"Error fetching data.");
        NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
    }
    
    if (toIndex != self.companyList.count-1) {
        newPosition = @(newPosition.integerValue/2);
    }
    else
        newPosition = @(newPosition.integerValue + 1024);
    
    predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"name", [self.companyList objectAtIndex:fromIndex].name];
    
    [fetchRequest setPredicate:predicate];
    
    result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    
    if (!fetchError) {
        for (Company_MO *companyMO in result) {
            NSLog(@"pos: %@", companyMO.pos);
            [companyMO setValue:newPosition forKey:@"pos"];
        }
        
    } else {
        NSLog(@"Error fetching data.");
        NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
    }
    
    [self saveAllToCoreData];

    
    
    
}

-(void) updatePositionInCoreDataForProductsFrom: (NSUInteger) fromIndex To: (NSUInteger) toIndex { // did not finish
    
    NSNumber *newPosition = @(0);
    // Fetching
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Product"];
    // Create Predicate
    NSPredicate *predicate;
    
    if (toIndex == 0) {
        
        predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"name", [self.companyList objectAtIndex:self.currentCompanyNumber].productsList.firstObject.name];
        
    }
    else
        
        if (toIndex == [self.companyList objectAtIndex:self.currentCompanyNumber].productsList.count-1) {
            
            predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"name", [self.companyList objectAtIndex:self.currentCompanyNumber].productsList.lastObject.name];
        }
        else
            
        {
            
            predicate = [NSPredicate predicateWithFormat:@"%K == %@ || %K == %@", @"name", [[self.companyList objectAtIndex:self.currentCompanyNumber].productsList objectAtIndex:toIndex+1].name, @"name", [[self.companyList objectAtIndex:self.currentCompanyNumber].productsList objectAtIndex:toIndex].name];
        }
    
    [fetchRequest setPredicate:predicate];
    
    // Execute Fetch Request
    NSError *fetchError = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    
    if (!fetchError) {
        for (Product_MO *managedObject in result) {
            NSLog(@"pos: %@", managedObject.pos);
            newPosition = @([managedObject.pos integerValue] + [newPosition integerValue]);
        }
        
    } else {
        NSLog(@"Error fetching data.");
        NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
    }
    
    if (toIndex != [self.companyList objectAtIndex:self.currentCompanyNumber].productsList.count-1) {
        newPosition = @(newPosition.integerValue/2);
    }
    else
        newPosition = @(newPosition.integerValue + 1024);
    
    predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"name", [[self.companyList objectAtIndex:self.currentCompanyNumber].productsList objectAtIndex:fromIndex].name];
    
    [fetchRequest setPredicate:predicate];
    
    result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    
    if (!fetchError) {
        for (Product_MO *productMO in result) {
            NSLog(@"pos: %@", productMO.pos);
            [productMO setValue:newPosition forKey:@"pos"];
        }
        
    } else {
        NSLog(@"Error fetching data.");
        NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
    }
    
    [self saveAllToCoreData];
    
    
    
    
}


-(void) deleteCompanyFromCoreData:(NSUInteger)companyIndex {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Company"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"name", [self.companyList objectAtIndex:companyIndex].name];
    [fetchRequest setPredicate:predicate];
    // Execute Fetch Request
    NSError *fetchError = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    
    if (!fetchError) {
        for (Company_MO *managedObject in result) {
            NSLog(@"company %@ deleted from Core Data", managedObject.name);
            [self.managedObjectContext deleteObject:managedObject];
            [self saveAllToCoreData];
        }
        
    } else {
        NSLog(@"Error fetching data.");
        NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
    }


}

-(void) undoLastAction {
    
    [self.managedObjectContext undo];
    
    [self getCompaniesFromCoreData];
    
}

-(void) saveAllToCoreData {
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unable to save managed object context.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    else
        NSLog(@"All changes have been saved to Core Data!");

}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Dealloc

- (void)dealloc {
    // Should never be called, but just here for clarity really.
//    [self.someProperty release];
    [super dealloc];
}

@end
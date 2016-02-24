//
//  DAO.m
//  NavCtrl
//
//  Created by Vladyslav Gusakov on 2/3/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "MyManager.h"

static MyManager *sharedMyManager = nil;

@implementation MyManager

{
    sqlite3 *NavCtrlDB;

    NSFileManager *fileManager;
    sqlite3_stmt *statement;
    NSString *querySQL;

}


#pragma mark Singleton Methods
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

- (id)init {
    if (self = [super init]) {
        NSLog(@"Init DAO");
        
//        Product *iphone = [[Product alloc] initWithName:@"iPhone" andLogo:[UIImage imageNamed:@"iphone.png"] andURL:@"https://apple.com/iphone"];
//        Product *ipod = [[Product alloc] initWithName:@"iPod" andLogo:[UIImage imageNamed:@"ipod.png"] andURL:@"https://apple.com/ipod"];
//        Product *ipad = [[Product alloc] initWithName:@"iPad" andLogo:[UIImage imageNamed:@"ipad.png"] andURL:@"https://apple.com/ipad"];
//        
//        Company *apple = [[Company alloc] initWithName:@"Apple mobile devices" andLogo:[UIImage imageNamed:@"apple_s.png"] andProducts:[NSMutableArray arrayWithObjects: iphone, ipod, ipad, nil]];
//        
//        Product *galaxyS4 = [[Product alloc] initWithName:@"Galaxy S4" andLogo:[UIImage imageNamed:@"s4.png"] andURL:@"http://www.samsung.com/global/microsite/galaxys4/"];
//        Product *galaxyNote = [[Product alloc] initWithName:@"Galaxy Note" andLogo:[UIImage imageNamed:@"note.png"] andURL:@"http://www.samsung.com/global/microsite/galaxynote/"];
//        Product *galaxyTab = [[Product alloc] initWithName:@"Galaxy Tab" andLogo:[UIImage imageNamed:@"tab.png"] andURL:@"http://www.samsung.com/global/microsite/galaxytab/"];
//        
//        Company *samsung = [[Company alloc] initWithName:@"Samsung mobile devices" andLogo:[UIImage imageNamed:@"samsung_s.png"] andProducts:[NSMutableArray arrayWithObjects: galaxyS4, galaxyNote, galaxyTab, nil]];
//        
//        Product *lumia950XL = [[Product alloc] initWithName:@"Lumia 950XL" andLogo:[UIImage imageNamed:@"lumia950xl.png"] andURL:@"https://www.microsoft.com/en-us/mobile/phone/lumia950-xl-dual-sim/"];
//        Product *lumia550 = [[Product alloc] initWithName:@"Lumia 550" andLogo:[UIImage imageNamed:@"lumia550.png"] andURL:@"https://www.microsoft.com/en-us/mobile/phone/lumia550/"];
//        Product *lumia1520 = [[Product alloc] initWithName:@"Lumia 1520" andLogo:[UIImage imageNamed:@"lumia1520.png"] andURL:@"https://www.microsoft.com/en-us/mobile/phone/lumia1520/"];
//        
//        Company *microsoft = [[Company alloc] initWithName:@"Microsoft mobile devices" andLogo:[UIImage imageNamed:@"microsoft.png"] andProducts:[NSMutableArray arrayWithObjects:lumia950XL, lumia550, lumia1520, nil]];
//        
//        Product *signature = [[Product alloc] initWithName:@"Signature" andLogo:[UIImage imageNamed:@"signature.png"] andURL:@"http://www.vertu.com/us/en/collections/signature/"];
//        Product *stouch = [[Product alloc] initWithName:@"The New Signature Touch" andLogo:[UIImage imageNamed:@"stouch.jpeg"] andURL:@"http://www.vertu.com/us/en/collections/signature-touch/"];
//        Product *aster = [[Product alloc] initWithName:@"Aster" andLogo:[UIImage imageNamed:@"aster.png"] andURL:@"http://www.vertu.com/us/en/collections/aster/"];
//
//        Company *vertu = [[Company alloc] initWithName:@"Vertu mobile devices" andLogo:[UIImage imageNamed:@"vertu_s.png"] andProducts:[NSMutableArray arrayWithObjects: signature, stouch, aster, nil]];
        
//        self.companyList = [[NSMutableArray alloc] initWithObjects: apple, samsung, microsoft, vertu, nil];
        
        self.companyList = [[NSMutableArray alloc] init];
        
        
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //path to device's Documents folder
        NSString *docPath = [path objectAtIndex:0];
        fileManager = [NSFileManager defaultManager];
        self.imagesPath = [docPath stringByAppendingPathComponent:@"images"];
        self.dbPathString = [docPath stringByAppendingPathComponent:@"NavCtrl.db"]; // path to .db file on device

        [self createDataBase];

    }
    return self;
}

-(void)createDataBase
{
    NSError *error;

    NSString *pathToMainBundle = [[NSBundle mainBundle] pathForResource:@"NavCtrl" ofType:@"db"]; //path to .db file inside the project
    NSURL *url = [NSURL fileURLWithPath:pathToMainBundle];
    NSData *dataDB = [NSData dataWithContentsOfURL:url]; // actual .db file as NSData
    
    if (![fileManager fileExistsAtPath:self.dbPathString])
    {
        //create database
        if (sqlite3_open([self.dbPathString UTF8String], &NavCtrlDB)== SQLITE_OK)
        {
            [dataDB writeToFile:self.dbPathString atomically:YES];
            sqlite3_close(NavCtrlDB);
        }
        else
            NSLog(@"Unable to open db");
    }
    
    
    if (![fileManager fileExistsAtPath:self.imagesPath]) {
        [fileManager createDirectoryAtPath:self.imagesPath withIntermediateDirectories:NO attributes:nil error:&error];
        NSLog(@"'Images' folder created");
        [self loadCompanies:0];
        [self loadProducts:0];
        
        //load additional images
        NSString *imageFile = [self.imagesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"noimg.png"]];
        
        if (![fileManager fileExistsAtPath:imageFile]) {
            NSLog(@"noimg.png image loaded");
            NSData *imgData = UIImagePNGRepresentation([UIImage imageNamed:@"noimg.png"]);
            [imgData writeToFile:imageFile atomically:YES];
        }
        
    }
    else {
        NSLog(@"Failed to create 'images' folder OR it already exists");
        [self loadCompanies:1];
        [self loadProducts:1];
    }
    
}

-(void) loadCompanies: (int) num {
    
    if (sqlite3_open([self.dbPathString UTF8String], &NavCtrlDB)== SQLITE_OK) // init companies
    {
        NSLog(@"---Connected to DB---");
        //[fileManager removeItemAtPath:dbPathString error:nil];
        
        querySQL = [NSString stringWithFormat:@"SELECT * FROM company ORDER BY position"];
        
        const char *query_sql = [querySQL UTF8String];
        if (sqlite3_prepare(NavCtrlDB, query_sql, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement)== SQLITE_ROW)
            {
                NSString *name = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                NSString *logo = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                
                //NSLog(@"name:%@", name); //company name
                //NSLog(@"logo:%@", logo); //company logo
                
                Company *newCompany;
                
                if (num == 0) {
                    newCompany = [[Company alloc] initWithName:name andLogo:[UIImage imageNamed:logo] andProducts:nil];
                }
                else {
                    newCompany = [[Company alloc] initWithName:name andLogo:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.png",self.imagesPath, name]] andProducts:nil];
                }
                

                NSString *imageFile = [self.imagesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",newCompany.companyName]];
                
                if (![fileManager fileExistsAtPath:imageFile]) {
                    NSLog(@"company image loaded");
                    NSData *companyImgData = UIImagePNGRepresentation([UIImage imageNamed:logo]);
                    [companyImgData writeToFile:imageFile atomically:YES];
                }
                
                
                [self.companyList addObject:newCompany];
            }
        }
        NSLog(@"---Loaded Companies List from DB---");
        sqlite3_close(NavCtrlDB);
    }
    else
        NSLog(@"Unable to open db");
    
}

-(void) loadProducts: (int) num {
    
    int res = sqlite3_open([self.dbPathString UTF8String], &NavCtrlDB);
    
    if (res == SQLITE_OK) // init products
    {
        for (int i = 0; i < self.companyList.count; i++) { //for begin
            
            NSMutableArray *products = [[NSMutableArray alloc] init];
            
            querySQL = [NSString stringWithFormat:@"SELECT * FROM product WHERE company_id = (SELECT id FROM company WHERE position IS %i) ORDER BY position" , i];
            
            const char *query_sql = [querySQL UTF8String];
            if (sqlite3_prepare(NavCtrlDB, query_sql, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement)== SQLITE_ROW)
                {
                    NSString *pname = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                    NSString *plogo = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                    NSString *purl = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                    
                    Product *newProduct = [[Product alloc] initWithName:pname andLogo:[UIImage imageNamed:plogo] andURL:purl];
                    
                    if (num == 0) {
                        newProduct = [[Product alloc] initWithName:pname andLogo:[UIImage imageNamed:plogo] andURL:purl];
                    }
                    else {
                        newProduct = [[Product alloc] initWithName:pname andLogo:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.png",self.imagesPath, pname]] andURL:purl];
                    }
                    
                    NSString *imageFile = [self.imagesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",newProduct.productName]];
                    
                    if (![fileManager fileExistsAtPath:imageFile]) {
                        NSLog(@"product image loaded");
                        NSData *companyImgData = UIImagePNGRepresentation([UIImage imageNamed:plogo]);
                        [companyImgData writeToFile:imageFile atomically:YES];
                    }
                    
                    [products addObject:newProduct];
                    
                }
                [self.companyList objectAtIndex:i].productsList = products;
            }
        }
        NSLog(@"---Loaded Products List from DB---");
        sqlite3_close(NavCtrlDB);
    }
    else
    {
        NSLog(@"Unable to open db");
    }
    
}

-(void) saveNewCompanyToDB { // new company is the last object in self.companyList
    
    int res = sqlite3_open([self.dbPathString UTF8String], &NavCtrlDB);
    char *error;
    
    if (res == SQLITE_OK) // init
    {
        NSString *name = [self.companyList.lastObject companyName];
        UIImage *logo = [self.companyList.lastObject companyLogo];
        NSData *imgAsData = UIImagePNGRepresentation(logo);
        NSString *imageFile = [self.imagesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",name]];
        [imgAsData writeToFile:imageFile atomically:YES];
        
        NSString *logoStr = @"noimg.png"; // default img
        
        if ( [self.companyList.lastObject companyLogo] != nil) {
            logoStr = [NSString stringWithFormat:@"%@.png",name];
        }
        
        querySQL = [NSString stringWithFormat:@"INSERT INTO company(name, logo, position) VALUES('%s','%s', %lu)", [name UTF8String], [logoStr UTF8String], self.companyList.count-1];
        
        if (sqlite3_exec(NavCtrlDB, [querySQL UTF8String], NULL, NULL, &error) == SQLITE_OK)
        {
            NSLog(@"---New Company Saved---");
        }
        
        int i = 0;
        for (Product *newProduct in self.companyList.lastObject.productsList) {
            querySQL = [NSString stringWithFormat:@"INSERT INTO product(name, logo, url, company_id, position) VALUES ('%s','%s.png','%s',%lu, %i)", [newProduct.productName UTF8String], [newProduct.productName UTF8String], [newProduct.productURL UTF8String], self.companyList.count, i];
            
            
            if (sqlite3_exec(NavCtrlDB, [querySQL UTF8String], NULL, NULL, &error) == SQLITE_OK)
            {
                NSString *name = [[[self.companyList.lastObject productsList] objectAtIndex:i] productName];
                UIImage *logo = [[[self.companyList.lastObject productsList] objectAtIndex:i] productLogo];
                NSData *imgAsData = UIImagePNGRepresentation(logo);
                NSString *imageFile = [self.imagesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",name]];
                [imgAsData writeToFile:imageFile atomically:YES];

                NSLog(@"---New Product SAVED---");
            }
            
            i++;
            
        }
    }
    else {
        NSLog(@"Unable to open DB");
    }
    
    sqlite3_close(NavCtrlDB);

}

-(void) deleteCompany:(NSInteger) position {
    
    int res = sqlite3_open([self.dbPathString UTF8String], &NavCtrlDB);
    char *error;
    
    if (res == SQLITE_OK) // init products
    {
        
        querySQL = [NSString stringWithFormat:@"DELETE FROM product WHERE company_id IS (SELECT id FROM company WHERE position IS %lu)", position];
        
        if (sqlite3_exec(NavCtrlDB, [querySQL UTF8String], NULL, NULL, &error) == SQLITE_OK)
        {
            NSLog(@"---ALL PRODUCTS ASSOCIATED WITH COMPANY DELETED---");
            for (int i = 0; i < [[self.companyList objectAtIndex:position] productsList].count; i++) {
                
                NSString *path = [NSString stringWithFormat:@"%@/%@.png",self.imagesPath,[[[[self.companyList objectAtIndex:position] productsList] objectAtIndex:i] productName]];
                
                if ([fileManager fileExistsAtPath:path]) {
                    [fileManager removeItemAtPath: path error:nil];
                    NSLog(@"---PRODUCT IMAGE DELETED---");
                }
                else {
                    NSLog(@"ERROR: Couldn't delete PRODUCT image");
                }
                
            }
        }
        else {
            NSLog(@"---ERROR DELETING PRODUCTS---");

        }
        
        querySQL = [NSString stringWithFormat:@"DELETE FROM company WHERE position IS %lu", position];
        
        if (sqlite3_exec(NavCtrlDB, [querySQL UTF8String], NULL, NULL, &error) == SQLITE_OK)
        {
            NSLog(@"---COMPANY DELETED---");
            NSString *path = [NSString stringWithFormat:@"%@/%@.png",self.imagesPath,[[self.companyList objectAtIndex:position] companyName]];
            if ([fileManager fileExistsAtPath:path]) {
                [fileManager removeItemAtPath: path error:nil];
                 NSLog(@"---COMPANY IMAGE DELETED---");
            }
            else {
                NSLog(@"No image found");
            }
            
        }
        else {
            NSLog(@"---ERROR DELETING COMPANY---");
            
        }
        
        [self.companyList removeObjectAtIndex:position];
    }
    else {
        NSLog(@"Unable to open DB");
    }
    
    sqlite3_close(NavCtrlDB);
    
}

-(void) deleteProduct:(NSInteger) position {
    
    int res = sqlite3_open([self.dbPathString UTF8String], &NavCtrlDB);
    char *error;
    
    if (res == SQLITE_OK) // init products
    {
        querySQL = [NSString stringWithFormat:@"DELETE FROM product WHERE position IS %lu AND company_id IS (SELECT id FROM company WHERE position IS %lu)", position, self.currentCompanyNumber];
        
        if (sqlite3_exec(NavCtrlDB, [querySQL UTF8String], NULL, NULL, &error) == SQLITE_OK)
        {
            NSLog(@"---PRODUCT DELETED---");
        }
        
    }
    else {
        NSLog(@"Unable to open DB");
    }
    
    sqlite3_close(NavCtrlDB);
    
}

-(void) updatePositionForCompany  {
    
    int res = sqlite3_open([self.dbPathString UTF8String], &NavCtrlDB);
    char *error;
    if (res == SQLITE_OK) // init
    {
        for (int i = 0; i < self.companyList.count; i++) { //for begin
            querySQL = [NSString stringWithFormat:@"UPDATE company SET position = %i WHERE name ='%s'" , i, [[[self.companyList objectAtIndex:i] companyName] UTF8String]];
            
            if (sqlite3_exec(NavCtrlDB, [querySQL UTF8String], NULL, NULL, &error) == SQLITE_OK)
            {
                NSLog(@"---POSITION UPDATED---");
            }
            else {
                NSLog(@"---FAILED TO UPDATE POSITION---");
            }
        }
        
        NSLog(@"---POSITION UPDATING FINISHED---");
        sqlite3_close(NavCtrlDB);
    }
    else
    {
        NSLog(@"Unable to open db");
        NSLog(@"error: %i", res);
        NSLog(@"dbpath: %s",[self.dbPathString UTF8String]);
    }
    
}

-(void) updatePositionForProducts  {
    
    int res = sqlite3_open([self.dbPathString UTF8String], &NavCtrlDB);
    char *error;
    if (res == SQLITE_OK) // init
    {
        for (int i = 0; i < [[self.companyList objectAtIndex:self.currentCompanyNumber] productsList].count; i++) { //for begin
            querySQL = [NSString stringWithFormat:@"UPDATE product SET position = %i WHERE name ='%s'" , i, [[[[[self.companyList objectAtIndex:self.currentCompanyNumber] productsList] objectAtIndex:i] productName] UTF8String]];
            
            if (sqlite3_exec(NavCtrlDB, [querySQL UTF8String], NULL, NULL, &error) == SQLITE_OK)
            {
                NSLog(@"---POSITION UPDATED---");
            }
            else {
                NSLog(@"---FAILED TO UPDATE POSITION---");
            }
        }
        
        NSLog(@"---POSITION UPDATING FINISHED---");
        sqlite3_close(NavCtrlDB);
    }
    else
    {
        NSLog(@"Unable to open db");
        NSLog(@"error: %i", res);
        NSLog(@"dbpath: %s",[self.dbPathString UTF8String]);
    }
    
}

-(void) saveEditedProduct {
    int res = sqlite3_open([self.dbPathString UTF8String], &NavCtrlDB);
    char *error;
    
    if (res == SQLITE_OK) // init
    {
        NSString *name = [[[[self.companyList objectAtIndex:self.currentCompanyNumber] productsList] objectAtIndex:self.currentProductNumber] productName];
        UIImage *logo = [[[[self.companyList objectAtIndex:self.currentCompanyNumber] productsList] objectAtIndex:self.currentProductNumber] productLogo];
        NSString *url = [[[[self.companyList objectAtIndex:self.currentCompanyNumber] productsList] objectAtIndex:self.currentProductNumber] productURL];
        
        NSData *imgAsData = UIImagePNGRepresentation(logo);
        NSString *imageFile = [self.imagesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",name]];
        [imgAsData writeToFile:imageFile atomically:YES];
        
        
        querySQL = [NSString stringWithFormat:@"UPDATE product SET name = '%s', logo = '%s.png', url = '%s' WHERE company_id = (SELECT id FROM company WHERE position IS %lu) AND position = %lu", [name UTF8String], [name UTF8String], [url UTF8String], self.currentCompanyNumber, self.currentProductNumber];
        
        if (sqlite3_exec(NavCtrlDB, [querySQL UTF8String], NULL, NULL, &error) == SQLITE_OK)
        {
            NSLog(@"---Product Successfully Edited---");
        }
        
    }
    else {
        NSLog(@"Unable to open DB");
    }
    
    sqlite3_close(NavCtrlDB);
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
//    [self.someProperty release];
    [super dealloc];
}

@end
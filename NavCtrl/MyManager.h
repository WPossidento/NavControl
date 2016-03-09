//
//  DAO.h
//  NavCtrl
//
//  Created by Vladyslav Gusakov on 2/3/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Company.h"
#import "Product.h"
#import "Company_MO.h"
#import "Product_MO.h"

@interface MyManager : NSObject

@property (nonatomic, retain) NSMutableArray <Company *> *companyList;
@property (nonatomic) NSInteger currentCompanyNumber;
@property (nonatomic) NSInteger currentProductNumber;

@property (nonatomic) BOOL isCompanyInEditMode;

@property (nonatomic, retain) NSString *imagesPath;

+ (id)sharedManager;

//- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void) createDataAtFirstLaunch;
-(void) getCompaniesFromCoreData;
-(void) saveNewCompanyToCoreData;

-(void) updatePositionInCoreDataForCompaniesFrom: (NSUInteger) fromIndex To: (NSUInteger) toIndex;
-(void) updatePositionInCoreDataForProductsFrom: (NSUInteger) fromIndex To: (NSUInteger) toIndex;

-(void) deleteCompanyFromCoreData: (NSUInteger) companyIndex;
-(void) undoLastAction;

@end
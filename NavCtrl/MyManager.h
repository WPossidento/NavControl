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
//#import "AddCompanyViewController.h"

//@class AddCompanyViewController;

@interface MyManager : NSObject

@property (nonatomic, retain) NSMutableArray <Company *> *companyList;
@property (nonatomic) NSInteger currentCompanyNumber;
@property (nonatomic) NSInteger currentProductNumber;

//@property (nonatomic, retain) AddCompanyViewController *addCompanyViewController;


+ (id)sharedManager;

//-(void) saveNewCompany;
@end
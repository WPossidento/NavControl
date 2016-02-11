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

@class CompanyViewController;


@protocol MyManagerDelegate <NSObject>

@optional
- (void)stockUpdated;

@end


@interface MyManager : NSObject

@property (nonatomic, retain) NSMutableArray <Company *> *companyList;
@property (nonatomic) NSInteger currentCompanyNumber;
@property (nonatomic) NSInteger currentProductNumber;
@property (nonatomic, retain) NSMutableArray *stocksFinal;

@property (nonatomic, retain) CompanyViewController *companyViewController;


+ (id)sharedManager;

//-(void) saveNewCompany;
-(void) loadStocksTo:(id<MyManagerDelegate>) delegate;


@end
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

@interface MyManager : NSObject

@property (nonatomic, retain) NSMutableArray <Company *> *companyList;
@property (nonatomic, retain) NSString *someProperty;
@property (nonatomic) NSInteger currentCompanyNumber;
@property (nonatomic) NSInteger currentProductNumber;

+ (id)sharedManager;

@end
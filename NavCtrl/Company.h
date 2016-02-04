//
//  Company.h
//  NavCtrl
//
//  Created by Vladyslav Gusakov on 2/3/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

@interface Company : NSObject

@property (nonatomic, retain) NSString *companyName;
@property (nonatomic, retain) NSString *companyLogo;
@property (nonatomic, retain) NSMutableArray <Product *> *productsList;

-(instancetype)initWithName: (NSString *) name andLogo: (NSString *) logo andProducts: (NSMutableArray <Product *>*) products;

@end

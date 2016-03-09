//
//  Company.h
//  NavCtrl
//
//  Created by Vladyslav Gusakov on 2/3/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Product;

@interface Company : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *logo;
@property (nonatomic, retain) NSNumber *pos;

@property (nonatomic, retain) NSMutableArray <Product *> *productsList;

-(instancetype)initWithName: (NSString *) name andLogo: (NSString *) logo andProducts: (NSMutableArray <Product *>*) products;

@end

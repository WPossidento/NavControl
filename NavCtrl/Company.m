//
//  Company.m
//  NavCtrl
//
//  Created by Vladyslav Gusakov on 2/3/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "Company.h"

@implementation Company

-(instancetype)initWithName: (NSString *) name andLogo: (NSString *) logo andPos: (NSUInteger) pos andProducts: (NSMutableArray <Product *>*) products {
    self = [super init];
    if (self) {
        self.name = name;
        self.logo = logo;
        self.pos = pos;
        self.productsList  = products;
    }
    
    return self;
}

@end

//
//  Product.m
//  NavCtrl
//
//  Created by Vladyslav Gusakov on 2/3/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "Product.h"

@implementation Product


-(instancetype)initWithName: (NSString *) name andLogo: (NSString *) logo andURL: (NSString*) url
{
    self = [super init];
    if (self) {
        self.productName = name;
        self.productLogo = logo;
        self.productURL  = url;
    }
    
    return self;
}

@end

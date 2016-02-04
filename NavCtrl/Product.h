//
//  Product.h
//  NavCtrl
//
//  Created by Vladyslav Gusakov on 2/3/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (nonatomic, retain) NSString *productName;
@property (nonatomic, retain) NSString *productLogo;
@property (nonatomic, retain) NSString *productURL;

-(instancetype)initWithName: (NSString *) name andLogo: (NSString *) logo andURL: (NSString*) url;


@end

//
//  Product.h
//  NavCtrl
//
//  Created by Vladyslav Gusakov on 2/3/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Product : NSObject

@property (retain) NSString *name;
@property (nonatomic, retain) NSString *logo;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSNumber *pos;



-(instancetype)initWithName: (NSString *) name andLogo: (NSString *) logo andURL: (NSString*) url;


@end

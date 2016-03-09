//
//  Product_MO+CoreDataProperties.h
//  NavCtrl
//
//  Created by Vladyslav Gusakov on 3/5/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Product_MO.h"

NS_ASSUME_NONNULL_BEGIN

@interface Product_MO (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *logo;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSNumber *pos;
@property (nullable, nonatomic, retain) Company_MO *company;

@end

NS_ASSUME_NONNULL_END

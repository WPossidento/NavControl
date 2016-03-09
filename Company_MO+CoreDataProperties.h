//
//  Company_MO+CoreDataProperties.h
//  NavCtrl
//
//  Created by Vladyslav Gusakov on 3/5/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Company_MO.h"

NS_ASSUME_NONNULL_BEGIN

@interface Company_MO (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *logo;
@property (nullable, nonatomic, retain) NSNumber *pos;
@property (nullable, nonatomic, retain) NSSet<Product_MO *> *productsList;

@end

@interface Company_MO (CoreDataGeneratedAccessors)

- (void)addProductsListObject:(Product_MO *)value;
- (void)removeProductsListObject:(Product_MO *)value;
- (void)addProductsList:(NSSet<Product_MO *> *)values;
- (void)removeProductsList:(NSSet<Product_MO *> *)values;

@end

NS_ASSUME_NONNULL_END

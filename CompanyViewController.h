//
//  CompanyViewController.h
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductViewController.h"
#import "MyManager.h"
#import "AddCompanyViewController.h"

//@class ProductViewController;

@interface CompanyViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, retain) MyManager *sharedManager;

@property (nonatomic, retain) IBOutlet  ProductViewController * productViewController;

@property (nonatomic, retain) AddCompanyViewController  *addCompanyViewController;

-(void) insertNewObject;
-(void) editCompany;

@end

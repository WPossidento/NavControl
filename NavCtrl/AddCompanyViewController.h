//
//  AddCompanyViewController.h
//  NavCtrl
//
//  Created by Vladyslav Gusakov on 2/4/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyManager.h"

@class MyManager;

@interface AddCompanyViewController : UIViewController

@property (retain, nonatomic) IBOutlet UIButton *AddProductsButton;
@property (nonatomic) NSUInteger productsViewCounter;
@property (retain, nonatomic) IBOutlet UITextField *companyNameTextField;
@property (retain, nonatomic) IBOutlet UIImageView *companyLogo;
//@property (retain, nonatomic) UIImagePickerController *companyImgPicker;
//@property (retain, nonatomic) UIImagePickerController *productImgPicker;
@property (retain, nonatomic) UIView *productsView;
@property (retain, nonatomic) UIImageView *iv;

@property (retain, nonatomic) Company *company;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) BOOL fillView;


- (IBAction)displayNewProductsList:(id)sender;
- (IBAction)chooseCompanyLogo:(id)sender;
- (IBAction)deleteImg:(id)sender;

//-(void) fillProducts;
//- (id)initWithCompany:(Company *)comp;

@end

//
//  EditProductViewController.m
//  NavCtrl
//
//  Created by Vladyslav Gusakov on 2/10/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "EditProductViewController.h"

@interface EditProductViewController ()

@property (retain, nonatomic) IBOutlet UIView *productView;
@property (retain, nonatomic) IBOutlet UITextField *productNameTextField;
@property (retain, nonatomic) IBOutlet UIImageView *productLogoImageView;
- (IBAction)chooseButtonPressed:(id)sender;
- (IBAction)deleteButtonPressed:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *productURLTextField;

@property (nonatomic, retain) MyManager *sharedManager;

@property (retain, nonatomic) UIImagePickerController *productImgPicker;


-(void) saveProduct;


@end

@implementation EditProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.sharedManager = [MyManager sharedManager];

    self.productView.layer.borderColor = [[UIColor orangeColor] CGColor];
    self.productView.layer.borderWidth = 1.0f;
    self.productView.layer.cornerRadius = 10.0f;
    
    self.productLogoImageView.layer.borderColor = [[UIColor blueColor] CGColor];
    self.productLogoImageView.layer.borderWidth = 0.5f;
    self.productLogoImageView.layer.cornerRadius = 7.0f;
    self.productLogoImageView.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveProduct)];
    
    self.productNameTextField.text = [[[[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] objectAtIndex:self.sharedManager.currentProductNumber] productName];
    
    self.productLogoImageView.image = [[[[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] objectAtIndex:self.sharedManager.currentProductNumber] productLogo];
    
    self.productURLTextField.text = [[[[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] objectAtIndex:self.sharedManager.currentProductNumber] productURL];
    
}

-(void) saveProduct {
    
    Product *product = [[Product alloc] initWithName:self.productNameTextField.text andLogo:self.productLogoImageView.image andURL:self.productURLTextField.text];
    
    [[[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] replaceObjectAtIndex:self.sharedManager.currentProductNumber withObject:product];
    
    [self.sharedManager saveEditedProduct];
    [self.navigationController popViewControllerAnimated:YES];

    [product release];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:
(NSDictionary<NSString *,id> *)info {
    
    self.productLogoImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)chooseButtonPressed:(id)sender {
    
    self.productImgPicker = [[UIImagePickerController alloc] init];
    self.productImgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.productImgPicker.delegate = self;
    [self presentViewController:self.productImgPicker animated:YES completion:nil];
}

- (IBAction)deleteButtonPressed:(id)sender {
//    [self.productLogoImageView setImage:nil];
    [self.productLogoImageView setImage:[UIImage imageNamed:@"noimg.png"]];
}

- (void)dealloc {
    [_productView release];
    [_productNameTextField release];
    [_productLogoImageView release];
    [_productURLTextField release];
    [super dealloc];
}

@end

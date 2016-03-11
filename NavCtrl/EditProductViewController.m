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

//@property (retain, nonatomic) UIImagePickerController *productImgPicker;


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
    
    self.productNameTextField.text = [[[[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] objectAtIndex:self.sharedManager.currentProductNumber] name];
    
    self.productLogoImageView.image = [UIImage imageNamed:[[[[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] objectAtIndex:self.sharedManager.currentProductNumber] logo]];
    
    self.productURLTextField.text = [[[[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] objectAtIndex:self.sharedManager.currentProductNumber] url];
    
}

-(void) saveProduct {
    
    NSData *imgAsData = UIImagePNGRepresentation(self.productLogoImageView.image);
    NSString *imageFile = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"images/%@.png",self.productNameTextField.text]];
    [imgAsData writeToFile:imageFile atomically:YES];
    
    NSUInteger prevPos = [[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber].productsList objectAtIndex:self.sharedManager.currentProductNumber].pos;
    
    Product *product = [[Product alloc] initWithName:self.productNameTextField.text andLogo: self.productNameTextField.text andURL:self.productURLTextField.text andPos:prevPos];
    
    [[[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] replaceObjectAtIndex:self.sharedManager.currentProductNumber withObject:product];
    
    //[self.sharedManager saveEditedProduct];
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
    
    UIImagePickerController *productImgPicker = [[UIImagePickerController alloc] init];
    productImgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    productImgPicker.delegate = self;
    [self presentViewController:productImgPicker animated:YES completion:nil];
    
    [productImgPicker release];
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

//
//  AddCompanyViewController.m
//  NavCtrl
//
//  Created by Vladyslav Gusakov on 2/4/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "AddCompanyViewController.h"

@interface AddCompanyViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, retain) MyManager *sharedManager;


@end

@implementation AddCompanyViewController


//- (id)initWithCompany:(Company *)comp {
//    
//    self = [super initWithNibName:@"AddCompanyViewController" bundle:nil];
//    if (self) {
//        self.company = comp;
//    }
//    return self;
//}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.sharedManager = [MyManager sharedManager];

    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveNewCompany)];
    
    self.companyNameTextField.layer.borderWidth = 1.0f;
    self.companyNameTextField.layer.cornerRadius = 5.0f;
    self.companyNameTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];

    self.companyLogo.layer.borderWidth = 1.0f;
    self.companyLogo.layer.cornerRadius = 5.0f;
    self.companyLogo.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.companyLogo.image = [UIImage imageNamed:@"noimg.png"];
    
    if (self.sharedManager.isCompanyInEditMode == YES) {
        self.fillView = YES;
        
        self.companyNameTextField.text =  [[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] companyName];   //[self.company companyName];
        self.companyLogo.image = [[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] companyLogo];
    
        for (int i = 0; i < [[[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] count]; i++) {
        
            [self displayNewProductsList:nil];
        
        }
    
        self.fillView = NO;
    }
    else {
        self.sharedManager.currentCompanyNumber = -1;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)displayNewProductsList:(id)sender {
    
    CGFloat prViewX = self.AddProductsButton.frame.origin.x;
    CGFloat prViewY = self.AddProductsButton.frame.origin.y;
    CGFloat prViewWidth = 400.0;
    CGFloat prViewHeigh = 200.0;
    
    
    self.self.productsView = [[UIView alloc] initWithFrame:CGRectMake(prViewX+self.AddProductsButton.frame.size.width/2, prViewY+self.AddProductsButton.frame.size.height+(prViewHeigh+5)*self.self.productsViewCounter, prViewWidth, prViewHeigh)];
    
    self.productsView.tag = self.productsViewCounter+100;
    self.productsView.layer.borderWidth = 1.0f;
    self.productsView.layer.cornerRadius = 5.0f;
    self.productsView.layer.borderColor = [[UIColor blackColor] CGColor];
    
    
    
    UILabel *num = [[UILabel alloc] initWithFrame:CGRectMake(-25, 16, 25, 20 )];
    num.text = [NSString stringWithFormat:@"#%lu", self.self.productsViewCounter+1];
    
    [self.productsView addSubview:num];
    
    UILabel *productName = [[UILabel alloc] initWithFrame:CGRectMake(6, 16, 115, 21 )];
    productName.text = @"Product Name:";
    
    UITextView *productNameTextView = [[UITextView alloc] initWithFrame:CGRectMake(145, 12, 240, 30)];
    
    productNameTextView.layer.borderWidth = 1.0f;
    productNameTextView.layer.cornerRadius = 5.0f;
    productNameTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    if (self.fillView == YES) {
        productNameTextView.text = [[[[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] objectAtIndex:self.productsViewCounter] productName];
    }
    
    [self.productsView addSubview:productName];
    [self.productsView addSubview:productNameTextView];
    
    UILabel *productLogo = [[UILabel alloc] initWithFrame:CGRectMake(6, 40, 108, 51 )];
    productLogo.text = @"Product Logo:";
    
    self.productLogoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(145, 49, 100, 100)];
    
    self.productLogoImageView.layer.borderWidth = 1.0f;
    self.productLogoImageView.layer.cornerRadius = 5.0f;
    self.productLogoImageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.productLogoImageView.tag = self.productsViewCounter;
    
    if (self.fillView == YES) {
        self.productLogoImageView.image = [[[[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] objectAtIndex:self.productsViewCounter] productLogo];
    }
    else {
        self.productLogoImageView.image = [UIImage imageNamed:@"noimg.png"];
    }
    
    [self.productsView addSubview:productLogo];
    [self.productsView addSubview:self.productLogoImageView];
    
    UIButton *choose = [[UIButton alloc] initWithFrame:CGRectMake(255, 100, 75, 25)];
    [choose setTitle:@"Choose..." forState:UIControlStateNormal];
    [choose setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [choose setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:0.5] forState:UIControlStateHighlighted];
    choose.titleLabel.font = [UIFont systemFontOfSize:15];
    choose.tag = -self.productsViewCounter;
    [choose addTarget:self action:@selector(chooseProductLogo:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.productsView addSubview:choose];
    
    UIButton *delete = [[UIButton alloc] initWithFrame:CGRectMake(340, 100, 50, 25)];
    [delete setTitle:@"Delete" forState:UIControlStateNormal];
    [delete setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [delete setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:0.5] forState:UIControlStateHighlighted];
    delete.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [self.productsView addSubview:delete];
    
    UILabel *productURL = [[UILabel alloc] initWithFrame:CGRectMake(6, 160, 102, 21 )];
    productURL.text = @"Product URL:";
    
    UITextView *productURLTextView = [[UITextView alloc] initWithFrame:CGRectMake(145, 156, 240, 30)];
    
    productURLTextView.layer.borderWidth = 1.0f;
    productURLTextView.layer.cornerRadius = 5.0f;
    productURLTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    productURLTextView.keyboardType = UIKeyboardTypeURL;
    productURLTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    productURLTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    if (self.fillView == YES) {
        productURLTextView.text = [[[[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] objectAtIndex:self.productsViewCounter] productURL];
    }
    
    [self.productsView addSubview:productURL];
    [self.productsView addSubview:productURLTextView];
    
    [self.view addSubview:self.productsView];
    
    self.productsViewCounter++;
    
}

- (IBAction)chooseCompanyLogo:(id)sender {
    
    self.companyImgPicker = [[UIImagePickerController alloc] init];
    self.companyImgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.companyImgPicker.delegate = self;
    [self presentViewController:self.companyImgPicker animated:YES completion:nil];
    
}

- (IBAction)deleteImg:(id)sender {
//    [self.companyLogo setImage:nil];
    [self.companyLogo setImage:[UIImage imageNamed:@"noimg.png"]];

}

- (void) chooseProductLogo:(id) sender {

    self.productImgPicker = [[UIImagePickerController alloc] init];
    self.productImgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.productImgPicker.delegate = self;
    
    UIButton *chooseProduct = (UIButton *) sender;
    
    for (UIView *i in self.view.subviews) {
        for (UIView *sub in i.subviews) {
            if ([sub isKindOfClass:[UIImageView class]] && sub.tag == -chooseProduct.tag) {
                self.iv = (UIImageView *) sub;
                NSLog(@"tag: %li", (long)sub.tag);
            }
        }
    }
    
    NSLog(@"%lu", self.productsViewCounter);
    
    [self presentViewController:self.productImgPicker animated:YES completion:nil];


    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:
                                                                        (NSDictionary<NSString *,id> *)info {
    

    if ([picker isEqual:self.companyImgPicker]) {
        self.companyLogo.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    else if ([picker isEqual:self.productImgPicker]) {
        self.iv.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }

    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
}

-(void) saveNewCompany {
    int counter;
    
    NSMutableArray *products = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<self.productsViewCounter; i++) {
        UIView *prView = [self.view viewWithTag:i+100];
        Product *newProduct = [[Product alloc] init];
        
        counter = 0; //?
        
        for (UIView *tmp in prView.subviews) {
            if ([tmp isKindOfClass:[UITextView class]]) {
                switch (counter) {
                    case 0: {
                        
                        newProduct.productName = [(UITextView *)tmp text];
                        
                        if ([newProduct.productName isEqualToString:@""]) {
                            newProduct.productName = @"Unnamed Product";
                        }
                        
                        NSLog(@"productName: %@",newProduct.productName);
                        
                    }
                        break;
                        
                    case 1: {
                        newProduct.productURL = [(UITextView *)tmp text];
                        
                        if ([newProduct.productURL isEqualToString:@""]) {
                            newProduct.productURL = @"https://google.com";
                        }
                        
                        NSLog(@"productURL: %@",newProduct.productURL);
                        counter = 0;
                    }
                    default:
                        break;
                }
                
                counter++;
                
            }
            
            if ([tmp isKindOfClass:[UIImageView class]]) {
                newProduct.productLogo = [(UIImageView *) tmp image];
            }
            
        }
        
        if (![newProduct.productName isEqualToString:@""]) {
            [products addObject:newProduct];
        }
        
    }
    
    if ([self.companyNameTextField.text isEqualToString:@""]) {
        self.companyNameTextField.text = @"Unnamed Company";
    }
    
    Company *newComp = [[Company alloc] initWithName:self.companyNameTextField.text andLogo: self.companyLogo.image andProducts:products];
    
    if (self.sharedManager.currentCompanyNumber < 0) { // creating new company
        [self.sharedManager.companyList addObject:newComp];
        [self.sharedManager saveNewCompanyToDB];
        
    }
    else { // editing existing company
        [self.sharedManager.companyList replaceObjectAtIndex:self.sharedManager.currentCompanyNumber withObject:newComp];
    }

    [self.navigationController popToRootViewControllerAnimated:YES];

    
    
}

- (void)dealloc {
    [_AddProductsButton release];
    [_companyNameTextField release];
    [_companyLogo release];
    [super dealloc];
}
@end

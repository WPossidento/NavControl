//
//  AddCompanyViewController.m
//  NavCtrl
//
//  Created by Vladyslav Gusakov on 2/4/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "AddCompanyViewController.h"

@interface AddCompanyViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImagePickerController *companyImgPicker;
    UIImagePickerController *productImgPicker;
}

@property (nonatomic, retain) MyManager *sharedManager;


@end

@implementation AddCompanyViewController


- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.sharedManager = [MyManager sharedManager];

    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, 0);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveNewCompany)];
    
    companyImgPicker = [[UIImagePickerController alloc] init];
    companyImgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    companyImgPicker.delegate = self;
    
    productImgPicker = [[UIImagePickerController alloc] init];
    productImgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    productImgPicker.delegate = self;
    
    
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
    
    CGFloat prViewWidth = 400.0;
    CGFloat prViewHeigh = 200.0;
    
    UIView *productsView = [[UIView alloc] initWithFrame:CGRectMake(100, 20+(prViewHeigh+5)*self.productsViewCounter, prViewWidth, prViewHeigh)];
    
    productsView.tag = self.productsViewCounter+100;
    productsView.layer.borderWidth = 1.0f;
    productsView.layer.cornerRadius = 5.0f;
    productsView.layer.borderColor = [[UIColor blackColor] CGColor];
    
    
    
    UILabel *num = [[UILabel alloc] initWithFrame:CGRectMake(-32, 16, 32, 20 )];
    num.text = [NSString stringWithFormat:@"#%lu", self.productsViewCounter+1];
    
    [productsView addSubview:num];
    [num release];
    
    UILabel *productName = [[UILabel alloc] initWithFrame:CGRectMake(6, 16, 115, 21 )];
    productName.text = @"Product Name:";
    
    UITextView *productNameTextView = [[UITextView alloc] initWithFrame:CGRectMake(145, 12, 240, 30)];
    
    productNameTextView.layer.borderWidth = 1.0f;
    productNameTextView.layer.cornerRadius = 5.0f;
    productNameTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    if (self.fillView == YES) {
        productNameTextView.text = [[[[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] objectAtIndex:self.productsViewCounter] productName];
    }
    
    [productsView addSubview:productName];
    [productName release];
    [productsView addSubview:productNameTextView];
    [productNameTextView release];
    
    UILabel *productLogo = [[UILabel alloc] initWithFrame:CGRectMake(6, 40, 108, 51 )];
    productLogo.text = @"Product Logo:";
    
    UIImageView *productLogoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(145, 49, 100, 100)];
    
    productLogoImageView.layer.borderWidth = 1.0f;
    productLogoImageView.layer.cornerRadius = 5.0f;
    productLogoImageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    productLogoImageView.tag = self.productsViewCounter;
    
    if (self.fillView == YES) {
        productLogoImageView.image = [[[[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] objectAtIndex:self.productsViewCounter] productLogo];
    }
    else {
        productLogoImageView.image = [UIImage imageNamed:@"noimg.png"];
    }
    
    [productsView addSubview:productLogo];
    [productLogo release];
    
    [productsView addSubview:productLogoImageView];
    [productLogoImageView release];
    
    UIButton *choose = [[UIButton alloc] initWithFrame:CGRectMake(255, 100, 75, 25)];
    [choose setTitle:@"Choose..." forState:UIControlStateNormal];
    [choose setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [choose setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:0.5] forState:UIControlStateHighlighted];
    choose.titleLabel.font = [UIFont systemFontOfSize:15];
    choose.tag = -self.productsViewCounter;
    [choose addTarget:self action:@selector(chooseProductLogo:) forControlEvents:UIControlEventTouchUpInside];
    
    [productsView addSubview:choose];
    
    UIButton *delete = [[UIButton alloc] initWithFrame:CGRectMake(340, 100, 50, 25)];
    [delete setTitle:@"Delete" forState:UIControlStateNormal];
    [delete setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [delete setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:0.5] forState:UIControlStateHighlighted];
    delete.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [productsView addSubview:delete];
    [delete release];
    
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
    
    [productsView addSubview:productURL];
    [productURL release];
    
    [productsView addSubview:productURLTextView];
    [productURLTextView release];
    
    [self.scrollView addSubview:productsView];
    [productsView release];
    
    self.productsViewCounter++;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, 20+self.productsViewCounter*(self.productsView.bounds.size.height+5));
    
}

- (IBAction)chooseCompanyLogo:(id)sender {
    
    [self presentViewController:companyImgPicker animated:YES completion:nil];
    
}

- (IBAction)deleteImg:(id)sender {
//    [self.companyLogo setImage:nil];
    [self.companyLogo setImage:[UIImage imageNamed:@"noimg.png"]];

}

- (void) chooseProductLogo:(id) sender {

    
    
    UIButton *chooseProduct = (UIButton *) sender;
    
    for (UIView *i in self.scrollView.subviews) {
        for (UIView *sub in i.subviews) {
            if ([sub isKindOfClass:[UIImageView class]] && sub.tag == -chooseProduct.tag) {
                self.iv = (UIImageView *) sub;
            }
        }
    }
    
    NSLog(@"%lu", self.productsViewCounter);
    
    [self presentViewController:productImgPicker animated:YES completion:nil];


    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:
                                                                        (NSDictionary<NSString *,id> *)info {
    

    if ([picker isEqual:companyImgPicker]) {
        self.companyLogo.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    else if ([picker isEqual:productImgPicker]) {
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
        
        
        [products addObject:newProduct];
        [newProduct release];
        
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
    
    [products release];
    [newComp release];

    [self.navigationController popToRootViewControllerAnimated:YES];

    
    
}

- (void)dealloc {
    [_AddProductsButton release];
    [_companyNameTextField release];
    [_companyLogo release];
    [companyImgPicker release];
    [productImgPicker release];
    [_scrollView release];
    [super dealloc];
}
@end

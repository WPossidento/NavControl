//
//  WebViewController.m
//  NavCtrl
//
//  Created by Vladyslav Gusakov on 2/2/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <WKNavigationDelegate>

@property (retain, nonatomic) WKWebView *webView;

@end

@implementation WebViewController


- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        //Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *productName = @"";
    NSString *companyName = @"https://apple.com";
    
    if ([self.title isEqualToString: @"iPad"]) {
        companyName = @"https://apple.com";
        productName = @"ipad";
    }
    else if ([self.title isEqualToString:@"iPod Touch"]) {
        companyName = @"https://apple.com";
        productName = @"ipod";
    }
    else if ([self.title isEqualToString:@"iPhone"]) {
        companyName = @"https://apple.com";
        productName = @"iphone";
    }
    else if ([self.title isEqualToString:@"Galaxy S4"]) {
        companyName = @"http://www.samsung.com";
        productName = @"global/microsite/galaxys4";
    }
    else if ([self.title isEqualToString:@"Galaxy Note"]) {
        companyName = @"http://www.samsung.com";
        productName = @"global/microsite/galaxynote";
    }
    else if ([self.title isEqualToString:@"Galaxy Tab"]) {
        companyName = @"http://www.samsung.com";
        productName = @"global/microsite/galaxytab";
    }
    else if ([self.title isEqualToString:@"Lumia 950XL"]) {
        companyName = @"https://www.microsoft.com";
        productName = @"en-us/mobile/phone/lumia950-xl-dual-sim/";
    }
    else if ([self.title isEqualToString:@"Lumia 550"]) {
        companyName = @"https://www.microsoft.com";
        productName = @"en-us/mobile/phone/lumia550/";
    }
    else if ([self.title isEqualToString:@"Lumia 1520"]) {
        companyName = @"https://www.microsoft.com";
        productName = @"en-us/mobile/phone/lumia1520/";
    }
    else if ([self.title isEqualToString:@"Signature"]) {
        companyName = @"http://www.vertu.com";
        productName = @"us/en/collections/signature/";
    }
    else if ([self.title isEqualToString:@"The New Signature Touch"]) {
        companyName = @"http://www.vertu.com";
        productName = @"us/en/collections/signature-touch/";
    }
    else if ([self.title isEqualToString:@"Aster"]) {
        companyName = @"http://www.vertu.com";
        productName = @"us/en/collections/aster/";
    }
    
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat width = CGRectGetWidth(screen);
    CGFloat height = CGRectGetHeight(screen);

    
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, width, height) configuration:theConfiguration];
    [self.view addSubview:self.webView];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", companyName, productName]];
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestURL];
    
    
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

- (void)dealloc {
    [_webView release];
    [super dealloc];
}

@end

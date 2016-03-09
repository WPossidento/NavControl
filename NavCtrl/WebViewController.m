//
//  WebViewController.m
//  NavCtrl
//
//  Created by Vladyslav Gusakov on 2/2/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <WKNavigationDelegate>
{
    WKWebViewConfiguration *theConfiguration;
    WKWebView *webView;
}



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
    
    self.sharedManager = [MyManager sharedManager];
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat width = CGRectGetWidth(screen);
    CGFloat height = CGRectGetHeight(screen);

    
    theConfiguration = [[WKWebViewConfiguration alloc] init];
    webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, width, height) configuration:theConfiguration];
    [self.view addSubview:webView];
    
    NSURL *productUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] objectAtIndex:self.sharedManager.currentProductNumber] url]]];
    
    NSLog(@"URL: %@", [NSString stringWithFormat:@"%@",[[[[self.sharedManager.companyList objectAtIndex:self.sharedManager.currentCompanyNumber] productsList] objectAtIndex:self.sharedManager.currentProductNumber] url]]);
    
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:productUrl];
    [webView loadRequest:requestURL];
    
    
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
    [theConfiguration release];
    [webView release];
    
    
    [super dealloc];
}

@end

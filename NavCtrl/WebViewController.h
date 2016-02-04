//
//  WebViewController.h
//  NavCtrl
//
//  Created by Vladyslav Gusakov on 2/2/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "MyManager.h"

@interface WebViewController : UIViewController

@property (nonatomic, retain) MyManager *sharedManager;


@end

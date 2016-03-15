//
//  CustomCell.m
//  NavCtrl
//
//  Created by Vladyslav Gusakov on 3/11/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)dealloc {
    [_imageView release];
    [_companyNameLabel release];
    [_deleteButton release];
    [_stockPrice release];
    [super dealloc];
}

@end

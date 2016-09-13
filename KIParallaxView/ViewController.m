//
//  ViewController.m
//  KIParallaxView
//
//  Created by apple on 15/11/3.
//  Copyright (c) 2015年 smartwalle. All rights reserved.
//

#import "ViewController.h"
#import "KIParallaxView.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tv = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:tv];
    
    [tv setParallaxViewImage:[UIImage imageNamed:@"test.jpg"] delegate:nil height:150 minHeight:0];
    
    
}

@end

//
//  ViewController.m
//  KIParallaxView
//
//  Created by apple on 15/11/3.
//  Copyright (c) 2015年 smartwalle. All rights reserved.
//

#import "ViewController.h"
#import "KIParallaxView.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, KIParallaxViewDelegate>
@property (nonatomic, assign) NSInteger totalCount;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.totalCount = 50;
    
    UITableView *tv = [[UITableView alloc] initWithFrame:self.view.bounds];
    [tv setDataSource:self];
    [tv setDelegate:self];
    [self.view addSubview:tv];
    
    NSLog(@"%f", CGRectGetWidth([UIScreen mainScreen].applicationFrame));
    
    
//    [tv setParallaxViewImage:[UIImage imageNamed:@"testa.jpg"] delegate:nil height:150 minHeight:0];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 150)];
    [v setBackgroundColor:[UIColor greenColor]];
    [tv setParallaxView:v delegate:self height:150 minHeight:64 maxHeight:150];
    
    UIView *hv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [hv setBackgroundColor:[UIColor redColor]];
    [tv setTableHeaderView:hv];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.totalCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"test"];
    }
    [cell.textLabel setText:[NSString stringWithFormat:@"%d", indexPath.row]];
    return cell;
}

- (void)parallaxView:(KIParallaxView *)parallaxView percentOfDrag:(CGFloat)percent {
    NSLog(@"%f", percent);
}

@end

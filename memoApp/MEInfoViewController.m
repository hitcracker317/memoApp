//
//  MEInfoViewController.m
//  memoApp
//
//  Created by maeda on 2014/11/26.
//  Copyright (c) 2014年 maeda. All rights reserved.
//

#import "MEInfoViewController.h"

@interface MEInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation MEInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameLabel.text = [self.object valueForKey:@"name"];
    self.addressLabel.text = [self.object valueForKey:@"address"];
    self.phoneLabel.text = [self.object valueForKey:@"phone"];
    
    //NSDateをNSStringに変換
    NSDateFormatter *format = [NSDateFormatter new];
    [format setDateFormat:@"yyyy年M月d日:H時m分"]; //NSDateの表示形式を指定
    NSString *dateString = [format stringFromDate:[self.object valueForKey:@"date"]];
    self.dateLabel.text = dateString;
    
}

- (IBAction)popViewController:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end

//
//  MEInfoViewController.m
//  memoApp
//
//  Created by maeda on 2014/11/26.
//  Copyright (c) 2014年 maeda. All rights reserved.
//

#import "MEInfoViewController.h"
#import "MEEditViewControler.h"

@interface MEInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation MEInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameLabel.text = self.memoObject.name;
    self.addressLabel.text = self.memoObject.address;
    self.phoneLabel.text = self.memoObject.phone;
    
    //NSDateをNSStringに変換
    NSDateFormatter *format = [NSDateFormatter new];
    [format setDateFormat:@"yyyy年M月d日:H時m分"]; //NSDateの表示形式を指定
    NSString *dateString = [format stringFromDate:self.memoObject.date];
    self.dateLabel.text = dateString;
    
}

- (IBAction)popViewController:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)edit:(id)sender {
    MEEditViewControler *editViewControler = [MEEditViewControler new];
    editViewControler.memoObject = self.memoObject;
}

#pragma mark - prepareForSegue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [[segue identifier] isEqualToString:@"openEditViewController"] ) {
        MEEditViewControler *editViewControler = [segue destinationViewController];
        //遷移先のビューコントローラーに値を受け渡す
        editViewControler.memoObject = self.memoObject;
        editViewControler.isFromInfoViewController = YES;
    }
}


@end

//
//  MEInfoViewController.m
//  memoApp
//
//  Created by maeda on 2014/11/26.
//  Copyright (c) 2014年 maeda. All rights reserved.
//

#import "MEInfoViewController.h"
#import "MEEditViewControler.h"

#import "MEMemoManager.h"

@interface MEInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation MEInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *memoListArray = [[MEMemoManager sharedInstance] getMemoList];
    Memo *memoObject = memoListArray[self.indexPath.row];
    self.nameLabel.text = memoObject.name;
    self.addressLabel.text = memoObject.address;
    self.phoneLabel.text = memoObject.phone;
    
    //NSDateをNSStringに変換
    NSDateFormatter *format = [NSDateFormatter new];
    [format setDateFormat:@"yyyy年M月d日:H時m分"]; //NSDateの表示形式を指定
    NSString *dateString = [format stringFromDate:memoObject.date];
    self.dateLabel.text = dateString;
    
}

- (IBAction)popViewController:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)edit:(id)sender {
    
}

#pragma mark - prepareForSegue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [[segue identifier] isEqualToString:@"openEditViewController"] ) {
        //編集画面にindexPath.rowの値を受け渡す
        MEEditViewControler *editViewControler = [segue destinationViewController];
        editViewControler.indexPathInteger = self.indexPath.row;
    }
}


@end

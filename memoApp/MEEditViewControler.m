//
//  EditViewControlerViewController.m
//  memoApp
//
//  Created by maeda on 2014/11/26.
//  Copyright (c) 2014年 maeda. All rights reserved.
//

#import "MEEditViewControler.h"
#import "MEInfoViewController.h"

#import "Memo.h"
#import "MEMemoManager.h"

@interface MEEditViewControler ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@end

@implementation MEEditViewControler

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameTextField.text = self.memoObject.name;
    self.addressTextField.text = self.memoObject.address;
    self.phoneTextField.text = self.memoObject.phone;
}


- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveContents:(id)sender {
    //データ追加
    [[MEMemoManager sharedInstance] addData:self.nameTextField.text address:self.addressTextField.text phone:self.phoneTextField.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

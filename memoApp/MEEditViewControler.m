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
    
    if (self.indexPathInteger) {
        //index.rowの値を保持しているときのみ過去に入力した内容をフォームに反映
        NSArray *memoListArray = [[MEMemoManager sharedInstance] getMemoList];
        Memo *memoObject = memoListArray[self.indexPathInteger];
        self.nameTextField.text = memoObject.name;
        self.addressTextField.text = memoObject.address;
        self.phoneTextField.text = memoObject.phone;
    }
    
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveContents:(id)sender {
    
    if (self.indexPathInteger) {
        NSLog(@"更新！");
    } else {
        //データ追加
        [[MEMemoManager sharedInstance] addData:self.nameTextField.text address:self.addressTextField.text phone:self.phoneTextField.text];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

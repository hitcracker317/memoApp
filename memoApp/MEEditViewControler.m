//
//  EditViewControlerViewController.m
//  memoApp
//
//  Created by maeda on 2014/11/26.
//  Copyright (c) 2014年 maeda. All rights reserved.
//

#import "MEEditViewControler.h"

#import "AppDelegate.h"
#import "Memo.h"

@interface MEEditViewControler ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@end

@implementation MEEditViewControler

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveContents:(id)sender {
    
    //NSManagedObjectContextを取得
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    //エンティティのオブジェクトを生成。insertNewObjectForEntityForNameの引数にはエンティティの名前を指定。
    Memo *memoEntity = (Memo*)[NSEntityDescription insertNewObjectForEntityForName:@"Memo" inManagedObjectContext:context];
    
    //エンティティのAttributeに各プロパティを格納
    memoEntity.name = self.nameTextField.text;
    memoEntity.address = self.addressTextField.text;
    memoEntity.phone = self.phoneTextField.text;
    memoEntity.date = [NSDate date];
    
    //NSManagedObjectContextのsaveメソッドを読んで、作成したNSManagedObjectをDBに保存
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"error = %@", error);
    } else {
        NSLog(@"保存完了！！");
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

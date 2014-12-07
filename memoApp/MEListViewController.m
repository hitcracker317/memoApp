//
//  ViewController.m
//  memoApp
//
//  Created by maeda on 2014/11/26.
//  Copyright (c) 2014年 maeda. All rights reserved.
//

#import "MEListViewController.h"

#import "MEInfoViewController.h"

#import "AppDelegate.h"
#import <CoreData/CoreData.h>

static NSString *const cellIdentifier = @"cell";

@interface MEListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (nonatomic) NSArray *listArray;

@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSManagedObject *object;

@end

@implementation MEListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.tableFooterView = [[UIView alloc] init];

    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [self getListData];
    [self.listTableView reloadData];
}

- (void)getListData{
    
    //NSManagedObjectの取得
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    self.managedObjectContext = [delegate managedObjectContext];
    
    //NSFetchクラスを使用して、どのエンティティからデータを取得するのかを指定
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Memo"];
    
    //先ほど生成したNSFetchオブジェクトの設定により、NSManagedObjectContextからデータを取得。
    //取得してきたデータを配列に格納
    self.listArray = [self.managedObjectContext executeFetchRequest:request error:nil];
    
}

#pragma mark - UITableViewDelagate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    //配列からデータ(NSManagedObject)を取り出す
    self.object = self.listArray[indexPath.row];
    //valueForKeyメソッドの引数にエンティティのAttribute名を指定することで、Attributeに格納されているデータを取得
    cell.textLabel.text = [self.object valueForKey:@"name"];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"選択されたセル:%ld",indexPath.row);
    
    self.object = self.listArray[indexPath.row];
    //詳細ページへ遷移
    [self performSegueWithIdentifier:@"pushInfoViewController" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [[segue identifier] isEqualToString:@"pushInfoViewController"] ) {
        MEInfoViewController *infoViewController = [segue destinationViewController];
        //遷移先のビューコントローラーに値を受け渡す
        infoViewController.object = self.object;
    }
}

@end

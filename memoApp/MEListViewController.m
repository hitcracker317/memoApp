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

#import "Memo.h"

static NSString *const cellIdentifier = @"cell";

@interface MEListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (nonatomic) NSArray *listArray;

@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) Memo *memoObject;

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

//CoreDataに保存したデータを取得、表示
- (void)getListData{
    
    //NSManagedObjectの取得
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    self.managedObjectContext = [delegate managedObjectContext];
    
    //NSFetchクラスを使用して、どのエンティティからデータを取得するのかを指定
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Memo"];
    
    //ソート条件を指定
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *sortArray = [[NSArray alloc] initWithObjects:sort, nil]; //ソート条件を指定した配列を生成
    [request setSortDescriptors:sortArray]; //NSfetchオブジェクトに先ほど生成した配列をセット
    
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
    Memo *memoObject = self.listArray[indexPath.row];
    //valueForKeyメソッドの引数にエンティティのAttribute名を指定することで、Attributeに格納されているデータを取得
    cell.textLabel.text = [memoObject valueForKey:@"name"];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"選択されたセル:%ld",indexPath.row);
    
    Memo *memoObject = self.listArray[indexPath.row];
    self.memoObject = memoObject;
    //詳細ページへ遷移
    [self performSegueWithIdentifier:@"pushInfoViewController" sender:self];
}

#pragma mark - UITableViewEditDelagate
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //指定したリストのデータを削除
        Memo *memoObject = self.listArray[indexPath.row];
        [self.managedObjectContext deleteObject:memoObject];
        
        //データを格納している配列からも削除
        NSMutableArray *mutableListArray = [self.listArray mutableCopy];
        [mutableListArray removeObjectAtIndex:indexPath.row];
        self.listArray = [mutableListArray copy];
        
        //削除したという状態をNSManagedObjectContextに反映
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"error = %@", error);
        } else {
            NSLog(@"削除完了！！");
        }
        
        //削除したときのテーブルビューのアニメーション
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

//テーブルビューを編集モード有効にする
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

#pragma mark - prepareForSegue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [[segue identifier] isEqualToString:@"pushInfoViewController"] ) {
        MEInfoViewController *infoViewController = [segue destinationViewController];
        
        //遷移先のビューコントローラーに値を受け渡す
        infoViewController.object = self.memoObject;
    }
}

@end

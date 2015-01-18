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
#import "MEMemoManager.h"

static NSString *const cellIdentifier = @"cell";

@interface MEListViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *listSearchBar;
@property (nonatomic) NSArray *listArray;
@property (nonatomic) Memo *memoObject;

@end

@implementation MEListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.tableFooterView = [[UIView alloc] init];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.listSearchBar.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [self getListData];
}

//CoreDataに保存したデータを全部取得して表示
- (void)getListData{
    self.listArray = [[MEMemoManager sharedInstance] getMemoList];
    [self.listTableView reloadData];
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
    cell.textLabel.text = memoObject.name;
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
        [[MEMemoManager sharedInstance] deleteData:indexPath.row];
        
        //データを格納している配列からも削除
        NSMutableArray *mutableListArray = [self.listArray mutableCopy];
        [mutableListArray removeObjectAtIndex:indexPath.row];
        self.listArray = [mutableListArray copy];
        
        //削除したという状態をNSManagedObjectContextに反映
        [[MEMemoManager sharedInstance] saveData];
        
        //削除したときのテーブルビューのアニメーション
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

//テーブルビューを編集モード有効にする
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

#pragma mark - UISearchBarDelegate
//検索ボタンを押したら実行
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.listSearchBar resignFirstResponder]; //キーボードを閉じる
    
    //検索した文字列に当てはまるもののみをテールブビューに表示
    self.listArray = [[MEMemoManager sharedInstance] searchData:searchBar.text];
    [self.listTableView reloadData];
}

//キャンセルボタン(shows Cancel Buttonにチェックすれば表示できる)を押されたときに実行
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self getListData];
}

#pragma mark - prepareForSegue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [[segue identifier] isEqualToString:@"pushInfoViewController"] ) {
        //セルを選択したときは遷移先に値を渡す。
        MEInfoViewController *infoViewController = [segue destinationViewController];
        
        //遷移先のビューコントローラーに値を受け渡す
        infoViewController.memoObject = self.memoObject;
    }
    
}

@end

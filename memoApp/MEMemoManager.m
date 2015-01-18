//
//  MEMemoManager.m
//  memoApp
//
//  Created by 前田 晃良 on 2015/01/18.
//  Copyright (c) 2015年 maeda. All rights reserved.
//

#import "MEMemoManager.h"
#import "Memo.h"

static MEMemoManager *sharedInstance_ = nil;

@implementation MEMemoManager

#pragma mark - Core Data stack
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance_ = [MEMemoManager new];
    });
    return sharedInstance_;
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "maeda.memoApp" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"memoApp" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"memoApp.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - CoreData Maneger
//データの取得
- (NSArray*)getMemoList{
    //NSFetchクラスを使用して、どのエンティティからデータを取得するのかを指定
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Memo"];
    
    //ソート条件を指定
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *sortArray = [[NSArray alloc] initWithObjects:sort, nil]; //ソート条件を指定した配列を生成
    [request setSortDescriptors:sortArray]; //NSfetchオブジェクトに先ほど生成した配列をセット
    
    //先ほど生成したNSFetchオブジェクトの設定により、NSManagedObjectContextからデータを取得。
    //取得してきたデータを配列に格納
    NSArray *memoListArray = [self.managedObjectContext executeFetchRequest:request error:nil];
    return memoListArray;
}

//データの追加
- (void)addData:(NSString*)name address:(NSString*)address phone:(NSString*)phone{
    //エンティティのオブジェクトを生成。insertNewObjectForEntityForNameの引数にはエンティティの名前を指定。
    Memo *memoEntity = (Memo*)[NSEntityDescription insertNewObjectForEntityForName:@"Memo" inManagedObjectContext:self.managedObjectContext];
    
    //エンティティのAttributeに各プロパティを格納
    memoEntity.name = name;
    memoEntity.address = address;
    memoEntity.phone = phone;
    memoEntity.date = [NSDate date];
    
    [self saveData]; //作成したNSManagedObjectをDBに保存
}


//データを保存
- (void)saveData{
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"error = %@", error);
    } else {
        NSLog(@"保存完了！！");
    }
}

//データの更新

//データの検索
- (NSArray*)searchData:(NSString*)searchString{
    //エンティティを指定してNSFetchRequestオブジェクトを作成
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Memo"];
    
    //検索結果のソートを設定
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    //NSPredicateを使用して検索条件を設定する。(ここではsearchBar.textの文字列を含んでいるnameのデータを取得)
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@",searchString];
    [request setPredicate:predicate];
    
    //データを検索、テーブルビューに反映
    NSArray *searchMemoListArray = [self.managedObjectContext executeFetchRequest:request error:nil];
    return searchMemoListArray;
}


//データの削除
- (void)deleteData:(NSInteger)indexPathRow{
    NSArray *memoListArray = [self getMemoList];
    Memo *memoObject = memoListArray[indexPathRow];
    [self.managedObjectContext deleteObject:memoObject];
}


@end

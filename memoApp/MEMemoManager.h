//
//  MEMemoManager.h
//  memoApp
//
//  Created by 前田 晃良 on 2015/01/18.
//  Copyright (c) 2015年 maeda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MEMemoManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+ (instancetype)sharedInstance;

- (NSArray*)getMemoList; //データを取得
- (void)addData:(NSString*)name address:(NSString*)address phone:(NSString*)phone; //データの追加
- (void)saveData; //CoreDataに保存
//データの更新
- (NSArray*)searchData:(NSString*)searchString; //データの検索
- (void)deleteData:(NSInteger)indexPathRow; //データを削除

- (NSURL *)applicationDocumentsDirectory;


@end

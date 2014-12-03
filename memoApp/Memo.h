//
//  Memo.h
//  memoApp
//
//  Created by maeda on 2014/12/03.
//  Copyright (c) 2014年 maeda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Memo : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSDate * date;

@end

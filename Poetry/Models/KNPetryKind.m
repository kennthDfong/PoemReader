//
//  KNPetryKind.m
//  Petroy
//
//  Created by Strom on 15/11/25.
//  Copyright © 2015年 Strom. All rights reserved.
//

#import "KNPetryKind.h"
#import "FMDatabase.h"
#import "KNDBManager.h"

@implementation KNPetryKind

+ (BOOL)removeKind:(NSString *)kindStr {
    FMDatabase *db = [KNDBManager sharedDatabase];
    BOOL success = [db executeUpdateWithFormat:@"delete from t_kind where D_KIND = %@", kindStr];
    
    [db close];
    return success;
}

+ (NSArray *)kinds {
    //从数据库中获取t_kind表中所有数据
    FMDatabase *db = [KNDBManager sharedDatabase];
    FMResultSet *rs = [db executeQuery:@"select * from T_KIND"];
    
    NSMutableArray *dataArr = [NSMutableArray new];
    
    while ([rs next]) {
        KNPetryKind *model = [self new];
        model.kind = [rs stringForColumn:@"D_KIND"];
        model.num = [rs longForColumn:@"D_NUM"];
        model.introKind = [rs stringForColumn:@"D_INKNOKIND"];
        model.introKind2 = [rs stringForColumn:@"D_INKNOKIND2"];
        [dataArr addObject:model];
    }
    
    //释放掉搜索出来的内容
    [db closeOpenResultSets];
    [db close];
    
    return [dataArr copy];
}

@end

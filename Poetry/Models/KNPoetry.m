//
//  KNPoetry.m
//  Petroy
//
//  Created by Strom on 15/11/25.
//  Copyright © 2015年 Strom. All rights reserved.
//

#import "KNPoetry.h"
#import "FMDatabase.h"
#import "KNDBManager.h"

@implementation KNPoetry

//把搜索结果FMResultSet类型转换为 包含PoetryModel的数组类型
+ (NSArray *)resultSetToPoetryList:(FMResultSet *)rs{
    
    NSMutableArray *dataArr = [NSMutableArray new];
    
    while ([rs next]) {
        KNPoetry *model = [self new];
        
        model.kind = [rs stringForColumn:@"d_kind"];
        model.author=[rs stringForColumn:@"d_author"];
        model.title=[rs stringForColumn:@"d_title"];
        model.ID = [rs longForColumn:@"d_id"];
        model.shi = [rs stringForColumn:@"d_shi"];
        model.introShi=[rs stringForColumn:@"d_introshi"];
        
        [dataArr addObject:model];
    }
    
    return [dataArr copy];
}

+ (NSArray *)poetryListWithSearchStr:(NSString *)searchStr{
    FMDatabase *database = [KNDBManager sharedDatabase];
    
    //SQL语句 通配符  ss ->  %ss%
    //如果要在format中输入%，需要转义符 %配合
    searchStr = [NSString stringWithFormat:@"%%%@%%", searchStr];
    FMResultSet *resultSet = [database executeQueryWithFormat:@"select * from t_shi where d_title like %@ or d_author like %@", searchStr, searchStr];
    NSArray *array = [self resultSetToPoetryList:resultSet];
    
    //操作完了管你数据库
    [database close];
    return array;
}

+ (BOOL)removePoetry:(long)poemID {
    FMDatabase *database = [KNDBManager sharedDatabase];
    
    BOOL success = [database executeUpdateWithFormat:@"delete from t_shi where d_id = %ld", poemID];
    [database close];
    
    return success;
}

+ (NSArray *)poetryListWithKind:(NSString *)kind{
    FMDatabase *database = [KNDBManager sharedDatabase];
    //如果数据库语句需要传参 ⬇️
    FMResultSet *resultSet = [database executeQueryWithFormat:@"select * from T_SHI where d_kind = %@", kind];
    NSArray *array = [self resultSetToPoetryList:resultSet];
    
    [database close];
    return array;
}


@end

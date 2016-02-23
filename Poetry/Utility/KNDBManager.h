//
//  KNDBManager.h
//  Petroy
//
//  Created by Strom on 15/11/25.
//  Copyright © 2015年 Strom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface KNDBManager : NSObject

//单例模式，返回唯一的数据库对象
+ (FMDatabase *)sharedDatabase;

@end

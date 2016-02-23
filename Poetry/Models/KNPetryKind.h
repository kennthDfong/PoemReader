//
//  KNPetryKind.h
//  Petroy
//
//  Created by Strom on 15/11/25.
//  Copyright © 2015年 Strom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KNPetryKind : NSObject

@property(nonatomic,strong) NSString *kind;
@property(nonatomic) long num;
@property(nonatomic,strong) NSString *introKind;
@property(nonatomic,strong) NSString *introKind2;

//删除当前数据
+ (BOOL)removeKind:(NSString *)kindStr;

+ (NSArray *)kinds;

@end

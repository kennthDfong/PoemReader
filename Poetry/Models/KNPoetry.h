//
//  KNPoetry.h
//  Petroy
//
//  Created by Strom on 15/11/25.
//  Copyright © 2015年 Strom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KNPoetry : NSObject

@property(nonatomic,strong) NSString *kind;
@property(nonatomic,strong) NSString *shi;
@property(nonatomic,strong) NSString *introShi;
@property(nonatomic,strong) NSString *title;
@property(nonatomic) long ID;
@property(nonatomic,strong) NSString *author;

+ (BOOL)removePoetry:(long)poemID;

+ (NSArray *)poetryListWithKind:(NSString *)kind;

@end

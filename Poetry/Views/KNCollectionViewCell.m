//
//  KNCollectionViewCell.m
//  Petroy
//
//  Created by Strom on 16/1/25.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import "KNCollectionViewCell.h"

@implementation KNCollectionViewCell

- (IBAction)clickDeleteButton:(id)sender {
    NSLog(@"开始删除整个诗集");
    
    if (!self.deleteButton.hidden) {
        [self.delegate removePoetryKindCell:self];
    }
}

@end

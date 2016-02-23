//
//  KNCollectionViewCell.h
//  Petroy
//
//  Created by Strom on 16/1/25.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KNCollectionViewCell;

@protocol PoetryKindCellDelegate <NSObject>

- (void)removePoetryKindCell:(KNCollectionViewCell *)poetryKindCell;

@end


@interface KNCollectionViewCell : UICollectionViewCell

//cell的背景视图
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) id<PoetryKindCellDelegate> delegate;

@end

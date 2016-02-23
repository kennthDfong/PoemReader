//
//  KNMainViewController.m
//  Poetry
//
//  Created by Strom on 16/1/25.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import "KNMainViewController.h"
#import "KNPetryKind.h"
#import "KNCollectionViewCell.h"
#import "KNPoetryListTableViewController.h"
#import "KNCollectionViewCell.h"

@interface KNMainViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, PoetryKindCellDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//存储诗词类型
@property (nonatomic, strong) NSArray *poetryArray;
//记录是否是编辑状态
@property (nonatomic, assign) BOOL isEditing;

@end

@implementation KNMainViewController

- (NSArray *)poetryArray {
    if (!_poetryArray) {
        _poetryArray = [KNPetryKind kinds];
    }
    
    return _poetryArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //添加item
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(clickRightItem)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //设置非编辑状态
    _isEditing = NO;
    
    //设置collectionView背景图片
    self.collectionView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"背景"]];
}

#pragma mark - 点击右边item触发方法
- (void)clickRightItem {
    //
    if (!_isEditing) {
        //设置标题为“确定”
        self.navigationItem.rightBarButtonItem.title = @"完成";
        _isEditing = YES;
    } else {
        //设置标题为"编辑"
        self.navigationItem.rightBarButtonItem.title = @"编辑";
        _isEditing = NO;
    }
    
    //重新加载数据
    [_collectionView reloadData];
    
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.poetryArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!_isEditing) {
        //当处于非编辑状态时
        KNPetryKind *poetryKind = self.poetryArray[indexPath.row];
        KNPoetryListTableViewController *poetryListViewController = [[KNPoetryListTableViewController alloc] initWithPoetryKind:poetryKind.kind];
        [self.navigationController pushViewController:poetryListViewController animated:YES];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    KNCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    //设置cell的删除button为隐藏
    cell.deleteButton.hidden = !_isEditing;
    //设置代理
    cell.delegate = self;
    
    KNPetryKind *peotryKind = self.poetryArray[indexPath.row];
    cell.backgroundImageView.image = [UIImage imageNamed:peotryKind.kind];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //    340 162
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 10) / 2 ;
    return CGSizeMake(width, width * 160 / 340);
}

#pragma mark - PoetryKindCellDelegate
- (void)removePoetryKindCell:(KNCollectionViewCell *)poetryKindCell {
    //获取当前诗词分类对应的indexPath
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:poetryKindCell];
    
    //创建UIAlertControler对象
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"删除诗词" message:@"确定永久删除该诗词吗?" preferredStyle:UIAlertControllerStyleAlert];
    //创建两个UIAlertAction对象(取消/确定)
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //数据来源
        KNPetryKind *peotryKind  = self.poetryArray[indexPath.row];
        if ([KNPetryKind removeKind:peotryKind.kind]) {
            
            //更新数据源
            self.poetryArray = [KNPetryKind kinds];
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        }
    }];
    //添加两个action
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    
    //显示
    [self presentViewController:alertController animated:YES completion:nil];
}

@end

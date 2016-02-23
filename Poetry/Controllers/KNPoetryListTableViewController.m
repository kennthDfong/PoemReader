//
//  KNPoetryListTableViewController.m
//  Petroy
//
//  Created by Strom on 15/11/25.
//  Copyright © 2015年 Strom. All rights reserved.
//

#import "KNPoetryListTableViewController.h"
#import "KNPoetry.h"
#import "KNDetailTableViewController.h"
#import "UIColor+FlatUI.h"

@interface PoetryCell : UITableViewCell
@end

@implementation PoetryCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}
@end



@interface KNPoetryListTableViewController ()

@property (nonatomic, strong) NSString *poetryKindStr;

@property (nonatomic, strong) NSArray *poetryArray;

@end

@implementation KNPoetryListTableViewController

- (NSArray *)poetryArray {
    if (!_poetryArray) {
        _poetryArray = [KNPoetry poetryListWithKind:self.poetryKindStr];
    }
    return _poetryArray;
}

- (id)initWithPoetryKind:(NSString *)kind {
    if (self = [super init]) {
        self.poetryKindStr = kind;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //注册自定义cell
    [self.tableView registerClass:[PoetryCell class] forCellReuseIdentifier:@"cell"];
    
    self.navigationItem.title = @"诗词列表";
    
    //设置背景图片
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"背景"]];
    
    self.navigationItem.backBarButtonItem.title = @"";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.poetryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PoetryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    KNPoetry *poetry = self.poetryArray[indexPath.row];
    cell.textLabel.text = poetry.title;
    cell.detailTextLabel.text = poetry.author;
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.textColor = [UIColor colorFromHexCode:@"7f6d54"];
    cell.detailTextLabel.textColor = [UIColor colorFromHexCode:@"907b5e"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    KNPoetry *poetry = self.poetryArray[indexPath.row];
    
    KNDetailTableViewController *vc = [[KNDetailTableViewController alloc] initWithPoetry:poetry.shi withIntro:poetry.introShi];
    [self.navigationController pushViewController:vc animated:YES];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
//修改左滑的文本
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除此诗";
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //创建UIAlertControler对象
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"删除诗词" message:@"确定永久删除该诗词吗?" preferredStyle:UIAlertControllerStyleAlert];
        //创建两个UIAlertAction对象(取消/确定)
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //数据来源
            KNPoetry *poem = self.poetryArray[indexPath.row];
            if ([KNPoetry removePoetry:poem.ID]) {
                ///////更新数据源(已经从删除后的表获取数据)
                self.poetryArray = [KNPoetry poetryListWithKind:poem.kind];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
        //添加两个action
        [alertController addAction:cancelAction];
        [alertController addAction:deleteAction];
        //显示出来(present)
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    PoetryDetailViewController *vc=[[PoetryDetailViewController alloc] initWithShi:[self.poetryVM shiForRow:indexPath.row] intro:[self.poetryVM shiIntroForRow:indexPath.row]];
//    [self.navigationController pushViewController:vc animated:YES];
//}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

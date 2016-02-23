//
//  KNDetailTableViewController.m
//  Petroy
//
//  Created by Strom on 15/11/26.
//  Copyright © 2015年 Strom. All rights reserved.
//

#import "KNDetailTableViewController.h"
#import "Masonry.h"
#import <AVFoundation/AVFoundation.h>

@interface PoetryDetailCell:UITableViewCell
@property(nonatomic, strong) UILabel *label;
@end
@implementation PoetryDetailCell
- (UILabel *)label{
    
    if (!_label) {
        _label = [UILabel new];
//        _label.font = [UIFont systemFontOfSize:18];
        _label.numberOfLines = 0;
    }
    return _label;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.label];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            //(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
            make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
        }];
    }
    return self;
}
@end


@interface KNDetailTableViewController ()<AVSpeechSynthesizerDelegate>

@property(nonatomic,strong) NSString *poepty;
@property(nonatomic,strong) NSString *poeptyIntro;

//语音功能
@property(nonatomic,strong) AVSpeechSynthesizer *spe;
//右上角朗读按钮
@property(nonatomic,strong) UIBarButtonItem *readItem;

@end

@implementation KNDetailTableViewController

- (AVSpeechSynthesizer *)spe{
    if (!_spe) {
        _spe = [AVSpeechSynthesizer new];
        _spe.delegate = self;
    }
    return _spe;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册自定义的cell
    [self.tableView registerClass:[PoetryDetailCell class] forCellReuseIdentifier:@"detail"];
    
    self.navigationItem.title = @"诗词详情";
    
    //创建右边朗读的item
    self.readItem = [[UIBarButtonItem alloc] initWithTitle:@"朗读" style:UIBarButtonItemStyleDone target:self action:@selector(startReadingPoetry)];
    //添加
    self.navigationItem.rightBarButtonItem = self.readItem;
    
    //设置背景图片
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"背景"]];
}

- (void)startReadingPoetry {
    
    if (self.spe.speaking) {
        [self.spe stopSpeakingAtBoundary:AVSpeechBoundaryWord];
        return;
    }
    
   //设置读取的文本
    AVSpeechUtterance *utt = [AVSpeechUtterance speechUtteranceWithString:[self.poepty stringByAppendingString:self.poeptyIntro]];
    //设置使用什么语言
    utt.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh_CN"];

    [self.spe speakUtterance:utt];

}


- (id)initWithPoetry:(NSString *)poetry withIntro:(NSString *)poetryIntro {
    if (self = [super init]) {
        self.poepty = poetry;
        self.poeptyIntro = poetryIntro;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.spe stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance{
    self.readItem.title = @"停止";
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance{
    self.readItem.title = @"朗读";
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance{
    self.readItem.title = @"朗读";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @[@"诗词鉴赏", @"注解"][section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PoetryDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detail"];
    cell.label.text = @[self.poepty, self.poeptyIntro][indexPath.section];
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
//    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SectionHeader"];
//    headerView.textLabel.text = @[@"诗词赏析", @"注解"][section];
//    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    return bgView;
}

/*
 面试问题:如何提高tableView的加载速度?
 协议：HeightForRow和cellForRow 执行顺序？
 在执行cellForRow之前，table中如果有100行，那么会执行100次HeightForRow，计算出table的内容总高度，为了让右侧滑动条显示准确
 当实现estimatedHeightForRow协议以后，HeightForRow方法只会当cell加载时，才运行。
 */
//下方协议，也是通过autoLayout实现cell高度自动匹配的关键点
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

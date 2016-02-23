//
//  AppDelegate.m
//  Poetry
//
//  Created by Strom on 16/1/25.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import "AppDelegate.h"
#import "UIColor+FlatUI.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self movePoetryDBToDocuments];
    
    [self configGlobalApperaranceStyle];
    
    return YES;
}

//统一设置背景图片/字体颜色
- (void)configGlobalApperaranceStyle {
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"背景"] forBarMetrics:UIBarMetricsDefault];
    [[UITableViewCell appearance] setBackgroundColor:[UIColor clearColor]];
    [[UITableView appearance] setSeparatorColor:[UIColor colorFromHexCode:@"9c896f"]];
    self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"背景"]];
    
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorFromHexCode:@"726754"]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorFromHexCode:@"534430"], NSFontAttributeName: [UIFont systemFontOfSize:22]}];
}


//因为要对数据库中的数据进行删除操作，但是app目录下的文件都是只读的，所以我们要复制一份到document文件夹下，以后就都对docment文件夹下的数据库做操作
- (void)movePoetryDBToDocuments {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Poetry" ofType:@"bundle"];
    path = [path stringByAppendingPathComponent:@"sqlite.db"];
    NSLog(@"path %@", path);
    
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    docPath = [docPath stringByAppendingPathComponent:@"sqlite.db"];
    NSLog(@"docPath %@", docPath);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:docPath]) {
        [fileManager copyItemAtPath:path toPath:docPath error:nil];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

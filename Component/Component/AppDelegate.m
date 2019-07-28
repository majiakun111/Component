//
//  AppDelegate.m
//  Component
//
//  Created by Ansel on 16/2/26.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import "AppDelegate.h"
#import "TestJSWebViewController.h"

#import "ViewController.h"

#import "TestPageRootViewController.h"

#import "TestNestCollectionViewController.h"
#import "NestCollectionViewComponent.h"
#import "TestCollectionViewCellItem.h"

#import "TestTableViewController.h"

#import "TestCollectionViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
//    TestJSWebViewController *rootViewController = [[TestJSWebViewController alloc] init];
//    UINavigationController *rootNavigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
//    self.window.rootViewController = rootNavigationController;
//    [self.window makeKeyAndVisible];
//    [self.window setBackgroundColor:[UIColor whiteColor]];

 
//    TestPageRootViewController *rootViewController = [[TestPageRootViewController alloc] init];
//    self.window.rootViewController = rootViewController;
//    [self.window makeKeyAndVisible];
//    [self.window setBackgroundColor:[UIColor whiteColor]];

    
//    TestPageViewController *rootViewController = [[TestPageViewController alloc] init];
//    self.window.rootViewController = rootViewController;
//    [self.window makeKeyAndVisible];
//    [self.window setBackgroundColor:[UIColor whiteColor]];

    CollectionViewSectionItem *topSectionItem = [[CollectionViewSectionItem alloc] init];
    TestNestCollectionViewTopCellItem *topSectionCellItem = [[TestNestCollectionViewTopCellItem alloc] init];
    topSectionCellItem.size = CGSizeMake([UIScreen mainScreen].bounds.size.width, 500);
    topSectionItem.cellItems = @[topSectionCellItem].mutableCopy;

    CollectionViewSectionItem *bottomSectionItem = [[CollectionViewSectionItem alloc] init];

    NestPageContainerReusableViewItem *bottomSectionHeaderViewItem = [[NestPageContainerReusableViewItem alloc] init];
    NSMutableArray<NSString *> *titles = @[].mutableCopy;
    for (NSInteger index = 0; index < 20; index++) {
        NSString *title = [NSString stringWithFormat:@"title_%d", (int)index];
        if (index % 2 ==0) {
            title = [NSString stringWithFormat:@"ansel_%@", title];
        }

        [titles addObject:title];
    }
    bottomSectionHeaderViewItem.size = CGSizeMake([UIScreen mainScreen].bounds.size.width, 40);;
    bottomSectionHeaderViewItem.titles = titles;
    bottomSectionHeaderViewItem.indexProgress = 0;
    bottomSectionItem.headerViewItem = bottomSectionHeaderViewItem;

    NSMutableArray<__kindof PageItem *> *pageItems = @[].mutableCopy;
    for (int pageIndex = 0; pageIndex < 20; pageIndex++) {
        PageItem *pageItem = [[PageItem alloc] init];
        CollectionViewSectionItem *sectionItem = [[CollectionViewSectionItem alloc] init];
        sectionItem.cellItems = @[].mutableCopy;
        for (int index = 0; index < 100; index ++) {
            TestCollectionViewCellItem *cellItem = [[TestCollectionViewCellItem alloc] init];
            cellItem.title = [NSString stringWithFormat:@"%d_%d", pageIndex, index];
            [sectionItem.cellItems addObject:cellItem];
            cellItem.size = CGSizeMake(80.0, 80.0);
        }

        pageItem.sectionItems = @[sectionItem];
        pageItem.viewControllerClass = [TestNestPageViewController class];
        [pageItems addObject:pageItem];
    }
    PageContainerItem *pageContainerItem = [[PageContainerItem alloc] init];
    pageContainerItem.pageItems = pageItems;

    NestPageContainerCellItem *bottomSectionCellItem = [[NestPageContainerCellItem alloc] init];
    bottomSectionCellItem.pageContainerItem = pageContainerItem;
    bottomSectionCellItem.canUpDownScroll = YES;
    bottomSectionCellItem.pageIndex = 0;
    bottomSectionCellItem.size = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - bottomSectionHeaderViewItem.size.height);

    bottomSectionItem.cellItems = @[bottomSectionCellItem].mutableCopy;

    TestNestCollectionViewController *rootViewController = [[TestNestCollectionViewController alloc] initWithSectioItems:@[topSectionItem, bottomSectionItem]];
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
//    TestTableViewController *rootViewController = [[TestTableViewController alloc] init];
//    self.window.rootViewController = rootViewController;
//    [self.window makeKeyAndVisible];
//    [self.window setBackgroundColor:[UIColor whiteColor]];
    
//    TestCollectionViewController *rootViewController =  [[TestCollectionViewController alloc] init];
//    self.window.rootViewController = rootViewController;
//    [self.window makeKeyAndVisible];
//    [self.window setBackgroundColor:[UIColor whiteColor]];

    return YES;
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

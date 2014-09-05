//
//  SideMenuManager.m
//  Salsette
//
//  Created by Kerekes Jozsef-Marton on 28/08/14.
//
//

#import "SideMenuManager.h"
#import "TWTMainViewController.h"
#import "TWTSideMenuViewController.h"
#import "SideMenuFactory.h"
#import "TWTMenuViewController.h"
//#import "ParseManager.h"
#import "ParseIncludes.h"

@interface SideMenuManager () <TWTSideMenuViewControllerDelegate>

@property (nonatomic, strong) TWTSideMenuViewController *sideMenuViewController;
@property (nonatomic, strong) TWTMenuViewController *menuViewController;
@property (nonatomic, strong) TWTMainViewController *mainViewController;
@property (nonatomic, strong) NSArray *menuDataSource;

@end

@implementation SideMenuManager

- (void)createSideMenuForWindow:(UIWindow *)window {
    
    [self loadMenuDataSource];

    self.menuViewController = [[TWTMenuViewController alloc] init];
    self.menuViewController.dataSource = [self.menuDataSource mutableCopy];
    self.mainViewController = [[TWTMainViewController alloc] init];

    self.sideMenuViewController = [[TWTSideMenuViewController alloc] initWithMenuViewController:self.menuViewController mainViewController:[[UINavigationController alloc] initWithRootViewController:self.mainViewController]];
    self.sideMenuViewController.shadowColor = [UIColor blackColor];
    self.sideMenuViewController.edgeOffset = (UIOffset) { .horizontal = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 18.0f : 0.0f };
    self.sideMenuViewController.zoomScale = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 0.5634f : 0.85f;
    self.sideMenuViewController.delegate = self;
    window.rootViewController = self.sideMenuViewController;

    window.backgroundColor = [UIColor whiteColor];
    [window makeKeyAndVisible];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMenuWithNotification:) name:MenuShouldReloadNotification];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addItemToMenuWithNotification:) name:MenuShouldAddObject];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMenuWithNotification:) name:MenuShouldRemoveObject];
}

- (void)loadMenuDataSource {
    
    self.menuDataSource = [SideMenuFactory menuItemsWithUser:[PFUser currentUser] event:^(SideMenuItem *item) {
        if (item && item.section) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.menuViewController addItem:item atSection:item.section];
            });
        }
    } update:^(SideMenuItem *item) {
        if (item && item.section) {
            dispatch_async(dispatch_get_main_queue(), ^{
            });
        }
    }];
}
- (void)reloadMenuWithNotification:(NSNotification *)notification {
    
    if ([NSThread isMainThread]) {
        [self loadMenuDataSource];
        self.menuViewController.dataSource = [self.menuDataSource mutableCopy];
        [self.menuViewController reload];
    }
}

- (void)addItemToMenuWithNotification:(NSNotification *)notification {
    
    SideMenuItem *item = [SideMenuItem eventItemWithEvent:notification.object];
    [self.menuViewController addItem:item atSection:item.section];
}

#pragma mark - TWTSideMenuViewControllerDelegate

- (UIStatusBarStyle)sideMenuViewController:(TWTSideMenuViewController *)sideMenuViewController statusBarStyleForViewController:(UIViewController *)viewController
{
    if (viewController == self.menuViewController) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

- (void)sideMenuViewControllerWillOpenMenu:(TWTSideMenuViewController *)sender {

    
}

- (void)sideMenuViewControllerDidOpenMenu:(TWTSideMenuViewController *)sender {

    
}

- (void)sideMenuViewControllerWillCloseMenu:(TWTSideMenuViewController *)sender {

    
}

- (void)sideMenuViewControllerDidCloseMenu:(TWTSideMenuViewController *)sender {

    
}


@end

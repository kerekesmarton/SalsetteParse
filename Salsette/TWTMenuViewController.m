//
//  TWTMenuViewController.m
//  TWTSideMenuViewController-Sample
//
//  Created by Josh Johnson on 8/14/13.
//  Copyright (c) 2013 Two Toasters. All rights reserved.
//

#import "TWTMenuViewController.h"
#import "TWTMainViewController.h"
#import "TWTSideMenuViewController.h"

#import "SideMenuGroup.h"
#import "SideMenuItem.h"

@interface TWTMenuViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation TWTMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect imageViewRect = [[UIScreen mainScreen] bounds];
    imageViewRect.size.width += 589;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5.0f;
    layout.minimumInteritemSpacing = 5.0f;
    layout.itemSize = CGSizeMake(64.0f, 64.0f);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.headerReferenceSize = CGSizeMake(imageViewRect.size.width, 15.0f);
    layout.footerReferenceSize = CGSizeMake(imageViewRect.size.width, 15.0f);
    layout.sectionInset = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:imageViewRect collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.collectionView];
    
    UINib *cellNib = [UINib nibWithNibName:@"SideMenuCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"cell"];
    

    NSDictionary *viewDictionary = @{ @"imageView" : self.collectionView };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]" options:0 metrics:nil views:viewDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView]" options:0 metrics:nil views:viewDictionary]];
}

- (void)reload {
    
    [self.collectionView reloadData];
}

- (void)closeButtonPressed
{
    [self.sideMenuViewController closeMenuAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
 
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    SideMenuGroup *group = [self.dataSource objectAtIndex:section];
    
    return group.groupItems.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    
    SideMenuGroup *group = [self.dataSource objectAtIndex:indexPath.section];
    SideMenuItem  *item = [group.groupItems objectAtIndex:indexPath.row];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    recipeImageView.image = item.itemImage;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SideMenuGroup *group = [self.dataSource objectAtIndex:indexPath.section];
    SideMenuItem  *item = [group.groupItems objectAtIndex:indexPath.row];
    
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:[item.viewControllerClass new]];
    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];
}

@end

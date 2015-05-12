//
//  EditClassesViewController.m
//  Salsette
//
//  Created by Kerekes, Marton on 28/04/15.
//
//

#import "EditClassesViewController.h"
#import "UIViewController+Navigation.h"
#import "EventCollectionViewCell.h"
#import "PFClassRoom.h"
#import "PFClassList.h"
#import "PFClass.h"

@interface EditClassesViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

//@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) PFClassList *classList;

@end

@implementation EditClassesViewController

- (PFClassList *)classList
{
    return (PFClassList *)self.object;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.classList fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5.0f;
        layout.minimumInteritemSpacing = 5.0f;
//        layout.estimatedItemSize = CGSizeMake(100.0f, 100.0f);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.headerReferenceSize = CGSizeMake(self.view.frameWidth, 5.0f);
        layout.footerReferenceSize = CGSizeMake(self.view.frameWidth, 5.0f);
        layout.sectionInset = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:self.collectionView];
        
        UINib *cellNib = [UINib nibWithNibName:@"EventCollectionViewCell" bundle:nil];
        [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"cell"];
        
        
        NSDictionary *viewDictionary = @{ @"imageView" : self.collectionView };
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]" options:0 metrics:nil views:viewDictionary]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView]" options:0 metrics:nil views:viewDictionary]];
        
//        [self.collectionView reloadData];
    }];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.classList.rooms.count + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    PFClassRoom *room = [self safeRoomForSection:section];
    NSArray *classes = [self.classList.schedule objectForKey:room.name];
    
    return classes.count + 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    
    PFClass *item = [self safeClassForIndex:indexPath];
    
    EventCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell.textView setText:[NSString stringWithFormat:@" %@ section %ld, row %ld",item.name,(long)indexPath.section, (long)indexPath.row]];
    cell.backgroundColor = [UIColor greenColor];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PFClassRoom *room = [self safeRoomForSection:indexPath.section];
    BOOL roomIsNew = [self createRoomIfNeeded:room completion:^{
        [self.collectionView reloadData];
    }];
    if (roomIsNew) {
        return;
    }
    
    PFClass *class = [self safeClassForIndex:indexPath];
    BOOL classIsNew = [self createClassIfNeeded:class forRoom:room completion:^{
        [self.collectionView reloadData];
    }];
    if (classIsNew) {
        return;
    }
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    UICollectionReusableView *reusableview = nil;
//    
////    if (kind == UICollectionElementKindSectionHeader) {
////        RecipeCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
////        NSString *title = [[NSString alloc]initWithFormat:@"Recipe Group #%i", indexPath.section + 1];
////        headerView.title.text = title;
////        UIImage *headerImage = [UIImage imageNamed:@"header_banner.png"];
////        headerView.backgroundImage.image = headerImage;
////        
////        reusableview = headerView;
////    }
////    
////    if (kind == UICollectionElementKindSectionFooter) {
////        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
////        
////        reusableview = footerview;
////    }
////    
//    return reusableview;
//}


- (PFClassRoom *)safeRoomForSection:(NSInteger)section
{
    if ([self.classList.rooms count] > section) {
        return [self.classList.rooms objectAtIndex:section];
    }
    else
    {
        return [PFClassRoom object];
    }
}

-(PFClass *)safeClassForIndex:(NSIndexPath *)indexPath
{
    PFClassRoom *room;
    if ([self.classList.rooms count] > indexPath.section) {
        room = [self.classList.rooms objectAtIndex:indexPath.section];
    }
    
    NSArray *array = [self.classList.schedule objectForKey:room.name];
    if (array.count > indexPath.row) {
        return [array objectAtIndex:indexPath.row];
    }
    else
    {
        return [PFClass object];
    }
}

- (BOOL)createRoomIfNeeded:(PFClassRoom *)room completion:(void (^)(void))completion
{
    if ([room.name isEqual:UNNAMED_ROOM]) {
        [self startEditingRoom:room withCompletion:^(PFClassRoom *room)
         {
             NSMutableArray *rooms = [NSMutableArray arrayWithArray:self.classList.rooms];
             [rooms addObject:room];
             self.classList.rooms = rooms;
             completion();
         }];
        return YES;
    } else
    {
        return NO;
    }
}

- (BOOL)createClassIfNeeded:(PFClass *)class forRoom:(PFClassRoom *)room completion:(void (^)(void))completion
{
    if ([class.name isEqual:UNNAMED_CLASS]) {
        [self startEditingClass:class withCompletion:^(PFClass *class) {
            
            NSMutableDictionary *schedule = [NSMutableDictionary dictionaryWithDictionary:self.classList.schedule];
            
            NSMutableArray *classes = [NSMutableArray arrayWithArray:[schedule objectForKey:room.name]];
            [classes addObject:class];
            [schedule setObject:classes forKey:room.name];
            self.classList.schedule = schedule;
            completion();
        }];
        return YES;
    } else
    {
        return NO;
    }
}

- (void)startEditingRoom:(PFClassRoom *)room withCompletion:(void (^)(PFClassRoom *))completion
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Create room" message:@"What is the name of the room?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = room.name;
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *text = [(UITextField *)[alert.textFields firstObject] text];
        if ([text length] > 0) {
            room.name = text;
            completion(room);
//            [self dismissViewControllerAnimated:YES completion:^{ }];
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//        [self dismissViewControllerAnimated:YES completion:^{ }];
    }]];
    
    [self presentViewController:alert animated:YES completion:^{}];
}

- (void)startEditingClass:(PFClass *)class withCompletion:(void (^)(PFClass *))completion
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Create class" message:@"What is the name of the class?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = class.name;
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *text = [(UITextField *)[alert.textFields firstObject] text];
        if ([text length] > 0) {
            class.name = text;
            completion(class);
//            [self dismissViewControllerAnimated:YES completion:^{ }];
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//        [self dismissViewControllerAnimated:YES completion:^{ }];
    }]];
    
    [self presentViewController:alert animated:YES completion:^{}];
}
@end

//
//  ViewController.m
//  LCMovableCollectionView
//
//  Created by lc on 2017/8/3.
//  Copyright © 2017年 liuchang. All rights reserved.
//

#import "ViewController.h"
#import "LCMovableCollectionView.h"
#import "CollectionViewCell.h"
#import "CollectionReusableView.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) LCMovableCollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *datas;

@end

@implementation ViewController

static NSString *reusedId = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"不可移动";
    
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.collectionView addGestureRecognizer:longPressGes];
    [self.view addSubview:self.collectionView];
}

- (void)longPress:(UILongPressGestureRecognizer *)longPressGes {
    if (longPressGes.state == UIGestureRecognizerStateBegan) {
        self.collectionView.movable = !self.collectionView.movable;
        self.title = self.collectionView.movable ? @"可移动" : @"不可移动";
    }
}

#pragma mark 🍀🍀 UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.datas.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.datas[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reusedId forIndexPath:indexPath];
    [cell setTitle:[NSString stringWithFormat:@"%@", self.datas[indexPath.section][indexPath.item]]];
    
    cell.contentView.backgroundColor = [UIColor redColor];
    if (indexPath.section == 0 && (indexPath.item == 0 || indexPath.item == 1)) {
        cell.contentView.backgroundColor = [UIColor grayColor];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    CollectionReusableView *reuseableView;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        reuseableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head" forIndexPath:indexPath];
        [reuseableView setTitle:[NSString stringWithFormat:@"section_%td", indexPath.section]];
    }
    return reuseableView;
}

#pragma mark 🍀🍀 UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch ([self.datas[indexPath.section][indexPath.item] integerValue] % 2) {
        case 0:
            return CGSizeMake(40, 50);
        case 1:
            return CGSizeMake(60, 50);
        default:
            return CGSizeMake(40, 50);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0, 40);
}

#pragma mark 🍀🍀 lazy load

- (LCMovableCollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        
        __weak __typeof(self)wself = self;
        LCMovableCollectionView *collectionView = [[LCMovableCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout moveCallBack:^(NSIndexPath *fromIndexPath, NSIndexPath *toIndexPath) {
            //移动后更改数据源
            [wself.datas[fromIndexPath.section] moveObjectAtIndex:fromIndexPath.item toIndex:toIndexPath.item];
        }];
        //设置不可以移动的indexPath
        collectionView.unmovableIndexPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForItem:0 inSection:0], [NSIndexPath indexPathForItem:1 inSection:0], nil];
        
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:reusedId];
        [collectionView registerClass:[CollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
        
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < 3; i++) {
            NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:0];
            for (int j = 0; j < 15; j++) {
                [arrayM addObject:[NSNumber numberWithInt:j]];
            }
            [_datas addObject:arrayM];
        }
    }
    
    return _datas;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

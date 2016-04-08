//
//  ViewController.m
//  CustomLayoutCollection-demo
//
//  Created by MARVIS on 15/11/6.
//  Copyright © 2015年 www.uluk.com. All rights reserved.
//

#import "ViewController.h"
#import "CustomLayCollectionOut.h"
#import "RAMCollectionViewCell.h"
#import "RAMCollectionAuxView.h"

static NSString *const CellIdentifier = @"MyCell";
static NSString * const HeaderIdentifier = @"HeaderIdentifier";
static NSString * const FooterIdentifier = @"FooterIdentifier";

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,CustomLayCollectionOutDelegate>
@property (nonatomic, strong) CustomLayCollectionOut *collectionViewLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Setup
- (void)setup{
    self.collectionViewLayout = [[CustomLayCollectionOut alloc] init];
    self.collectionViewLayout.delegate = self;

    
    self.collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:self.collectionViewLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor cyanColor];
    [self.collectionView registerClass:[RAMCollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    [self.collectionView registerClass:[RAMCollectionAuxView class] forSupplementaryViewOfKind:RAMCollectionViewFlemishBondHeaderKind withReuseIdentifier:HeaderIdentifier];
    [self.collectionView registerClass:[RAMCollectionAuxView class] forSupplementaryViewOfKind:RAMCollectionViewFlemishBondFooterKind withReuseIdentifier:FooterIdentifier];
    
    [self.view addSubview: self.collectionView];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return 16;
        }
            break;
        case 1:{
            return 48;
        }
            break;
        case 2:{
            return 29;
        }
            break;
        default:{
            return 24;
        }
            break;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath%@",indexPath);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RAMCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell configureCellWithIndexPath:indexPath];
    
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *titleView;
    
    if (kind == RAMCollectionViewFlemishBondHeaderKind) {
        titleView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
        ((RAMCollectionAuxView *)titleView).label.text = @"Header";
    } else if (kind == RAMCollectionViewFlemishBondFooterKind) {
        titleView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:FooterIdentifier forIndexPath:indexPath];
        ((RAMCollectionAuxView *)titleView).label.text = @"Footer";
    }
    
    return titleView;
}
#pragma mark -CustomLayCollectionOutDelegate
#pragma mark -

//获取大View的高度
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(CustomLayCollectionOut *)collectionViewLayout estimatedHeightForUpCellInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return 50;
        }
            break;
        case 1:{
            return 100;
        }
            break;
        case 2:{
            return 150;
        }
            break;
        default:{
            return 80;
        }
            break;
    }
}
//获取小View的高度
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(CustomLayCollectionOut *)collectionViewLayout estimatedHeightForDownCellInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return 25;
        }
            break;
        case 1:{
            return 70;
        }
            break;
        case 2:{
            return 90;
        }
            break;
        default:{
            return 40;
        }
            break;
    }
}
//获取一行可以放几个小View
- (NSUInteger)collectionView:(UICollectionView *)collectionView layout:(CustomLayCollectionOut *)collectionViewLayout estimatedCellCountForRowInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return 1;
        }
            break;
        case 1:{
            return 4;
        }
            break;
        case 2:{
            return 3;
        }
            break;
        default:{
            return 4;
        }
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(CustomLayCollectionOut *)collectionViewLayout estimatedSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), 100);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(CustomLayCollectionOut *)collectionViewLayout estimatedSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), 100);
}


@end

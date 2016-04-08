//
//  CustomLayCollectionOut.h
//  CustomLayoutCollection-demo
//
//  Created by MARVIS on 15/11/6.
//  Copyright © 2015年 www.uluk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLayoutAttributes.h"

#ifndef DEBUG
#define CNLog(format, ...) NSLog((@"[Line %d] %s " format), __LINE__, __PRETTY_FUNCTION__, ## __VA_ARGS__)
#define CNLogRect(format, rect) NSLog(@"Line %d] %s x:%.4f, y:%.4f, w:%.4f, h:%.4f", __LINE__, __PRETTY_FUNCTION__, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
#define CNLogSize(format, size) NSLog(@"Line %d] %s w:%.4f, h:%.4f", __LINE__, __PRETTY_FUNCTION__, size.width, size.height)
#define CNLogPoint(format, point) NSLog(@"Line %d] %s x:%.4f, y:%.4f", __LINE__, __PRETTY_FUNCTION__, point.x, point.y)
#else
#define CNLog(format, ...)
#endif


FOUNDATION_EXPORT NSString *const RAMCollectionViewFlemishBondHeaderKind;
FOUNDATION_EXPORT NSString *const RAMCollectionViewFlemishBondFooterKind;

@class CustomLayCollectionOut;

@protocol CustomLayCollectionOutDelegate <NSObject>
@required
//获取大View的高度
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(CustomLayCollectionOut *)collectionViewLayout estimatedHeightForUpCellInSection:(NSInteger)section;
//获取小View的高度
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(CustomLayCollectionOut *)collectionViewLayout estimatedHeightForDownCellInSection:(NSInteger)section;
//获取一行可以放几个小View
- (NSUInteger)collectionView:(UICollectionView *)collectionView layout:(CustomLayCollectionOut *)collectionViewLayout estimatedCellCountForRowInSection:(NSInteger)section;

@optional
//获取SectionFooter的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(CustomLayCollectionOut *)collectionViewLayout estimatedSizeForHeaderInSection:(NSInteger)section;
//获取SectionHeader的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(CustomLayCollectionOut *)collectionViewLayout estimatedSizeForFooterInSection:(NSInteger)section;
@end

@interface CustomLayCollectionOut : UICollectionViewLayout

@property (nonatomic, weak) id<CustomLayCollectionOutDelegate> delegate;

@end

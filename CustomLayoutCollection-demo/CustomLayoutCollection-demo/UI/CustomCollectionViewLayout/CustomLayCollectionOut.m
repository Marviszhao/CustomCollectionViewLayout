//
//  CustomLayCollectionOut.m
//  CustomLayoutCollection-demo
//
//  Created by MARVIS on 15/11/6.
//  Copyright © 2015年 www.uluk.com. All rights reserved.
//

#import "CustomLayCollectionOut.h"
static NSString *const RAMCollectionViewFlemishBondCellKind = @"RAMCollectionViewFlemishBondCellKind";
NSString *const RAMCollectionViewFlemishBondHeaderKind = @"RAMCollectionViewFlemishBondHeaderKind";
NSString *const RAMCollectionViewFlemishBondFooterKind = @"RAMCollectionViewFlemishBondFooterKind";

@interface CustomLayCollectionOut ()

@property (nonatomic, strong) NSDictionary *cellLayoutInfo;
@property (nonatomic, strong) NSDictionary *headerLayoutInfo;
@property (nonatomic, strong) NSDictionary *footerLayoutInfo;
@property (nonatomic, strong) NSMutableDictionary *headerSizes;
@property (nonatomic, strong) NSMutableDictionary *footerSizes;
@property (nonatomic, readonly) CGFloat totalHeaderHeight;
@property (nonatomic, readonly) CGFloat totalFooterHeight;

@end

@implementation CustomLayCollectionOut

#pragma mark - Lifecycle
- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}

#pragma mark - Custom Getter
- (NSInteger)numberOfSections
{
    return [self.collectionView numberOfSections];
}



#pragma mark - Setup
- (void)setup
{
    // Default values setting
    
}

- (void)validateData{
    
}

#pragma mark - UICollectionViewLayout
+ (Class)layoutAttributesClass
{
    return [CustomLayoutAttributes class];
}

- (void)prepareLayout
{
    NSMutableDictionary *newLayoutDictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutDictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *headerLayoutDictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *footerLayoutDictionary = [NSMutableDictionary dictionary];
    
    self.headerSizes = [NSMutableDictionary dictionary];
    self.footerSizes = [NSMutableDictionary dictionary];
    [self validateData];
    
    if (![self.delegate conformsToProtocol:@protocol(CustomLayCollectionOutDelegate)]) {
        //CNLog(@"self.delegate must implements CustomLayCollectionOutDelegate!");
    }
    
    for (NSInteger section = 0; section < [self numberOfSections]; section++) {
        NSInteger itemsCount = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger item = 0; item < itemsCount; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            if (indexPath.item == 0) {
                if ([self.delegate respondsToSelector:@selector(collectionView:layout:estimatedSizeForHeaderInSection:)]) {
                    CGSize size = [self.delegate collectionView:self.collectionView layout:self estimatedSizeForHeaderInSection:section];
                    self.headerSizes[indexPath] = [NSValue valueWithCGSize:size];
                    
                    UICollectionViewLayoutAttributes *headerAttributes = [UICollectionViewLayoutAttributes
                                                                          layoutAttributesForSupplementaryViewOfKind:RAMCollectionViewFlemishBondHeaderKind
                                                                          withIndexPath:indexPath];
                    headerAttributes.frame = [self frameForHeaderAtIndexPath:indexPath withSize:size];
                    
                    headerLayoutDictionary[indexPath] = headerAttributes;
                }
            } else if([self isTheLastItemAtIndexPath:indexPath]) {
                if ([self.delegate respondsToSelector:@selector(collectionView:layout:estimatedSizeForFooterInSection:)]) {
                    CGSize size = [self.delegate collectionView:self.collectionView layout:self estimatedSizeForFooterInSection:section];
                    self.footerSizes[indexPath] = [NSValue valueWithCGSize:size];
                    
                    UICollectionViewLayoutAttributes *footerAttributes = [UICollectionViewLayoutAttributes
                                                                          layoutAttributesForSupplementaryViewOfKind:RAMCollectionViewFlemishBondFooterKind
                                                                          withIndexPath:indexPath];
                    footerAttributes.frame = [self frameForFooterAtIndexPath:indexPath withSize:size];
                    
                    footerLayoutDictionary[indexPath] = footerAttributes;
                }
            }
            
            CustomLayoutAttributes *layoutAttributes = [CustomLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            layoutAttributes.frame = [self frameForCellAtIndexPath:indexPath];
            
            cellLayoutDictionary[indexPath] = layoutAttributes;
        }
    }
    
    newLayoutDictionary[RAMCollectionViewFlemishBondCellKind] = cellLayoutDictionary;
    newLayoutDictionary[RAMCollectionViewFlemishBondHeaderKind] = headerLayoutDictionary;
    newLayoutDictionary[RAMCollectionViewFlemishBondFooterKind] = footerLayoutDictionary;
    
    self.cellLayoutInfo = newLayoutDictionary;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.cellLayoutInfo.count];
    
    [self.cellLayoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier,
                                                         NSDictionary *elementsInfo,
                                                         BOOL *stop) {
        [elementsInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                                          UICollectionViewLayoutAttributes *attributes,
                                                          BOOL *innerStop) {
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [allAttributes addObject:attributes];
            }
        }];
    }];
    
    return allAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellLayoutInfo[RAMCollectionViewFlemishBondCellKind][indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return self.cellLayoutInfo[kind][indexPath];
}

- (CGSize)collectionViewContentSize
{
//    1 获取indexPath.section之前所有的高度。
    NSInteger sections = [self.collectionView numberOfSections] - 1;
    NSInteger items = [self.collectionView numberOfItemsInSection:sections ];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:items inSection:sections];
    CGRect frame = [self frameForFooterAtIndexPath:indexPath withSize:CGSizeZero];
//    2 + indexPath.section之前最后一个section的footer的高度。
    if (indexPath.section > 0) {
        frame.origin.y += [_delegate collectionView:self.collectionView layout:self estimatedSizeForFooterInSection:indexPath.section - 1].height;
    }
    return CGSizeMake(self.collectionView.bounds.size.width, frame.origin.y);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}



#pragma mark - Private Methods
- (CGRect)frameForCellAtIndexPath:(NSIndexPath *)indexPath
{
    //    1 获取indexPath.section之前所有的高度。
    CGRect frame = CGRectZero;
    if (indexPath.section != 0) {//不是第一个section
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1];
        //    1.1  先获取section之前一个section的footer的frame
        frame = [self frameForFooterAtIndexPath:newIndexPath withSize:CGSizeZero];
        //    1.2  加上当前的footer的高度
        frame.origin.y += [_delegate collectionView:self.collectionView layout:self estimatedSizeForFooterInSection:newIndexPath.section ].height;
    }
    
    //    2  加上当前section的header的高度
    frame.origin.y += [_delegate collectionView:self.collectionView layout:self estimatedSizeForHeaderInSection:indexPath.section ].height;

    
//    3 计算当前的位置frame信息
    NSUInteger section = indexPath.section;
    CGFloat upCellHeight = [_delegate collectionView:self.collectionView layout:self estimatedHeightForUpCellInSection:section];
//    4 判断是upCell 处理
    if ([self isUpCellAtIndexPath:indexPath]) {
        frame.size = CGSizeMake(CGRectGetWidth(self.collectionView.frame), upCellHeight);
        return frame;
    }
    
//    5 判断不是upCell 处理
    NSUInteger row = indexPath.row;//本来就减去过1了，不用再减直接是从零开始的
    NSUInteger rowitemCount  = [_delegate collectionView:self.collectionView layout:self estimatedCellCountForRowInSection:section];
    CGFloat downCellHeight = [_delegate collectionView:self.collectionView layout:self estimatedHeightForDownCellInSection:section];
    
//    6 计算row location
    NSInteger resultValue = row  / rowitemCount;
    NSUInteger mod = row  % rowitemCount;
    
    if (mod == 0 && resultValue > 0 ) {
        mod = rowitemCount - 1; resultValue -= 1;
    } else if (mod == 0 && resultValue == 0 ) {
//        不处理
    }else if (mod > 0 && resultValue > 0 ) {
        mod -= 1;
    }else if (mod > 0 && resultValue == 0 ) {
        mod -= 1;
    }
    
    
    
    
    CGFloat cell_width = CGRectGetWidth(self.collectionView.frame)/rowitemCount;
    CGFloat x_position = mod * cell_width;
    CGFloat y_position = upCellHeight + resultValue * downCellHeight;
    //CNLog(@"Cell----cell的x_position--->>%.2f,\ncell的y_position--->>.2%f,\nindexPath--->>%@",x_position,y_position,indexPath);
    frame.origin.x = x_position;
    frame.origin.y += y_position;
    frame.size = CGSizeMake(cell_width, downCellHeight);
    //CNLog(@"Cell----frame--->>%@",NSStringFromCGRect(frame));
    return frame;
}

- (CGRect)frameForHeaderAtIndexPath:(NSIndexPath *)indexPath withSize:(CGSize)size
{
    CGRect frame = CGRectZero;
    NSInteger sectionCount = 0;
    if (indexPath.section >= 0) {
        sectionCount = indexPath.section;
    } else {
        return frame;
    }
    CGFloat supplementaryView_header_height = 0;//indexPath.section之前各区头部的总高度
    for (NSUInteger section = 0; section < sectionCount; section++) {
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:estimatedSizeForHeaderInSection:)]) {
            supplementaryView_header_height += [_delegate collectionView:self.collectionView layout:self estimatedSizeForHeaderInSection:section].height;
        }
    }
    
    CGFloat cell_Height = 0;//indexPath.section之前各区cell的总高度
    for (NSUInteger section = 0; section < sectionCount; section++) {
        NSUInteger itemsCount = [self.collectionView numberOfItemsInSection:section];
        NSUInteger rowitemCount  = [_delegate collectionView:self.collectionView layout:self estimatedCellCountForRowInSection:section];
        CGFloat upCellHeight = [_delegate collectionView:self.collectionView layout:self estimatedHeightForUpCellInSection:section];
        CGFloat downCellHeight = [_delegate collectionView:self.collectionView layout:self estimatedHeightForDownCellInSection:section];
        
        NSInteger resultValue = (itemsCount - 1) / rowitemCount;
        NSUInteger mod = (itemsCount - 1) % rowitemCount;
        if (mod > 0) {
            resultValue += 1;
        }
        
        CGFloat sectionItemHeight = upCellHeight + resultValue * downCellHeight;
        cell_Height += sectionItemHeight;
    }
    
    CGFloat supplementaryView_footer_height = 0;//indexPath.section之前各区尾部的总高度
    for (NSUInteger section = 0; section < sectionCount; section++) {
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:estimatedSizeForFooterInSection:)]) {
            supplementaryView_footer_height += [_delegate collectionView:self.collectionView layout:self estimatedSizeForFooterInSection:section].height;
        }
    }
    
    CGFloat y_position = supplementaryView_header_height + cell_Height + supplementaryView_footer_height;
    //CNLog(@"Header----头部总高度--->>%.2f,\ncell总高度--->>.2%f,\n尾部总高度--->>.2%f,\nindexPath--->>%@",supplementaryView_header_height,cell_Height,supplementaryView_footer_height,indexPath);
    frame.origin.y = y_position;
    frame.size = size;
    //CNLog(@"Header----frame--->>%@",NSStringFromCGRect(frame));
    return frame;
}

- (CGRect)frameForFooterAtIndexPath:(NSIndexPath *)indexPath withSize:(CGSize)size
{
    CGRect frame = CGRectZero;
    NSInteger sectionCount = 0;
    if (indexPath.section >= 0) {
        sectionCount = indexPath.section;
    } else {
        return frame;
    }
    CGFloat supplementaryView_header_height = 0;//indexPath.section之前各区头部的总高度,多加了个=表示也计算本区的header的高度
    for (NSUInteger section = 0; section <= sectionCount; section++) {
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:estimatedSizeForHeaderInSection:)]) {
            supplementaryView_header_height += [_delegate collectionView:self.collectionView layout:self estimatedSizeForHeaderInSection:section].height;
        }
    }
    
    CGFloat cell_Height = 0;//indexPath.section之前各区cell的总高度,多加了个=表示也计算本区的所有cell的高度
    for (NSUInteger section = 0; section <= sectionCount; section++) {
        NSUInteger itemsCount = [self.collectionView numberOfItemsInSection:section];
        NSUInteger rowitemCount  = [_delegate collectionView:self.collectionView layout:self estimatedCellCountForRowInSection:section];
        CGFloat upCellHeight = [_delegate collectionView:self.collectionView layout:self estimatedHeightForUpCellInSection:section];
        CGFloat downCellHeight = [_delegate collectionView:self.collectionView layout:self estimatedHeightForDownCellInSection:section];
        
        NSInteger resultValue = (itemsCount - 1) / rowitemCount;
        NSUInteger mod = (itemsCount - 1) % rowitemCount;
        if (mod > 0) {
            resultValue += 1;
        }
        
        CGFloat sectionItemHeight = upCellHeight + resultValue * downCellHeight;
        cell_Height += sectionItemHeight;
    }
    
    CGFloat supplementaryView_footer_height = 0;//indexPath.section之前各区尾部的总高度
    for (NSUInteger section = 0; section < sectionCount; section++) {
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:estimatedSizeForFooterInSection:)]) {
            supplementaryView_footer_height += [_delegate collectionView:self.collectionView layout:self estimatedSizeForFooterInSection:section].height;
        }
    }
    CGFloat y_position = supplementaryView_header_height + cell_Height + supplementaryView_footer_height;
    //CNLog(@"Footer----头部总高度--->>%.2f,\ncell总高度--->>.2%f,\n尾部总高度--->>.2%f",supplementaryView_header_height,cell_Height,supplementaryView_footer_height);
    frame.origin.y = y_position;
    frame.size = size;
    //CNLog(@"Footer----frame--->>%@",NSStringFromCGRect(frame));
    return frame;
}

//判断是不是顶部的cell；
- (BOOL)isUpCellAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return YES;
    }
    return NO;
}

//判断当前的indexPath是否是section中的最后一个cell
- (BOOL)isTheLastItemAtIndexPath:(NSIndexPath *)indexPath
{
    if((indexPath.row + 1) == [self.collectionView numberOfItemsInSection:indexPath.section]) {
        return YES;
    }
    
    return NO;
}









@end

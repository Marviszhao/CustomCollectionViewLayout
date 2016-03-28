//
//  RAMCollectionViewCell.m
//  RAMCollectionViewFlemishBondLayoutDemo
//
//  Created by Rafael Aguilar Martín on 20/10/13.
//  Copyright (c) 2013 Rafael Aguilar Martín. All rights reserved.
//

#import "RAMCollectionViewCell.h"
#import "UIColor+additions.h"


@interface RAMCollectionViewCell ()
    @property (nonatomic, strong) UILabel *label;
@end

@implementation RAMCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - Setup
- (void)setup
{
    [self setupView];
    [self setupLabel];
}

- (void)setupView
{
    self.backgroundColor = [UIColor randomColor];
}

- (void)setupLabel
{
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    
    [self addSubview:self.label];
}

#pragma mark - Configure
- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
{
    self.label.text = [NSString stringWithFormat:@"Cell %ld", (long)(indexPath.row)];
}

@end

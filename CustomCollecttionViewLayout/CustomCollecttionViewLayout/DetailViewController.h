//
//  DetailViewController.h
//  CustomCollecttionViewLayout
//
//  Created by imac on 16/3/25.
//  Copyright © 2016年 suishouji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end


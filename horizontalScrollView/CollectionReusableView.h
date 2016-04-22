//
//  CollectionReusableView.h
//  horizontalScrollView
//
//  Created by YiChe on 16/4/21.
//  Copyright © 2016年 YiChe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionReusableView : UICollectionReusableView
@property(nonatomic, weak)IBOutlet UILabel *headLabel;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *labelLeft;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *headWidth;
@end

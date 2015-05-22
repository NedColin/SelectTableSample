//
//  UISelectTable.h
//  Vihome
//
//  Created by Ned on 3/6/15.
//  Copyright (c) 2015 orvibo. All rights reserved.
//

#import <UIKit/UIKit.h>



@class UISelectTable;

@protocol UISelectTableDelegate <NSObject>

- (void)didSelectIndex:(NSInteger)index selectTable:(UISelectTable *)selectTable;

@end

@interface UISelectTable : UIView

@property (nonatomic, assign)id <UISelectTableDelegate> delegate;

@property (nonatomic, assign)int                        currrentIndex;

@property (nonatomic, assign)CGFloat                    rowHeight;


- (void)setSelectIndex:(NSInteger)index;

- (void)loadData:(NSArray *)data;



@end

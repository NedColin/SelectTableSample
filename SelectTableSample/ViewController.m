//
//  ViewController.m
//  SelectTableSample
//
//  Created by Ned on 5/22/15.
//  Copyright (c) 2015 orvibo. All rights reserved.
//

#import "ViewController.h"
#import "UISelectTable.h"

@interface ViewController ()
{
    UISelectTable *_minuteTable;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat Xpadding = 50;
    CGFloat Ypadding = 50;
    CGFloat tableWidth = 100;
    CGFloat tableHeight = 150;
    _minuteTable = [[UISelectTable alloc] initWithFrame:CGRectMake( (screenWidth - tableWidth) / 2.0, Ypadding, tableWidth, tableHeight)];
    _minuteTable.delegate = self;
    _minuteTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_minuteTable];
    
    [_minuteTable loadData:[self getIndexStringArrayWithEndNumber:60]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSArray *)getIndexStringArrayWithEndNumber:(NSInteger )endNumber
{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for (int i = 0; i < endNumber; i ++) {
        if (endNumber == 60) {
            [array addObject:[NSString stringWithFormat:@"%02d", i]];
        }else{
            [array addObject:[NSString stringWithFormat:@"%d", i]];
        }
        
    }
    return array;
}

@end

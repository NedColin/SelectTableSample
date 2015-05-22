//
//  UISelectTable.m
//  Vihome
//
//  Created by Ned on 3/6/15.
//  Copyright (c) 2015 orvibo. All rights reserved.
//

#import "UISelectTable.h"

#define RGBA(r, g, b, a)                    [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:a]



@interface UIMagnifyingView : UIView

@property (nonatomic, retain)UIView *magifyView;

@end

@implementation UIMagnifyingView

- (void)drawRect:(CGRect)rect {
    UISelectTable * selectView = (UISelectTable *)self.superview;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 10, -selectView.rowHeight * 2 );
    CGContextScaleCTM(context, 1.0, 1.0);
    CGContextTranslateCTM(context, -10, 0);
    [self.superview.layer renderInContext:context];
}

@end

@interface UISelectTable()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation UISelectTable
{
    UITableView *           _table;
    
    NSMutableArray *        _dataArray;
    
    
    NSInteger               _selectIndex;
    
    UIMagnifyingView        *_magnifyView;
    
}

@synthesize rowHeight;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViewsWithFrame:frame];
    }
    return self;
}

- (void)initSubViewsWithFrame:(CGRect)frame
{
    rowHeight = frame.size.height / 5;
    
    _table = [[UITableView alloc] init];
    _table.delegate = self;
    _table.dataSource = self;
    _table.backgroundColor = [UIColor clearColor];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.showsVerticalScrollIndicator = NO;
    _table.showsHorizontalScrollIndicator = NO;
    _table.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    [self addSubview:_table];
    
    _dataArray = [[NSMutableArray alloc] init];
    
    CAGradientLayer * upMaskLayer = [[CAGradientLayer alloc] init];
    upMaskLayer.frame = CGRectMake(0, 0, frame.size.width, rowHeight*2.0);
    [self.layer addSublayer:upMaskLayer];
    upMaskLayer.backgroundColor = [UIColor clearColor].CGColor;
    upMaskLayer.colors = [NSArray arrayWithObjects:RGBA(255, 255, 255, 0.8).CGColor,RGBA(255, 255, 255, 0.3).CGColor, nil];
    upMaskLayer.locations = [NSArray arrayWithObjects:
                       [NSNumber numberWithFloat:0.0],
                       [NSNumber numberWithFloat:1.5],
                       nil];
				upMaskLayer.startPoint = CGPointMake(0.0, 0.0);
				upMaskLayer.endPoint = CGPointMake(0.0, 1.0);
    
    
    CAGradientLayer * downMaskLayer = [[CAGradientLayer alloc] init];
    downMaskLayer.frame = CGRectMake(0, frame.size.height - rowHeight * 2.0, frame.size.width, rowHeight*2.0);
    [self.layer addSublayer:downMaskLayer];
    downMaskLayer.backgroundColor = [UIColor clearColor].CGColor;
    downMaskLayer.colors = [NSArray arrayWithObjects:RGBA(255, 255, 255, 0.3).CGColor,RGBA(255, 255, 255, 0.8).CGColor, nil];
    downMaskLayer.locations = [NSArray arrayWithObjects:
                             [NSNumber numberWithFloat:0.0],
                             [NSNumber numberWithFloat:1.5],
                             nil];
				downMaskLayer.startPoint = CGPointMake(0.0, 0.0);
				downMaskLayer.endPoint = CGPointMake(0.0, 1.0);

    _magnifyView = [[UIMagnifyingView alloc] initWithFrame:CGRectZero];
    _magnifyView.backgroundColor = RGBA(255, 255, 255, 1);
    _magnifyView.userInteractionEnabled = NO;
    _magnifyView.magifyView = self;
    self.clipsToBounds = NO;
    [self addSubview:_magnifyView];
    _magnifyView.center = _table.center;
    
    _magnifyView.frame = CGRectMake(0, 0, frame.size.width, rowHeight);
    _magnifyView.center = _table.center;


}

- (void)loadData:(NSArray *)data
{
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:data];
    [_table reloadData];

   [self reSetScrollView:_table reset:NO];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_magnifyView setNeedsDisplay];
    });
    

}

- (void)setSelectIndex:(NSInteger)index
{
    _selectIndex = index;
    
    if (index >= [_dataArray count] + 4) {

        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    });
   
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count] + 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * reuseIdentifier = @"reuseIdentifier";
    UITableViewCell * cell;
    cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];

    
    NSString * text = nil;
    if (indexPath.row >= 2 && indexPath.row < ([_dataArray count] + 2)) {
        if (((indexPath.row - 2) > [_dataArray count] - 1) || (indexPath.row - 2) < 0 || [_dataArray count] == 0) {
            return cell;
        }
        text = [_dataArray objectAtIndex:indexPath.row - 2];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = text;
    cell.textLabel.font = [UIFont systemFontOfSize:25];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return rowHeight;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_magnifyView setNeedsDisplay];
    [self reSetScrollView:scrollView reset:NO];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self reSetScrollView:scrollView reset:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self reSetScrollView:scrollView reset:YES];
    }
    
}

#pragma mark - reset content

- (void)reSetScrollView:(UIScrollView *)scrollView reset:(BOOL)reset
{
    UITableView * table = (UITableView *)scrollView;
    NSArray * array = [table visibleCells];
    
    for (int i = 0; i < [array count]; i++) {
        UITableViewCell * cell = [array objectAtIndex:i];
        NSIndexPath * innerIndex = [table indexPathForCell:cell];

        CGFloat markYoffset = scrollView.contentOffset.y - (innerIndex.row - 2) * rowHeight;
        CGFloat angle = markYoffset/70 * 0.8;
        CATransform3D rotateTransform = CATransform3DIdentity;
        rotateTransform.m34 = -1.0/50.0;
        rotateTransform = CATransform3DRotate(rotateTransform, angle, 1.0, 0.0, 0.0);
        
        CATransform3D scale = CATransform3DIdentity;
        CGFloat halfHight = rowHeight * 3.0;
        
        CGFloat scaleFactor = markYoffset;
        scaleFactor *= 0.5;
        
        CGFloat scaleCoefficient  = fabsf(halfHight - fabsf(scaleFactor))/(halfHight);
        scale = CATransform3DScale(scale, scaleCoefficient, scaleCoefficient, 1);
        CATransform3D concatTransform = CATransform3DConcat(rotateTransform,scale);
        cell.textLabel.layer.transform = concatTransform;

    }
    
    
    NSInteger index = scrollView.contentOffset.y / rowHeight;
    
    if ((scrollView.contentOffset.y - index * rowHeight) > (rowHeight/2)) {
        index++;
    }
    
    if (index < 0) {
        index = 0;
    }else if (index >= [_dataArray count]){
        index = [_dataArray count] - 1;
    }
    
    if (reset) {
        [scrollView setContentOffset:CGPointMake(0, rowHeight * index) animated:YES];
    }
    
    _selectIndex = index;
    
    self.currrentIndex = _selectIndex;
    if ([self.delegate respondsToSelector:@selector(didSelectIndex:selectTable:)]) {
        [self.delegate didSelectIndex:_selectIndex selectTable:self];
    }
   }


@end

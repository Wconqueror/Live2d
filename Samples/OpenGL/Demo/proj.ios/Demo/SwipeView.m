//
//  SwipeView.m
//  Demo
//
//  Created by hgf on 2018/12/5.
//  Copyright © 2018 live2d. All rights reserved.
//

#import "SwipeView.h"
#import "GXCardView/GXCardView.h"
#import "CardViewCell.h"

@interface  SwipeView ()<GXCardViewDataSource,GXCardViewDelegate,UITableViewDelegate>

@property (strong, nonatomic) GXCardView *cardView;

@end

@implementation SwipeView

-(GXCardView *)cardView{
    if (!_cardView) {
        _cardView = [[GXCardView alloc]initWithFrame:CGRectMake(20, 230, 335, 400)];
        _cardView.dataSource = self;
        _cardView.delegate = self;
        _cardView.visibleCount = 3;
        _cardView.lineSpacing = 10.0;
        _cardView.maxAngle = 15.0;
        _cardView.maxRemoveDistance = 100.0;
        [_cardView registerClass:[CardViewCell class] forCellReuseIdentifier:@"cardCell"];
    }
    return _cardView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.cardView];
//        self.vc = [[ViewController alloc]init];
        [self.cardView reloadData];
        
        
    }
    return self;
}

- (GXCardViewCell *)cardView:(GXCardView *)cardView cellForRowAtIndex:(NSInteger)index {
    CardViewCell *cell = [cardView dequeueReusableCellWithIdentifier:@"cardCell"];
    return cell;
}

- (NSInteger)numberOfCountInCardView:(UITableView *)cardView {
    return 10;
}

#pragma mark - GXCardViewDelegate
- (void)cardView:(GXCardView *)cardView didRemoveLastCell:(GXCardViewCell *)cell forRowAtIndex:(NSInteger)index{
    [cardView reloadDataAnimated:YES];
}

//- (void)cardView:(GXCardView *)cardView didRemoveCell:(GXCardViewCell *)cell forRowAtIndex:(NSInteger)index {
//    NSLog(@"didRemoveCell forRowAtIndex = %ld", index);
//}
//
//- (void)cardView:(GXCardView *)cardView didDisplayCell:(GXCardViewCell *)cell forRowAtIndex:(NSInteger)index {
//    NSLog(@"didDisplayCell forRowAtIndex = %ld", index);
//}

- (void)cardView:(GXCardView *)cardView didMoveCell:(GXCardViewCell *)cell forMovePoint:(CGPoint)point{
    //    NSLog(@"move point = %@", NSStringFromCGPoint(point));
}


//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.vc touchesBegan:touches withEvent:event];
//}
//
//-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.vc touchesEnded:touches withEvent:event];
//}
//
//-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.vc touchesMoved:touches withEvent:event];
//}

@end

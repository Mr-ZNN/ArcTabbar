//
//  MCCustomTabbar.m
//  MonitorClient_iOS
//
//  Created by Davetech on 2021/1/20.
//  Copyright © 2021 johnsoncontrols. All rights reserved.
//

#import "MCCustomTabbar.h"

#define kTopArcWidth 90
#define kTabbarItemsCount 3

@implementation MCCustomTabbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTranslucent:NO];
    }
    return self;
}
+(void)setTabBarUI:(NSArray*)views tabBar:(UITabBar*)tabBar topLineColor:(UIColor*)lineColor backgroundColor:(UIColor*)backgroundColor index:(NSInteger)index{
    [views enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
            
            UIView * topView = [obj viewWithTag:9999];
            if (topView) {
                [topView removeFromSuperview];
                topView = nil;
            }
            UIView * top = [[UIView alloc] initWithFrame:CGRectMake(0, -20, tabBar.bounds.size.width, 20)];
            top.userInteractionEnabled = NO;
            top.backgroundColor = [UIColor clearColor];
            top.tag = 9999;
            [obj addSubview:[[self class] addTopViewToParentView:top topLineColor:lineColor backgroundColor:backgroundColor index:index]];
            
        }
    }];
}
+(UIView*)addTopViewToParentView:(UIView*)parent topLineColor:(UIColor*)lineColor backgroundColor:(UIColor*)backgroundColor index:(NSInteger)index{
    ////////
    CGFloat totleWidth = parent.bounds.size.width;
    CGFloat itemWith = totleWidth/kTabbarItemsCount;
    CGFloat centerOpintX = itemWith*index+itemWith*0.5;
    float angle = atanhf((kTopArcWidth/2.0-20)/(kTopArcWidth/2.0))-M_PI/360*4;
    //
    UIBezierPath *path = [UIBezierPath bezierPath];
    //
    CGPoint p0 = CGPointMake(0.0, 20);
    CGPoint p1 = CGPointMake(centerOpintX - kTopArcWidth/2.0, 20);
    CGPoint centerPoint = CGPointMake(centerOpintX, kTopArcWidth/2.0);
    CGPoint p2 = CGPointMake(centerOpintX + kTopArcWidth/2.0, 20);
    CGPoint p3 = CGPointMake(parent.bounds.size.width, 20);

    [path moveToPoint:p0];
    [path addLineToPoint:p1];
    [path addArcWithCenter:centerPoint radius:kTopArcWidth/2.0 startAngle:M_PI+angle endAngle:M_PI*2-angle clockwise:YES];
    [path addLineToPoint:p2];
    [path addLineToPoint:p3];
    //
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    shapeLayer.frame = CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    shapeLayer.lineWidth = 0.5;
    shapeLayer.lineCap = @"round";
    shapeLayer.strokeColor = [lineColor CGColor];
    shapeLayer.fillColor = [backgroundColor CGColor];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeStart = 0.0;
    shapeLayer.strokeEnd = 1.0;
    [parent.layer addSublayer:shapeLayer];
    parent.userInteractionEnabled = NO;
    return parent;
}

@end

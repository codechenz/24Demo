//
//  ZCCycleView.m
//  24EditorDemo
//
//  Created by zhuchen on 2017/12/6.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "ZCCycleView.h"
#import "UIView+ZCCate.h"

@implementation ZCCycleView

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();//获取上下文
    
    CGPoint center = self.center;  //设置圆心位置
    CGFloat radius = self.width / 2;  //设置半径
    CGFloat startA = - M_PI_2;  //圆起点位置
    CGFloat endA = -M_PI_2 + M_PI * 2 * _progress;  //圆终点位置
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    
    CGContextSetLineWidth(ctx, 5); //设置线条宽度
    [[UIColor greenColor] setStroke]; //设置描边颜色
    
    CGContextAddPath(ctx, path.CGPath); //把路径添加到上下文
    
    CGContextStrokePath(ctx);  //渲染
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

@end

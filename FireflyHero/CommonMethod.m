//
//  CommonMethod.m
//  FireflyHero
//
//  Created by lihua liu on 12-9-14.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import "CommonMethod.h"

@implementation CommonMethod

//根据两个点计算角度  -- 主要用于  萤火虫和蜘蛛的 转向  
+ (float)getAngleWithPoint1:(CGPoint) point1 point2:(CGPoint)point2
{
    float deltaX =  point2.x - point1.x;
    float deltaY =  point2.y - point1.y;
    
    float angle = atanf(deltaX/deltaY)*180/M_PI; 
    angle = deltaY>0?angle-180:angle;
    if (deltaX<=0 && deltaY == 0) {
        angle = 90;
    }else if (deltaX>=0 && deltaY == 0) {
        angle = -90;
    }    
    return angle;
}

//求 经过 p3 且垂直于 line（经过p1、p2的直线 ）的直线 与line的交点  
//直线垂直的原理:
//line      : Ax +By +C = 0;
//line的垂线 : Bx -Ay +M = 0;
+ (CGPoint)getCrossPoint:(CGPoint) p1:(CGPoint) p2:(CGPoint) p3
{
    if (p1.x-p2.x>-0.000001 && p1.x-p2.x<0.000001) {
        return CGPointMake(p1.x, p3.y);
    }
    if (p1.y-p2.y>-0.000001 && p1.y-p2.y<0.000001) {
        return CGPointMake(p3.x, p1.y);
    }
    float A = (p1.x - p2.x)/(p1.y-p2.y);
    float B = -1;
    float C = p1.y- A*p1.x;
    float M = A*p3.y-B*p3.x;
    //交点
    float x = -(C*A+B*M)/(A*A+B*B);
    float y = (M*A-C*B)/(A*A+B*B);
    return CGPointMake(x, y);
}

@end

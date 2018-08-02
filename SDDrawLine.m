//
//  SDDrawLine.m
//  freeStuff
//
//  Created by 孙号斌 on 2017/11/23.
//  Copyright © 2017年 孙号斌. All rights reserved.
//

#import "SDDrawLine.h"

@implementation SDDrawLine
+ (CATransition *)layerAnimationWithType:(NSString *)type
                                 subtype:(NSString *)subtype
                                duration:(NSInteger)duration
{
    CATransition *animation = [CATransition animation];
    animation.type = type;          //@"rippleEffect"
    animation.subtype = subtype;//`fromLeft', `fromRight', `fromTop' `fromBottom'.
    animation.duration = duration;
    
    return animation;
}


//画虚线
+ (CAShapeLayer *)drawDashLine:(UIView *)superView
                     lineWidth:(CGFloat)lineWidth
                     lineColor:(UIColor *)lineColor
                  lineProperty:(NSArray *)lineProperty
                    startPoint:(CGPoint)startPoint
                      endPoint:(CGPoint)endPoint
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = superView.bounds;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = lineWidth;                       //虚线宽度
    shapeLayer.strokeColor = lineColor.CGColor;             //虚线颜色
    shapeLayer.lineJoin = kCALineCapRound;
    shapeLayer.lineDashPattern = lineProperty;              //@[@6,@3]  6表示线宽，3表示线间隔
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
    CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);
    
    shapeLayer.path = path;
    CGPathRelease(path);
    
    [superView.layer addSublayer:shapeLayer];
    return shapeLayer;
}
//画实线
+ (CAShapeLayer *)drawLine:(UIView *)superView
                 lineWidth:(CGFloat)lineWidth
                 lineColor:(UIColor *)lineColor
                startPoint:(CGPoint)startPoint
               interPoints:(NSArray *)interPoints
                  endPoint:(CGPoint)endPoint
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    for (NSValue *pointValue in interPoints)
    {
        [path addLineToPoint:pointValue.CGPointValue];
    }
    [path addLineToPoint:endPoint];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = superView.bounds;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = lineWidth;                       //虚线宽度
    shapeLayer.strokeColor = lineColor.CGColor;             //虚线颜色
    shapeLayer.lineJoin = kCALineJoinBevel;
    shapeLayer.path = path.CGPath;
    
    [superView.layer addSublayer:shapeLayer];
    return shapeLayer;
}
//画文字
+ (CATextLayer *)drawText:(UIView *)superView
                    frame:(CGRect)frame
                     text:(NSString *)text
                textColor:(UIColor *)textColor
                     font:(UIFont *)font
{
    return [self drawText:superView
                    frame:frame
            alignmentMode:kCAAlignmentCenter
                     text:text
                textColor:textColor
                     font:font];
}
+ (CATextLayer *)drawText:(UIView *)superView
                    frame:(CGRect)frame
            alignmentMode:(NSString *)alignmentMode
                     text:(NSString *)text
                textColor:(UIColor *)textColor
                     font:(UIFont *)font
{
    CATextLayer *textLayer = [[CATextLayer alloc] init];
    [textLayer setFrame:frame];
    [textLayer setAlignmentMode:alignmentMode];
    [textLayer setForegroundColor:[textColor CGColor]];
    [textLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    [textLayer setContentsScale:[UIScreen mainScreen].scale];
    //        [textLayer setTruncationMode:kCATruncationEnd];                 //如何将字符串截断以适应图层大小
    
    
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    
    [textLayer setString:text];
    
    [superView.layer addSublayer:textLayer];
    return textLayer;
}






/*
 周边加阴影，并且同时圆角
 */
+ (void)addShadowToView:(UIView *)view
            shadowColor:(UIColor *)color
          shadowOpacity:(float)opacity
           shadowRadius:(CGFloat)radius
           shadowOffset:(CGSize)offSize
           cornerRadius:(CGFloat)cornerRadius
{
    //////// shadow /////////
    CALayer *shadowLayer = [CALayer layer];
    shadowLayer.frame = view.layer.frame;
    
    shadowLayer.shadowColor = color.CGColor;//shadowColor阴影颜色
    shadowLayer.shadowOffset = offSize;//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    shadowLayer.shadowOpacity = opacity;//0.8;//阴影透明度，默认0
    shadowLayer.shadowRadius = radius;//8;//阴影半径，默认3
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = shadowLayer.bounds.size.width;
    float height = shadowLayer.bounds.size.height;
    float x = shadowLayer.bounds.origin.x;
    float y = shadowLayer.bounds.origin.y;
    
    CGPoint topLeft      = shadowLayer.bounds.origin;
    CGPoint topRight     = CGPointMake(x + width, y);
    CGPoint bottomRight  = CGPointMake(x + width, y + height);
    CGPoint bottomLeft   = CGPointMake(x, y + height);
    
    CGFloat offset = -1.f;
    [path moveToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    [path addArcWithCenter:CGPointMake(topLeft.x + cornerRadius, topLeft.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI endAngle:M_PI_2 * 3 clockwise:YES];
    [path addLineToPoint:CGPointMake(topRight.x - cornerRadius, topRight.y - offset)];
    [path addArcWithCenter:CGPointMake(topRight.x - cornerRadius, topRight.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 * 3 endAngle:M_PI * 2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomRight.x + offset, bottomRight.y - cornerRadius)];
    [path addArcWithCenter:CGPointMake(bottomRight.x - cornerRadius, bottomRight.y - cornerRadius) radius:(cornerRadius + offset) startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y + offset)];
    [path addArcWithCenter:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y - cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    
    //设置阴影路径
    shadowLayer.shadowPath = path.CGPath;
    
    //////// cornerRadius /////////
    view.layer.cornerRadius = cornerRadius;
    view.layer.masksToBounds = YES;
    view.layer.shouldRasterize = YES;
    view.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [view.superview.layer insertSublayer:shadowLayer below:view.layer];
}


//加渐变
+ (void)addGradientLayerTo:(UIView *)view
                    colors:(NSArray *)colors
                 locations:(NSArray *)locations
                startPoint:(CGPoint)startPoint
                  endPoint:(CGPoint)endPoint
              cornerRadius:(CGFloat)cornerRadius
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = colors;
    gradientLayer.locations = locations;
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    gradientLayer.frame = view.bounds;
    gradientLayer.cornerRadius = cornerRadius;
    [view.layer addSublayer:gradientLayer];
}




@end

//
//  SDDrawLine.h
//  freeStuff
//
//  Created by 孙号斌 on 2017/11/23.
//  Copyright © 2017年 孙号斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDDrawLine : NSObject
/**
 *  返回一个layer动画
 *
 *  @param type     动画的类型   fade    moveIn  push    reveal  cube(立方)    rippleEffect(波纹)    suckEffect(吸; 吮)
 oglFlip(弹，掷)   pageCurl    pageUnCurl  cameraIrisHollowOpen    cameraIrisHollowClose等
 *  @param subtype  方向的类型。  fromLeft, fromRight, fromTop, fromBottom
 *  @param duration 动画时长
 *  @return CATransition对象
 */
+ (CATransition *)layerAnimationWithType:(NSString *)type
                                 subtype:(NSString *)subtype
                                duration:(NSInteger)duration;

//画虚线
+ (CAShapeLayer *)drawDashLine:(UIView *)superView
                     lineWidth:(CGFloat)lineWidth
                     lineColor:(UIColor *)lineColor
                  lineProperty:(NSArray *)lineProperty
                    startPoint:(CGPoint)startPoint
                      endPoint:(CGPoint)endPoint;
//画实线
+ (CAShapeLayer *)drawLine:(UIView *)superView
                 lineWidth:(CGFloat)lineWidth
                 lineColor:(UIColor *)lineColor
                startPoint:(CGPoint)startPoint
               interPoints:(NSArray *)interPoints
                  endPoint:(CGPoint)endPoint;
//画文字
+ (CATextLayer *)drawText:(UIView *)superView
                    frame:(CGRect)frame
                     text:(NSString *)text
                textColor:(UIColor *)textColor
                     font:(UIFont *)font;
+ (CATextLayer *)drawText:(UIView *)superView
                    frame:(CGRect)frame
            alignmentMode:(NSString *)alignmentMode
                     text:(NSString *)text
                textColor:(UIColor *)textColor
                     font:(UIFont *)font;

//父类上加阴影
+ (void)addShadowToView:(UIView *)view
            shadowColor:(UIColor *)color
          shadowOpacity:(float)opacity
           shadowRadius:(CGFloat)radius
           shadowOffset:(CGSize)offSize
           cornerRadius:(CGFloat)cornerRadius;

//加渐变
+ (void)addGradientLayerTo:(UIView *)view
                    colors:(NSArray *)colors
                 locations:(NSArray *)locations
                startPoint:(CGPoint)startPoint
                  endPoint:(CGPoint)endPoint
              cornerRadius:(CGFloat)cornerRadius;
@end

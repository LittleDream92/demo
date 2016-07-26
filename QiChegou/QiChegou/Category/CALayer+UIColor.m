//
//  CALayer+UIColor.m
//  QiChegou
//
//  Created by Meng Fan on 16/7/22.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "CALayer+UIColor.h"

@implementation CALayer (UIColor)

- (void)setBorderUIColor:(UIColor*)color {
    self.borderColor = color.CGColor;
}

- (UIColor*)borderUIColor {
    return [UIColor colorWithCGColor:self.borderColor];
}

/*
 .h
 //@property (nonatomic, strong) UIColor *borderColorFromUIColor;
 //- (void)setBorderColorFromUI:(UIColor *)color;
 @property(nonatomic, assign) UIColor* borderUIColor;
 ...
 .m
 //#import <objc/runtime.h>
 
 @Implementation CALayer (LKExtension)
 //- (void)setBorderColorFromUI:(UIColor *)color {
 // self.borderColor = color.CGColor;
 //}
 //
 //- (UIColor *)borderColorFromUIColor {
 // return objc_getAssociatedObject(self, @selector(borderColorFromUIColor));
 //}
 //
 //- (void)setBorderColorFromUIColor:(UIColor *)color {
 // objc_setAssociatedObject(self, @selector(borderColorFromUIColor), color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
 // [self setBorderColorFromUI:self.borderColorFromUIColor];
 //}
 - (void)setBorderUIColor:(UIColor*)color {
 self.borderColor = color.CGColor;
 }
 
 - (UIColor*)borderUIColor {
 return [UIColor colorWithCGColor:self.borderColor];
 }
 
 一共两种方法，上面注释掉的是使用运行时解决的，需要添加头文件。没注释的就是使用属性添加的。
 */

@end

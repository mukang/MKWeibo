//
//  UIView+MK.m
//  QQ空间HD
//
//  Created by 穆康 on 15/2/4.
//  Copyright (c) 2015年 穆康. All rights reserved.
//

#import "UIView+MK.h"

@implementation UIView (MK)


- (void)setX:(CGFloat)x {
    
    CGRect tempFrame = self.frame;
    tempFrame.origin.x = x;
    self.frame = tempFrame;
}

- (CGFloat)x {
    
    return self.frame.origin.x;
}


- (void)setY:(CGFloat)y {
    
    CGRect tempFrame = self.frame;
    tempFrame.origin.y = y;
    self.frame = tempFrame;
}

- (CGFloat)y {
    
    return self.frame.origin.y;
}


- (void)setWidth:(CGFloat)width {
    
    CGRect tempFrame = self.frame;
    tempFrame.size.width = width;
    self.frame = tempFrame;
}

- (CGFloat)width {
    
    return self.frame.size.width;
}


- (void)setHeight:(CGFloat)height {
    
    CGRect tempFrame = self.frame;
    tempFrame.size.height = height;
    self.frame = tempFrame;
}

- (CGFloat)height {
    
    return self.frame.size.height;
}


@end

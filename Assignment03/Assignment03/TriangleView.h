//
//  TriangleView.h
//  Assignment03
//
//  Created by Khaled Alyousefi on 9/30/13.
//  Copyright (c) 2013 Khaled Alyousefi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Triangle.h"

@interface TriangleView : UIView

@property (nonatomic) Triangle *triangle;
@property (nonatomic) NSArray *point1;
@property (nonatomic) NSArray *point2;
@property (nonatomic) NSArray *point3;

@end
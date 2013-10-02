//
//  Circle.h
//  Assignment03
//
//  Created by Khaled Alyousefi on 10/1/13.
//  Copyright (c) 2013 Khaled Alyousefi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Circle : NSObject

@property (nonatomic) NSMutableArray *circleArray;
@property (nonatomic) NSMutableArray *rainbowArray;

- (void) drawCircle:(CGFloat)radius forCenterPoint: (CGPoint) centerPoint Width:(int) width Height:(int)height WithColor:(UIColor*) color;

-(void) shadeCircle:(NSMutableArray*) outerCircle InnerCircle:(NSMutableArray*) innerCircle;

@end

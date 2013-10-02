//
//  Circle.m
//  Assignment03
//
//  Created by Khaled Alyousefi on 10/1/13.
//  Copyright (c) 2013 Khaled Alyousefi. All rights reserved.
//

#import "Circle.h"

@implementation Circle
@synthesize circleArray,rainbowArray;

- (id)init
{
    if (self)
    {
        circleArray   = [[NSMutableArray alloc]init];
        rainbowArray   = [[NSMutableArray alloc]init];
    }
    return self;
}

//  @@@@@@ Bresenham's Implementation of Drawing a Circle @@@@@@
- (void) drawCircle:(CGFloat)radius forCenterPoint: (CGPoint) centerPoint Width:(int) width Height:(int)height WithColor:(UIColor*) color
{
    //I used the algorthim from this source: answers.com/Q/Bresenham_circle_drawing_algorithms:
    int xc = centerPoint.x;
    int yc = centerPoint.y;
    int x = 0;
    int y = radius;
    int d = 3-2*radius;
    while (x<y) {
        
        if (d<0) d = d + ( 4 * x ) + 6;
        else {
            y--;
            d = d + (( x - y ) * 4 ) + 10;
        }
        
        if ((x >= 0) && (y >= 0)){
            
            
            if ((xc+x < width) && (yc-y < height) && (yc-y >= 0))
                [circleArray addObject:[NSArray arrayWithObjects:[CIVector vectorWithX:xc+x Y:yc-y], color, nil]];
            if ((xc-x < width) && (yc-y < height) && (xc-x >= 0) && (yc-y >= 0))
                [circleArray addObject:[NSArray arrayWithObjects:[CIVector vectorWithX:xc-x Y:yc-y], color, nil]];
            if ((xc+y < width) && (yc-x < height) && (yc-x >= 0))
                [circleArray addObject:[NSArray arrayWithObjects:[CIVector vectorWithX:xc+y Y:yc-x], color, nil]];
            if ((xc-y < width) && (yc-x < height) && (xc-y >= 0) && (yc-x >= 0))
                [circleArray addObject:[NSArray arrayWithObjects:[CIVector vectorWithX:xc-y Y:yc-x], color, nil]];
            /*
             if ((xc+x < width) && (yc+y < height))
             [circleArray addObject:[NSArray arrayWithObjects:[CIVector vectorWithX:xc+x Y:yc+y], color, nil]];
             if ((xc-x < width) && (yc+y < height) && (xc-x >= 0))
             [circleArray addObject:[NSArray arrayWithObjects:[CIVector vectorWithX:xc-x Y:yc+y], color, nil]];
             if ((xc+y < width) && (yc+x < height))
             [circleArray addObject:[NSArray arrayWithObjects:[CIVector vectorWithX:xc+y Y:yc+x], color, nil]];
             if ((xc-y < width) && (yc+x < height) && (xc-y >= 0))
             [circleArray addObject:[NSArray arrayWithObjects:[CIVector vectorWithX:xc-y Y:yc+x], color, nil]];
             
             */
        }
        x++;
    }
}

- (void) drawLine:(NSArray*)startPoint EndPoint:(NSArray*)endPoint
{
    UIColor  *currentColor;
    CIVector *currentPoint;
    
    // Retrieve coordinates for startPoint & endPoint
    int x1 = [[startPoint objectAtIndex:0] CGPointValue].x, y1 = [[startPoint objectAtIndex:0] CGPointValue].y;
    int x2 = [[endPoint   objectAtIndex:0] CGPointValue].x, y2 = [[endPoint objectAtIndex:0]   CGPointValue].y;
    
    // I used the algorthim from this source: tech-algorithm.com/articles/drawing-line-using-bresenham-algorithm
    int dx = x2 - x1, dy = y2 - y1;
    
    int dx1 = 0, dy1 = 0;
    int dx2 = 0, dy2 = 0;
    
    if (dx < 0) dx1 = -1; else if (dx > 0) dx1 = 1;
    if (dy < 0) dy1 = -1; else if (dy > 0) dy1 = 1;
    if (dx < 0) dx2 = -1; else if (dx > 0) dx2 = 1;
    
    // Assume that horizontal dx is longer than vertical dy
    int longSide  = abs(dx), shortSide = abs(dy);
    
    // If not, Exchange longSide & shortSide values
    if (shortSide > longSide) {
        longSide  = abs(dy);
        shortSide = abs(dx);
        if      (dy < 0) dy2 = -1;
        else if (dy > 0) dy2 =  1;
        dx2 = 0;
    }
    
    int numerator = longSide >> 1;

    int numberOfColors = 6;
    
    int rainbowDistance = longSide/(numberOfColors);
    
    
    NSArray *rainbowColors = [NSArray arrayWithObjects:
                       @[@255,@0,@0],
                       @[@255,@127,@0],
                       @[@255,@255,@0],
                       @[@0,@255,@0],
                       @[@0,@0,@255],
                       @[@75,@0,@130],
                       @[@143,@0,@255], nil];
    
    
    for (int i=0; i<numberOfColors; i++) {
        NSArray *color1 = [rainbowColors objectAtIndex:i];
        NSArray *color2 = [rainbowColors objectAtIndex:i+1];
        
        CGFloat red =  [color1[0] floatValue],    green = [color1[1] floatValue],   blue = [color1[2] floatValue];
        CGFloat red2 = [color2[0] floatValue],   green2 = [color2[1] floatValue],  blue2 = [color2[2] floatValue];
        //NSLog(@"red=%d grren=%d blue=%d red2=%d grren2=%d blue2=%d",(int)red,(int)green,(int)blue,(int)red2,(int)green2,(int)blue2);
        // As we loop through x axis, color will be change from color1 to color2
        CGFloat redStep   = (CGFloat) (red2-red)       / rainbowDistance;
        CGFloat greenStep = (CGFloat) (green2 - green) / rainbowDistance;
        CGFloat blueStep  = (CGFloat) (blue2 - blue)   / rainbowDistance;
        
        for (int i = 0; i <= rainbowDistance; i++) {
            // Drawing starts from color1
            currentColor = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/250.0 alpha:1];
            currentPoint = [CIVector vectorWithX:x1 Y:y1];
            
            // Add this point & color to the array that hold all colord pixels in the image
            [rainbowArray addObject:[NSArray arrayWithObjects:currentPoint,currentColor, nil]];
            
            // Find next point
            numerator += shortSide;
            if (numerator > longSide) {
                numerator -= longSide;
                x1 += dx1, y1 += dy1;
            }
            else x1 += dx2, y1 += dy2;
            
            // Each iteration in this loop, color will be changed by adding a color step to color2
            // Last iteration in this loop, color = color2.
            red   += redStep;
            green += greenStep;
            blue  += blueStep;
        }
    }
}


-(void) shadeCircle:(NSMutableArray*) outerCircle InnerCircle:(NSMutableArray*) innerCircle
{
    NSArray *currentPoint, *otherPoint;
    float percentage,b;
    CIVector *outerpoint,*innerpoint;
    
    NSArray *outer = [outerCircle sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        CIVector *p1 = [obj1 objectAtIndex:0];
        CIVector *p2 = [obj2 objectAtIndex:0];
        NSNumber *v1 = [NSNumber numberWithInt:[p1 CGPointValue].x];
        NSNumber *v2 = [NSNumber numberWithInt:[p2 CGPointValue].x];
        return [v1 compare: v2];
    }];
    NSArray *inner = [innerCircle sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        CIVector *p1 = [obj1 objectAtIndex:0];
        CIVector *p2 = [obj2 objectAtIndex:0];
        NSNumber *v1 = [NSNumber numberWithInt:[p1 CGPointValue].x];
        NSNumber *v2 = [NSNumber numberWithInt:[p2 CGPointValue].x];
        return [v1 compare: v2];
    }];
    
    for (int i=0; i<[outer count]; i++) {
        currentPoint = [outer objectAtIndex:i];
        percentage = (float)i / [outer count];
        b          = percentage * [inner count];
        otherPoint = [inner objectAtIndex:(int)b];
        
        outerpoint = [currentPoint objectAtIndex:0];
        innerpoint = [otherPoint objectAtIndex:0];
        NSLog(@"Outer=%d:%d Inner=%d:%d",i,(int)outerpoint.X,(int)b,(int)innerpoint.X);
        
        [self drawLine:currentPoint EndPoint:otherPoint];
    }
}

@end

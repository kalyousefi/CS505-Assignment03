//
//  Triangle.m
//  Assignment03
//
//  Created by Khaled Alyousefi on 9/30/13.
//  Copyright (c) 2013 Khaled Alyousefi. All rights reserved.
//

#import "Triangle.h"

@implementation Triangle
@synthesize triangleOutline,triangleFill,triangleArray;

- (id)init
{
    if (self)
    {
        triangleArray   = [[NSMutableArray alloc]init];
        triangleOutline = [[NSMutableArray alloc]init];
        triangleFill    = [[NSMutableArray alloc]init];
    }
    return self;
}


- (void)drawTriangle:(NSArray*)point1 Point2: (NSArray*)point2 Point3: (NSArray*) point3
{
    // Draw the three lines of triangle
    [self drawRainbowLine:point1 EndPoint:point2];
    [self drawRainbowLine:point1 EndPoint:point3];
    [self drawRainbowLine:point2 EndPoint:point3];
    
    // Shade triangle
    [self shadeTriangle];
}

- (void)drawSquare:(NSArray*)point1 Point2: (NSArray*)point2 Point3: (NSArray*) point3 Point4: (NSArray*) point4
{
    // Draw the three lines of triangle
    [self drawRainbowLine:point1 EndPoint:point3];
    [self drawRainbowLine:point1 EndPoint:point2];
    [self drawRainbowLine:point4 EndPoint:point3];
    [self drawRainbowLine:point4 EndPoint:point2];
    
    // Shade triangle
    [self shadeTriangle];
}

- (void) drawLine:(NSArray*)startPoint EndPoint:(NSArray*)endPoint
{
    // Retrieve color components for startPoint & endPoint
    const CGFloat* color1RGB = CGColorGetComponents([[startPoint objectAtIndex:1] CGColor]);
    const CGFloat* color2RGB = CGColorGetComponents([[endPoint objectAtIndex:1] CGColor]);
    CGFloat red = color1RGB[0],   green = color1RGB[1],  blue = color1RGB[2];
    CGFloat red2 = color2RGB[0], green2 = color2RGB[1], blue2 = color2RGB[2];
    
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
    // As we loop through x axis, color will be change from color1 to color2
    CGFloat redStep   = (CGFloat) (red2-red)       / longSide;
    CGFloat greenStep = (CGFloat) (green2 - green) / longSide;
    CGFloat blueStep  = (CGFloat) (blue2 - blue)   / longSide;
    
    UIColor  *currentColor;
    CIVector *currentPoint;
    
    for (int i = 0; i <= longSide; i++) {
        // Drawing starts from color1
        currentColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
        currentPoint = [CIVector vectorWithX:x1 Y:y1];
        
        // Add this point & color to the array that hold all colord pixels in the image
        [triangleOutline addObject:[NSArray arrayWithObjects:currentPoint,currentColor, nil]];
        
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
    [triangleArray addObjectsFromArray:triangleOutline];
}

-(void) shadeTriangle
{
    CIVector *currentPoint, *otherPoint, *point1, *point2;
    UIColor *color1, *color2;
    
    for (int i=0; i<[triangleOutline count]/2; i++) {
        currentPoint = [[triangleOutline objectAtIndex:i] objectAtIndex:0];
        for (int j=0; j<[triangleOutline count]; j++) {
            otherPoint = [[triangleOutline objectAtIndex:j] objectAtIndex:0];
            if (currentPoint.X != otherPoint.X && currentPoint.Y == otherPoint.Y) {
                point1 = [CIVector vectorWithX:currentPoint.X Y:currentPoint.Y];
                point2 = [CIVector vectorWithX:otherPoint.X Y:otherPoint.Y];
                color1  = [[triangleOutline objectAtIndex:i] objectAtIndex:1];
                color2  = [[triangleOutline objectAtIndex:j] objectAtIndex:1];
                [self drawHorizontalLine:@[point1,  color1] EndPoint:@[point2,  color2]];
            }
        }
    }
    [triangleArray addObjectsFromArray:triangleFill];
}

- (void)drawHorizontalLine:(NSArray*)startPoint EndPoint:(NSArray*)endPoint
{
    // Retrieve color components for startPoint & endPoint
    const CGFloat* color1RGB = CGColorGetComponents([[startPoint objectAtIndex:1] CGColor]);
    const CGFloat* color2RGB = CGColorGetComponents([[endPoint objectAtIndex:1] CGColor]);
    CGFloat red = color1RGB[0],   green = color1RGB[1],  blue = color1RGB[2];
    CGFloat red2 = color2RGB[0], green2 = color2RGB[1], blue2 = color2RGB[2];
    
    // Retrieve coordinates for startPoint & endPoint
    int x1 = [[startPoint objectAtIndex:0] CGPointValue].x, y1 = [[startPoint objectAtIndex:0] CGPointValue].y;
    int x2 = [[endPoint   objectAtIndex:0] CGPointValue].x;
    
    int loopIteration = abs(x2-x1);
    UIColor *currentColor;
    
    // As we loop through x axis, color will be change from color1 to color2
    CGFloat redStep   = (CGFloat) (red2-red)       / loopIteration;
    CGFloat greenStep = (CGFloat) (green2 - green) / loopIteration;
    CGFloat blueStep  = (CGFloat) (blue2 - blue)   / loopIteration;
    
    for (int i=x1; i<x2; i++) {
        red   += redStep;
        green += greenStep;
        blue  += blueStep;
        currentColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
        [triangleFill addObject:[NSArray arrayWithObjects:[CIVector vectorWithX:i Y:y1], currentColor, nil]];
    }
}

- (void) drawRainbowLine:(NSArray*)startPoint EndPoint:(NSArray*)endPoint
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
            [triangleFill addObject:[NSArray arrayWithObjects:currentPoint,currentColor, nil]];
            
            // Find next point
            numerator += shortSide;
            if (numerator > rainbowDistance) {
                numerator -= rainbowDistance;
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
@end

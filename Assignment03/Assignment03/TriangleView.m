//
//  TriangleView.m
//  Assignment03
//
//  Created by Khaled Alyousefi on 9/30/13.
//  Copyright (c) 2013 Khaled Alyousefi. All rights reserved.
//

#import "TriangleView.h"
#import "Circle.h"

@implementation TriangleView
@synthesize triangle,point1,point2,point3;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        // initialize a triangle with three known points & thier colors
        triangle = [[Triangle alloc]init];
        point1 = @[[CIVector vectorWithX:50  Y:100],[UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1]];
        point2 = @[[CIVector vectorWithX:350 Y:100],[UIColor colorWithRed:0/255.0 green:255/255.0 blue:0/255.0 alpha:1]];
        point3 = @[[CIVector vectorWithX:50 Y:400], [UIColor colorWithRed:0/255.0   green:0/255.0   blue:255/255.0   alpha:1]];
    }
    return self;
}

#pragma mark Draw Curve
// &&&&&&&&&&&&&&&&&&&&& DRAW HANDLING &&&&&&&&&&&&&&&&&&&&&
- (void)drawRect:(CGRect)rect
{
    NSArray *point4 = @[[CIVector vectorWithX:350 Y:400], [UIColor colorWithRed:0/255.0   green:0/255.0   blue:255/255.0   alpha:1]];

    // Store all triangle pixels in an array
    //[triangle drawTriangle:point1 Point2:point2 Point3:point3];
    [triangle drawSquare:point1 Point2:point2 Point3:point3 Point4:point4];
    // Display the triangle on the screen
    [self drawImage:triangle.triangleFill WithSize:20];
    /*
    Circle *circle1 = [[Circle alloc] init];
    Circle *circle2 = [[Circle alloc] init];
    
    
    [circle1 drawCircle:100.0 forCenterPoint:CGPointMake(350, 400) Width:700 Height:1000 WithColor:[UIColor blueColor]];
    [circle2 drawCircle:350.0 forCenterPoint:CGPointMake(350, 400) Width:700 Height:1000 WithColor:[UIColor redColor]];
    
    [circle1 shadeCircle:circle1.circleArray InnerCircle:circle2.circleArray];
    
    NSLog(@"circle1 count=%d",[circle1.circleArray count]);
    NSLog(@"circle2 count=%d",[circle2.circleArray count]);
    NSLog(@"circle1 Rainbow count=%d",[circle1.rainbowArray count]);
    
    [self drawImage:circle1.rainbowArray WithSize:30];
    
    
    
    // Create an image for a solid-shaded triangle
    [self createImageWithFileName:@"SolidColorTriangle.png" Points:triangle.triangleFill];
    
    // Remove triangle properties
    [triangle.triangleOutline removeAllObjects];
    [triangle.triangleFill    removeAllObjects];
    [triangle.triangleArray   removeAllObjects];
    
    // Draw another triangle by changing points coordinates & colors
    point1 = @[[CIVector vectorWithX:90  Y:42], [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1]];
    point2 = @[[CIVector vectorWithX:105 Y:123],[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]];
    point3 = @[[CIVector vectorWithX:175 Y:76], [UIColor colorWithRed:1/255.0   green:1/255.0   blue:1/255.0   alpha:1]];
    
    // Store all triangle pixels in an array
    [triangle drawTriangle:point1 Point2:point2 Point3:point3];
    
    // Display the triangle on the screen
    [self drawImage:triangle.triangleArray WithSize:1];
    
    // Create an image for a solid-shaded triangle
    [self createImageWithFileName:@"GouraudShadingTriangle.png" Points:triangle.triangleFill];
     */
}

#pragma mark Create png Files

// &&&&&&&&&& DRAWING & CREATING A PNG IMAGE FILE &&&&&&&&&&
- (void)createImageWithFileName:(NSString *) filename Points:(NSMutableArray*)imagePoints
{
    CIVector *currentPoint;
    
    CGFloat max_x=0;
    CGFloat max_y=0;
    
    // Find Max x & Max y From the points array
    for (int i=0; i<[imagePoints count]-1; i++) {
        currentPoint = [[imagePoints objectAtIndex:i] objectAtIndex:0];
        if (currentPoint.X > max_x) {
            max_x = currentPoint.X;
        }
        if (currentPoint.Y > max_y) {
            max_y = currentPoint.Y;
        }
    }
    
    // Set Width & Height to be equal to (Max x + 10) & (Max y + 10)
    // We can be sure now of taking the best Width & Height for cuuent points array
    CGFloat width  = max_x + 100;
    CGFloat height = max_y + 100;
    CGSize    size = CGSizeMake(width, height);
    
    // Creating image
    NSString *targetPath = [NSString stringWithFormat:@"/Users/khaledalyousefi/Dropbox/CSC-505/Assignments/images/%@",filename];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, width, height));
    
    // Write text:(image.info) on the image
    UIFont *font = [UIFont boldSystemFontOfSize:12];
    CGRect rect = CGRectMake(1, 1, width-4, 200);
    [[UIColor grayColor] set];
    
    // Retrieve color components for color1 & color2 & color3
    const CGFloat* color1RGB = CGColorGetComponents([[point1 objectAtIndex:1] CGColor]);
    const CGFloat* color2RGB = CGColorGetComponents([[point2 objectAtIndex:1] CGColor]);
    const CGFloat* color3RGB = CGColorGetComponents([[point3 objectAtIndex:1] CGColor]);
    CGFloat red1 = color1RGB[0]*255, green1 = color1RGB[1]*255, blue1 = color1RGB[2]*255;
    CGFloat red2 = color2RGB[0]*255, green2 = color2RGB[1]*255, blue2 = color2RGB[2]*255;
    CGFloat red3 = color3RGB[0]*255, green3 = color3RGB[1]*255, blue3 = color3RGB[2]*255;
    
    NSString *info = [NSString stringWithFormat:@"%@: %.0fpx x %.0fpx \n\n\n\n\n\n\n\n\n\n"
                      "P1= (%.0f,%.0f) RGB:(%.0f,%.0f,%.0f) \n"
                      "P2= (%.0f,%.0f) RGB:(%.0f,%.0f,%.0f) \n"
                      "P3= (%.0f,%.0f) RGB:(%.0f,%.0f,%.0f) \n",
                      filename,width,height,
                      [[point1 objectAtIndex:0] CGPointValue].x,[[point1 objectAtIndex:0] CGPointValue].y,red1,green1,blue1,
                      [[point2 objectAtIndex:0] CGPointValue].x,[[point2 objectAtIndex:0] CGPointValue].y,red2,green2,blue2,
                      [[point3 objectAtIndex:0] CGPointValue].x,[[point3 objectAtIndex:0] CGPointValue].y,red3,green3,blue3];
    
    [info drawInRect:CGRectIntegral(rect) withFont:font];
    
    UIColor *currentColor;
    // Draw the image
    for (int i=0; i<[imagePoints count]-1; i++) {
        currentPoint = [[imagePoints objectAtIndex:i] objectAtIndex:0];
        currentColor = [[imagePoints objectAtIndex:i] objectAtIndex:1];
        CGContextSetFillColorWithColor(context, [currentColor CGColor]);
        if (((currentPoint.X >= 0) && (currentPoint.X < width) && (currentPoint.Y >= 0) && (currentPoint.Y < height))) {
            CGContextFillRect(context, CGRectMake(currentPoint.X, currentPoint.Y, 1.0, 1.0));
        }
    }
    
    // Write context to uiimage
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    // Write the image to the file
    [UIImagePNGRepresentation(image) writeToFile:targetPath atomically:YES];
}

// &&&&&&&&&&&&&&&&& DRAW IMAGE ON SCREEN &&&&&&&&&&&&&&&&&
// Draw the image from the Points Array
- (void) drawImage:(NSMutableArray *) imagePoints WithSize:(int)size
{
    CIVector *currentPoint;
    UIColor  *currentColor;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
    
    for (int i=0; i< imagePoints.count; i++) {
        currentPoint = [[imagePoints objectAtIndex:i] objectAtIndex:0];
        currentColor = [[imagePoints objectAtIndex:i] objectAtIndex:1];
        if (((currentPoint.X >= 0) && (currentPoint.X < self.frame.size.width) &&
             (currentPoint.Y >= 0) && (currentPoint.Y < self.frame.size.height))) {
            CGContextSetFillColorWithColor(context, [currentColor CGColor]);
            CGContextFillEllipseInRect(context, CGRectMake(currentPoint.X, currentPoint.Y, size, size));
        }
    }
}
@end

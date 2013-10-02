//
//  Triangle.h
//  Assignment03
//
//  Created by Khaled Alyousefi on 9/30/13.
//  Copyright (c) 2013 Khaled Alyousefi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Triangle : NSObject

@property (nonatomic) NSMutableArray *triangleOutline;
@property (nonatomic) NSMutableArray *triangleFill;
@property (nonatomic) NSMutableArray *triangleArray;
- (void)drawTriangle:(NSArray*)point1 Point2: (NSArray*)point2 Point3: (NSArray*) point3;

@end
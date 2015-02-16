//
//  GRNodeScore.h
//  TexturePacker-SpriteKit
//
//  Created by GrepRuby on 08/01/15.
//  Copyright (c) 2015 CodeAndWeb. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GRNodeScore : SKLabelNode

#pragma mark - Essential and Change restricted Function
/*
 Initialization of score node.
 */

- (instancetype)initWithPosition:(CGPoint)position withLabelFont:(NSString *)fontName;

@end

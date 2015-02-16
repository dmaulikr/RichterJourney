//
//  SecondScene.h
//  ScrollingSpriteKitTutorial
//
//  Created by GrepRuby on 17/01/15.
//  Copyright (c) 2015 Arthur Knopper. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ScrollingBackground.h"
#import "RichterNode.h"
#import "BaseScene.h"

@interface SecondScene : BaseScene <scrollVwDelegate>

@property (nonatomic,strong) ScrollingBackground *scrollingBackground; // scrolling backgroung
@property (nonatomic, strong)RichterNode *hero;

@end

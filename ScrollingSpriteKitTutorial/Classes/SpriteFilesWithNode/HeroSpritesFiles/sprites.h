//
//  sprites.h
//  ScrollingSpriteKitTutorial
//
//  Created by GrepRuby on 12/01/15.
//  Copyright (c) 2015 Arthur Knopper. All rights reserved.
//
#ifndef __SPRITES_ATLAS__
#define __SPRITES_ATLAS__

    // ------------------------
    // name of the atlas bundle
    // ------------------------
#define SPRITES_ATLAS_NAME @"sprites"
#define SPRITE_WALK_01 [SKTexture textureWithImageNamed:@"walk1"]
#define SPRITE_JUMP [SKTexture textureWithImageNamed:@"jumpUp3"]
#define SPRITE_TURN_RIGHT [SKTexture textureWithImageNamed:@"turnRight"];
#define SPRITE_DIE [SKTexture textureWithImageNamed:@"jumpDown1"];

#define SPRITES_ANIM_WALK @[ \
[SKTexture textureWithImageNamed:@"walk1"], \
[SKTexture textureWithImageNamed:@"walk2"], \
[SKTexture textureWithImageNamed:@"walk3"], \
[SKTexture textureWithImageNamed:@"walk4"], \
]

#define SPRITES_ANIM_WALK_WITH_WEAPON @[ \
[SKTexture textureWithImageNamed:@"walk1"], \
[SKTexture textureWithImageNamed:@"walk2"], \
[SKTexture textureWithImageNamed:@"Shoot"], \
[SKTexture textureWithImageNamed:@"walk4"], \
]

#define SPRITES_ANIM_JUMP_DOWN @[ \
[SKTexture textureWithImageNamed:@"jumpDown1"], \
]

#define SPRITES_ANIM_JUMP_UP @[ \
[SKTexture textureWithImageNamed:@"jumpUp1"], \
]

#define SPRITES_ANIM_JUMP_UP_WITH_FIRE @[ \
[SKTexture textureWithImageNamed:@"jumpUpWithFire"], \
]

#define SPRITES_ANIM_JUMP_DOWN_WITH_FIRE @[ \
[SKTexture textureWithImageNamed:@"jumpDownWithFire"], \
]

//[SKTexture textureWithImageNamed:@"jumpUp2"], \
[SKTexture textureWithImageNamed:@"jumpUp3"], \

#define SPRITES_ANIM_JUMP_UP_DOWN @[ \
[SKTexture textureWithImageNamed:@"jumpUp2"], \
]

#define SPRITES_ANIM_TURN @[ \
[SKTexture textureWithImageNamed:@"turnRight"], \
]

#define SPRITES_ANIM_TURN_LEFT @[ \
[SKTexture textureWithImageNamed:@"turnLeft"], \
]

#define EAGLE_IMG @[ \
[SKTexture textureWithImageNamed:@"eagle1"], \
[SKTexture textureWithImageNamed:@"eagle2"], \
[SKTexture textureWithImageNamed:@"eagle3"], \
[SKTexture textureWithImageNamed:@"eagle4"], \
[SKTexture textureWithImageNamed:@"eagle5"], \
[SKTexture textureWithImageNamed:@"eagle6"], \
[SKTexture textureWithImageNamed:@"eagle7"], \
[SKTexture textureWithImageNamed:@"eagle8"], \
[SKTexture textureWithImageNamed:@"eagle9"], \
[SKTexture textureWithImageNamed:@"eagle10"], \
[SKTexture textureWithImageNamed:@"eagle11"], \
[SKTexture textureWithImageNamed:@"eagle12"], \
[SKTexture textureWithImageNamed:@"eagle13"], \
[SKTexture textureWithImageNamed:@"eagle14"], \
[SKTexture textureWithImageNamed:@"eagle15"], \
[SKTexture textureWithImageNamed:@"eagle16"], \
[SKTexture textureWithImageNamed:@"eagle17"], \
[SKTexture textureWithImageNamed:@"eagle18"], \
[SKTexture textureWithImageNamed:@"eagle19"], \
[SKTexture textureWithImageNamed:@"eagle20"], \
[SKTexture textureWithImageNamed:@"eagle21"], \
[SKTexture textureWithImageNamed:@"eagle22"], \
]

#define MONSTER1 @[\
[SKTexture textureWithImageNamed:@"Monster1"], \
[SKTexture textureWithImageNamed:@"Monster2"], \
[SKTexture textureWithImageNamed:@"Monster3"], \
[SKTexture textureWithImageNamed:@"Monster4"], \
]

#endif

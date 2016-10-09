//
//  GameScene.m
//  2048
//
//  Created by 嘉荣 张 on 2016/10/9.
//  Copyright © 2016年 Mario. All rights reserved.
//

#import "GameScene.h"


@implementation GameScene{
    BOOL _createdScene;
}

- (void)didMoveToView:(SKView *)view {
    
    if(!_createdScene){
        [self createScene];
        _createdScene = YES;
    }
    // Setup your scene here
    
    // Get label node from scene and store it for use later
}


- (void)touchDownAtPoint:(CGPoint)pos {
}

- (void)touchMovedToPoint:(CGPoint)pos {
}

- (void)touchUpAtPoint:(CGPoint)pos {
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Run 'Pulse' action from 'Actions.sks'
    NSArray<SKNode*> *nodes = [self children];
    
    NSInteger index = 1;
    for(SKNode *node in nodes){
        node.name = nil;
        if(index != nodes.count){
            [node runAction:[self transAction]];
        }else{
            [node runAction:[self transAction] completion:^{
                MainScene *mainScene = [[MainScene alloc]initWithSize:self.size];
                SKTransition *door = [SKTransition fadeWithColor:[Colors transColorWithHex:SCENE_BKG_COLOR] duration:0.25];
                [self.view presentScene:mainScene transition:door];
            }];
        }
        index++;
    }
    
    
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
}


-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}

-(void)createScene{
    
    self.backgroundColor = [Colors transColorWithHex:SCENE_BKG_COLOR];
    
    SKLabelNode *headLabel = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
    headLabel.fontSize = FONTSIZE_LG;
//    headLabel.fontColor = [Colors transColorWithHex:SCENE_BKG_COLOR_HEAD];
    headLabel.text = LABEL_HEAD;
    headLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height * 0.618);
    headLabel.name = @"headLabel";
    
    SKLabelNode *headLabelM = [[SKLabelNode alloc] initWithFontNamed:@"Avenir"];
    headLabelM.fontSize = FONTSIZE_SM;
    headLabelM.text = LABEL_HEAD_M;
    headLabelM.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height * 0.58);
    headLabel.name = @"headLabel";
//    headLabelM.fontColor = Colors transColorWithHex:SCENE
    
    SKLabelNode *headLabelW = [[SKLabelNode alloc] initWithFontNamed:@"Avenir"];
    headLabelW.fontSize = FONTSIZE_XS;
    headLabelW.text = LABEL_HEAD_W;
    headLabelW.position = CGPointMake(self.frame.size.width * 0.7, 8);
    
    [self addChild:headLabel];
    [self addChild:headLabelM];
    [self addChild:headLabelW];
    
}

-(SKAction *)transAction{
    SKAction *zoom = [SKAction scaleTo:2.0 duration:0.5];
    SKAction *pause = [SKAction waitForDuration:1];
    SKAction *fadeAway = [SKAction fadeOutWithDuration:0.5];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *sequence = [SKAction sequence:@[zoom,pause,fadeAway,remove]];
    return sequence;
}

@end

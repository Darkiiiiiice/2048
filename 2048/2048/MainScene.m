//
//  MainScene.m
//  2048
//
//  Created by 嘉荣 张 on 2016/10/9.
//  Copyright © 2016年 Mario. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene{
    BOOL _createdScene;
    
    NSInteger _width;
    NSInteger _height;
    
    NSTimeInterval lastUpdate;
}

-(void)didMoveToView:(SKView *)view{
    
    _width = self.view.frame.size.width;
    _height = self.view.frame.size.height;
    
    NSLog(@"MainScene: %ld X %ld",_width,_height);
    
    if(!_createdScene){
        [self createScene];
    }
}


-(void)createScene{
    self.backgroundColor = [Colors transColorWithHex:SCENE_BKG_COLOR];
    
    [self createHeader];
}

-(void)createHeader{
    SKSpriteNode *leftScore = [self createRectWithSize:CGSizeMake(_width * 0.4, _height * 0.1)
                                            Name:@"leftScore"
                                            Position:CGPointMake(_width * 0.1, _height * 0.8)];
    [self addChild:leftScore];
}

-(SKSpriteNode *)createRectWithSize:(CGSize)size Name:(NSString *)name Position:(CGPoint)position{
    SKSpriteNode *sprite = [[SKSpriteNode alloc]initWithColor:[Colors transColorWithHex:SCORE_BKG_COLOR] size:size];
    sprite.position = position;
    sprite.anchorPoint = CGPointZero;
    return sprite;
}


@end

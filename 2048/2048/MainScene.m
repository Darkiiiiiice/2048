//
//  MainScene.m
//  2048
//
//  Created by Mario on 2016/10/9.
//  Copyright © 2016年 Mario. All rights reserved.
//

#import "MainScene.h"

#define COUNT 4
#define ROW   4

@implementation MainScene{
    BOOL _createdScene;
    
    NSInteger _width;       //视图宽度
    NSInteger _height;      //视图高度
    
    NSInteger _drain;       //排水沟宽度
    NSInteger _mainWidth;   //棋盘宽度
    NSInteger _mainHeight;  //棋盘高度
    NSInteger _cardWidth;   //卡片宽度
    NSInteger _cardHeight;  //卡片高度
    
    NSInteger _score;       //得分
    
    NSTimeInterval lastUpdate;
    
    SKLabelNode *_leftScoreNode;    //左侧得分节点
    SKLabelNode *_rightScoreNode;   //右侧得分节点
    SKLabelNode *_highScoreNode;    //最高得分节点
    
    NSInteger _g_cards[ROW][COUNT]; //棋盘数据
}

-(void)didMoveToView:(SKView *)view{
    
    _width = self.view.frame.size.width;
    _height = self.view.frame.size.height;
    
    _drain = 6;
    _mainWidth = _width * 0.96;
    _mainHeight = _width * 1.2;
    _cardWidth = (_mainWidth - _drain * (COUNT + 1)) / COUNT;
    _cardHeight = (_mainHeight - _drain * (ROW + 1)) / ROW;
    
    _score = 0;
    
    NSLog(@"MainScene: %ld X %ld",_width,_height);
    
    if(!_createdScene){
        [self createScene];
        [self randomNewCard];
    }
}
-(void)update:(NSTimeInterval)currentTime{
    if(currentTime - lastUpdate >= 0){
        SKSpriteNode *main = (SKSpriteNode*)[self childNodeWithName:@"mainLayout"];
        
        NSArray<SKNode*> *nodes = [main children];
        SKNode *node;
        NSInteger r = 0,c = 0;
        for(NSInteger i = 0;i<nodes.count;i++){
            if(c >= 4){
                c = 0;
                r++;
            }
            node = (SKNode*)nodes[i];
            SKLabelNode *label = (SKLabelNode*)[node childNodeWithName:@"cardLabel"];
            if(_g_cards[r][c] ==0){
                label.text = [NSString stringWithFormat:@""];
            }else{
                label.text = [NSString stringWithFormat:@"%ld",_g_cards[r][c]];
            }
            c++;
        }
        
        NSString *score = [NSString stringWithFormat:@"%ld",_score];
        
        _leftScoreNode.text = score;
        _rightScoreNode.text = score;
        
        lastUpdate = currentTime;
    }
    
}

/*
 *  创建场景
 */
-(void)createScene{
    self.backgroundColor = [Colors transColorWithHex:SCENE_BKG_COLOR];
    
    [self createHeader];
    [self createMain];
    
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipRecognizer:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipRecognizer:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipRecognizer:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipRecognizer:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:recognizer];
}

-(void)createHeader{
    
    NSInteger rectWidth = 80;
    NSInteger rectHeight = _height * 0.1;
    NSInteger drain = (_width - rectWidth * 4) / 4;
    NSInteger rectY = _height * 0.94 - rectHeight;
    
    SKSpriteNode *leftScore = [self createRectWithSize:CGSizeMake(rectWidth * 2, rectHeight)
                                                  Name:@"leftScore"
                                              Position:CGPointMake(drain, rectY)
                                                 Color:SCORE_BKG_COLOR];
    
    SKSpriteNode *rightScore = [self createRectWithSize:CGSizeMake(rectWidth, rectHeight)
                                                   Name:@"rightScore"
                                               Position:CGPointMake(drain * 2 + rectWidth * 2, rectY)
                                                  Color:SCORE_BKG_COLOR];
    
    SKSpriteNode *highScore = [self createRectWithSize:CGSizeMake(rectWidth, rectHeight)
                                                  Name:@"highScore"
                                              Position:CGPointMake(drain * 3 + rectWidth * 3, rectY)
                                                 Color:SCORE_BKG_COLOR];
    
    SKLabelNode *leftScoreLabel = [self createLabelWithSize:FONTSIZE_MD
                                                       Name:@"leftScoreLabel"
                                                   Position:CGPointMake(leftScore.size.width / 2, leftScore.size.height / 2)];
    leftScoreLabel.text = @"0";
    
    _leftScoreNode = leftScoreLabel;
    
    SKLabelNode *rightTopScoreLabel = [self createLabelWithSize:FONTSIZE_XS
                                                           Name:@"rightTopScoreLabel"
                                                       Position:CGPointMake(rightScore.size.width / 2, rightScore.size.height / 4 * 3)];
    rightTopScoreLabel.text = @"当前得分";
    SKLabelNode *rightBottomScoreLabel = [self createLabelWithSize:FONTSIZE_XS + 8
                                                              Name:@"rightBottomScoreLabel"
                                                          Position:CGPointMake(rightScore.size.width / 2, rightScore.size.height / 4)];
    rightBottomScoreLabel.text = @"0";
    
    _rightScoreNode = rightBottomScoreLabel;
    
    SKLabelNode *highTopScoreLabel = [self createLabelWithSize:FONTSIZE_XS
                                                          Name:@"highTopScoreLabel"
                                                      Position:CGPointMake(highScore.size.width / 2, highScore.size.height / 4 * 3)];
    highTopScoreLabel.text = @"最高得分";
    SKLabelNode *highBottomScoreLabel = [self createLabelWithSize:FONTSIZE_XS + 8
                                                             Name:@"highBottomScoreLabel"
                                                         Position:CGPointMake(highScore.size.width / 2, highScore.size.height / 4)];
    highBottomScoreLabel.text = @"0";
    
    _highScoreNode = highBottomScoreLabel;
    
    [self addChild:leftScore];
    [leftScore addChild:leftScoreLabel];
    [self addChild:rightScore];
    [rightScore addChild:rightTopScoreLabel];
    [rightScore addChild:rightBottomScoreLabel];
    [self addChild:highScore];
    [highScore addChild:highTopScoreLabel];
    [highScore addChild:highBottomScoreLabel];
}
-(void)createMain{
    NSInteger drain = _drain;
    NSInteger mainWidth = _mainWidth;
    NSInteger mainHeight = _mainHeight;
    NSInteger cardWidth = _cardWidth;
    NSInteger cardHeight = _cardHeight;
    
    SKSpriteNode *main = [self createRectWithSize:CGSizeMake(mainWidth, mainHeight)
                                             Name:@"mainLayout"
                                         Position:CGPointMake(_width * 0.02, _height * 0.1)
                                            Color:MAIN_BKG_COLOR];
    
    [self addChild:main];
    
    for(NSInteger i = 0;i<ROW;i++){
        for(NSInteger j = 0;j<COUNT;j++){
            SKSpriteNode *card = [self createCardWithSize:CGSizeMake(cardWidth, cardHeight) Position:CGPointMake(drain * (i + 1) + cardWidth * i, drain * (j + 1) + cardHeight * j) Color:CARD_BKG_COLOR];
            
            SKLabelNode *cardLabel = [self createLabelWithSize:FONTSIZE_MD
                                                          Name:@"cardLabel"
                                                      Position:CGPointMake(card.size.width / 2, card.size.height / 2)];
            cardLabel.text = @"0";
            [card addChild:cardLabel];
            
            [main addChild:card];
        }
    }
    
    
}

-(SKSpriteNode *)createRectWithSize:(CGSize)size Name:(NSString *)name Position:(CGPoint)point Color:(NSInteger)color{
    SKSpriteNode *sprite = [[SKSpriteNode alloc]initWithColor:[Colors transColorWithHex:color] size:size];
    sprite.position = point;
    sprite.name = name;
    sprite.anchorPoint = CGPointZero;
    return sprite;
}
-(SKSpriteNode *)createCardWithSize:(CGSize)size Position:(CGPoint)point Color:(NSInteger)color{
    SKSpriteNode *sprite = [[SKSpriteNode alloc]initWithColor:[Colors transColorWithHex:color] size:size];
    sprite.position = point;
    sprite.anchorPoint = CGPointZero;
    sprite.name = @"card";
    return sprite;
}
-(SKLabelNode *)createLabelWithSize:(NSInteger)size Name:(NSString *)name Position:(CGPoint)point{
    SKLabelNode *label = [[SKLabelNode alloc] initWithFontNamed:@"Avenir"];
    label.fontSize = size;
    label.name = name;
    label.position = point;
    label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    return label;
}

//新增数据
-(void)randomNewCard{
    NSInteger row = arc4random() % 4;
    NSInteger count = arc4random() % 4;
    
    if(![self hasBlank]){
        return ;
    }
    
    if(_g_cards[row][count] == 0){
        _g_cards[row][count] = 2;
    }else{
        [self randomNewCard];
    }
    
    NSLog(@"Cards:[%ld, %ld]",row,count);
}
-(BOOL)hasBlank{
    BOOL hasBlank = NO;
    for(NSInteger r = 0;r<ROW;r++){
        for(NSInteger c = 0;c<COUNT;c++){
            if(_g_cards[r][c] == 0){
                hasBlank = YES;
            }
        }
    }
    return hasBlank;
}

//手势滑动处理
-(void)handleSwipRecognizer:(UISwipeGestureRecognizer *)recognize{
    
    BOOL moved = NO,merged = NO;
    
    switch (recognize.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            NSLog(@"LeftSwipGestureRecognizer...");
            moved = [self leftRemoveBlank];
            merged = [self leftMergeCard];
            if(moved || merged)
                [self randomNewCard];
            break;
        case UISwipeGestureRecognizerDirectionRight:
            NSLog(@"RightSwipGestureRecognizer...");
            moved = [self rightRemoveBlank];
            merged = [self rightMergeCard];
            if(moved || merged)
                [self randomNewCard];
            break;
        case UISwipeGestureRecognizerDirectionUp:
            NSLog(@"UpSwipGestureRecognizer...");
            moved = [self upRemoveBlank];
            merged = [self upMergedCard];
            if(moved || merged)
                [self randomNewCard];
            break;
        case UISwipeGestureRecognizerDirectionDown:
            NSLog(@"DownSwipGestureRecognizer...");
            moved = [self downRemoveBlank];
            merged = [self downMergedCard];
            if(moved || merged)
                [self randomNewCard];
            break;
        default:
            break;
    }
}

-(BOOL)leftRemoveBlank{
    BOOL moved = NO;
    for(NSInteger c = 0;c<COUNT;c++){
        NSInteger k;
        for(NSInteger r = 1;r<ROW;r++){
            k = r;
            while (k-1>=0 && _g_cards[k][c] != 0 && _g_cards[k-1][c] == 0) {
                NSInteger tmp = _g_cards[k-1][c];
                _g_cards[k-1][c] = _g_cards[k][c];
                _g_cards[k][c] = tmp;
                moved = YES;
                k--;
            }
        }
    }
    return moved;
}
-(BOOL)rightRemoveBlank{
    BOOL moved = NO;
    for(NSInteger c = 0;c<COUNT;c++){
        NSInteger k;
        for(NSInteger r = ROW - 1;r >= 0;r--){
            k = r;
            while(k + 1 < 4 && _g_cards[k][c] != 0 && _g_cards[k+1][c] == 0){
                NSInteger tmp = _g_cards[k+1][c];
                _g_cards[k+1][c] = _g_cards[k][c];
                _g_cards[k][c] = tmp;
                moved = YES;
                k++;
            }
        }
    }
    return moved;
}
-(BOOL)upRemoveBlank{
    BOOL moved = NO;
    for(NSInteger r = 0;r<ROW;r++){
        NSInteger k;
        for(NSInteger c = COUNT - 1;c >= 0;c--){
            k = c;
            while(k + 1 < 4 && _g_cards[r][k] != 0 && _g_cards[r][k+1] == 0){
                NSInteger tmp = _g_cards[r][k+1];
                _g_cards[r][k+1] = _g_cards[r][k];
                _g_cards[r][k] = tmp;
                moved = YES;
                k++;
            }
        }
    }
    return moved;
}
-(BOOL)downRemoveBlank{
    BOOL moved = NO;
    for(NSInteger r = 0;r<ROW;r++){
        NSInteger k;
        for(NSInteger c = 1;c<COUNT;c++){
            k = c;
            while (k-1>=0 && _g_cards[r][k] != 0 && _g_cards[r][k-1] == 0) {
                NSInteger tmp = _g_cards[r][k-1];
                _g_cards[r][k-1] = _g_cards[r][k];
                _g_cards[r][k] = tmp;
                moved = YES;
                k--;
            }
        }
    }
    
    return moved;
}
-(BOOL)leftMergeCard{
    BOOL merged = NO;
    for(NSInteger c = 0;c < COUNT;c++){
        for(NSInteger r = 0;r < ROW - 1;r++){
            if(_g_cards[r][c] != 0 && _g_cards[r][c] == _g_cards[r+1][c]){
                _score += _g_cards[r+1][c];
                _g_cards[r][c] += _g_cards[r+1][c];
                _g_cards[r+1][c] = 0;
                
                merged = YES;
                [self leftRemoveBlank];
            }
        }
    }
    return merged;
}
-(BOOL)rightMergeCard{
    BOOL merged = NO;
    for(NSInteger c = 0;c < COUNT;c++){
        for(NSInteger r = ROW - 1;r > 0;r--){
            if(_g_cards[r][c] != 0 && _g_cards[r][c] == _g_cards[r-1][c]){
                _score += _g_cards[r-1][c];
                _g_cards[r][c] += _g_cards[r-1][c];
                _g_cards[r-1][c] = 0;
                merged = YES;
                [self rightRemoveBlank];
            }
        }
    }
    return merged;
}
-(BOOL)upMergedCard{
    BOOL merged = NO;
    for(NSInteger r = 0;r < ROW;r++) {
        for(NSInteger c = COUNT - 1; c > 0;c--){
            if(_g_cards[r][c] != 0 && _g_cards[r][c] == _g_cards[r][c-1]){
                _score += _g_cards[r][c-1];
                _g_cards[r][c] += _g_cards[r][c-1];
                _g_cards[r][c-1] = 0;
                merged = YES;
                [self upRemoveBlank];
            }
        }
    }
    return merged;
}
-(BOOL)downMergedCard{
    BOOL merged = NO;
    for(NSInteger r = 0;r < ROW;r++){
        for(NSInteger c = 0;c < COUNT - 1;c++){
            if(_g_cards[r][c] != 0 && _g_cards[r][c] == _g_cards[r][c+1]){
                _score += _g_cards[r][c+1];
                _g_cards[r][c] += _g_cards[r][c+1];
                _g_cards[r][c+1] = 0;
                merged = YES;
                [self downRemoveBlank];
            }
        }
    }
    return merged;
}



@end

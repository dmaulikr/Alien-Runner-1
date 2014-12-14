//
//  GameScene.m
//  Alien Runner
//
//  Created by Kenneth Wilcox on 12/13/14.
//  Copyright (c) 2014 Kenneth Wilcox. All rights reserved.
//

#import "GameScene.h"
#import "JSTileMap.h"

@interface GameScene()

@property (nonatomic) JSTileMap *map;
@property (nonatomic) SKNode *camera;
@end

@implementation GameScene

- (id)initWithSize:(CGSize)size {
  
  if (self = [super initWithSize:size]) {
    // Sky blue background
    self.backgroundColor = [SKColor colorWithRed:0.81 green:0.91 blue:0.96 alpha:1.0];
    
    // Load level
    self.map = [JSTileMap mapNamed:@"Level1.tmx"];
    [self addChild:self.map];
    
    // Setup camera
    self.camera = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor] size:CGSizeMake(5, 5)];
    self.camera.position = CGPointMake(size.width * 0.5, size.height * 0.5);
    [self.map addChild:self.camera];
  }
  return self;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  for (UITouch *touch in touches) {
    CGPoint touchLocation = [touch locationInNode:self];
    CGPoint previousTouchLocation = [touch previousLocationInNode:self];
    CGPoint movement = CGPointMake(touchLocation.x - previousTouchLocation.x,
                                   touchLocation.y - previousTouchLocation.y);
    self.camera.position = CGPointMake(self.camera.position.x + movement.x, self.camera.position.y + movement.y);
  }
}
@end

//
//  GameScene.m
//  Alien Runner
//
//  Created by Kenneth Wilcox on 12/13/14.
//  Copyright (c) 2014 Kenneth Wilcox. All rights reserved.
//

#import "GameScene.h"
#import "JSTileMap.h"
#import "Player.h"

@interface GameScene()

@property (nonatomic) JSTileMap *map;
@property (nonatomic) SKNode *camera;
@property (nonatomic) Player *player;
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
    self.camera = [SKNode node];
    self.camera.position = CGPointMake(size.width * 0.5, size.height * 0.5);
    [self.map addChild:self.camera];
    
    // Setup Player
    self.player = [[Player alloc] init];
    self.player.position = [self getMarkerPosition:@"Player"];
    [self.map addChild:self.player];
  }
  return self;
}

- (CGPoint)getMarkerPosition:(NSString*)markerName
{
  CGPoint position = CGPointMake(0, 0); // default to something
  TMXObjectGroup *markerLayer = [self.map groupNamed:@"Markers"];
  if (markerLayer) {
    NSDictionary *marker = [markerLayer objectNamed:markerName];
    if (marker) {
      position = CGPointMake([[marker valueForKey:@"x"] floatValue],
                             [[marker valueForKey:@"y"] floatValue]);
    }
  }
  return position;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  for (UITouch *touch in touches) {
    self.player.position = [touch locationInNode:self.map];
    self.player.velocity = CGVectorMake(0, 0);
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  for (UITouch *touch in touches) {
    CGPoint touchLocation = [touch locationInNode:self];
    CGPoint previousTouchLocation = [touch previousLocationInNode:self];
    CGPoint movement = CGPointMake(touchLocation.x - previousTouchLocation.x,
                                   touchLocation.y - previousTouchLocation.y);
    
    self.player.position = CGPointMake(self.player.position.x + movement.x, self.player.position.y + movement.y);
//    [self updateView];
  }
}

- (void)update:(NSTimeInterval)currentTime
{
  // Update player
  [self.player update];
  
  // Move player
//  self.player.position = self.player.targetPosition;
  
  // Update position of camera
  self.camera.position = CGPointMake(self.player.position.x + (self.size.width * 0.25), self.player.position.y);
  [self updateView];
}

- (void)updateView
{
  // Calculate clamped x and y locations
  CGFloat x = fmaxf(self.camera.position.x, self.size.width * 0.5);
  CGFloat y = fmaxf(self.camera.position.y, self.size.height * 0.5);
  x = fminf(x, (self.map.mapSize.width * self.map.tileSize.width) - self.size.width * 0.5);
  y = fminf(y, (self.map.mapSize.height * self.map.tileSize.height) - self.size.height * 0.5);
  
  // Center view on camera's position in the map
  self.map.position = CGPointMake((self.size.width * 0.5) - x, (self.size.height * 0.5) - y);
}

@end

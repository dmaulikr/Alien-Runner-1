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
@property (nonatomic) TMXLayer *mainLayer;
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
    self.mainLayer = [self.map layerNamed:@"Main"];
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
    CGPoint touchLocation = [touch locationInNode:self];
    if (touchLocation.x < 50) {
      self.player.velocity = CGVectorMake(-5, self.player.velocity.dy);
    } else if (touchLocation.x > self.size.width - 50) {
      self.player.velocity = CGVectorMake(5, self.player.velocity.dy);
    } else {
      self.player.position = [touch locationInNode:self.map];
      self.player.velocity = CGVectorMake(0, 0);
    }
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

- (BOOL)validTileCoord:(CGPoint)tileCoord
{
  return tileCoord.x >= 0 && tileCoord.y >= 0 && tileCoord.x < self.map.mapSize.width && tileCoord.y < self.map.mapSize.height;
}

- (CGRect)rectForTileCoord:(CGPoint)tileCoord
{
  CGFloat x = tileCoord.x * self.map.tileSize.width;
  CGFloat mapHeight = self.map.mapSize.height * self.map.tileSize.height;
  CGFloat y = mapHeight - ((tileCoord.y + 1) * self.map.tileSize.height);
  return CGRectMake(x, y, self.map.tileSize.width, self.map.tileSize.height);
}

- (void)collide:(Player *)player withLayer:(TMXLayer *)layer
{
  // Create coordinate offsets for tiles to check
  CGPoint coordOffsets[8] = {CGPointMake(0, 1), CGPointMake(0, -1), CGPointMake(1, 0), CGPointMake(-1, 0), CGPointMake(1, -1), CGPointMake(-1, -1), CGPointMake(1, 1), CGPointMake(-1, 1)};
  
  // Get tile grid coord for player's position
  CGPoint playerCoord = [layer coordForPoint:player.targetPosition];
  
  for (int i = 0; i < 8; i++) {
    CGRect playerRect = [player collisionRectAtTarget];
    
    CGPoint offset = coordOffsets[i];
    CGPoint tileCoord = CGPointMake(playerCoord.x + offset.x, playerCoord.y + offset.y);
    
    // Get gid for tile at coordinate
    int gid = 0;
    if ([self validTileCoord:tileCoord]) {
      gid = [layer.layerInfo tileGidAtCoord:tileCoord];
    }
    
    if (gid != 0) {
      CGRect intersection = CGRectIntersection(playerRect, [self rectForTileCoord:tileCoord]);
      
      if (!CGRectIsEmpty(intersection)) {
        // Do we move the player horizontally or vertically?
        BOOL resolveVertically = offset.x == 0 || (offset.y != 0 && intersection.size.height < intersection.size.width);
        
        CGPoint positionAdjustment = CGPointZero;
        
        // Calculate the distance we need to move the player
        // Reset the player velocity
        if (resolveVertically) {
          positionAdjustment.y = intersection.size.height * offset.y;
          player.velocity = CGVectorMake(player.velocity.dx, 0);
        } else {
          positionAdjustment.x = intersection.size.width * -offset.x;
          player.velocity = CGVectorMake(0, player.velocity.dy);
        }
        
        player.targetPosition = CGPointMake(player.targetPosition.x + positionAdjustment.x, player.targetPosition.y + positionAdjustment.y);
      }
    }
  }
}

- (void)update:(NSTimeInterval)currentTime
{
  // Update player
  [self.player update];
  
  // Collide player with world
  [self collide:self.player withLayer:self.mainLayer];
  
  // Move player
  self.player.position = self.player.targetPosition;
  
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

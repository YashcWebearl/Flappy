import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flappy/component/pipe.dart';
import 'package:flutter/material.dart';

import '../bloc/game/game_cubit.dart';
import '../flappy_dash_game.dart';
import 'hidden_coin.dart';
class Dash extends PositionComponent
    with
        CollisionCallbacks,HasGameRef<FlappyDashGame>,
        FlameBlocReader<GameCubit,GameState> {
  Dash() : super(
      position: Vector2(0, 0),
      size: Vector2.all(100.0),
      anchor: Anchor.center,
    priority: 10,
  );

  late Sprite _dashSprite;

  final Vector2 _gravity = Vector2(0, 1400.0);
  Vector2 _velocity = Vector2(0, 0);
  final Vector2 _jumpForce = Vector2(0, -400);
  @override
  Future<void> onLoad() async{
      await super.onLoad();
      // debugMode = true;
      final radius = size.x/2.5;
      final center = size/2;
      _dashSprite =await Sprite.load('dash2.png');
      add(CircleHitbox(
        radius: radius * 0.8,
        position: center * 1.1,
        // radius: radius * 0.8,
        // position: center * 1.1,
        anchor: Anchor.center,
      ));
  }

  @override
  void update(double dt) async{
    super.update(dt);
    if(bloc.state.currentPlayingState.isNotPlaying){
      return;
    }
    _velocity += _gravity * dt;
    position += _velocity * dt;
    final double bottomY = gameRef.size.y - (size.y +435);
    // if (position.y >= bottomY) {
    //   position.y = bottomY; // Keep Dash on the ground
    //   _velocity = Vector2.zero(); // Stop movement
    //   bloc.gameOver(); // Trigger game over
    // }
    if (position.y.abs() > (game.size.y / 2) - 35) {
      bloc.gameOver();
    }
  }

  void jump(){
    if(bloc.state.currentPlayingState.isNotPlaying){
      return;
    }
    _velocity = _jumpForce;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _dashSprite.render(canvas,size: size,position: Vector2(0, 10));
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints,other);
    if(bloc.state.currentPlayingState.isNotPlaying){
      return;
    }
    if(other is HiddenCoin){
      bloc.increaseScore();
     debugPrint('lets increase a coin!!');
     // game.world.increaseScore();
     other.removeFromParent();
    }else if(other is Pipe){
      bloc.gameOver();
      // debugPrint('Game Overrr!!');
    }
  }
}


// position += Vector2(0,0);

// class Dash2 extends SpriteComponent {
//   Dash2({
//     required super.sprite,
// });
// }




// @override
//   void update(double dt) async{
//     super.update(dt);
//     // position.x += 1;
//     position = Vector2.zero();
//
//     // angle += 0.1;
//     // print('update ($dt)');
//   }
// canvas.drawRect(toRect(), BasicPalette.red.paint());
// canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: size.x, height: size.y), BasicPalette.red.paint());
// canvas.drawCircle(Offset.zero, 20, BasicPalette.blue.paint());
// print('render ()');
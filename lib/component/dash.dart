// import 'dart:ui';
// import 'package:flame/collisions.dart';
// import 'package:flame/components.dart';
// import 'package:flame_bloc/flame_bloc.dart';
// import 'package:flappy/component/pipe.dart';
// import 'package:flutter/material.dart';
//
// import '../bloc/game/game_cubit.dart';
// import '../flappy_dash_game.dart';
// import 'hidden_coin.dart';
// class Dash extends PositionComponent
//     with
//         CollisionCallbacks,HasGameRef<FlappyDashGame>,
//         FlameBlocReader<GameCubit,GameState> {
//   Dash() : super(
//       position: Vector2(0, 0),
//       size: Vector2.all(100.0),
//       anchor: Anchor.center,
//     priority: 10,
//   );
//   final List<String> avatarImages = [
//     'dash2.png',
//     'dash_red.png',
//     'dash_green.png',
//     'dash_yellow.png',
//   ];
//
//   late Sprite _dashSprite;
//
//   final Vector2 _gravity = Vector2(0, 1400.0);
//   Vector2 _velocity = Vector2(0, 0);
//   final Vector2 _jumpForce = Vector2(0, -400);
//   @override
//   Future<void> onLoad() async{
//       await super.onLoad();
//       // debugMode = true;
//       final radius = size.x/2.5;
//       final center = size/2;
//       // _dashSprite =await Sprite.load('dash2.png');
//       _dashSprite = await Sprite.load(avatarImages[bloc.state.avatarIndex]);
//
//       add(CircleHitbox(
//         radius: radius * 0.8,
//         position: center * 1.1,
//         // radius: radius * 0.8,
//         // position: center * 1.1,
//         anchor: Anchor.center,
//       ));
//   }
//
//   @override
//   void update(double dt) async{
//     super.update(dt);
//
//     final newAvatar = avatarImages[bloc.state.avatarIndex];
//     if (_dashSprite.image != newAvatar) {
//       _dashSprite = await Sprite.load(newAvatar);
//     }
//
//
//     if(bloc.state.currentPlayingState.isNotPlaying){
//       return;
//     }
//     _velocity += _gravity * dt;
//     position += _velocity * dt;
//     // final double bottomY = gameRef.size.y - (size.y +435);
//     // if (position.y >= bottomY) {
//     //   position.y = bottomY; // Keep Dash on the ground
//     //   _velocity = Vector2.zero(); // Stop movement
//     //   bloc.gameOver(); // Trigger game over
//     // }
//     if (position.y.abs() > (game.size.y / 2) - 35) {
//       bloc.gameOver();
//     }
//   }
//
//   void jump(){
//     if(bloc.state.currentPlayingState.isNotPlaying){
//       return;
//     }
//     _velocity = _jumpForce;
//   }
//
//   @override
//   void render(Canvas canvas) {
//     super.render(canvas);
//     _dashSprite.render(canvas,size: size,position: Vector2(0, 10));
//   }
//
//   @override
//   void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
//     super.onCollision(intersectionPoints,other);
//     if(bloc.state.currentPlayingState.isNotPlaying){
//       return;
//     }
//     if(other is HiddenCoin){
//       bloc.increaseScore();
//      debugPrint('lets increase a coin!!');
//      // game.world.increaseScore();
//      other.removeFromParent();
//     }else if(other is Pipe){
//       bloc.gameOver();
//       // debugPrint('Game Overrr!!');
//     }
//   }
// }
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';

import '../bloc/game/game_cubit.dart';
import '../flappy_dash_game.dart';
import 'hidden_coin.dart';
import 'pipe.dart';

class Dash extends PositionComponent
    with CollisionCallbacks, HasGameRef<FlappyDashGame>, FlameBlocReader<GameCubit, GameState> {
  Dash()
      : super(
    position: Vector2(0, 0),
    size: Vector2.all(100.0),
    anchor: Anchor.center,
    priority: 10,
  );

  final List<String> avatarImages = [
    'dash2.png',
    'dash_red.png',
    'dash_green.png',
    'dash_yellow.png',
  ];

  final List<double> gravityValues = [1400.0, 1450.0, 1500.0, 1600.0]; // Gravity per avatar
  final List<double> jumpForceValues = [-400.0, -450.0, -500.0, -550.0]; // Jump force per avatar

  late Sprite _dashSprite;

  Vector2 _gravity = Vector2(0, 1400.0);
  Vector2 _velocity = Vector2(0, 0);
  Vector2 _jumpForce = Vector2(0, -400);

  int _currentAvatarIndex = 0; // Track changes

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final radius = size.x / 2.5;
    final center = size / 2;

    _currentAvatarIndex = bloc.state.avatarIndex;
    _updateAvatar(); // Load initial avatar and physics values
    print('current gravity:-$_gravity');
    print('current jumpforce:- $_jumpForce');
    add(CircleHitbox(
      radius: radius * 0.8,
      position: center * 1.1,
      anchor: Anchor.center,
    ));
  }

  void _updateAvatar() async {
    int index = bloc.state.avatarIndex;
    _dashSprite = await Sprite.load(avatarImages[index]); // Load sprite
    _gravity = Vector2(0, gravityValues[index]); // Update gravity
    _jumpForce = Vector2(0, jumpForceValues[index]); // Update jump force
    print('Updated gravity:-$_gravity');
    print('Updated jumpforce:- $_jumpForce');
  }

  @override
  void update(double dt) async {
    super.update(dt);
    print('Runned gravity:-$_gravity');
    print('Runned jumpforce:- $_jumpForce');
    // Check if the avatar index has changed
    if (_currentAvatarIndex != bloc.state.avatarIndex) {
      _currentAvatarIndex = bloc.state.avatarIndex;
      _updateAvatar(); // Update physics values and sprite
    }

    if (bloc.state.currentPlayingState.isNotPlaying) {
      return;
    }

    _velocity += _gravity * dt;
    position += _velocity * dt;

    // Check if Dash has hit the ground or ceiling
    if (position.y.abs() > (game.size.y / 2) - 35) {
      bloc.gameOver();
    }
  }

  void jump() {
    if (bloc.state.currentPlayingState.isNotPlaying) {
      return;
    }
    _velocity = _jumpForce;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _dashSprite.render(canvas, size: size, position: Vector2(0, 10));
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (bloc.state.currentPlayingState.isNotPlaying) {
      return;
    }
    if (other is HiddenCoin) {
      bloc.increaseScore();
      debugPrint('Coin collected!');
      other.removeFromParent();
    } else if (other is Pipe) {
      bloc.gameOver();
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
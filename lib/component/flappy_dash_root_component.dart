import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import '../bloc/game/game_cubit.dart';
import '../flappy_dash_game.dart';
import 'dash.dart';
import 'dash_parallex_background.dart';
import 'pipe_pair.dart';

class FlappyDashRootComponent extends Component
    with HasGameRef<FlappyDashGame>, FlameBlocReader<GameCubit, GameState> {
  late Dash _dash;
  late PipePair _lastPipe;
  static const _pipesDistance = 400.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(DashParallaxBackground());
    add(_dash = Dash());
    _generatePipes(
      fromX: 350,
    );
  }

  void _generatePipes({
    int count = 5,
    double fromX = 0.0,
  }) {
    for (int i = 0; i < count; i++) {
      const area = 600;
      final y = (Random().nextDouble() * area) - (area / 2);
      add(_lastPipe = PipePair(
        position: Vector2(fromX + (i * _pipesDistance), y),
      ));
    }
  }

  void _removeLastPipes() {
    final pipes = children.whereType<PipePair>();
    final shouldBeRemoved = max(pipes.length - 5, 0);
    pipes.take(shouldBeRemoved).forEach((pipe) {
      pipe.removeFromParent();
    });
  }

  void onSpaceDown() {
    _checkToStart();
    _dash.jump();
  }

  void onTapDown(TapDownEvent event) {
    _checkToStart();
    _dash.jump();
  }

  void _checkToStart() {
    if (bloc.state.currentPlayingState.isIdle) {
      bloc.startPlaying();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_dash.x >= _lastPipe.x) {
      _generatePipes(
        fromX: _pipesDistance,
      );
      _removeLastPipes();
    }
    game.camera.viewfinder.zoom = 1.0;
  }
}
// import 'dart:math';
// import 'package:flame/components.dart';
// import 'package:flame/events.dart';
// import 'package:flame_bloc/flame_bloc.dart';
// import 'package:flappy/component/pipe_pair.dart';
// import 'package:flutter/material.dart';
// import '../bloc/game/game_cubit.dart';
// import '../flappy_dash_game.dart';
// import 'dash.dart';
// import 'dash_parallex_background.dart';
// class FlappyDashRootComponents extends Component with HasGameRef<FlappyDashGame> ,FlameBlocReader<GameCubit,GameState>{
//   late Dash _dash;
//   late PipePair _lastPipe;
//   static const _pipesDistance = 400.0;
//   // int _score = 0;
//   // late TextComponent _scoreText;
//   @override
//   void onGameResize(Vector2 size) {
//     // TODO: implement onGameResize
//     super.onGameResize(size);
//     debugPrint('onGameResize($size)');
//   }
//
//   @override
//   Future<void> onLoad() async {
//     // TODO: implement onLoad
//     await super.onLoad();
//     add(DashParallaxBackground());
//     add(_dash = Dash());
//     _generatePipes(fromx: 350);
//   }
//
//   void _generatePipes({
//     int count = 5,
//     double fromx = 0.0,
//     // double distance = 400.0,
//   }) {
//     for (int i = 0; i < count; i++) {
//       const area = 600;
//       final y = (Random().nextDouble() * area) - (area / 2);
//       add(
//           _lastPipe = PipePair(
//             position: Vector2(fromx + (i * _pipesDistance), y),
//           ));
//     }
//   }
//   void _removeLastPipes() {
//     final pipes = children.whereType<PipePair>();
//     final shouldBeRemove = max(pipes.length -5, 0);
//     pipes.take(shouldBeRemove).forEach((pipe){
//       pipe.removeFromParent();
//     });
//     debugPrint('pipes length ${pipes.length}');
//   }
//
//
//
//   void onSpaceDown() {
//     _checkToStart();
//     _dash.jump();
//   }
//   void onTapDown(TapDownEvent event) {
//     _checkToStart();
//     _dash.jump();
//   }
//
//   void _checkToStart() {
//     if(bloc.state.currentPlayingState.isIdle){
//       bloc.startPlaying();
//     }
//   }
//   @override
//   void update(double dt) async {
//     super.update(dt);
//
//     // _scoreText.text = bloc.state.currentScore.toString();
//     if (_dash.x >= _lastPipe.x) {
//       _generatePipes(
//         fromx: _pipesDistance,
//       );
//       _removeLastPipes();
//     }
//     game.camera.viewfinder.zoom = 1.0;
//   }
// }
//
//
// // game.camera.viewfinder.add(
// // _scoreText =TextComponent(
// //   // text: _score.toString(),
// //   position: Vector2(0, -(game.size.y/2)),
// // )
// // );
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flappy/widget/audio_helper.dart';
import 'package:flappy/widget/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'bloc/game/game_cubit.dart';
import 'component/dash.dart';
import 'component/dash_parallex_background.dart';
import 'component/flappy_dash_root_component.dart';

class FlappyDashGame extends FlameGame<FlappyDashWorld> with KeyboardEvents,HasCollisionDetection {
  FlappyDashGame(this.gameCubit)
    : super(
        world: FlappyDashWorld(),
        camera: CameraComponent.withFixedResolution(width: 600, height: 1000),
      );

  final GameCubit gameCubit;

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is KeyDownEvent;

    final isSpace = keysPressed.contains(LogicalKeyboardKey.space);

    if (isSpace && isKeyDown) {
      world.onSpaceDown();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
}

class FlappyDashWorld extends World with TapCallbacks,HasGameRef<FlappyDashGame> {
  late FlappyDashRootComponents _rootComponents;
  @override
 Future<void> onLoad() async {
    // TODO: implement onLoad
     super.onLoad();
     await getIt.get<AudioHelper>().initialize();
     add(
       FlameBlocProvider<GameCubit,GameState>(create: ()=> game.gameCubit,children: [
         _rootComponents = FlappyDashRootComponents(),
       ],
       ),
     );


     // add(_rootComponents = FlappyDashRootComponents());
  }

  void onSpaceDown() {
    _rootComponents.onSpaceDown();
  }
  @override
  void onTapDown(TapDownEvent event) {
    // TODO: implement onTapDown
    super.onTapDown(event);
    _rootComponents.onTapDown(event);
    // _dash.jump();
  }
}

// class FlappyDashRootComponents extends Component with HasGameRef<FlappyDashGame> ,FlameBlocReader<GameCubit,GameState>{
//   late Dash _dash;
//   late PipePair _lastPipe;
//   static const _pipesDistance = 400.0;
//   // int _score = 0;
//   late TextComponent _scoreText;
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
//     add(DashParallexBackground());
//     add(_dash = Dash());
//     _generatePipes(fromx: 350);
//     game.camera.viewfinder.add(
//         _scoreText =TextComponent(
//           // text: _score.toString(),
//           position: Vector2(0, -(game.size.y/2)),
//         )
//     );
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
//   void _removeOldOnes() {
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
//     if(bloc.state.currentPlayingState == PlayingState.none){
//       bloc.startPlaying();
//     }
//   }
//   @override
//   void update(double dt) async {
//     super.update(dt);
//
//     _scoreText.text = bloc.state.currentScore.toString();
//     if (_dash.x >= _lastPipe.x) {
//       _generatePipes(
//         fromx: _pipesDistance,
//       );
//       _removeOldOnes();
//     }
//     game.camera.viewfinder.zoom = 1.0;
//   }
// }

// void increaseScore(){
//   _score +=1;
// }
// final distance = 400.0;
// debugPrint('onLoad()');

// add(PipePair(position: Vector2(0, 0)));
// add(PipePair(position: Vector2(300, 200)));
// add(PipePair(position: Vector2(600, -200)));

// @override
//   void onMount() {
//     // TODO: implement onMount
//     super.onMount();
//     debugPrint('onMount()');
//   }
//
//   @override
//   void update(double dt) {
//     super.update(dt);
//     // debugPrint('update ($dt)');
//   }
//
//   @override
//   void render(Canvas canvas) {
//     super.render(canvas);
//     // debugPrint('render ()');
//   }

//onload

// add( RectangleComponent(
//   // paint: BasicPalette.purple.paint(),
//   position: Vector2(10.0, 15.0),
//   size: Vector2.all(10),
//   angle: pi/2,
//   anchor: Anchor.center,
// ));

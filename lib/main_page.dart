import 'package:flame/game.dart';
import 'package:flappy/widget/game_over_widget.dart';
import 'package:flappy/widget/tap_to_play.dart';
import 'package:flappy/widget/top_score_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/game/game_cubit.dart';
import 'flappy_dash_game.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late FlappyDashGame _flappyDashGame;
  late GameCubit gameCubit;
  PlayingState? _latesteState;

  @override
  void initState() {
    // TODO: implement initState
    gameCubit = BlocProvider.of<GameCubit>(context);
    _flappyDashGame = FlappyDashGame(gameCubit);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameCubit, GameState>(
      listener: (context,state){
        if(state.currentPlayingState.isIdle && _latesteState == PlayingState.gameover){
          setState(() {
            _flappyDashGame = FlappyDashGame(gameCubit);
          });
        }
        _latesteState = state.currentPlayingState;
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
              body: Stack(
                children: [
                  GameWidget(game: _flappyDashGame),
                  if(state.currentPlayingState.isGameOver)
                    const GameOverWidget(),
                  if(state.currentPlayingState.isIdle)
                    Align(
                        alignment: Alignment(0, 0.7),
                        child: TapToPlay()
                    ),
                  if(state.currentPlayingState.isNotGameOver)
                     Align(
                       alignment: Alignment(0, 0.1),
                         child: const TopScore()
                     ),
                ],
              )
          ),
        );
      },
    );
  }
}
// Align(
//   alignment: Alignment(0, 0.8),
//   child: IgnorePointer(
//     child: const Text(
//       "TAP To Start",
//       style: TextStyle(
//         color: Colors.blueGrey,
//         fontWeight: FontWeight.bold,
//         fontSize: 28,
//       ),
//     )
//         .animate() // Add animation here
//         .fadeIn(duration: 500.ms) // Fade in over 1 second
//         .scaleXY(begin: 0.5, end: 1.0, duration: 800.ms),
//   ), // Scale from 0.5 to 1
// ),
//  Align(
//   alignment: Alignment.topCenter,
//   child: Padding(
//     padding: EdgeInsets.only(top: 20.0),
//     child: Text(
//       state.currentScore.toString(),
//       style: TextStyle(
//         fontSize: 20,
//         color: Colors.black
//       ),
//     ),
//   ),
// )
// class GameOverWidget extends StatelessWidget {
//   const GameOverWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.black54,
//       child: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text('Game Over', style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 38,
//             ),),
//             SizedBox(height: 18),
//             ElevatedButton(
//                 onPressed: () {
//                  context.read<GameCubit>().restartGame();
//                 }, child: Text('Play Again'))
//           ],
//         ),
//       ),
//     );
//   }
// }


// backgroundBuilder: (context){
//   return Container(
//     color: Colors.grey,
//   );
// },
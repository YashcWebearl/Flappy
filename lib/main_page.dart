import 'package:flame/game.dart';
import 'package:flappy/widget/app_style.dart';
import 'package:flappy/widget/box_overlay.dart';
import 'package:flappy/widget/top_score_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/game/game_cubit.dart';
import 'db/local_storage.dart';
import 'flappy_dash_game.dart';
import 'widget/game_over_widget.dart';
import 'widget/tap_to_play.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late FlappyDashGame _flappyDashGame;

  late GameCubit gameCubit;

  PlayingState? _latestState;

  @override
  void initState() {
    gameCubit = BlocProvider.of<GameCubit>(context);
    _flappyDashGame = FlappyDashGame(gameCubit);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameCubit, GameState>(
      listener: (context, state) {
        if (state.currentPlayingState.isIdle &&
            _latestState == PlayingState.gameOver) {
          setState(() {
            _flappyDashGame = FlappyDashGame(gameCubit);
          });
        }

        _latestState = state.currentPlayingState;
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              GameWidget(game: _flappyDashGame,backgroundBuilder: (_){
                return Container(color: AppColors.backgroundColor);
              },),
              if (state.currentPlayingState.isGameOver) const GameOverWidget(),
              if (state.currentPlayingState.isIdle)
                const Align(
                  alignment: Alignment(0, 0.7),
                  child: TapToPlay(),
                ),
              if (state.currentPlayingState.isNotGameOver) const TopScore(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: BoxOverlay(child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/icon/user.png',height: 30,),
                    SizedBox(width: 10),
                    Text("My Profile",style: TextStyle(
                      color: AppColors.mainColor,
                      fontSize: 20,
                    ),),
                  ],
                )),
              ),
              Positioned(
                top: 90,
                left: 16,
                child: FutureBuilder<int>(
                  future: LocalStorage.getBestScore(),
                  builder: (context, snapshot) {
                    int bestScore = snapshot.data ?? 0;
                    return BoxOverlay(
                      child: Row(
                        children: [
                          Image.asset('assets/icon/trophy.png', height: 30),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Best Score', style: TextStyle(fontSize: 10, color: Colors.grey)),
                              Text('$bestScore', style: TextStyle(fontSize: 18, color: AppColors.mainColor)),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
// import 'package:flame/game.dart';
// import 'package:flappy/widget/game_over_widget.dart';
// import 'package:flappy/widget/tap_to_play.dart';
// import 'package:flappy/widget/top_score_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import 'bloc/game/game_cubit.dart';
// import 'flappy_dash_game.dart';
//
// class MainPage extends StatefulWidget {
//   const MainPage({super.key});
//
//   @override
//   State<MainPage> createState() => _MainPageState();
// }
//
// class _MainPageState extends State<MainPage> {
//   late FlappyDashGame _flappyDashGame;
//   late GameCubit gameCubit;
//   PlayingState? _latesteState;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     gameCubit = BlocProvider.of<GameCubit>(context);
//     _flappyDashGame = FlappyDashGame(gameCubit);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<GameCubit, GameState>(
//       listener: (context,state){
//         if(state.currentPlayingState.isIdle && _latesteState == PlayingState.gameOver){
//           setState(() {
//             _flappyDashGame = FlappyDashGame(gameCubit);
//           });
//         }
//         _latesteState = state.currentPlayingState;
//       },
//       builder: (context, state) {
//         return SafeArea(
//           child: Scaffold(
//               body: Stack(
//                 children: [
//                   GameWidget(game: _flappyDashGame),
//                   if(state.currentPlayingState.isGameOver)
//                     const GameOverWidget(),
//                   if(state.currentPlayingState.isIdle)
//                     Align(
//                         alignment: Alignment(0, 0.7),
//                         child: TapToPlay()
//                     ),
//                   if(state.currentPlayingState.isNotGameOver)
//                      Align(
//                        alignment: Alignment(0, 0.1),
//                          child: const TopScore()
//                      ),
//                 ],
//               )
//           ),
//         );
//       },
//     );
//   }
// }
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
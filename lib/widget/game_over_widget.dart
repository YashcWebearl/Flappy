import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/game/game_cubit.dart';

class GameOverWidget extends StatelessWidget {
  const GameOverWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (context, state) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            color: Colors.black54,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                'Game Over',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  letterSpacing: 2
                ),
              )
                  .animate(onPlay: (controller) => controller.repeat()) // Loop indefinitely
                  .scaleXY(begin: 1.0, end: 1.2, duration: 700.ms) // Pulse up
                  .then()
                  .scaleXY(begin: 1.2, end: 1.0, duration: 700.ms) // Pulse down
                  .tint(color: Color(0xffFFCA00), duration: 1400.ms),
                  const SizedBox(height: 6),
                  Text(
                    'Score: ${state.currentScore}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 60),
                  ElevatedButton(
                    onPressed: () => context.read<GameCubit>().restartGame(),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'PLAY AGAIN!',
                        style: TextStyle(
                          fontSize: 22,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../bloc/game/game_cubit.dart';
// class GameOverWidget extends StatefulWidget  {
//   const GameOverWidget({super.key});
//
//   @override
//   State<GameOverWidget> createState() => _GameOverWidgetState();
// }
//
// class _GameOverWidgetState extends State<GameOverWidget> {
//   late GameCubit gameCubit;
//   @override
//   void initState() {
//     // TODO: implement initState
//     gameCubit = BlocProvider.of<GameCubit>(context);
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return BackdropFilter(
//         filter: ImageFilter.blur(sigmaX:6,sigmaY: 6),
//       child: Container(
//         color: Colors.black54,
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               //  Text('Game Over', style: TextStyle(
//               //   color: Colors.white,
//               //   fontWeight: FontWeight.bold,
//               //   fontSize: 38,
//               // ),),
//               Text(
//                 'Game Over',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 40,
//                   letterSpacing: 2
//                 ),
//               )
//                   .animate(onPlay: (controller) => controller.repeat()) // Loop indefinitely
//                   .scaleXY(begin: 1.0, end: 1.2, duration: 700.ms) // Pulse up
//                   .then()
//                   .scaleXY(begin: 1.2, end: 1.0, duration: 700.ms) // Pulse down
//                   .tint(color: Color(0xffFFCA00), duration: 1400.ms),
//               SizedBox(height: 6),
//               Text('Score : ${gameCubit.state.currentScore.toString()}',style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 22,
//                   letterSpacing: 2
//               )),
//               SizedBox(height: 15),
//               ElevatedButton(
//                 onPressed: () {
//                   context.read<GameCubit>().restartGame();
//                   // PlayingState.Idle;
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.all(6.0),
//                   child: const Text('Play Again',style: TextStyle(
//                     fontSize: 20,
//                     letterSpacing: 2,
//                     color: Colors.blueGrey,
//                     fontWeight: FontWeight.bold,),),
//                 ),
//               )
//                   .animate(
//                 onPlay: (controller) => controller.repeat(), // Loop indefinitely
//               )
//                   .fadeIn(duration: 2000.ms) // Fade in over 1 second
//                   .shake(duration: 800.ms, hz: 4),
//               // ElevatedButton(
//               //     onPressed: () {
//               //       context.read<GameCubit>().restartGame();
//               //     }, child: Text('Play Again'))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
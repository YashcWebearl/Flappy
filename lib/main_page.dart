import 'dart:ui'; // Import for blur effect
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/game/game_cubit.dart';
import 'db/local_storage.dart';
import 'flappy_dash_game.dart';
import 'widget/app_style.dart';
import 'widget/box_overlay.dart';
import 'widget/game_over_widget.dart';
import 'widget/tap_to_play.dart';
import 'widget/top_score_widget.dart';
class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> {
  late FlappyDashGame _flappyDashGame;
  late GameCubit gameCubit;
  PlayingState? _latestState;
  String profileName = "My Profile"; // Default profile name
  bool _showAvatarPopup = false; // Track popup visibility
  bool _showProfilePopup = false;
  int bestScore = 0; // Store best score
  final TextEditingController _profileController = TextEditingController();
  final List<String> avatarImages = [
    'assets/images/dash2.png',
    'assets/images/dash_red.png',
    'assets/images/dash_green.png',
    'assets/images/dash_yellow.png',
  ];
  final List<double> gravityValues = [1.4, 1.45, 1.5, 1.6];
  final List<double> jumpForceValues = [4.0, 4.5, 5.0, 5.5];
  @override
  void initState() {
    gameCubit = BlocProvider.of<GameCubit>(context);
    _flappyDashGame = FlappyDashGame(gameCubit);
    _loadProfileName();
    _loadBestScore();
    super.initState();
  }
  Future<void> _loadProfileName() async {
    String savedName = await LocalStorage.getProfileName();
    setState(() {
      profileName = savedName;
      _profileController.text = savedName; // Set initial text in TextField
    });
  }
  Future<void> _loadBestScore() async {
    int savedScore = await LocalStorage.getBestScore();
    setState(() {
      bestScore = savedScore;
      print('best score is:- $bestScore');
    });
  }
  void _toggleAvatarPopup() {
    setState(() {
      _showAvatarPopup = !_showAvatarPopup;
    });
  }
  void _toggleProfilePopup() {
    setState(() {
      _showProfilePopup = !_showProfilePopup;
    });
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameCubit, GameState>(
      listener: (context, state) async {
        if (state.currentPlayingState.isGameOver) {
          // Save best score when game ends
          await LocalStorage.saveBestScore(state.currentScore);
          await _loadBestScore(); // Refresh best score
        }
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
              GameWidget(
                game: _flappyDashGame,
                backgroundBuilder: (_) {
                  return Container(color: AppColors.backgroundColor);
                },
              ),
              if (state.currentPlayingState.isGameOver) const GameOverWidget(),
              if (state.currentPlayingState.isIdle)
                const Align(
                  alignment: Alignment(0, 0.7),
                  child: TapToPlay(),
                ),
              if (state.currentPlayingState.isNotGameOver) const TopScore(),
              if (state.currentPlayingState.isIdle) ...[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: _toggleAvatarPopup, // Show popup on tap
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: AppColors.boxbgColor,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(avatarImages[state.avatarIndex],
                                height: 50),
                            // Updated to dynamic avatar
                            const Text(
                              'Avatar',
                              style: TextStyle(
                                  color: AppColors.mainColor, fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: _toggleProfilePopup,
                    child: BoxOverlay(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/icon/user.png', height: 30),
                          const SizedBox(width: 10),
                          Text(
                            profileName,
                            style: const TextStyle(
                              color: AppColors.mainColor,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 90,
                  left: 16,
                  child: BoxOverlay(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/icon/trophy.png', height: 30),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Best Score',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontFamily: 'Roboto'),
                            ),
                            Text(
                              '$bestScore', // Updated UI dynamically
                              style: const TextStyle(
                                  fontSize: 18, color: AppColors.mainColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (_showAvatarPopup)
                _buildPopup(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Select Your Avatar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          state.avatarIndex > 0?
                            IconButton(
                              icon: const Icon(
                                  Icons.arrow_back_ios, color: Colors.white,size: 24,),
                              onPressed: () {
                                gameCubit.changeAvatar((state.avatarIndex - 1) %
                                    avatarImages.length);
                              },
                            )
                          :SizedBox(width: 40,),

                          Image.asset(avatarImages[state.avatarIndex], height: 80),
                          state.avatarIndex < avatarImages.length - 1?
                            IconButton(
                              icon: const Icon(Icons.arrow_forward_ios, color: Colors.white,size: 24,),
                              onPressed: () {
                                gameCubit.changeAvatar((state.avatarIndex + 1) % avatarImages.length);
                              },
                            ):SizedBox(width: 40,),
                        ],
                      ),
                      Text(
                        'Gravity: ${gravityValues[state.avatarIndex]}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      Text(
                        'Jump Force: ${jumpForceValues[state.avatarIndex]}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _toggleAvatarPopup,
                        child: const Text('Select'),
                      ),
                    ],
                  ),
                ),

              if (_showProfilePopup)
                _buildPopup(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Edit Profile Name',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _profileController,
                          // Set controller
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onSubmitted: (value) async {
                            await LocalStorage.saveProfileName(value);
                            setState(() {
                              profileName = value;
                            });
                            _toggleProfilePopup();
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _toggleProfilePopup,
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
  Widget _buildPopup({required Widget child}) {
    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),
        ),
        Center(
          child: Container(
            width: 250,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: const Color(0xff16425B),
                borderRadius: BorderRadius.circular(16.0)),
            child: child,
          ),
        ),
      ],
    );
  }
}

// import 'package:flame/game.dart';
// import 'package:flappy/widget/app_style.dart';
// import 'package:flappy/widget/box_overlay.dart';
// import 'package:flappy/widget/top_score_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'bloc/game/game_cubit.dart';
// import 'db/local_storage.dart';
// import 'flappy_dash_game.dart';
// import 'widget/game_over_widget.dart';
// import 'widget/tap_to_play.dart';
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
//
//   late GameCubit gameCubit;
//
//   PlayingState? _latestState;
//
//   @override
//   void initState() {
//     gameCubit = BlocProvider.of<GameCubit>(context);
//     _flappyDashGame = FlappyDashGame(gameCubit);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<GameCubit, GameState>(
//       listener: (context, state) {
//         if (state.currentPlayingState.isIdle &&
//             _latestState == PlayingState.gameOver) {
//           setState(() {
//             _flappyDashGame = FlappyDashGame(gameCubit);
//           });
//         }
//         _latestState = state.currentPlayingState;
//       },
//       builder: (context, state) {
//         return Scaffold(
//           body: Stack(
//             children: [
//               GameWidget(
//                 game: _flappyDashGame,
//                 backgroundBuilder: (_) {
//                   return Container(color: AppColors.backgroundColor);
//                 },
//               ),
//               if (state.currentPlayingState.isGameOver) const GameOverWidget(),
//               if (state.currentPlayingState.isIdle)
//                 const Align(
//                   alignment: Alignment(0, 0.7),
//                   child: TapToPlay(),
//                 ),
//               if (state.currentPlayingState.isNotGameOver) const TopScore(),
//
//               // Show these widgets ONLY when the state is IDLE
//               if (state.currentPlayingState.isIdle) ...[
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Align(
//                     alignment: Alignment.bottomRight,
//                     child: Container(
//                       height: 80,
//                       width: 80,
//                       decoration: BoxDecoration(
//                         color: AppColors.boxbgColor,
//                         borderRadius: BorderRadius.circular(16.0),
//                       ),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Image.asset('assets/images/dash_red.png', height: 50),
//                           Text(
//                             'Avatar',
//                             style: TextStyle(
//                                 color: AppColors.mainColor, fontSize: 20),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: BoxOverlay(
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Image.asset('assets/icon/user.png', height: 30),
//                         SizedBox(width: 10),
//                         Text(
//                           "My Profile",
//                           style: TextStyle(
//                             color: AppColors.mainColor,
//                             fontSize: 20,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 90,
//                   left: 16,
//                   child: FutureBuilder<int>(
//                     future: LocalStorage.getBestScore(),
//                     builder: (context, snapshot) {
//                       int bestScore = snapshot.data ?? 0;
//                       return BoxOverlay(
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Image.asset('assets/icon/trophy.png', height: 30),
//                             SizedBox(width: 10),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Best Score',
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.white,
//                                       fontFamily: 'Roboto'),
//                                 ),
//                                 Text(
//                                   '$bestScore',
//                                   style: TextStyle(
//                                       fontSize: 18,
//                                       color: AppColors.mainColor),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// @override
// Widget build(BuildContext context) {
//   return BlocConsumer<GameCubit, GameState>(
//     listener: (context, state) {
//       if (state.currentPlayingState.isIdle &&
//           _latestState == PlayingState.gameOver) {
//         setState(() {
//           _flappyDashGame = FlappyDashGame(gameCubit);
//         });
//       }
//
//       _latestState = state.currentPlayingState;
//     },
//     builder: (context, state) {
//       return Scaffold(
//         body: Stack(
//           children: [
//             GameWidget(game: _flappyDashGame,backgroundBuilder: (_){
//               return Container(color: AppColors.backgroundColor);
//             },),
//             if (state.currentPlayingState.isGameOver) const GameOverWidget(),
//             if (state.currentPlayingState.isIdle)
//               const Align(
//                 alignment: Alignment(0, 0.7),
//                 child: TapToPlay(),
//               ),
//             if (state.currentPlayingState.isNotGameOver) const TopScore(),
//             if(state.currentPlayingState.isIdle)
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Align(
//                   alignment: Alignment.bottomRight,
//                   child: Container(
//                     // color: AppColors.boxbgColor,
//                     height: 80,
//                     width: 80,
//                     decoration: BoxDecoration(
//                       color: AppColors.boxbgColor,
//                       borderRadius: BorderRadius.circular(16.0),
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Image.asset('assets/images/dash_blue.png',height: 50,),
//                         Text('Avatar',style: TextStyle(color: AppColors.mainColor,fontSize: 20),)
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: BoxOverlay(child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Image.asset('assets/icon/user.png',height: 30,),
//                   SizedBox(width: 10),
//                   Text("My Profile",style: TextStyle(
//                     color: AppColors.mainColor,
//                     fontSize: 20,
//                   ),),
//                 ],
//               )),
//             ),
//             Positioned(
//               top: 90,
//               left: 16,
//               child: FutureBuilder<int>(
//                 future: LocalStorage.getBestScore(),
//                 builder: (context, snapshot) {
//                   int bestScore = snapshot.data ?? 0;
//                   return BoxOverlay(
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Image.asset('assets/icon/trophy.png', height: 30),
//                         SizedBox(width: 10),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('Best Score', style: TextStyle(fontSize: 14, color: Colors.white,fontFamily: 'Roboto')),
//                             Text('$bestScore', style: TextStyle(fontSize: 18, color: AppColors.mainColor)),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }

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

// Center(
//   child: StatefulBuilder( // Use StatefulBuilder to update only this widget
//     builder: (context, setState) {
//       // Avatar images list
//       List<String> avatarImages = [
//         'assets/images/dash2.png',
//         'assets/images/dash_red.png',
//         'assets/images/dash_green.png',
//         'assets/images/dash_yellow.png',
//       ];
//
//
//
//       return Container(
//         width: 300,
//         height: 250,
//         decoration: BoxDecoration(
//           color: Color(0xff16425B),
//           borderRadius: BorderRadius.circular(16.0),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Select Your Avatar',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 20),
//
//             // Avatar Image with Forward & Backward Icons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.arrow_back_ios, color: Colors.white),
//                   onPressed: () {
//                     setState(() {
//                       if (currentAvatarIndex > 0) {
//                         currentAvatarIndex--;
//                       } else {
//                         currentAvatarIndex = avatarImages.length - 1;
//                       }
//                     });
//                   },
//                 ),
//                 Image.asset(
//                   avatarImages[currentAvatarIndex],
//                   height: 80,
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
//                   onPressed: () {
//                     setState(() {
//                       if (currentAvatarIndex < avatarImages.length - 1) {
//                         currentAvatarIndex++;
//                       } else {
//                         currentAvatarIndex = 0;
//                       }
//                     });
//                   },
//                 ),
//               ],
//             ),
//
//             SizedBox(height: 20),
//
//             ElevatedButton(
//               onPressed: _togglePopup,
//               child: Text('Select'),
//             ),
//           ],
//         ),
//       );
//     },
//   ),
// ),

// if (_showAvatarPopup)
//   Stack(
//     children: [
//       Positioned.fill(
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//           child: Container(
//             color: Colors.black.withOpacity(0.5),
//           ),
//         ),
//       ),
//       Center(
//         child: Container(
//           width: 200,
//           height: 180,
//           decoration: BoxDecoration(color: Color(0xff16425B), borderRadius: BorderRadius.circular(16.0)),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//                       mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('Select Your Avatar', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () {
//                     gameCubit.changeAvatar((state.avatarIndex - 1 + avatarImages.length) % avatarImages.length);
//                   }),
//                   Image.asset(avatarImages[state.avatarIndex], height: 80),
//                   IconButton(icon: Icon(Icons.arrow_forward_ios, color: Colors.white), onPressed: () {
//                     gameCubit.changeAvatar((state.avatarIndex + 1) % avatarImages.length);
//                   }),
//                 ],
//               ),
//               ElevatedButton(onPressed: _toggleAvatarPopup, child: Text('Select')),
//             ],
//           ),
//         ),
//       ),
//     ],
//   ),



// Positioned(
//   top: 90,
//   left: 16,
//   child: FutureBuilder<int>(
//     future: LocalStorage.getBestScore(),
//     builder: (context, snapshot) {
//       int bestScore = snapshot.data ?? 0;
//       return BoxOverlay(
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Image.asset('assets/icon/trophy.png', height: 30),
//             const SizedBox(width: 10),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Best Score',
//                   style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.white,
//                       fontFamily: 'Roboto'),
//                 ),
//                 Text(
//                   '$bestScore',
//                   style: const TextStyle(
//                       fontSize: 18,
//                       color: AppColors.mainColor),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       );
//     },
//   ),
// ),
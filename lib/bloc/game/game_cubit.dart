import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../db/local_storage.dart';
import '../../widget/audio_helper.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit(this._audioHelper) : super(GameState());
  // GameCubit() : super(GameState());
  final AudioHelper _audioHelper;
  void startPlaying() {
    _audioHelper.playBackgroundAudio();
    emit(state.copyWith(
      currentPlayingState: PlayingState.playing,
      currentScore: 0,
    ));
  }

  void increaseScore() {
    _audioHelper.playScoreCollectSound();
    emit(state.copyWith(
      currentScore: state.currentScore + 1,
    ));
  }

  void gameOver() async{
    _audioHelper.stopBackgroundAudio();
    await LocalStorage.saveBestScore(state.currentScore);
    _audioHelper.playGameOverSound();
    emit(state.copyWith(
      currentPlayingState: PlayingState.gameOver,
    ));
  }

  void restartGame() {
    _audioHelper.initialize();
    emit(state.copyWith(
      currentPlayingState: PlayingState.idle,
      currentScore: 0,
    ));
  }

}
// startPlaying(){
//
//   print("Playing sound...");
//   _audioHelper.playBackgroundAudio();
//   // _audioHelper.playGameOverSound();
//   print("sound played!");
//   emit(state.copyWith(
//     currentPlayingState: PlayingState.playing,
//     currentScore: 0,
//   ));
// }
//
// void increaseScore(){
//   _audioHelper.playScoreCollectSound();
//   print('collect coin background music');
//   emit(state.copyWith(
//     currentScore: state.currentScore + 1,
//   ));
// }
//
// void gameOver() {
//   if (state.currentPlayingState == PlayingState.gameover) {
//     return; // Prevents multiple game over calls
//   }
//
//   _audioHelper.stopBackgroundAudio();
//
//   Future.delayed(Duration(milliseconds: 100), () {
//     _audioHelper.playGameOverSound();
//   });
//
//   emit(state.copyWith(
//     currentPlayingState: PlayingState.gameover,
//   ));
// }
//
// // void gameOver(){
// //
// //   _audioHelper.stopBackgroundAudio();
// //   // _audioHelper.playGameOverSound();
// //   Future.delayed(Duration(milliseconds: 200), () {
// //     // _audioHelper.playGameOverSound();
// //     print("Playing game over sound...");
// //     _audioHelper.playGameOverSound();
// //     print("Game over sound played!");
// //   });
// //
// //   emit(state.copyWith(
// //     currentPlayingState: PlayingState.gameover,
// //   ));
// // }
// void restartGame() {
//   _audioHelper.stopBackgroundAudio(); // Stop all sounds
//   _audioHelper.initialize(); // Ensure audio is reloaded properly
//
//   emit(state.copyWith(
//     currentPlayingState: PlayingState.Idle,
//     currentScore: 0,
//   ));
// }


// void restartGame() {
//   emit(state.copyWith(
//     currentPlayingState: PlayingState.Idle,
//     currentScore: 0,
//   ));
// }
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../widget/audio_helper.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit(this._audioHelper) : super(GameState());
  // GameCubit() : super(GameState());
  final AudioHelper _audioHelper;

  startPlaying(){
    _audioHelper.playBackgroundAudio();
    emit(state.copyWith(
      currentPlayingState: PlayingState.playing,
      currentScore: 0,
    ));
  }

  void increaseScore(){
    _audioHelper.playScoreCollectSound();
    emit(state.copyWith(
      currentScore: state.currentScore + 1,
    ));
  }

  void gameOver(){
    _audioHelper.stopBackgroundAudio();
    _audioHelper.playGameOverSound();
    emit(state.copyWith(
      currentPlayingState: PlayingState.gameover,
    ));
  }

  void restartGame() {
    emit(state.copyWith(
      currentPlayingState: PlayingState.Idle,
      currentScore: 0,
    ));
  }
}

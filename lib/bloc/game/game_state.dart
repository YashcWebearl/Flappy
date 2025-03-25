part of 'game_cubit.dart';

class GameState with EquatableMixin {
  const GameState({
    this.currentScore = 0,
    this.currentPlayingState = PlayingState.idle,
  });

  final int currentScore;
  final PlayingState currentPlayingState;

  GameState copyWith({
    int? currentScore,
    PlayingState? currentPlayingState,
  }) =>
      GameState(
        currentScore: currentScore ?? this.currentScore,
        currentPlayingState: currentPlayingState ?? this.currentPlayingState,
      );

  @override
  List<Object> get props => [
    currentScore,
    currentPlayingState,
  ];
}

enum PlayingState {
  idle,
  playing,
  paused,
  gameOver;

  bool get isPlaying => this == PlayingState.playing;

  bool get isNotPlaying => !isPlaying;

  bool get isGameOver => this == PlayingState.gameOver;

  bool get isNotGameOver => !isGameOver;

  bool get isIdle => this == PlayingState.idle;

  bool get isPaused => this == PlayingState.paused;
}
// part of 'game_cubit.dart';
//
// class GameState with EquatableMixin {
//   const GameState({
//     this.currentScore = 0,
//     this.currentPlayingState = PlayingState.Idle,
// });
//
//   final int currentScore;
//   final PlayingState currentPlayingState;
//
//   GameState copyWith({
//     int? currentScore,
//     PlayingState? currentPlayingState,
// }) => GameState(
//     currentScore:  currentScore ?? this.currentScore,
//     currentPlayingState: currentPlayingState ?? this.currentPlayingState,
//   );
//
//   @override
//   List<Object> get props => [
//     currentScore,
//     currentPlayingState
//   ];
// }
// enum PlayingState{
//   Idle,
//   playing,
//   paused,
//   gameover;
//
//   bool get isPlaying => this == PlayingState.playing;
//   bool get isNotPlaying => this != PlayingState.playing;
//   bool get isPaused => this == PlayingState.paused;
//   bool get isGameOver => this == PlayingState.gameover;
//   bool get isNotGameOver => this != PlayingState.gameover;
//   bool get isIdle => this == PlayingState.Idle;
// }
// // final class GameInitial extends GameState {
// //
// // }

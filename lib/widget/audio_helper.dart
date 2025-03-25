import 'package:just_audio/just_audio.dart';

class AudioHelper {
  final AudioPlayer _backgroundPlayer = AudioPlayer();
  final AudioPlayer _scorePlayer = AudioPlayer();

  Future<void> initialize() async {
    try {
      // Load audio sources
      await _backgroundPlayer.setAsset('assets/audio/background.mp3');
      await _scorePlayer.setAsset('assets/audio/score.mp3');
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  void playBackgroundAudio() {
    _backgroundPlayer.setLoopMode(LoopMode.one); // Loop background music
    _backgroundPlayer.play();
  }

  void stopBackgroundAudio() {
    _backgroundPlayer.stop();
  }

  void playScoreCollectSound() {
    _scorePlayer.seek(Duration.zero); // Restart from beginning
    _scorePlayer.play();
  }

  void dispose() {
    _backgroundPlayer.dispose();
    _scorePlayer.dispose();
  }
}

// import 'package:flutter_soloud/flutter_soloud.dart';
//
// class AudioHelper{
//   late SoLoud _soLoud;
//   late AudioSource _backgroundSourcel;
//   SoundHandle? _playingBackground;
//
//   late AudioSource _scoreSource;
//   Future<void> initialize()async {
//     _soLoud = SoLoud.instance;
//     if(_soLoud.isInitialized){
//       return;
//     }
//     await _soLoud.init();
//     _backgroundSourcel = await _soLoud.loadAsset('assets/audio/background.mp3');
//     _scoreSource = await _soLoud.loadAsset('assets/audio/score.mp3');
//   }
//
//   void playBackgroundAudio()async{
//     _playingBackground = await _soLoud.play(_backgroundSourcel);
//     _soLoud.setProtectVoice(_playingBackground!, true);
//   }
//
//   void stopBackgroundAudio(){
//     if(_playingBackground == null){
//       return;
//     }
//     _soLoud.fadeVolume(
//         _playingBackground!,
//         0.0,
//         Duration(milliseconds: 500)
//     );
//   }
//
//   void playScoreCollectSound()async{
//     await _soLoud.play(_scoreSource);
//   }
// }
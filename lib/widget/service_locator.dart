import 'package:get_it/get_it.dart';

import 'audio_helper.dart';

final getIt = GetIt.instance;
// Future<void> setupServiceLocator()async{
//   getIt.registerLazySingleton<AudioHelper>(() => AudioHelper());
// }

Future<void> setupServiceLocator() async {
  final audioHelper = AudioHelper();
  await audioHelper.initialize();
  getIt.registerSingleton<AudioHelper>(audioHelper);
}

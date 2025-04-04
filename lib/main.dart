import 'package:flappy/widget/audio_helper.dart';
import 'package:flappy/widget/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/game/game_cubit.dart';
import 'main_page.dart';

void main() async {
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => GameCubit(
        getIt.get<AudioHelper>(),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flappy Dash',
        theme: ThemeData(fontFamily: 'Chewy'),
        home: const MainPage(),
      ),
    );
  }
}
// import 'package:flappy/widget/audio_helper.dart';
// import 'package:flappy/widget/service_locator.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import 'bloc/game/game_cubit.dart';
// import 'main_page.dart';
//
// void main() async{
//
//   WidgetsFlutterBinding.ensureInitialized(); // Ensures async calls are completed
//   await setupServiceLocator();
//   final AudioHelper audioHelper = AudioHelper();
//   await audioHelper.initialize(); // Ensure audio is loaded
//   // runApp(MyApp(audioHelper));
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => GameCubit(
//         getIt.get<AudioHelper>(),
//       ),
//       child: MaterialApp(
//         theme: ThemeData(fontFamily: 'Chewy'),
//         debugShowCheckedModeBanner: false,
//         title: 'Flappy Dash',
//         home: MainPage(),
//       ),
//     );
//   }
// }
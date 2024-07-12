import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzic/config/routes/routes.dart';
import 'package:muzic/di.dart';
import 'package:muzic/features/home/presentation/bloc/audio_bloc.dart';
import 'package:muzic/features/home/presentation/bloc/audio_event.dart';
import 'package:muzic/features/home/presentation/pages/home_page.dart';
import 'package:muzic/config/theme/theme_provider.dart';
import 'package:provider/provider.dart';



void main() {

  WidgetsFlutterBinding.ensureInitialized();
  initDependencies();

  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AudioBloc>(
      create: (context) => sl()..add( GetSongsEvent()),

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home:  const HomePage(),
        theme: Provider.of<ThemeProvider>(context).themeData,
        onGenerateRoute: AppRoutes.onGenerateRoutes,
        initialRoute: '/',
      ),
    );
  }
}

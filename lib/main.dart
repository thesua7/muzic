import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzic/config/routes/routes.dart';
import 'package:muzic/config/theme/dark_mode.dart';
import 'package:muzic/di.dart';
import 'package:muzic/features/home/data/data_source/audio_data_source.dart';
import 'package:muzic/features/home/data/repository/audio_repository_impl.dart';
import 'package:muzic/features/home/domain/repository/audio_repository.dart';
import 'package:muzic/features/home/domain/usecases/get_songs_usecase.dart';
import 'package:muzic/features/home/presentation/bloc/audio_bloc.dart';
import 'package:muzic/features/home/presentation/bloc/audio_event.dart';
import 'package:muzic/features/home/presentation/pages/home_page.dart';
import 'package:muzic/config/theme/theme_provider.dart';
import 'package:provider/provider.dart';

import '';

import 'config/theme/light_mode.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  initDependencies();

  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AudioBloc>(
      create: (context) => sl()..add( GetSongsEvent()),

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home:  HomePage(),
        theme: Provider.of<ThemeProvider>(context).themeData,
        onGenerateRoute: AppRoutes.onGenerateRoutes,
        initialRoute: '/',
      ),
    );
  }
}

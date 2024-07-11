import 'package:get_it/get_it.dart';
import 'package:muzic/features/home/data/data_source/audio_data_source.dart';
import 'package:muzic/features/home/data/repository/audio_repository_impl.dart';
import 'package:muzic/features/home/domain/repository/audio_repository.dart';
import 'package:muzic/features/home/domain/usecases/get_songs_usecase.dart';
import 'package:muzic/features/home/presentation/bloc/audio_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';

final sl = GetIt.instance;

void initDependencies() {
  // Registering dependencies

  // Registering dependencies

  // Registering OnAudioQuery
  sl.registerSingleton<OnAudioQuery>(OnAudioQuery());

  // Registering Data Source
  sl.registerSingleton<AudioLocalDataSource>(
      AudioLocalDataSourceImpl(sl<OnAudioQuery>())
  );

  // Registering Repository
  sl.registerSingleton<AudioRepository>(
      AudioRepositoryImpl(sl<AudioLocalDataSource>())
  );

  // Registering Use Case
  sl.registerSingleton<GetSongs>(
      GetSongs(sl<AudioRepository>())
  );

  // Registering BLoC
  sl.registerFactory<AudioBloc>(
          () => AudioBloc(getSongs: sl<GetSongs>())
  );

}

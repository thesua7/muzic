import 'package:muzic/features/home/data/data_source/audio_data_source.dart';
import 'package:muzic/features/home/domain/entities/song.dart';
import 'package:muzic/features/home/domain/repository/audio_repository.dart';


class AudioRepositoryImpl implements AudioRepository {
  final AudioLocalDataSource localDataSource;

  AudioRepositoryImpl(this.localDataSource);

  @override
  Future<List<Song>> getSongs() async {
    return await localDataSource.getSongsFromLocal();
  }
}

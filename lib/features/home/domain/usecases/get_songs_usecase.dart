import 'package:muzic/core/usecases/usecase.dart';
import 'package:muzic/features/home/domain/entities/song.dart';

import 'package:muzic/features/home/domain/repository/audio_repository.dart';

class GetSongs implements UseCase<List<Song>, NoParams> {
  final AudioRepository repository;

  GetSongs(this.repository);

  @override
  Future<List<Song>> call(NoParams params) async {
    return await repository.getSongs();
  }
}

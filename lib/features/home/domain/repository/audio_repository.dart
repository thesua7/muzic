import 'package:muzic/features/home/domain/entities/song.dart';

abstract class AudioRepository {
  Future<List<Song>> getSongs();
}

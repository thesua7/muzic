import 'package:on_audio_query/on_audio_query.dart';
import 'package:muzic/features/home/domain/entities/song.dart';

class MySongModel extends Song {
  MySongModel({
    required String displayNameWOExt,
    required String artist,
    required int albumArtImagePath,
    required String audioPath,
  }) : super(
          displayNameWOExt: displayNameWOExt,
          artist: artist,
          audioPath: audioPath,
          albumArtImagePath: albumArtImagePath,
        );

  factory MySongModel.fromSongInfo(SongModel songInfo) {
    return MySongModel(
      displayNameWOExt: songInfo.displayNameWOExt,
      artist: songInfo.artist ?? "Unknown",
      albumArtImagePath: songInfo.albumId ?? -1,
      // Assuming `albumArtwork` is the correct property
      audioPath: songInfo.uri ?? "",
    );
  }


}

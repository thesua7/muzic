import 'package:on_audio_query/on_audio_query.dart';

class Song {
  final int albumArtImagePath;
  final String audioPath;
  final String displayNameWOExt;
  final String artist;

  Song({
    required this.displayNameWOExt,
    required this.artist,
    required this.audioPath,
    required this.albumArtImagePath,
  });

  Future<String> getAlbumArtworkPath(int albumId) async {
    // Replace with your logic to fetch artwork path based on albumArtImagePath
    // For example, using OnAudioQuery library if needed:
    OnAudioQuery onAudioQuery = OnAudioQuery();
    var artworkPath = await onAudioQuery.queryArtwork(albumArtImagePath, ArtworkType.ALBUM);
    // if(artworkPath!.isNotEmpty){
    //   print(artworkPath);
    // }
    return artworkPath?.toString() ?? "";

    // Example placeholder:
// Replace with your actual logic
  }
}

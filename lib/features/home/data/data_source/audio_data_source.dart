import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:muzic/features/home/data/model/song_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class AudioLocalDataSource {
  Future<List<MySongModel>> getSongsFromLocal();
}

class AudioLocalDataSourceImpl implements AudioLocalDataSource {
  final OnAudioQuery audioQuery;

  AudioLocalDataSourceImpl(this.audioQuery);

  @override
  Future<List<MySongModel>> getSongsFromLocal() async {
    await _checkAndRequestPermission(); // Ensure permissions are granted before querying songs

    List<SongModel> songs = await audioQuery.querySongs();
    return songs.map((songInfo) => MySongModel.fromSongInfo(songInfo)).toList();
  }

  Future<void> _checkAndRequestPermission() async {
    if (Platform.isAndroid) {
      if (await _requestPermission()) {
        // Permission granted, continue
      } else {
        throw Exception('Storage permission is required to access music files');
      }
    }
  }

  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      int androidVersion = androidInfo.version.sdkInt;

      if (androidVersion >= 33) { // Android 13 and above
        PermissionStatus audioPermission = await Permission.audio.request();
        return audioPermission.isGranted;
      } else { // Android 12 and below
        PermissionStatus storagePermission = await Permission.storage.request();
        return storagePermission.isGranted;
      }
    }
    return false;
  }
}
